module PgEngine
  class BasePublicController < ApplicationController
    # :nocov:
    def login_as
      return head :bad_request unless dev_user_or_env?

      usuario = User.find(params[:id])
      if usuario.confirmed_at.present?
        sign_in(:user, usuario)
        redirect_to after_sign_in_path_for(usuario)
      else
        go_back('No está confirmado')
      end
    end
    # :nocov:
  end
end
