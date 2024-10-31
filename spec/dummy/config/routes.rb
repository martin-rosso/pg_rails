include PgEngine::RouteHelpers

Rails.application.routes.draw do
  namespace :tenant, path: 'u/t(/:tid)' do
    pg_resource(:cosas)
    pg_resource(:categoria_de_cosas) do
      pg_resource(:cosas)
    end
  end

  namespace :admin, path: 'a' do
    pg_resource(:cosas)
    pg_resource(:categoria_de_cosas) do
      pg_resource(:cosas)
    end
  end

  get :action_with_redirect, to: 'dummy_base#action_with_redirect'
  get :check_dev_user, to: 'dummy_base#check_dev_user'
  get :test_not_authorized, to: 'dummy_base#test_not_authorized'
  get :test_internal_error, to: 'dummy_base#test_internal_error'
end
