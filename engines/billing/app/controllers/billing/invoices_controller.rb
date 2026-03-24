module Billing
  class InvoicesController < ApplicationController
    def index
      @invoices = Invoice.recent
    end

    def show
      @invoice = Invoice.find(params[:id])
      policy = InvoicePolicy.new(current_user, @invoice)

      unless policy.show?
        head :forbidden
      end
    end
  end
end
