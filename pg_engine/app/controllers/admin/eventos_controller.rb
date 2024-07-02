module Admin
  class EventosController < AdminController
    layout 'pg_layout/containerized'

    add_breadcrumb 'Eventos'

    before_action do
      @notifier_types = %w[
        EmailUserNotifier
        SimpleUserNotifier
      ]
    end

    def index
      @events = Noticed::Event.order(id: :desc)
    end

    # rubocop:disable Metrics/AbcSize
    def new
      @event = Evento.new(type: 'SimpleUserNotifier')
      return if params[:event_id].blank?

      reference = Noticed::Event.find(params[:event_id])
      @event.type = reference.type
      @event.message = reference.params[:message]
      @event.message_text = reference.params[:message_text]
      @event.tooltip = reference.params[:tooltip]
      @event.subject = reference.params[:subject]
      @event.record_type = reference.record_type
      @event.record_id = reference.record_id
    end
    # rubocop:enable Metrics/AbcSize

    # rubocop:disable Metrics/MethodLength
    def create # rubocop:disable Metrics/AbcSize
      @event = Evento.new(event_params)
      # @event.message.save!
      unless @event.valid?
        render :new, status: :unprocessable_entity
        return
      end
      json_params_for_event = {
        record: @event.record,
        message: @event.message,
        message_text: @event.message_text,
        tooltip: @event.tooltip,
        subject: @event.subject
      }
      notifier_class = @event.type.constantize
      notifier = notifier_class.with(json_params_for_event)

      case @event.target
      when 'todos'
        notifier.deliver(User.all)
      when 'devs'
        notifier.deliver(User.where(developer: true))
      when 'user_ids'
        notifier.deliver(User.where(email: @event.user_ids.split(',')))
      else
        # :nocov:
        'shouldnt happen'
        # :nocov:
      end

      redirect_to admin_eventos_path
    rescue StandardError => e
      # :nocov:
      flash.now[:alert] = e.to_s
      render :new, status: :unprocessable_entity
      # :nocov:
    end
    # rubocop:enable Metrics/MethodLength

    private

    def event_params
      params.require(:evento).permit(
        :type, :message, :tooltip, :record_type, :record_id, :target, :subject,
        :user_ids, :message_text
      )
    end
  end
end
