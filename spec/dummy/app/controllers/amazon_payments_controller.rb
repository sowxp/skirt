require 'pay_with_amazon'
class AmazonPaymentsController < ApplicationController

  def login
    @popup = params[:popup] == 'true'
  end

  def new
  end

  def create

    @reference_id = params[:orderReferenceId]
    @access_token = params[:access_token]

    # TODO: 注文処理
    amount = '10.00'

    # 注文が成功したらamazon課金
    @aor = Skirt::AmazonOrderReference.new(amazon_order_reference_id: @reference_id, amount: amount)

    if Rails.env.test?
      seller_order_id = "rspec #{Time.now.to_s}"
    end 

    @aor.save_and_authorize(@access_token, seller_order_id)

    # TODO: 課金が成功しなかったらロールバック 

    # TODO: 完了画面へリダイレクト

    render plain: @aor.to_json

  end

end
