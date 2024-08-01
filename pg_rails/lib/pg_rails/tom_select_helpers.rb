module PgRails
  module TomSelectHelpers
    def select_tom(placeholder:, text:)
      find("input[placeholder=\"#{placeholder}\"]").click
      find('.ts-wrapper [role="option"]', text:).click
    end
  end
end
