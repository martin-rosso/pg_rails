module PgEngine
  module Resource
    def self.included(clazz)
      # clazz.before_action :authenticate_user!
      clazz.helper_method :atributos_para_listar
      clazz.helper_method :atributos_para_mostrar
      clazz.helper_method :current_page_size
      clazz.helper_method :show_filters?
      clazz.helper_method :available_page_sizes

      clazz.layout :set_layout
    end

    def set_layout
      if action_name == 'index'
        'pg_layout/base'
      else
        'pg_layout/containerized'
      end
    end

    # Public endpoints
    def abrir_modal
      pg_respond_abrir_modal
    end

    def buscar
      pg_respond_buscar
    end

    def index
      @collection = filtros_y_policy(atributos_para_buscar, default_sort)

      pg_respond_index
    end

    def show
      pg_respond_show
    end

    def respond_with_modal(klass_or_string)
      if klass_or_string.is_a?(Class)
        content = klass_or_string.new(instancia_modelo).render_in(view_context)
      elsif klass_or_string.is_a?(String)
        content = ModalContentComponent.new.with_body_content(klass_or_string)
                                       .render_in(view_context)
      end

      if can_open_modal?
        modal = ModalComponent.new.with_content(content)
        render turbo_stream: turbo_stream.append_all('body', modal)
      else
        render html: content
      end
    end

    def new
      if respond_with_modal?
        respond_with_modal(FormModalComponent)
      else
        add_breadcrumb instancia_modelo.submit_default_value
      end
    end

    def edit
      if respond_with_modal?
        respond_with_modal(FormModalComponent)
      else
        add_breadcrumb instancia_modelo.to_s_short, instancia_modelo.target_object
        add_breadcrumb 'Editando'
      end
    end

    def create
      pg_respond_create
    end

    def update
      pg_respond_update
    end

    def destroy
      pg_respond_destroy(instancia_modelo, params[:redirect_to])
    end
    # End public endpoints

    protected

    def default_sort
      'id desc'
    end

    def available_page_sizes
      [10, 20, 30, 50, 100].push(current_page_size).uniq.sort
    end

    def show_filters?
      cur_route = pg_current_route
      idtf = cur_route[:controller] + '#' + cur_route[:action] + '#open-filters'

      if params[:ocultar_filtros]
        session[idtf] = nil
      elsif params[:mostrar_filtros]
        session[idtf] = true
      end

      session[idtf]
    end

    def current_page_size
      if params[:page_size].present?
        session[page_size_session_key] = params[:page_size].to_i
      end

      session[page_size_session_key].presence || default_page_size
    end

    def page_size_session_key
      "#{controller_name}/#{action_name}/page_size"
    end

    def default_page_size
      10
    end

    def pg_respond_update
      object = instancia_modelo
      if (@saved = object.save)
        if in_modal?
          body = <<~HTML.html_safe
            <pg-event data-event-name="pg:record-created" data-turbo-temporary
              data-response='#{object.decorate.to_json}'></pg-event>
          HTML
          render html: ModalContentComponent.new.with_body_content(body)
                                            .render_in(view_context)
        else
          redirect_to object.decorate.target_object
        end
      elsif in_modal?
        render html: FormModalComponent.new(instancia_modelo.decorate)
                                       .render_in(view_context)
      else
        add_breadcrumb instancia_modelo.decorate.to_s_short, instancia_modelo.decorate.target_object
        add_breadcrumb 'Editando'
        # TODO: esto solucionaría el problema?
        # self.instancia_modelo = instancia_modelo.decorate
        #
        render :edit, status: :unprocessable_entity
      end
    end

    def pg_respond_create
      object = instancia_modelo
      if (@saved = object.save)
        if in_modal?
          body = <<~HTML.html_safe
            <pg-event data-event-name="pg:record-created" data-turbo-temporary
              data-response='#{object.decorate.to_json}'></pg-event>
          HTML
          render html: ModalContentComponent.new.with_body_content(body)
                                            .render_in(view_context)

        else
          redirect_to object.decorate.target_object
        end
      elsif in_modal?
        render html: FormModalComponent.new(instancia_modelo.decorate)
                                       .render_in(view_context)
      else
        add_breadcrumb instancia_modelo.decorate.submit_default_value
        # TODO: esto solucionaría el problema?
        # self.instancia_modelo = instancia_modelo.decorate

        render :new, status: :unprocessable_entity
      end
    end

    def pg_respond_index
      respond_to do |format|
        format.json { render json: @collection }
        format.html { render_listing }
        format.xlsx do
          render xlsx: 'download',
                 filename: "#{@clase_modelo.nombre_plural.gsub(' ', '-').downcase}" \
                           "-#{Time.zone.now.strftime('%Y-%m-%d-%H.%M.%S')}.xlsx"
        end
      end
    end

    def accepts_turbo_stream?
      request.headers['Accept'].present? &&
        request.headers['Accept'].include?('text/vnd.turbo-stream.html')
    end

    def in_modal?
      request.headers['turbo-frame'] == 'modal_generic'
    end

    def respond_with_modal?
      can_open_modal? || in_modal?
    end

    def can_open_modal?
      request.get? &&
        params[:start_modal] == 'true' &&
        accepts_turbo_stream? &&
        !in_modal?
    end

    def pg_respond_show
      if respond_with_modal?
        respond_with_modal(ShowModalComponent)
      else
        add_breadcrumb instancia_modelo.to_s_short, instancia_modelo.target_object
      end
    end

    def destroyed_message(model)
      "#{model.model_name.human} #{model.gender == 'f' ? 'borrada' : 'borrado'}"
    end

    def pg_respond_destroy(model, redirect_url = nil)
      if destroy_model(model)
        if respond_with_modal?
          body = <<~HTML.html_safe
            <pg-event data-event-name="pg:record-destroyed" data-turbo-temporary>
            </pg-event>
          HTML
          respond_with_modal(body)
        elsif redirect_url.present?
          redirect_to redirect_url, notice: destroyed_message(model), status: :see_other
        elsif accepts_turbo_stream?
          body = <<~HTML.html_safe
            <pg-event data-event-name="pg:record-destroyed" data-turbo-temporary>
            </pg-event>
          HTML
          render turbo_stream: turbo_stream.append_all('body', body)
        else
          redirect_back(fallback_location: root_path,
                        notice: destroyed_message(model), status: 303)
        end
      elsif in_modal?

        flash.now[:alert] = @error_message
        render turbo_stream: render_turbo_stream_flash_messages(to: '.modal-body .flash')
      elsif accepts_turbo_stream?
        flash.now[:alert] = @error_message
        render turbo_stream: render_turbo_stream_flash_messages
      else
        flash[:alert] = @error_message
        redirect_back(fallback_location: root_path, status: 303)
      end
    end

    def destroy_model(model)
      @error_message = 'No se pudo eliminar el registro'

      begin
        destroy_method = model.respond_to?(:discard) ? :discard : :destroy
        return true if model.send(destroy_method)

        @error_message = model.errors.full_messages.join(', ').presence || @error_message

        false
      rescue ActiveRecord::InvalidForeignKey => e
        model_name = t("activerecord.models.#{model.class.name.underscore}")
        @error_message = "#{model_name} no se pudo borrar porque tiene elementos asociados."
        pg_warn(e)
      end

      false
    end

    def render_listing
      @collection = @collection.page(params[:page]).per(current_page_size)
      @records_filtered = default_scope_for_current_model.any? if @collection.empty?
    end

    def buscar_instancia
      if Object.const_defined?('FriendlyId') && @clase_modelo.is_a?(FriendlyId)
        @clase_modelo.friendly.find(params[:id])
      elsif @clase_modelo.respond_to? :find_by_hashid!
        @clase_modelo.find_by_hashid!(params[:id])
      else
        @clase_modelo.find(params[:id])
      end
    rescue ActiveRecord::RecordNotFound
      raise PgEngine::PageNotFoundError
    end

    def set_instancia_modelo
      if action_name.in? %w[new create]
        self.instancia_modelo = @clase_modelo.new(modelo_params)
      else
        self.instancia_modelo = buscar_instancia

        instancia_modelo.assign_attributes(modelo_params) if action_name.in? %w[update]
      end

      # FIXME: estaría bueno delegar directamente a pundit, pero habría que
      # arreglar tema policies
      Current.user&.developer? || authorize(instancia_modelo)

      # TODO: problema en create y update cuando falla la validacion
      # Reproducir el error antes de arreglarlo
      self.instancia_modelo = instancia_modelo.decorate if action_name.in? %w[show edit new]
    end

    def instancia_modelo=(val)
      instance_variable_set(:"@#{nombre_modelo}", val)
    end

    def instancia_modelo
      instance_variable_get(:"@#{nombre_modelo}")
    end

    def modelo_params
      if action_name == 'new'
        params.permit(atributos_permitidos)
      else
        params.require(nombre_modelo).permit(atributos_permitidos)
      end
    end

    def nombre_modelo
      @clase_modelo.name.underscore
    end

    def clase_modelo
      # agarro la variable o intento con el nombre del controller
      @clase_modelo ||= self.class.name.singularize.gsub('Controller', '').constantize
    end

    def filtros_y_policy(campos, dflt_sort = nil)
      @filtros = PgEngine::FiltrosBuilder.new(
        self, clase_modelo, campos
      )
      scope = policy_scope(clase_modelo)

      scope = @filtros.filtrar(scope)

      shared_context = Ransack::Adapters::ActiveRecord::Context.new(scope)
      @q = @clase_modelo.ransack(params[:q], context: shared_context)

      @q.sorts = dflt_sort if @q.sorts.empty? && dflt_sort.present?

      shared_context.evaluate(@q)
    end

    def default_scope_for_current_model
      PgEngine::FiltrosBuilder.new(
        self, clase_modelo, []
      ).filtrar(policy_scope(clase_modelo))
    end
  end
end
