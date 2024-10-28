module Users
  class InlineEditController < PgEngine.config.users_controller
    before_action do
      if current_turbo_frame.blank?
        render_my_component(BadRequestComponent.new, :bad_request)
      else
        @model = GlobalID::Locator.locate params[:model]
        authorize(@model)
      end
    end

    def edit
      attribute = params[:attribute]
      render InlineEditComponent.new(@model, attribute), layout: false
    end

    def show
      attribute = params[:attribute]
      render InlineShowComponent.new(@model, attribute), layout: false
    end
  end
end
