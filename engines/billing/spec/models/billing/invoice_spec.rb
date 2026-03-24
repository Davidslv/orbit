require "rails_helper"

RSpec.describe Billing::Invoice, type: :model do
  describe "validations" do
    it "requires user_id" do
      invoice = Billing::Invoice.new(amount_cents: 1000, currency: "GBP", status: "pending")
      expect(invoice).not_to be_valid
      expect(invoice.errors[:user_id]).to include("can't be blank")
    end

    it "requires amount_cents greater than 0" do
      invoice = Billing::Invoice.new(user_id: 1, amount_cents: 0, currency: "GBP", status: "pending")
      expect(invoice).not_to be_valid
      expect(invoice.errors[:amount_cents]).to include("must be greater than 0")
    end

    it "requires a valid status" do
      invoice = Billing::Invoice.new(user_id: 1, amount_cents: 1000, currency: "GBP", status: "invalid")
      expect(invoice).not_to be_valid
    end

    it "is valid with all required attributes" do
      invoice = Billing::Invoice.new(user_id: 1, amount_cents: 1000, currency: "GBP", status: "pending")
      expect(invoice).to be_valid
    end
  end

  describe "#mark_as_paid!" do
    it "sets status to paid and records timestamp" do
      invoice = Billing::Invoice.create!(user_id: 1, amount_cents: 1000, currency: "GBP", status: "pending")

      freeze_time do
        invoice.mark_as_paid!
        expect(invoice.reload.status).to eq("paid")
        expect(invoice.paid_at).to eq(Time.current)
      end
    end

    it "publishes an invoice.paid.billing event" do
      invoice = Billing::Invoice.create!(user_id: 1, amount_cents: 1000, currency: "GBP", status: "pending")
      events = []

      ActiveSupport::Notifications.subscribe("invoice.paid.billing") do |event|
        events << event
      end

      invoice.mark_as_paid!

      expect(events.size).to eq(1)
      expect(events.first.payload[:invoice_id]).to eq(invoice.id)
    ensure
      ActiveSupport::Notifications.unsubscribe("invoice.paid.billing")
    end
  end

  describe "callbacks" do
    it "publishes invoice.created.billing on create" do
      events = []

      ActiveSupport::Notifications.subscribe("invoice.created.billing") do |event|
        events << event
      end

      Billing::Invoice.create!(user_id: 1, amount_cents: 1000, currency: "GBP", status: "pending")

      expect(events.size).to eq(1)
      expect(events.first.payload[:amount_cents]).to eq(1000)
    ensure
      ActiveSupport::Notifications.unsubscribe("invoice.created.billing")
    end
  end

  describe "scopes" do
    before do
      Billing::Invoice.create!(user_id: 1, amount_cents: 1000, currency: "GBP", status: "pending")
      Billing::Invoice.create!(user_id: 1, amount_cents: 2000, currency: "GBP", status: "paid")
      Billing::Invoice.create!(user_id: 1, amount_cents: 3000, currency: "GBP", status: "overdue")
    end

    it ".pending returns only pending invoices" do
      expect(Billing::Invoice.pending.count).to eq(1)
    end

    it ".paid returns only paid invoices" do
      expect(Billing::Invoice.paid.count).to eq(1)
    end

    it ".overdue returns only overdue invoices" do
      expect(Billing::Invoice.overdue.count).to eq(1)
    end
  end
end
