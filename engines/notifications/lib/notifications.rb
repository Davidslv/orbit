require "notifications/version"
require "notifications/engine"

module Notifications
  mattr_accessor :current_recipient_method, default: :current_user
  mattr_accessor :parent_controller, default: "::ApplicationController"
end
