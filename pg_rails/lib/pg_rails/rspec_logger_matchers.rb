# :nocov:
module PgEngine
  module Matchers
    module PgLogger
      class Base < RSpec::Rails::Matchers::BaseMatcher
        def initialize(text, level)
          super()
          @text = text
          @level = level
        end
      end

      class PgHaveLogged < Base
        def matches?(proc)
          msg = 'have_logged only support block expectations'
          raise ArgumentError, msg unless proc.is_a?(Proc)

          original_messages = Set.new(PgEngine::PgLogger.test_logged_messages)
          proc.call
          logged_messages = Set.new(PgEngine::PgLogger.test_logged_messages)

          @new_messages = logged_messages - original_messages
          @new_messages.any? do |level, message|
            if @text.present? && @level.present?
              level == @level && message.include?(@text)
            elsif @text.present?
              message.include? @text
            elsif @level.present?
              level == @level
            else
              true
            end
          end
        end

        def failure_message_when_negated
          msg = "expected not to #{@level || log}"
          msg << "with text: #{@text}" if @text.present?
          return msg unless @new_messages.any?

          msg << "\nLogged messages:"
          @new_messages.each do |level, message|
            msg << "\n  #{level}: #{message[0..500]}"
          end
          msg
        end

        def failure_message
          msg = "expected to #{@level || log}"
          msg << "with text: #{@text}" if @text.present?
          return msg unless @new_messages.any?

          msg << "\nLogged messages:"
          @new_messages.each do |level, message|
            msg << "\n  #{level}: #{message[0..500]}"
          end
          msg
        end

        def supports_block_expectations?
          true
        end
      end
    end

    def have_errored(text = nil) # rubocop:disable Naming/PredicateName
      PgLogger::PgHaveLogged.new(text, :error)
    end

    def have_warned(text = nil) # rubocop:disable Naming/PredicateName
      PgLogger::PgHaveLogged.new(text, :warn)
    end
  end
end
# :nocov:
