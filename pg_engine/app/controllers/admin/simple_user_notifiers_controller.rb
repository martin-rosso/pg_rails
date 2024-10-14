module Admin
  class SimpleUserNotifiersController < AdminController
    include PgEngine::Resource

    self.clase_modelo = SimpleUserNotifier

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    def column_options_for(object, attribute)
      case attribute
      when :message
        { class: 'column-truncate-30', title: object.send(attribute).to_s }
      else
        super
      end
    end

    # rubocop:disable Metrics/MethodLength
    def create
      @event = SimpleUserNotifier.new(modelo_params)
      # @event.message.save!
      unless @event.valid?
        render :new, status: :unprocessable_entity
        return
      end
      json_params_for_event = {
        message: @event.message,
        tooltip: @event.tooltip
      }
      notifier = SimpleUserNotifier.with(json_params_for_event)

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

      redirect_to admin_simple_user_notifiers_path
    rescue StandardError => e
      # :nocov:
      flash.now[:alert] = e.to_s
      render :new, status: :unprocessable_entity
      # :nocov:
    end
    # rubocop:enable Metrics/MethodLength

    private

    def atributos_permitidos
      %i[
        type message tooltip record_type record_id target subject
        user_ids message_text
      ]
    end

    def atributos_para_buscar
      %i[]
    end

    def atributos_para_listar
      %i[message tooltip created_at notifications_count]
    end

    def atributos_para_mostrar
      %i[tooltip]
    end
  end
end
