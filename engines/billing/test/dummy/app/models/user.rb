class User < ApplicationRecord
  include Billing::Billable

  validates :email, presence: true
  validates :name, presence: true
end
