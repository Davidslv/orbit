require "rails_helper"

RSpec.describe Billing::Subscription, type: :model do
  let(:plan) { Billing::Plan.create!(name: "Starter", price_cents: 999, interval: "monthly") }

  describe "validations" do
    it "requires a user_id" do
      subscription = Billing::Subscription.new(plan: plan, status: "active")
      expect(subscription).not_to be_valid
      expect(subscription.errors[:user_id]).to include("can't be blank")
    end

    it "requires a valid status" do
      subscription = Billing::Subscription.new(plan: plan, user_id: 1, status: "invalid")
      expect(subscription).not_to be_valid
      expect(subscription.errors[:status]).to include("is not included in the list")
    end

    it "is valid with all required attributes" do
      subscription = Billing::Subscription.new(
        plan: plan, user_id: 1, status: "active", started_at: Time.current
      )
      expect(subscription).to be_valid
    end
  end

  describe "#cancel!" do
    it "sets status to cancelled and records the timestamp" do
      subscription = Billing::Subscription.create!(
        plan: plan, user_id: 1, status: "active", started_at: Time.current
      )

      freeze_time do
        subscription.cancel!
        expect(subscription.reload.status).to eq("cancelled")
        expect(subscription.cancelled_at).to eq(Time.current)
      end
    end
  end

  describe "scopes" do
    it ".active returns only active subscriptions" do
      active = Billing::Subscription.create!(plan: plan, user_id: 1, status: "active", started_at: Time.current)
      Billing::Subscription.create!(plan: plan, user_id: 2, status: "cancelled", started_at: Time.current)

      expect(Billing::Subscription.active).to contain_exactly(active)
    end
  end
end
