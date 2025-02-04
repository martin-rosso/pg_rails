# :nocov:
module PgEngine
  class HealthController < ApplicationController
    rescue_from(Exception) do |error|
      pg_err error
      render_down
    end

    def show
      check_redis
      check_postgres
      check_websocket
      check_ssl
      render_up
    end

    private

    def check_postgres
      return if User.count.is_a? Integer

      raise PgEngine::Error, 'postgres is down'
    end

    def check_redis
      return if Kredis.counter('healthcheck').increment.is_a? Integer

      raise PgEngine::Error, 'redis is down'
    end

    # rubocop:disable Metrics/MethodLength
    def check_websocket
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
    # rubocop:enable Metrics/MethodLength

    def check_ssl
      raise PgEngine::Error, 'no ssl log file' unless File.exist?(PgEngine::SslVerifier::OUTPUT_PATH)

      sites = JSON.parse(File.read(PgEngine::SslVerifier::OUTPUT_PATH))
      PgEngine.config.health_ssl_urls.each do |url|
        check_site_ssl(sites, url)
      end
    end

    def check_site_ssl(sites, url)
      raise PgEngine::Error, "SSL record not present: #{url}" if sites[url].blank?

      if Time.zone.parse(sites[url]['verified_at']) < 2.days.ago
        raise PgEngine::Error, "The SSL info is outdated: #{url}"
      end

      return unless Time.zone.parse(sites[url]['expires_at']) < 7.days.from_now

      raise PgEngine::Error, "The SSL certificate is expired (or about to expire): #{url}"
    end

    def render_up
      render html: html_status(color: '#005500')
    end

    def render_down
      render html: html_status(color: '#990000'), status: :internal_server_error
    end

    def html_status(color:)
      %(<!DOCTYPE html><html><body style="background-color: #{color}"></body></html>).html_safe
    end
  end
end
# :nocov:
