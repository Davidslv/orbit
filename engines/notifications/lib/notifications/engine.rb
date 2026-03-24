module Notifications
  class Engine < ::Rails::Engine
    isolate_namespace Notifications

    initializer "notifications.i18n" do
      config.i18n.load_path += Dir[root.join("config", "locales", "**", "*.{rb,yml}")]
    end

    initializer "notifications.active_record" do
      ActiveSupport.on_load(:active_record) do
        # Engine-specific AR configuration can go here
      end
    end

    initializer "notifications.helpers" do
      ActiveSupport.on_load(:action_controller_base) do
        helper Notifications::Engine.helpers
      end
    end

    initializer "notifications.subscribe_to_billing_events" do
      ActiveSupport.on_load(:active_record) do
        if defined?(Billing)
          ActiveSupport::Notifications.subscribe("invoice.created.billing") do |event|
            Notifications::SendNotificationJob.perform_later(
              recipient_type: "User",
              recipient_id: event.payload[:user_id],
              subject: "New invoice",
              body: "Invoice for #{event.payload[:amount_cents]} cents has been created."
            )
          end

          ActiveSupport::Notifications.subscribe("invoice.paid.billing") do |event|
            Notifications::SendNotificationJob.perform_later(
              recipient_type: "User",
              recipient_id: event.payload[:user_id],
              subject: "Invoice paid",
              body: "Your invoice has been paid. Thank you!"
            )
          end
        end
      end
    end
  end
end
