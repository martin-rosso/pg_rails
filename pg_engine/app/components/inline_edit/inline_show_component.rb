class InlineShowComponent < InlineComponent
  def initialize(model, attribute, record_updated: false)
    @record_updated = record_updated

    super(model, attribute)
  end
end
