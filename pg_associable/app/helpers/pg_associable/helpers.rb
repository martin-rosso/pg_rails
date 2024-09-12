module PgAssociable
  module Helpers
    MAX_RESULTS = 8

    def pg_respond_abrir_modal
      src = clase_modelo.new.decorate.new_object_url
      content = ModalContentComponent.new(src:).render_in(view_context)
      modal = AsociableModalComponent.new(modal_id: params[:id]).with_content(content)
      render turbo_stream: turbo_stream.append_all('body', modal)
    end

    def pg_respond_buscar
      partial = 'pg_associable/resultados_inline'
      resultados_prefix = 'resultados-inline'
      query = params[:query]
      timeout_id = params[:timeout_id]
      @collection = search_in_scope(query)
      render turbo_stream:
        turbo_stream.update("#{resultados_prefix}-#{params[:id]}",
                            partial:, locals: { collection: @collection, query:, timeout_id: })
    end

    def search_in_scope(query)
      scope = policy_scope(clase_modelo).kept

      if clase_modelo.ransackable_attributes.include?('search')
        scope.ransack(search_cont: query).result
      else
        Rails.logger.warn("WARNING: #{clase_modelo} should implement a 'search' ransacker")

        if scope.respond_to?(:query)
          Rails.logger.warn("DEPRECATED WARNING: #{clase_modelo}#query is deprecated in favor of 'search' ransacker")
          scope.query(query)
        else
          scope.where(id: query)
        end
      end
    end
  end
end
