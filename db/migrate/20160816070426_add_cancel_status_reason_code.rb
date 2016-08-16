class AddCancelStatusReasonCode < ActiveRecord::Migration
  def change
    add_column :amazon_order_references, :cancel_status_reason_code, :string
  end
end
