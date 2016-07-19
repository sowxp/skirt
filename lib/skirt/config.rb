module Skirt

  module Config
    extend self
    attr_accessor :after_login_path
    attr_accessor :purchase_path
    attr_accessor :client_id
    attr_accessor :seller_id

    attr_accessor :mws_access_key_id
    attr_accessor :mws_secret_key

    # メールに表示される情報(オプション)
    attr_accessor :store_name                # ショップ名・サイト名
    attr_accessor :seller_note               # 販売事業者情報
    attr_accessor :seller_authorization_note # 請求情報の追記事項
  end

  class << self
    def configure
      block_given? ? yield(Config) : Config
    end

    def config
      Config
    end
  end
end
