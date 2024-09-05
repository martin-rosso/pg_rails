class AccountTenantColumns < ActiveRecord::Migration[7.2]
  def change
    add_column :accounts, :domain, :string
    add_column :accounts, :subdomain, :string

    add_reference :audits, :account, index: true, foreign_key: true
    add_reference :emails, :account, index: true, foreign_key: true
    add_reference :email_logs, :account, index: true, foreign_key: true
  end
end
