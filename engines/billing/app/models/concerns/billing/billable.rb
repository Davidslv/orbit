module Billing
  module Billable
    extend ActiveSupport::Concern

    included do
      has_many :invoices,
               class_name: "Billing::Invoice",
               foreign_key: :user_id,
               dependent: :restrict_with_error

      has_many :subscriptions,
               class_name: "Billing::Subscription",
               foreign_key: :user_id,
               dependent: :restrict_with_error
    end

    def current_subscription
      subscriptions.active.order(started_at: :desc).first
    end

    def active_plan
      current_subscription&.plan
    end

    def billable?
      current_subscription.present?
    end
  end
end
