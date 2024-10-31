# frozen_string_literal: true

module PgEngine
  module TenantHelper
    # rubocop:disable Metrics/AbcSize
    def set_tenant_from_params_or_fail!
      if ActsAsTenant.current_tenant.present?
        return unless Rails.env.test?

        # Si es un controller test
        # TODO: migrar a request
        ua = Current.user.user_accounts.ua_active.where(account: ActsAsTenant.current_tenant).first
        Current.active_user_account = ua

        # Si no fue seteado por el domain

        return
      end

      uaid = UserAccount.decode_id(params[:tid]) if params[:tid].present?

      ua = ActsAsTenant.without_tenant do
        Current.user.user_accounts.ua_active.where(id: uaid).first if uaid.present?
      end

      raise ActsAsTenant::Errors::NoTenantSet if ua.blank?

      set_current_tenant(ua.account)
      Current.active_user_account = ua
    end
    # rubocop:enable Metrics/AbcSize
  end
end
