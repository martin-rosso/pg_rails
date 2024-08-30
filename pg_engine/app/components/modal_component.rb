class ModalComponent < ViewComponent::Base
  def initialize(klass: 'modal-xl', id: nil, auto_show: true)
    @klass = klass
    @auto_show = auto_show
    @id = id
    @remove_on_hide = @auto_show

    super
  end

  def before_render
    return unless @auto_show

    controller.instance_variable_set(:@using_modal, true)
  end
end
