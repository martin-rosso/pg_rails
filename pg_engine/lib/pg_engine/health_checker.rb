module PgEngine
  class HealthChecker
    def run_checks(only: nil, except: nil)
      ary = [default_checks, PgEngine.config.health_checks].flatten
      ary.each do |health_check|
        included = only.present? && only.include?(health_check[:name].to_s)
        excluded = except.present? && except.include?(health_check[:name].to_s)

        if included || (only.blank? && !health_check[:only_explicit] && !excluded)
          Rails.logger.info "Running health check: #{health_check[:name]}"

          health_check[:block].call
        else
          Rails.logger.info "Skipping health check: #{health_check[:name]}"
        end
      rescue StandardError => e
        raise "Health check failed: #{health_check[:name]}. With: #{e.message}", cause: e
      end
    end

    private

    def default_checks
      ary = []
      ary << {
        name: :redis,
        block: lambda do
                 return if Kredis.counter('healthcheck').increment.is_a? Integer

                 raise PgEngine::Error, 'redis is down'
               end
      }
      ary << {
        name: :postgres,
        block: lambda do
                 return if User.count.is_a? Integer

                 raise PgEngine::Error, 'postgres is down'
               end
      }
      ary << {
        name: :websocket,
        block: lambda do
                 result = nil
                 begin
                   Timeout.timeout(5) do
                     EM.run do
                       url = Rails.application.config.action_cable.url
                       ws = Faye::WebSocket::Client.new(url)

                       ws.on :message do |event|
                         type = JSON.parse(event.data)['type']
                         if type == 'welcome'
                           result = :success
                           ws.close
                           EM.stop
                         end
                       end
                     end
                   end
                 rescue Timeout::Error
                   raise PgEngine::Error, 'websocket server is down'
                 end

                 return if result == :success

                 raise PgEngine::Error, 'websocket server is down'
               end
      }
      ary << {
        name: :ssl,
        block: lambda do
                 SslChecker.new.check_ssl
               end
      }
    end

    class SslChecker
      def check_ssl
        raise PgEngine::Error, 'no ssl log file' unless File.exist?(PgEngine::SslVerifier::OUTPUT_PATH)

        sites = JSON.parse(File.read(PgEngine::SslVerifier::OUTPUT_PATH))
        PgEngine.config.health_ssl_urls.each do |url|
          check_site_ssl(sites, url)
        end
      end

      def check_site_ssl(sites, url)
        raise PgEngine::Error, "SSL record not present: #{url}. Forgot to run PgEngine::SslVerifier ?" if sites[url].blank?

        if Time.zone.parse(sites[url]['verified_at']) < 2.days.ago
          raise PgEngine::Error, "The SSL info is outdated: #{url}. PgEngine::SslVerifier is down?"
        end

        return unless Time.zone.parse(sites[url]['expires_at']) < 7.days.from_now

        raise PgEngine::Error, "The SSL certificate is expired (or about to expire): #{url}"
      end
    end
  end
end
