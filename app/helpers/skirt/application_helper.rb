module Skirt
  module ApplicationHelper

    def show_amazon_payments_address_widget
      render '/skirt/address_widget'
    end

    def show_amazon_payments_order_button
      render '/skirt/order_button'
    end

    def show_pay_with_amazon_button(popup = false, size = "medium")
      render '/skirt/pay_with_amazon_button', popup: popup, size: size
    end

    def show_amazon_payments_wallet_widget
      render '/skirt/wallet_widget'
    end

  end
end
