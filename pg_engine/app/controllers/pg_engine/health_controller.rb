# :nocov:
module PgEngine
  class HealthController < ApplicationController
    rescue_from(Exception) do |error|
      pg_err error
      render_down
    end

    # Examples:
    # ?except=["good_job", "ssl", "websocket"]
    # ?only=["redis"]
    def show
      HealthChecker.new.run_checks(
        only: parse_ary(params[:only]),
        except: parse_ary(params[:except])
      )

      render_up
    end

    private

    def parse_ary(param)
      return if param.blank?

      ary = JSON.parse(param)

      ary.is_a?(Array) ? ary : [ary]
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
