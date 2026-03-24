module Billing
  class InvoicePolicy
    attr_reader :user, :invoice

    def initialize(user, invoice)
      @user = user
      @invoice = invoice
    end

    def show?
      return false unless user

      owner? || admin?
    end

    def refund?
      return false unless user

      admin? && invoice.status == "paid"
    end

    private

    def owner?
      invoice.user_id == user.id
    end

    def admin?
      user.respond_to?(:admin?) && user.admin?
    end
  end
end
