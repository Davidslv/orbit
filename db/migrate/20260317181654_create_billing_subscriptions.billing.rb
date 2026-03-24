# This migration comes from billing (originally 20260317181355)
class CreateBillingSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :billing_subscriptions do |t|
      t.bigint :user_id, null: false
      t.references :plan, null: false, foreign_key: { to_table: :billing_plans }
      t.string :status, default: "active", null: false
      t.datetime :started_at
      t.datetime :cancelled_at

      t.timestamps
    end

    add_index :billing_subscriptions, :user_id
  end
end
