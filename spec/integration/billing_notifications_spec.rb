require "rails_helper"

RSpec.describe "Billing to Notifications integration", type: :model do
  include ActiveJob::TestHelper

  let(:user) { User.create!(email: "alice@example.com", name: "Alice") }

  it "creates a notification when an invoice is created" do
    perform_enqueued_jobs do
      expect {
        Billing::Invoice.create!(
          user_id: user.id,
          amount_cents: 5000,
          currency: "GBP",
          status: "pending"
        )
      }.to change { user.notifications.count }.by(1)
    end

    notification = user.notifications.last
    expect(notification.subject).to eq("New invoice")
    expect(notification.body).to include("5000")
  end

  it "creates a notification when an invoice is paid" do
    invoice = perform_enqueued_jobs {
      Billing::Invoice.create!(
        user_id: user.id,
        amount_cents: 5000,
        currency: "GBP",
        status: "pending"
      )
    }

    perform_enqueued_jobs do
      expect {
        invoice.mark_as_paid!
      }.to change { user.notifications.count }.by(1)
    end

    notification = user.notifications.last
    expect(notification.subject).to eq("Invoice paid")
  end
end
