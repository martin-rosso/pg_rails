class AsociableModalComponent < ModalComponent
  def initialize(modal_id: nil, **)
    @modal_id = modal_id

    super(**)
  end
end
