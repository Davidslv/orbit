module Notifications
  class Notification < ApplicationRecord
    belongs_to :recipient, polymorphic: true

    validates :subject, presence: true
    validates :body, presence: true

    scope :unread, -> { where(read_at: nil) }
    scope :read, -> { where.not(read_at: nil) }
    scope :recent, -> { order(created_at: :desc).limit(10) }

    def read?
      read_at.present?
    end

    def mark_as_read!
      update!(read_at: Time.current) unless read?
    end

    def mark_as_unread!
      update!(read_at: nil)
    end
  end
end
