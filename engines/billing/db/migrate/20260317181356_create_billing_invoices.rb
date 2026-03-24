class CreateBillingInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :billing_invoices do |t|
      t.bigint :user_id, null: false
      t.integer :amount_cents, null: false
      t.string :currency, default: "GBP", null: false
      t.string :status, default: "pending", null: false
      t.date :due_date
      t.datetime :paid_at

      t.timestamps
    end

    add_index :billing_invoices, :user_id
  end
end
