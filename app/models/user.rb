class User < ApplicationRecord
  include Billing::Billable
  include Notifications::Notifiable

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
