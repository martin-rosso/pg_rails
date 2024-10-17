module PgEngine
  module RouteHelpers
    def pg_resource(key, options = {})
      resources(key, options) do
        member do
          post :archive
          post :restore
        end
        collection do
          get :archived
          get :abrir_modal
          post :buscar
        end
        yield if block_given?
      end
    end
  end
end
