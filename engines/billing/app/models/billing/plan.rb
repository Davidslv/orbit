module Billing
  class Plan < ApplicationRecord
    has_many :subscriptions, dependent: :restrict_with_error

    validates :name, presence: true
    validates :price_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :interval, presence: true, inclusion: { in: %w[monthly yearly] }

    scope :active, -> { where(active: true) }
  end
end
