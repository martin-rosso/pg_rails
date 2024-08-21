class FormModalComponent < ViewComponent::Base
  def initialize(record)
    @record = record
    super
  end
end
