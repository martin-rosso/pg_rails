module Admin
  class EventosController < AdminController
    layout 'pg_layout/containerized'

    add_breadcrumb 'Eventos'

    def index
      @events = Noticed::Event.order(id: :desc)
    end

    def new
      @event = Evento.new(type: SimpleUserNotifier.to_s)
    end

    def create # rubocop:disable Metrics/AbcSize
      @event = Evento.new(event_params)
      # @event.message.save!
      unless @event.valid?
        render :new, status: :unprocessable_entity
        return
      end
      json_params_for_event = {
        message: @event.message,
        tooltip: @event.tooltip
      }
      notifier_class = @event.type.constantize
      notifier = notifier_class.with(json_params_for_event)

      if @event.target == 'todos'
        notifier.deliver(User.all)
      elsif @event.target == 'devs'
        notifier.deliver(User.where(developer: true))
      end

      redirect_to admin_eventos_path
    rescue StandardError => e
      flash.now[:alert] = e.to_s
      render :new, status: :unprocessable_entity
    end

    private

    def event_params
      params.require(:evento).permit(
        :type, :message, :tooltip, :record_type, :record_id, :target
      )
    end
  end
end
