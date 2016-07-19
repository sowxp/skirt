module Skirt
  module AmazonAPI

    def client
      return @client if @client
      @client = ::PayWithAmazon::Client.new(
        Config.seller_id,
        Config.mws_access_key_id,
        Config.mws_secret_key,
        sandbox: true,
        currency_code: :jpy,
        region: :jp
      )
    end

    # オーソライズAPI呼び出し
    def call_authorize(transaction_timeout = nil)
      client.authorize(
        self.amazon_order_reference_id,
        self.generate_authorization_reference_id,
        self.amount,

        currency_code: 'JPY', # Default: USD
        seller_authorization_note: Config.seller_authorization_note,

        # Set to 0 for synchronous mode
        transaction_timeout: transaction_timeout,
        capture_now: false
      )
    end

    # キャプチャ（支払い）
    def call_capture
      client.capture(
        self.amazon_authorization_id,
        self.generate_capture_reference_id,
        self.amount,
        currency_code: 'JPY',
        seller_capture_note: ''
      )
    end

    def call_confirm_order_reference(amazon_order_reference_id)
      client.confirm_order_reference(amazon_order_reference_id)
    end

    def call_get_order_reference_details(amazon_order_reference_id,
                                         address_consent_token)

      client.get_order_reference_details(
        amazon_order_reference_id,
        address_consent_token: address_consent_token
      )
    end

    def call_set_order_reference_details(seller_order_id = '')
      client.set_order_reference_details(
        amazon_order_reference_id,
        self.amount,
        # currency_code: 'JPY', # Default: USD
        seller_order_id:  seller_order_id,
        seller_note:      Config.seller_note,
        store_name:       Config.store_name
      )
    end

    def call_close_order_reference(amazon_order_reference_id)
      client.close_order_reference(amazon_order_reference_id)
    end

    def treat_error(ret_xml, column)
      error_code = parse_error_code(ret_xml)
      self.update_column(column, error_code) unless self.new_record?

      error_code
    end

    def parse_error_code(ret_xml)
      code = nil
      response = Hash.from_xml ret_xml.body
      if response["ErrorResponse"]
        code = response["ErrorResponse"]["Error"]["Code"]
      end

      code
    end

    # Set a unique id for your current authorization
    # of this payment.
    def generate_authorization_reference_id
      return self.authorization_reference_id if self.authorization_reference_id

      "auth-#{Time.now.to_i}-#{self.id}"
    end

    # Set a unique id for your current authorization
    # of this payment.
    def generate_capture_reference_id
      return self.capture_reference_id if self.capture_reference_id

      self.capture_reference_id = "capture-#{Time.now.to_i}-#{self.id}"
    end

  end

end
