class InlineComponent < ViewComponent::Base
  def initialize(model, attribute)
    @model = model
    @attribute = attribute
    @unsuffixed_attribute = unsuffixed(attribute)
    @frame_id = dom_id(model, "#{attribute}_inline_edit")

    super
  end

  def before_render
    return unless controller.in_modal?

    controller.instance_variable_set(:@using_modal, true)
  end

  SUFIJOS = %i[f text].freeze
  def unsuffixed(attribute)
    ret = attribute.to_s.dup

    SUFIJOS.each do |sufijo|
      ret.gsub!(/_#{sufijo}$/, '')
    end

    ret
  end
end
