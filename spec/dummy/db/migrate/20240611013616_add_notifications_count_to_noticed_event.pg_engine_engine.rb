# This migration comes from pg_engine_engine (originally 20240611000220)
# This migration comes from noticed (originally 20240129184740)
class AddNotificationsCountToNoticedEvent < ActiveRecord::Migration[6.1]
  def change
    add_column :noticed_events, :notifications_count, :integer
  end
end
