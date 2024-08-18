class ModalComponent < ViewComponent::Base
  def initialize(title: nil, modal_id: nil)
    @klass = 'modal-xl'
    @title = title
    @modal_id = modal_id
    super
  end

  def before_render
    controller.instance_variable_set(:@using_modal, true)
  end
end
