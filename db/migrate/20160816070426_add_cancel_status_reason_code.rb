class AddCancelStatusReasonCode < ActiveRecord::Migration
  def change
    add_column :amazon_order_references, :cancel_status_reason_code, :string, after: :capture_result
  end
end
