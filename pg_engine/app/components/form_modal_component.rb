class FormModalComponent < ViewComponent::Base
  def initialize(record, modal_id: nil)
    @record = record
    super
  end
end
