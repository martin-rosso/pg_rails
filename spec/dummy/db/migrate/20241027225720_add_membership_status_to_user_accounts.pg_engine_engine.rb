# This migration comes from pg_engine_engine (originally 20241027225618)
class AddMembershipStatusToUserAccounts < ActiveRecord::Migration[7.2]
  def change
    add_column :user_accounts, :membership_status, :integer, null: false, default: 2
  end
end
