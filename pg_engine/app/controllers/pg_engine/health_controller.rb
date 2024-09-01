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
