include PgEngine::RouteHelpers

Rails.application.routes.draw do
  namespace :frontend, path: 'u' do
    pg_resource(:cosas)
    pg_resource(:categoria_de_cosas)
  end
  namespace :admin, path: 'a' do
    pg_resource(:cosas)
    pg_resource(:categoria_de_cosas) do
      pg_resource(:cosas)
    end
  end
  root "frontend/categoria_de_cosas#index"

  get :action_with_redirect, to: 'dummy_base#action_with_redirect'
  get :check_dev_user, to: 'dummy_base#check_dev_user'
  get :test_not_authorized, to: 'dummy_base#test_not_authorized'
  get :test_internal_error, to: 'dummy_base#test_internal_error'
end
