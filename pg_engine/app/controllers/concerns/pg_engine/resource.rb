module PgEngine
  module Resource
    def self.included(clazz)
      # clazz.before_action :authenticate_user!
      clazz.helper_method :atributos_para_listar
      clazz.helper_method :atributos_para_mostrar
      clazz.helper_method :current_page_size
      clazz.helper_method :show_filters?
      clazz.helper_method :available_page_sizes
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
      add_breadcrumb instancia_modelo.to_s_short, instancia_modelo.target_object

      pg_respond_show
    end

    def new
      add_breadcrumb instancia_modelo.submit_default_value
    end

    def edit
      add_breadcrumb instancia_modelo.to_s_short, instancia_modelo.target_object
      add_breadcrumb 'Editando'
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
      nil
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
      respond_to do |format|
        if (@saved = object.save)
          format.html { redirect_to object.decorate.target_object }
          format.json { render json: object.decorate }
        else
          # TODO: esto solucionaría el problema?
          # self.instancia_modelo = instancia_modelo.decorate
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: object.errors, status: :unprocessable_entity }
        end
      end
    end

    def pg_respond_create
      object = instancia_modelo
      respond_to do |format|
        if (@saved = object.save)
          # TODO: 'asociable' lo cambiaría por 'in_modal' o algo así
          if params[:asociable]
            format.turbo_stream do
              render turbo_stream:
                turbo_stream.update_all('.modal.show .pg-associable-form', <<~HTML
                  <div data-modal-target="response" data-response='#{object.decorate.to_json}'></div>
                HTML
                )
              # FIXME: handlear json
              # render json: object.decorate, content_type: 'application/json'
            end
          end
          format.html do
            if params[:save_and_next] == 'true'
              new_path = "#{url_for(@clase_modelo)}/new"
              redirect_to new_path, notice: "#{@clase_modelo.nombre_singular} creado."
            else
              redirect_to object.decorate.target_object
            end
          end
          format.json { render json: object.decorate }
        else
          # TODO: esto solucionaría el problema?
          # self.instancia_modelo = instancia_modelo.decorate
          if params[:asociable]
            format.turbo_stream do
              # FIXME: agregar , status: :unprocessable_entity
              render turbo_stream:
                turbo_stream.update_all('.modal.show .pg-associable-form', partial: 'form', locals: { asociable: true })
            end
          end
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: object.errors.full_messages, status: :unprocessable_entity }
        end
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

    def pg_respond_show(object = nil)
      object ||= instancia_modelo
      if params[:modal].present?
        render turbo_stream: turbo_stream.append_all(
          'body', partial: 'pg_layout/modal_show', locals: { object: }
        )
      else
        respond_to do |format|
          format.json { render json: object }
          format.html
        end
      end
    end

    def pg_respond_destroy(model, redirect_url = nil)
      if destroy_model(model)
        msg = "#{model.model_name.human} #{model.gender == 'f' ? 'borrada' : 'borrado'}"
        respond_to do |format|
          if redirect_url.present?
            format.html do
              redirect_to redirect_url, notice: msg, status: :see_other
            end
          else
            format.turbo_stream do
              # Esto no es totalmente limpio pero funciona tanto en los listados como en los
              # modal show
              render turbo_stream: turbo_stream.remove(model) + turbo_stream.remove_all('.modal')
            end
            format.html do
              redirect_back(fallback_location: root_path, notice: msg, status: 303)
            end
            format.json { head :no_content }
          end
        end
      else
        respond_to do |format|
          format.html do
            if model.respond_to?(:associated_elements) && model.associated_elements.present?
              @model = model
              render destroy_error_details_view
            else
              flash[:alert] = @error_message
              redirect_back(fallback_location: root_path, status: 303)
            end
          end
          format.json { render json: { error: @error_message }, status: :unprocessable_entity }
        end
      end
    end

    # TODO: crear esta vista en pg_rails
    def destroy_error_details_view
      'destroy_error_details'
    end

    def destroy_model(model)
      @error_message = 'No se pudo eliminar el registro'
      begin
        destroy_method = model.respond_to?(:discard) ? :discard : :destroy
        return true if model.send(destroy_method)

        @error_message = model.errors.full_messages.join(', ')
        false
      rescue ActiveRecord::InvalidForeignKey => e
        # class_name = /from table \"(?<table_name>[\p{L}_]*)\"/.match(e.message)[:table_name].singularize.camelcase
        # # pk_id = /from table \"(?<pk_id>[\p{L}_]*)\"/.match(e.message)[:pk_id].singularize.camelcase
        # clazz = Object.const_get class_name
        # objects = clazz.where(model.class.table_name.singularize => model)
        model_name = t("activerecord.models.#{model.class.name.underscore}")
        @error_message = "#{model_name} no se pudo borrar porque tiene elementos asociados."
        logger.debug e.message
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
