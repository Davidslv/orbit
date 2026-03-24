class AddAuditColumnsToBillingInvoices < ActiveRecord::Migration[8.1]
  def change
    add_column :billing_invoices, :created_by, :bigint
    add_column :billing_invoices, :updated_by, :bigint
  end
end
