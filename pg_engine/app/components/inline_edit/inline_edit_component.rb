class InlineEditComponent < InlineComponent
  def initialize(*)
    @wrapper_mappings = {
      string: :inline_form_grow,
      pg_associable: :inline_form_control,
      date: :inline_form_control_autosubmit,
      datetime: :inline_form_control,
      time: :inline_multi_select,
      select: :inline_form_select
    }

    super
  end
end
