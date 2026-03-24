require "rails_helper"

RSpec.describe Billing::Plan, type: :model do
  describe "validations" do
    it "requires a name" do
      plan = Billing::Plan.new(price_cents: 999, interval: "monthly")
      expect(plan).not_to be_valid
      expect(plan.errors[:name]).to include("can't be blank")
    end

    it "requires price_cents" do
      plan = Billing::Plan.new(name: "Pro", interval: "monthly")
      expect(plan).not_to be_valid
      expect(plan.errors[:price_cents]).to include("can't be blank")
    end

    it "rejects negative price_cents" do
      plan = Billing::Plan.new(name: "Pro", price_cents: -100, interval: "monthly")
      expect(plan).not_to be_valid
      expect(plan.errors[:price_cents]).to include("must be greater than or equal to 0")
    end

    it "requires a valid interval" do
      plan = Billing::Plan.new(name: "Pro", price_cents: 999, interval: "weekly")
      expect(plan).not_to be_valid
      expect(plan.errors[:interval]).to include("is not included in the list")
    end

    it "is valid with all required attributes" do
      plan = Billing::Plan.new(name: "Pro", price_cents: 999, interval: "monthly")
      expect(plan).to be_valid
    end
  end

  describe "scopes" do
    it ".active returns only active plans" do
      active = Billing::Plan.create!(name: "Active", price_cents: 999, interval: "monthly", active: true)
      Billing::Plan.create!(name: "Inactive", price_cents: 999, interval: "monthly", active: false)

      expect(Billing::Plan.active).to contain_exactly(active)
    end
  end
end
