require "billing/version"
require "billing/engine"

module Billing
  mattr_accessor :customer_class, default: "User"
  mattr_accessor :currency, default: "GBP"
  mattr_accessor :tax_rate, default: 0.20
  mattr_accessor :parent_controller, default: "::ApplicationController"

  def self.customer_model
    customer_class.constantize
  end
end
