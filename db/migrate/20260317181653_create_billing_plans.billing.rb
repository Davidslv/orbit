# This migration comes from billing (originally 20260317181347)
class CreateBillingPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :billing_plans do |t|
      t.string :name
      t.integer :price_cents
      t.string :interval
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
