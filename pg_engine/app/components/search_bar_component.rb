# frozen_string_literal: true

class SearchBarComponent < ViewComponent::Base
  def initialize(ransack, filtros)
    @q = ransack
    @builder = filtros

    super
  end

  def extra_fields(&)
    @extra_fields = capture(&)
  end
end
