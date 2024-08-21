class ModalComponent < ViewComponent::Base
  def initialize(modal_id: nil)
    @klass = 'modal-xl'
    @modal_id = modal_id
    super
  end

  def before_render
    controller.instance_variable_set(:@using_modal, true)
  end
end
