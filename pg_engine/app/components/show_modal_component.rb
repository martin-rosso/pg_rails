class ShowModalComponent < ViewComponent::Base
  def initialize(record, **)
    @record = record

    super(**)
  end
end
