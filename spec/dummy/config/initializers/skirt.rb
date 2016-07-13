# require 'skirt'
# 
require 'skirt/config'
Skirt.configure do |config|

  # ログイン後のURL
  if Rails.env.test?
    config.after_login_path = 'https://sowxp-gift-poltergeist.dev:8443/amazon_payments/new'
  elsif Rails.env.development?
    config.after_login_path = 'https://sowxp-gift.dev/amazon_payments/new'
  end

  # 購入処理のURL
  config.purchase_path = '/amazon_payments'

  # amzn1.application-oa2-client.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  config.client_id = ENV['AMAZON_PAYMENTS_CLIENT_ID']
  # A108**********
  config.seller_id = ENV['AMAZON_PAYMENTS_SELLER_ID']

  # AKI*****************
  config.developer_access_key = ENV['AMAZON_PAYMENTS_DEVELOPER_ACCESS_KEY']

  # 7ML*************************************
  config.developer_secret_key = ENV['AMAZON_PAYMENTS_DEVELOPER_SECRET_KEY']

  # ショップ名・サイト名
  config.store_name = "dummy"

  # 販売事業者情報
  config.seller_note = nil

  # 請求情報の追記事項
  config.seller_authorization_note = nil

end
