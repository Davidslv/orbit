module Billing
  class Subscription < ApplicationRecord
    belongs_to :plan

    validates :user_id, presence: true
    validates :status, presence: true, inclusion: { in: %w[active cancelled past_due] }

    scope :active, -> { where(status: "active") }

    def cancel!
      update!(status: "cancelled", cancelled_at: Time.current)
    end
  end
end
