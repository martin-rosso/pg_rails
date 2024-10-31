module PgEngine
  class BasePublicController < ApplicationController
    before_action do
      Current.namespace = :public
    end

    # :nocov:
    def login_as
      # TODO!: make a POST route
      return head :bad_request unless dev_user_or_env?

      Current.namespace = nil

      usuario = User.find(params[:id])
      if usuario.confirmed_at.present?
        sign_in(:user, usuario)
        # redirect_to after_sign_in_path_for(usuario)
        redirect_to users_root_path
      else
        go_back('No está confirmado')
      end
    end
    # :nocov:
  end
end
