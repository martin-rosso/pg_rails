# This migration comes from pg_engine_engine (originally 20241027225618)
class AddMembershipStatusToUserAccounts < ActiveRecord::Migration[7.2]
  def change
    add_column :user_accounts, :membership_status, :integer, null: false, default: 1
    add_column :user_accounts, :invitation_status, :integer, null: false, default: 1
  end

  def migrate(direction)
    if direction == :up
      UserAccount.update_all(profiles: [0])
    end
    super
  end
end
