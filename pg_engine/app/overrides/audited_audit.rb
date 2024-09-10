Audited::Audit.class_eval do
  before_validation do
    if account_id.nil?
      if auditable.respond_to?(:account_id)
        self.account_id = auditable.account_id
      elsif auditable_type == 'Account'
        self.account_id = auditable.id
      elsif ActsAsTenant.current_tenant.present?
        self.account = ActsAsTenant.current_tenant
      end
    end
  end

  belongs_to :account, optional: true
end
