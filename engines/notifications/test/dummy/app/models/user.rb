class User < ApplicationRecord
  include Notifications::Notifiable

  validates :email, presence: true
  validates :name, presence: true
end
