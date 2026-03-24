require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "requires an email" do
      user = User.new(name: "Alice")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "requires a unique email" do
      User.create!(email: "alice@example.com", name: "Alice")
      duplicate = User.new(email: "alice@example.com", name: "Alice 2")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:email]).to include("has already been taken")
    end

    it "requires a name" do
      user = User.new(email: "alice@example.com")
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end
  end

  describe "Billing::Billable concern" do
    let(:user) { User.create!(email: "alice@example.com", name: "Alice") }
    let(:plan) { Billing::Plan.create!(name: "Pro", price_cents: 1999, interval: "monthly") }

    it "has invoices" do
      Billing::Invoice.create!(user_id: user.id, amount_cents: 1000, currency: "GBP", status: "pending")
      expect(user.invoices.count).to eq(1)
    end

    it "has subscriptions" do
      Billing::Subscription.create!(
        user_id: user.id, plan: plan, status: "active", started_at: Time.current
      )
      expect(user.subscriptions.count).to eq(1)
    end

    it "#active_plan returns the current plan" do
      Billing::Subscription.create!(
        user_id: user.id, plan: plan, status: "active", started_at: Time.current
      )
      expect(user.active_plan).to eq(plan)
    end

    it "#billable? returns true when user has an active subscription" do
      Billing::Subscription.create!(
        user_id: user.id, plan: plan, status: "active", started_at: Time.current
      )
      expect(user).to be_billable
    end

    it "#billable? returns false when user has no active subscription" do
      expect(user).not_to be_billable
    end
  end

  describe "Notifications::Notifiable concern" do
    let(:user) { User.create!(email: "bob@example.com", name: "Bob") }

    it "has notifications" do
      Notifications::Notification.create!(
        recipient: user, subject: "Hello", body: "World"
      )
      expect(user.notifications.count).to eq(1)
    end

    it "#unread_notifications_count" do
      Notifications::Notification.create!(recipient: user, subject: "New", body: "Unread")
      Notifications::Notification.create!(recipient: user, subject: "Old", body: "Read", read_at: Time.current)
      expect(user.unread_notifications_count).to eq(1)
    end

    it "#mark_all_notifications_as_read!" do
      Notifications::Notification.create!(recipient: user, subject: "A", body: "1")
      Notifications::Notification.create!(recipient: user, subject: "B", body: "2")
      user.mark_all_notifications_as_read!
      expect(user.unread_notifications_count).to eq(0)
    end
  end
end
