class CreateSkirtAmazonOrderReferences < ActiveRecord::Migration
  def change
    create_table :amazon_order_references do |t|
      t.integer :user_id

      t.string :amazon_order_reference_id

      t.string :authorization_reference_id
      t.string :capture_reference_id

      t.string :amazon_authorization_id

      t.string :amount

      t.string :destination_state_or_region
      t.string :destination_city
      t.string :destination_phone
      t.string :destination_country_code
      t.string :destination_postal_code
      t.string :destination_name
      t.string :destination_address_line1
      t.string :destination_address_line2
      t.string :destination_address_line3

      t.string :buyer_name
      t.string :buyer_email

      t.string :order_reference_status
      t.string :order_reference_status_reason_code
      t.string :authorization_status
      t.string :authorization_status_reason_code
      t.string :capture_status
      t.string :capture_status_reason_code

      t.text :authorization_result
      t.text :capture_result

      t.timestamps null: false
    end
  end
end
