module Notifications
  module Notifiable
    extend ActiveSupport::Concern

    included do
      has_many :notifications,
               class_name: "Notifications::Notification",
               as: :recipient,
               dependent: :destroy
    end

    def unread_notifications
      notifications.unread
    end

    def unread_notifications_count
      unread_notifications.count
    end

    def mark_all_notifications_as_read!
      unread_notifications.update_all(read_at: Time.current)
    end
  end
end
