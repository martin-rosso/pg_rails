class ModalComponent < ViewComponent::Base
  def initialize(klass: 'modal-xl')
    @klass = klass

    super
  end

  def before_render
    controller.instance_variable_set(:@using_modal, true)
  end
end
