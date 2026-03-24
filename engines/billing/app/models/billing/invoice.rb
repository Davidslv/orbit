module Billing
  class Invoice < ApplicationRecord
    include Core::Auditable

    belongs_to :user, class_name: "User", foreign_key: :user_id, optional: true

    attribute :currency, :string, default: -> { Billing.currency }

    validates :user_id, presence: true
    validates :amount_cents, presence: true, numericality: { greater_than: 0 }
    validates :currency, presence: true
    validates :status, presence: true, inclusion: { in: %w[pending paid overdue cancelled] }

    scope :pending, -> { where(status: "pending") }
    scope :paid, -> { where(status: "paid") }
    scope :overdue, -> { where(status: "overdue") }
    scope :recent, -> { order(created_at: :desc).limit(10) }

    after_create_commit :publish_created_event

    def mark_as_paid!
      update!(status: "paid", paid_at: Time.current)
      publish_paid_event
    end

    private

    def publish_created_event
      ActiveSupport::Notifications.instrument("invoice.created.billing", {
        invoice_id: id,
        user_id: user_id,
        amount_cents: amount_cents,
        currency: currency
      })
    end

    def publish_paid_event
      ActiveSupport::Notifications.instrument("invoice.paid.billing", {
        invoice_id: id,
        user_id: user_id,
        amount_cents: amount_cents,
        currency: currency
      })
    end
  end
end
