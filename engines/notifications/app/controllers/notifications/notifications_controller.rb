module Notifications
  class NotificationsController < ApplicationController
    def index
      @notifications = current_recipient.notifications.recent
    end

    def show
      @notification = current_recipient.notifications.find(params[:id])
    end

    def read
      @notification = current_recipient.notifications.find(params[:id])
      @notification.mark_as_read!
      redirect_to @notification, notice: "Notification marked as read."
    end

    def read_all
      current_recipient.notifications.unread.update_all(read_at: Time.current)
      redirect_to notifications_path, notice: "All notifications marked as read."
    end

    private

    def current_recipient
      send(Notifications.current_recipient_method)
    end
  end
end
