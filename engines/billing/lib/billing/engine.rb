module Billing
  class Engine < ::Rails::Engine
    isolate_namespace Billing

    initializer "billing.i18n" do
      config.i18n.load_path += Dir[root.join("config", "locales", "**", "*.{rb,yml}")]
    end

    initializer "billing.active_record" do
      ActiveSupport.on_load(:active_record) do
        # Engine-specific AR configuration can go here
      end
    end

    initializer "billing.helpers" do
      ActiveSupport.on_load(:action_controller_base) do
        helper Billing::Engine.helpers
      end
    end
  end
end
