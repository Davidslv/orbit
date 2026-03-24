module Billing
  class SubscriptionsController < ApplicationController
    def index
      @subscriptions = Subscription.all
    end

    def show
      @subscription = Subscription.find(params[:id])
    end
  end
end
