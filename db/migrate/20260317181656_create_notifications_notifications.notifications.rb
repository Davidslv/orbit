class CreateNotificationsNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications_notifications do |t|
      t.string :recipient_type, null: false
      t.bigint :recipient_id, null: false
      t.string :subject
      t.text :body
      t.datetime :read_at

      t.timestamps
    end

    add_index :notifications_notifications, [:recipient_type, :recipient_id]
  end
end
