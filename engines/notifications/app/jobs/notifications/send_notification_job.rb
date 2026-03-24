module Notifications
  class SendNotificationJob < ApplicationJob
    queue_as :default

    def perform(recipient_type:, recipient_id:, subject:, body:)
      recipient = recipient_type.constantize.find_by(id: recipient_id)
      return unless recipient

      Notification.create!(
        recipient: recipient,
        subject: subject,
        body: body
      )
    end
  end
end
