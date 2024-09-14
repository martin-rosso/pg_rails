# frozen_string_literal: true

require 'rainbow'

# TODO: poder pasar blocks
# TODO: loguear paralelamente a otro file

def pg_err(*args)
  if ENV.fetch('RAISE_ERRORS', false) == '1'
    # :nocov:
    raise args.first if args.first.is_a?(Exception)

    raise StandardError, args

    # :nocov:
  end

  byebug if ENV.fetch('BYEBUG_ERRORS', false) # rubocop:disable Lint/Debugger

  pg_log(:error, *args)
end

def pg_warn(*)
  pg_log(:warn, *)
end

def pg_info(*)
  pg_log(:info, *)
end

def pg_debug(*)
  pg_log(:debug, *)
end

def pg_log(*)
  PgEngine::PgLogger.log(*)
end

# To be called inside a method or block that is deprecated
def pg_deprecation(method, message = nil, deprecator:)
  deprecator.warn(deprecator.deprecation_warning(method, message), caller_locations(3))
end


module PgEngine
  class PgLogger
    def self.test_logged_messages
      @test_logged_messages ||= []
    end

    class << self
      def log(type, *)
        notify_all(build_msg(*), type)
      end

      private

      def notify_all(mensaje, type)
        send_to_logger(mensaje, type)
        send_to_rollbar(mensaje, type)
        send_to_stdout(mensaje, type) if ENV.fetch('LOG_TO_STDOUT', nil)
        save_internal(mensaje, type) if Rails.env.test?
        nil
      end

      # Senders

      def send_to_stdout(mensaje, type)
        puts rainbow_wrap(mensaje, type)
      end

      def send_to_rollbar(mensaje, type)
        Rollbar.send(type, mensaje)
        # Rollbar.send(type, "#{mensaje}\n\n#{bktrc.join("\n")}")
      rescue StandardError => e
        send_to_logger("Error notifying Rollbar #{e}", :error)
      end

      def send_to_logger(mensaje, type)
        Rails.logger.send(type, rainbow_wrap(mensaje, type))
      end

      def save_internal(mensaje, type)
        PgEngine::PgLogger.test_logged_messages << [type, mensaje]
      end

      # Format

      # TODO: loguear time
      def build_msg(*args)
        first = args.first
        if first.is_a?(Exception) && first.backtrace.present?
          <<~STR
            #{titulo(*args)}
            Exception Backtrace:
              #{cleaner.clean(first.backtrace).join("\n")}
            Caller Backtrace:
              #{cleaner.clean(caller).join("\n")}
          STR
        else
          <<~STR
            #{titulo(*args)}
            Caller Backtrace:
              #{cleaner.clean(caller).join("\n")}
          STR
        end
      rescue StandardError
        send_to_logger('ERROR: PgLogger error building msg', :error)
      end

      def titulo(*args)
        args.map { |obj| "#{obj.inspect} (#{obj.class})" }.join("\n")
      end

      def rainbow_wrap(mensaje, type)
        Rainbow(mensaje).bold.send(color_for(type))
      end

      def color_for(type)
        case type
        when :info
          :blue
        when :warn
          :yellow
        when :debug
          :orange
        else # :error
          :red
        end
      end

      # Backtrace helpers

      def cleaner
        bc = ActiveSupport::BacktraceCleaner.new
        bc.remove_silencers!
        pattern = %r{\A[^/]+ \([\w.]+\) }
        bc.add_silencer { |line| pattern.match?(line) && !line.match?(/pg_contable|pg_rails/) }
        bc.add_silencer { |line| /pg_logger/.match?(line) }
        bc
      end
    end
  end
end
