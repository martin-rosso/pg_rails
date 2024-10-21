# This migration comes from pg_engine_engine (originally 20241023203849)
class DeviseInvitable < ActiveRecord::Migration[7.2]
  def change
      add_column :users, :invitation_token, :string
      add_column :users, :invitation_created_at, :datetime
      add_column :users, :invitation_sent_at, :datetime
      add_column :users, :invitation_accepted_at, :datetime
      add_column :users, :invitation_limit, :integer
      add_column :users, :invited_by_id, :integer
      add_column :users, :invited_by_type, :string
      add_index :users, :invitation_token, unique: true
      change_column_null :users, :nombre, true
      change_column_null :users, :apellido, true
  end
end
