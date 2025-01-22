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
      PgEngine.config.health_ssl_urls.each do |url|
        check_ssl(url)
      end
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

    def check_ssl(url)
      uri = URI.parse(url)
      http_session = Net::HTTP.new(uri.host, uri.port)

      # Use SSL/TLS
      http_session.use_ssl = true

      # Create a request
      request = Net::HTTP::Get.new(uri.request_uri)

      begin
        # Start the HTTP session
        http_session.start do |http|
          http.request(request)

          # Check the response code

          # Get the SSL certificate
          cert = http.peer_cert

          raise PgEngine::Error, "#{url}: No SSL certificate found." unless cert
          # puts "Certificate Subject: #{cert.subject}"
          # puts "Certificate Issuer: #{cert.issuer}"
          # puts "Certificate Valid From: #{cert.not_before}"
          # puts "Certificate Valid Until: #{cert.not_after}"

          if cert.not_after < 7.days.from_now
            raise PgEngine::Error, "#{url}: The SSL certificate is expired (or about to expire)."
          end
        end
      rescue OpenSSL::SSL::SSLError => e
        raise PgEngine::Error, "#{url}: SSL Error: #{e.message}"
      rescue StandardError => e
        raise PgEngine::Error, "#{url}: An error occurred: #{e.message}"
      end
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
