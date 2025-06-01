module PgEngine
  module Resource
    def self.included(clazz)
      class << clazz
        # This is a per class variable, all subclasses of clazz inherit it
        # BUT **the values are independent between all of them**
        attr_accessor :nested_class, :nested_key, :clase_modelo

        # TODO: separar los endpoints de la lógica de filtros para evitar esta variable
        # en Agenda
        attr_accessor :skip_default_breadcrumb

        # Skip set_instancia_modelo && authorize
        attr_accessor :skip_default_hooks
      end
      clazz.delegate :nested_key, :nested_class, :clase_modelo, to: clazz

      clazz.helper_method :nested_class, :nested_key, :clase_modelo
      clazz.helper_method :nested_record, :nested_id

      clazz.helper_method :atributos_para_listar
      clazz.helper_method :atributos_para_mostrar
      clazz.helper_method :current_page_size
      clazz.helper_method :show_filters?
      clazz.helper_method :available_page_sizes
      clazz.helper_method :column_options_for
      clazz.helper_method :instancia_modelo

      # clazz.skip_before_action :save_and_load_filters, only: [:bulk_edit, :bulk_update]

      clazz.before_action do
        # TODO: quitar esto, que se use el attr_accessor
        #       o sea, quitar todas las referencias a @clase_modelo
        @clase_modelo = clase_modelo
      end

      clazz.before_action(only: %i[index archived], unless: -> { clazz.skip_default_hooks }) do
        authorize clase_modelo
      end

      clazz.before_action :set_instancia_modelo,
                          only: %i[new create show edit update destroy archive restore],
                          unless: -> { clazz.skip_default_hooks }

      clazz.before_action unless: -> { clazz.skip_default_breadcrumb } do
        if nested_record.present?
          # Link al nested, siempre que sea no sea un embedded frame
          # ya que en tal caso se supone que el nested está visible
          # en el main frame. Además, si es un modal abierto desde
          # el nested record, no muestro el link al mismo.
          unless frame_embedded?
            if modal_targeted? && referred_by?(nested_record)
              add_breadcrumb nested_record.decorate.to_s_short
            else
              add_breadcrumb nested_record.decorate.to_s_short,
                             path_for(nested_record.decorate.target_object)
            end
          end

          if action_name == 'archived'
            # En el listado de archivados tiene que haber un link al listado
            # principal
            add_breadcrumb clase_modelo.nombre_plural,
                           path_for([pg_namespace, nested_record, clase_modelo])
          else
            # Texto de index pero sin link, porque se supone que es un
            # embedded index o es un show dentro de un embedded y por ende
            # el paso atrás no tiene que ser el listado sino el show del parent
            add_breadcrumb clase_modelo.nombre_plural
          end

        elsif !modal_targeted?
          # Link al index, siempre que no sea un modal, porque en tal
          # caso se supone que el index está visible en el main frame
          if clase_modelo.present?
            add_breadcrumb clase_modelo.nombre_plural,
                           path_for([pg_namespace, nested_record, clase_modelo])
          else
            # :nocov:
            pg_warn 'clase_modelo is nil'
            # :nocov:
          end
        end
      end

      clazz.layout :set_layout
    end

    def column_options_for(_object, _attribute)
      { class: 'text-nowrap' }
    end

    def referred_by?(object)
      url_for(object.decorate.target_object) == request.referer
    end

    def nested_id
      return unless nested_key.present? && nested_class.present?

      id = params[nested_key]

      # if using hashid-rails
      if nested_class.respond_to? :decode_id
        id = nested_class.decode_id(id)
      end

      id
    end

    def nested_record
      return if nested_id.blank?

      nested_class.find(nested_id)
    rescue ActiveRecord::RecordNotFound => e
      pg_warn(e)
      raise PgEngine::PageNotFoundError
    end

    def accepts_turbo_stream?
      request.headers['Accept'].present? &&
        request.headers['Accept'].include?('text/vnd.turbo-stream.html')
    end

    def respond_with_modal?
      can_open_modal? || modal_targeted?
    end

    def can_open_modal?
      request.get? &&
        clase_modelo.default_modal &&
        accepts_turbo_stream? &&
        !in_modal?
    end

    def set_layout
      if action_name.in? %w[index archived]
        'pg_layout/base'
      elsif action_name == 'show'
        'pg_layout/show'
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

    def archived
      add_breadcrumb 'Archivados'

      @index_url = index_url

      @collection = filtros_y_policy(atributos_para_buscar, 'discarded_at desc', archived: true)

      pg_respond_index(archived: true)
    end

    def index
      @collection = filtros_y_policy(atributos_para_buscar, default_sort)

      pg_respond_index(archived: false)
    end

    def show
      pg_respond_show
    end

    # TODO!: refactor
    def respond_with_modal(component)
      content = component.render_in(view_context)

      if can_open_modal?
        modal = ModalComponent.new.with_content(content)
        render turbo_stream: turbo_stream.append_all('body', modal)
      else
        render html: content
      end
    end

    def new
      if can_open_modal?
        path = [request.path, request.query_string].compact.join('?')
        component = ModalContentComponent.new(src: path)
        respond_with_modal(component)
      else
        add_breadcrumb instancia_modelo.submit_default_value
      end
    end

    def edit
      if can_open_modal?
        path = [request.path, request.query_string].compact.join('?')
        component = ModalContentComponent.new(src: path)
        respond_with_modal(component)
      else
        if (modal_targeted? && referred_by?(instancia_modelo)) ||
           !policy(instancia_modelo.object).show?
          add_breadcrumb instancia_modelo.to_s_short
        else
          add_breadcrumb instancia_modelo.to_s_short,
                         instancia_modelo.target_object
        end
        add_breadcrumb 'Modificando'
      end
    end

    def create
      pg_respond_create
    end

    def update
      pg_respond_update
    end

    def destroy
      pg_respond_destroy(instancia_modelo, params[:land_on])
    end

    def archive
      discard_undiscard(:discard)
    end

    def restore
      discard_undiscard(:undiscard)
    end

    def set_session_key_identifier
      return unless action_name.in?(%w[index bulk_edit bulk_update])

      ::RansackMemory::Core.config[:session_key_format]
                           .gsub('%controller_name%', controller_path.parameterize.underscore)
                           .gsub('%action_name%', 'index')
                           .gsub('%request_format%', request.format.symbol.to_s)
                           .gsub('%turbo_frame%', request.headers['Turbo-Frame'] || 'top')
    end

    def bulk_edit
      # @no_main_frame = true

      @collection = filtros_y_policy(atributos_para_buscar, default_sort)
      @ids = @collection.map(&:to_key).join(',')
      @form_target = [:bulk_update, pg_namespace, nested_record, @clase_modelo].compact
      @model = @clase_modelo.new

      render 'bulk_edit'
    end

    def bulk_update
      if params[:refresh].present?
        bulk_component = BulkEditComponent.new(@clase_modelo, params:)
        render turbo_stream: turbo_stream.replace('bulk_form', bulk_component)

        return
      end
      # params = params.delete_if { |k,v| v.empty? or Hash === v && delete_blank(v).empty? }

      # TODO: test
      # :nocov:
      if params[:ids].blank?
        flash[:alert] = I18n.t('pg_engine.base.index.bulk_edit.blank_ids', model: @clase_modelo)
        flash[:toast] = true
        render turbo_stream: render_turbo_stream_flash_messages
        return
      end

      key = @clase_modelo.model_name.param_key
      unless params[key].is_a?(ActionController::Parameters)
        flash[:alert] = I18n.t('pg_engine.base.index.bulk_edit.bulk_not_hash')
        flash[:toast] = true
        render turbo_stream: render_turbo_stream_flash_messages
        return
      end
      # :nocov:

      ids = params[:ids]

      target = [pg_namespace, nested_record, @clase_modelo].compact
      Bulky.enqueue_update(@clase_modelo, ids, params[key])
      redirect_to target, notice: I18n.t('pg_engine.base.index.bulk_edit.enqueue_update')

      # FIXME: revisar cuando es embedded index
    end
    # End public endpoints

    protected

    def discard_undiscard(method)
      object = instancia_modelo
      if instancia_modelo.send(method)
        if method == :discard
          ActiveSupport::Notifications.instrument("record_discarded.pg_engine", object)
        else
          ActiveSupport::Notifications.instrument("record_restored.pg_engine", object)
        end

        if accepts_turbo_stream?
          body = <<~HTML.html_safe
            <pg-event data-event-name="pg:record-updated" data-reload="true" data-turbo-temporary>
            </pg-event>
          HTML
          render turbo_stream: turbo_stream.append(current_turbo_frame, body)
        else
          redirect_to instancia_modelo.decorate.target_object
        end

      else
        message = I18n.t('pg_engine.resource_not_updated', model: instancia_modelo.class)
        if accepts_turbo_stream?
          flash.now[:alert] = message
          render turbo_stream: render_turbo_stream_flash_messages, status: :unprocessable_entity
        else
          flash[:alert] = message
          redirect_to instancia_modelo.decorate.target_object
        end
      end
    end

    def index_url
      path_for([pg_namespace, nested_record, clase_modelo])
    end

    def default_sort
      'id desc'
    end

    def available_page_sizes
      [5, 10, 20, 30, 50, 100].push(current_page_size).uniq.sort
    end

    def show_filters_by_default?
      true
    end

    def filters_applied?
      params[RansackMemory::Core.config[:param].presence || :q].present?
    end

    def session_key_identifier
      ::RansackMemory::Core.config[:session_key_format]
                           .gsub('%controller_name%', controller_path.parameterize.underscore)
                           .gsub('%action_name%', action_name)
                           .gsub('%request_format%', request.format.symbol.to_s)
                           .gsub('%turbo_frame%', request.headers['Turbo-Frame'] || 'top')
      # TODO!!: rename to main?
    end

    def show_filters?
      return true if filters_applied?

      idtf = "show-filters_#{session_key_identifier}"

      if params[:ocultar_filtros]
        session[idtf] = false
      elsif params[:mostrar_filtros]
        session[idtf] = true
      end

      if session[idtf].nil?
        show_filters_by_default?
      else
        session[idtf]
      end
    end

    def current_page_size
      aux = params[:page_size].presence&.to_i
      if aux.present? && aux.positive?
        session[page_size_session_key] = aux
      end

      session[page_size_session_key].presence || default_page_size
    end

    def page_size_session_key
      "page_size_#{session_key_identifier}"
    end

    def default_page_size
      10
    end

    def pg_respond_update
      object = instancia_modelo
      # Maybe lock! to ensure consistency of audits
      if (@saved = object.save)
        ActiveSupport::Notifications.instrument("record_updated.pg_engine", object)
        respond_to do |format|
          format.html do
            if params[:inline_attribute].present?
              render InlineShowComponent.new(object, params[:inline_attribute], record_updated: true),
                     layout: false
            elsif in_modal?
              body = <<~HTML.html_safe
                <pg-event data-event-name="pg:record-updated" data-turbo-temporary
                  data-response='#{object.decorate.to_json}'></pg-event>
              HTML
              render html: ModalContentComponent.new.with_content(body)
                                                .render_in(view_context)
            else
              redirect_to object.decorate.target_object
            end
          end
          format.json do
            render json: object.decorate.as_json
          end
        end
      elsif params[:inline_attribute].present?
        render InlineEditComponent.new(object, params[:inline_attribute]),
               layout: false, status: :unprocessable_entity
      else
        add_breadcrumb instancia_modelo.decorate.to_s_short, instancia_modelo.decorate.target_object
        add_breadcrumb 'Modificando'
        # TODO: esto solucionaría el problema?
        # self.instancia_modelo = instancia_modelo.decorate
        #
        render :edit, status: :unprocessable_entity
      end
    end

    def pg_respond_create
      object = instancia_modelo
      if (@saved = object.save)
        ActiveSupport::Notifications.instrument("record_created.pg_engine", object)
        if in_modal?
          body = <<~HTML.html_safe
            <pg-event data-event-name="pg:record-created" data-turbo-temporary
              data-response='#{object.decorate.to_json}'></pg-event>
          HTML
          render turbo_stream: turbo_stream.append(current_turbo_frame, body)
        else
          redirect_to object.decorate.target_object
        end
      else
        add_breadcrumb instancia_modelo.decorate.submit_default_value
        # TODO: esto solucionaría el problema?
        # self.instancia_modelo = instancia_modelo.decorate

        render :new, status: :unprocessable_entity
      end
    end

    def pg_respond_index(archived:)
      respond_to do |format|
        format.json { render json: @collection }
        format.html { render_listing(archived:) }
        format.xlsx do
          render xlsx: 'download',
                 filename: "#{clase_modelo.nombre_plural.gsub(' ', '-').downcase}" \
                           "#{action_name == 'archived' ? '-archivados' : ''}" \
                           "-#{Time.zone.now.strftime('%Y-%m-%d-%H.%M.%S')}.xlsx"
        end
      end
    end

    def pg_respond_show
      if can_open_modal?
        path = [request.path, request.query_string].compact.join('?')
        component = ModalContentComponent.new(src: path)
        respond_with_modal(component)
      else
        add_breadcrumb instancia_modelo.to_s_short, instancia_modelo.target_object
      end
    end

    def land_on_url(land_on)
      case land_on
      when 'index'
        index_url
      else
        # :nocov:
        pg_warn "Unrecognized land_on: #{land_on}"
        instancia_modelo.decorate.target_object
        # :nocov:
      end
    end

    def pg_respond_destroy(model, land_on = nil)
      if destroy_model(model)
        ActiveSupport::Notifications.instrument("record_destroyed.pg_engine", model)
        # TODO!!: rename to main
        if turbo_frame? && current_turbo_frame != 'top'
          body = <<~HTML.html_safe
            <pg-event data-event-name="pg:record-destroyed" data-turbo-temporary>
            </pg-event>
          HTML
          render turbo_stream: turbo_stream.append(current_turbo_frame, body)
        elsif land_on.present?
          redirect_to land_on_url(land_on),
                      notice: I18n.t('pg_engine.resource_destroyed', model: model.class),
                      status: :see_other
        elsif accepts_turbo_stream?
          body = <<~HTML.html_safe
            <pg-event data-event-name="pg:record-destroyed" data-turbo-temporary>
            </pg-event>
          HTML
          render turbo_stream: turbo_stream.append_all('body', body)
        else
          redirect_back(fallback_location: root_path,
                        notice: I18n.t('pg_engine.resource_destroyed', model: model.class),
                        status: 303)
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
      @error_message = I18n.t('pg_engine.resource_not_destroyed', model: model.class)

      begin
        return true if model.destroy

        @error_message = model.errors.full_messages.join(', ').presence || @error_message

        false
      rescue ActiveRecord::InvalidForeignKey => e
        pg_warn(e)
        @error_message = I18n.t('pg_engine.resource_not_destroyed_because_associated', model: model.class)
      end

      false
    end

    def render_listing(archived:)
      total = @collection.count
      current_page = params[:page].presence&.to_i || 1
      if current_page_size * (current_page - 1) >= total
        current_page = (total.to_f / current_page_size).ceil
      end
      @collection = @collection.page(current_page).per(current_page_size)
      @records_filtered = default_scope_for_current_model(archived:).any? if @filtros.present? && @collection.empty?
      render :index
    end

    def buscar_instancia
      if Object.const_defined?('FriendlyId') && clase_modelo.is_a?(FriendlyId)
        clase_modelo.friendly.find(params[:id])
      elsif clase_modelo.respond_to? :find_by_hashid!
        clase_modelo.find_by_hashid!(params[:id])
      else
        clase_modelo.find(params[:id])
      end
    rescue ActiveRecord::RecordNotFound
      raise PgEngine::PageNotFoundError
    end

    def set_instancia_modelo
      if action_name.in? %w[new create]
        self.instancia_modelo = clase_modelo.new(modelo_params)
        authorize(instancia_modelo)
        if nested_id.present?
          instancia_modelo.send("#{nested_key}=", nested_id)
        end
      else
        self.instancia_modelo = buscar_instancia
        authorize(instancia_modelo)
        instancia_modelo.assign_attributes(modelo_params) if action_name.in? %w[update]
      end

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
        params.require(clase_modelo.model_name.param_key).permit(atributos_permitidos)
      end
    end

    def nombre_modelo
      clase_modelo.model_name.element
    end

    def filtros_y_policy(campos, dflt_sort = nil, archived: false)
      if campos.any?
        @filtros = PgEngine::FiltrosBuilder.new(
          self, clase_modelo, campos
        )
      end

      scope = default_scope_for_current_model(archived:)

      shared_context = Ransack::Adapters::ActiveRecord::Context.new(scope)
      @q = clase_modelo.ransack(params[:q], context: shared_context)
      @q.sorts = dflt_sort if @q.sorts.empty? && dflt_sort.present?

      shared_context.evaluate(@q)
    end

    def soft_delete_filter(scope, archived:)
      return scope unless scope.respond_to?(:discarded)

      if nested_id.present?
        if archived
          scope.discarded
        else
          scope.undiscarded
        end
      elsif archived
        scope.unkept
      else
        scope.kept
      end
    end

    def default_scope_for_current_model(archived: false)
      scope = policy_scope(clase_modelo)

      if nested_id.present?
        scope = scope.where(nested_key => nested_id)
      end

      soft_delete_filter(scope, archived:)
    end
  end
end
