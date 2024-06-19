module Admin
  class NoticedEventsController < AdminController
    layout 'pg_layout/containerized'

    add_breadcrumb 'Eventos'

    def index
      @events = Noticed::Event.order(id: :desc)
    end

    def new
      Rails.application.eager_load!
      @event = Noticed::Event.new
    end

    def create
      ActiveRecord::Base.transaction do
        @event = Noticed::Event.new(event_params)
        @event.message.save
        json_params_for_event = {
          message: @event.message,
          tooltip: @event.tooltip
        }
        notifier_class = @event.type.constantize
        notifier = notifier_class.with(json_params_for_event)

        notifier.deliver(User.all)

        redirect_to admin_noticed_events_path
      end
    rescue StandardError => e
      flash.now[:alert] = e.to_s
      render :new, status: :unprocessable_entity
    end

    private

    def event_params
      params.require(:event).permit(
        :type, :message, :tooltip, :record_type, :record_id
      )
    end
  end
end
