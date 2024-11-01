module PgEngine
  class TenantController < ApplicationController
    include PgEngine::RequireSignIn
    include PgEngine::TenantHelper

    before_action do
      Current.namespace = :tenant

      set_tenant_from_params_or_fail!

      cid = Current.account.id
      @other_active_accounts = ActsAsTenant.without_tenant do
        Current.user.user_accounts.ua_active.where.not(account_id: cid).to_a
      end

      unless using_modal2? || frame_embedded? ||
             (self.class.respond_to?(:skip_default_breadcrumb) && self.class.skip_default_breadcrumb)
        add_breadcrumb 'Inicio', :tenant_root_path
      end
    end
  end
end
