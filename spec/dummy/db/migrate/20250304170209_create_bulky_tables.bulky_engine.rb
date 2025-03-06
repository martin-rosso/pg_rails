# This migration comes from bulky_engine (originally 20150817161700)
class CreateBulkyTables < ActiveRecord::Migration[7.2]
  def change
    create_table :bulky_bulk_updates, force: true do |t|
      t.integer :ids, array: true, null: false
      t.jsonb :updates,  null: false
      t.integer :initiated_by_id

      t.timestamps null: false
    end
    add_index :bulky_bulk_updates, :initiated_by_id

    create_table :bulky_updated_records, force: true do |t|
      t.integer :bulk_update_id,    null: false
      t.integer :updatable_id,      null: false
      t.string  :updatable_type,    null: false
      t.jsonb    :updatable_changes, null: false
      t.string  :error_message
      t.text    :error_backtrace

      t.timestamps null: false
    end
    add_index :bulky_updated_records, :bulk_update_id
    add_index :bulky_updated_records, [:updatable_type, :updatable_id]
  end
end
