# frozen_string_literal: true

class SearchBarComponent < ViewComponent::Base
  def initialize(ransack, filtros)
    @q = ransack
    @builder = filtros

    super
  end
end
