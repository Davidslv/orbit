module Billing
  module Api
    module V1
      class InvoicesController < ActionController::API
        # NOTE: In production, add authentication before_action here.
        # This controller is intentionally minimal for demonstration purposes.

        def index
          invoices = Billing::Invoice.recent
          render json: invoices.map { |invoice| serialize(invoice) }
        end

        def show
          invoice = Billing::Invoice.find(params[:id])
          render json: serialize(invoice)
        end

        private

        def serialize(invoice)
          {
            id: invoice.id,
            user_id: invoice.user_id,
            amount_cents: invoice.amount_cents,
            currency: invoice.currency,
            status: invoice.status,
            due_date: invoice.due_date,
            paid_at: invoice.paid_at,
            created_at: invoice.created_at,
            updated_at: invoice.updated_at
          }
        end
      end
    end
  end
end
