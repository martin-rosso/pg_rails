class InlineComponent < ViewComponent::Base
  include PgEngine::IndexHelper
  def initialize(model, attribute)
    @model = model
    @attribute = attribute
    @unsuffixed_attribute = unsuffixed(attribute)
    @frame_id = dom_id(model, "#{attribute}_inline_edit")

    super
  end
end
