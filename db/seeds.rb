# Clean up existing data
Notifications::Notification.delete_all
Billing::Invoice.delete_all
Billing::Subscription.delete_all
Billing::Plan.delete_all
User.delete_all

# Create plans
starter = Billing::Plan.create!(name: "Starter", price_cents: 999, interval: "monthly")
pro = Billing::Plan.create!(name: "Pro", price_cents: 2999, interval: "monthly")
enterprise = Billing::Plan.create!(name: "Enterprise", price_cents: 9999, interval: "yearly")

puts "Created #{Billing::Plan.count} plans"

# Create users
alice = User.create!(email: "alice@example.com", name: "Alice Johnson")
bob = User.create!(email: "bob@example.com", name: "Bob Smith")
carol = User.create!(email: "carol@example.com", name: "Carol Williams")

puts "Created #{User.count} users"

# Create subscriptions
Billing::Subscription.create!(
  user_id: alice.id, plan: pro, status: "active", started_at: 3.months.ago
)
Billing::Subscription.create!(
  user_id: bob.id, plan: starter, status: "active", started_at: 1.month.ago
)
Billing::Subscription.create!(
  user_id: carol.id, plan: enterprise, status: "cancelled",
  started_at: 6.months.ago, cancelled_at: 1.week.ago
)

puts "Created #{Billing::Subscription.count} subscriptions"

# Create invoices (these will also trigger notification events)
Billing::Invoice.create!(
  user_id: alice.id, amount_cents: 2999, currency: "GBP",
  status: "paid", paid_at: 1.month.ago, due_date: 1.month.ago.to_date
)
Billing::Invoice.create!(
  user_id: alice.id, amount_cents: 2999, currency: "GBP",
  status: "pending", due_date: Date.today + 15
)
Billing::Invoice.create!(
  user_id: bob.id, amount_cents: 999, currency: "GBP",
  status: "pending", due_date: Date.today + 7
)
Billing::Invoice.create!(
  user_id: carol.id, amount_cents: 9999, currency: "GBP",
  status: "overdue", due_date: 1.week.ago.to_date
)

puts "Created #{Billing::Invoice.count} invoices"
puts "Created #{Notifications::Notification.count} notifications (via events)"
