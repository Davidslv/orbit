require "rails_helper"

RSpec.describe Notifications::Notification, type: :model do
  let(:user) { User.create!(email: "test@example.com", name: "Test User") }

  describe "validations" do
    it "requires a subject" do
      notification = Notifications::Notification.new(recipient: user, body: "Hello")
      expect(notification).not_to be_valid
      expect(notification.errors[:subject]).to include("can't be blank")
    end

    it "requires a body" do
      notification = Notifications::Notification.new(recipient: user, subject: "Hello")
      expect(notification).not_to be_valid
      expect(notification.errors[:body]).to include("can't be blank")
    end

    it "is valid with all required attributes" do
      notification = Notifications::Notification.new(
        recipient: user, subject: "Hello", body: "World"
      )
      expect(notification).to be_valid
    end
  end

  describe "#mark_as_read!" do
    it "sets read_at" do
      notification = Notifications::Notification.create!(
        recipient: user, subject: "Hello", body: "World"
      )

      freeze_time do
        notification.mark_as_read!
        expect(notification.reload.read_at).to eq(Time.current)
      end
    end

    it "does not update if already read" do
      notification = Notifications::Notification.create!(
        recipient: user, subject: "Hello", body: "World",
        read_at: 1.hour.ago
      )

      original_read_at = notification.read_at
      notification.mark_as_read!
      expect(notification.reload.read_at).to eq(original_read_at)
    end
  end

  describe "#mark_as_unread!" do
    it "clears read_at" do
      notification = Notifications::Notification.create!(
        recipient: user, subject: "Hello", body: "World",
        read_at: Time.current
      )

      notification.mark_as_unread!
      expect(notification.reload.read_at).to be_nil
    end
  end

  describe "#read?" do
    it "returns true when read_at is set" do
      notification = Notifications::Notification.new(read_at: Time.current)
      expect(notification).to be_read
    end

    it "returns false when read_at is nil" do
      notification = Notifications::Notification.new(read_at: nil)
      expect(notification).not_to be_read
    end
  end

  describe "scopes" do
    before do
      Notifications::Notification.create!(recipient: user, subject: "Read", body: "Body", read_at: Time.current)
      Notifications::Notification.create!(recipient: user, subject: "Unread", body: "Body")
    end

    it ".unread returns only unread notifications" do
      expect(Notifications::Notification.unread.count).to eq(1)
      expect(Notifications::Notification.unread.first.subject).to eq("Unread")
    end

    it ".read returns only read notifications" do
      expect(Notifications::Notification.read.count).to eq(1)
      expect(Notifications::Notification.read.first.subject).to eq("Read")
    end
  end
end
