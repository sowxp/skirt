require 'pay_with_amazon'

# [Order Reference Status メモ]
# https://payments.amazon.com/documentation/apireference/201752920
#
# Draft: confirmを呼ぶ前の状態。
# Open: confirmされた状態。この状態でないとauthorizeできない。
# Suspended: authorizeで問題が発生した状態。
# Canceled: キャンセルされた状態。
# Closed: CancelOrderReferenceが呼ばれた後の状態。authorizeはできない。

# [Authorization Status メモ]
# https://payments.amazon.com/documentation/apireference/201752950
#
# Pending: 非同期の場合、authorizeすると30秒間これになる
# Open: 非同期の場合、30秒経過するとこれになる　
# Decliend: authorizeがamazonによって拒否された
# Closed: CancelOrderReference されたらこれになる

# [Capture Statusメモ]
# https://payments.amazon.com/documentation/apireference/201753020

module Skirt
  class AmazonOrderReferenceError < StandardError; end

  class AmazonOrderReference < ActiveRecord::Base

    include AmazonAPI

    self.table_name = 'amazon_order_references'

    # seller_order_id
    # 販売事業者注文番号
    def set_order_refernce_details(seller_order_id = '')

      ret_xml = call_set_order_reference_details(seller_order_id)

      error_code = treat_error(ret_xml, :order_reference_status_reason_code)
      raise AmazonOrderReferenceError, error_code if error_code

      Hash.from_xml ret_xml.body
    end

    def get_order_reference_details(amazon_order_reference_id,
                                    address_consent_token)

      ret_xml = call_get_order_reference_details(
        amazon_order_reference_id,
        address_consent_token
      )

      error_code = treat_error(ret_xml, :order_reference_status_reason_code)
      raise AmazonOrderReferenceError, error_code if error_code

      Hash.from_xml ret_xml.body
    end

    def get_authorization_details
      call_get_authorization_details(self.amazon_authorization_id)
    end

    def copy_details(response)
      # GetOrderReferenceDetails
      # https://payments.amazon.com/documentation/apireference/201751970

      details = response["GetOrderReferenceDetailsResponse"]
                .try("[]", "GetOrderReferenceDetailsResult")
                .try("[]", "OrderReferenceDetails")

      return unless details
      return unless details["Destination"]

      destination = details["Destination"]["PhysicalDestination"]
      buyer       = details["Buyer"]
      order_reference_status = details["OrderReferenceStatus"]["State"]

      self.destination_state_or_region = destination["StateOrRegion"]
      self.destination_city            = destination["City"]
      self.destination_phone           = destination["Phone"]
      self.destination_country_code    = destination["CountryCode"]
      self.destination_postal_code     = destination["PostalCode"]
      self.destination_name            = destination["Name"]
      self.destination_address_line1   = destination["AddressLine1"]
      self.destination_address_line2   = destination["AddressLine2"]
      self.destination_address_line3   = destination["AddressLine3"]
      if buyer
        self.buyer_name  = buyer["Name"]
        self.buyer_email = buyer["Email"]
      end

      self.order_reference_status = order_reference_status
    end

    def confirm_order_reference

      # Make the ConfirmOrderReference API call to
      # confirm the details set in the API call
      # above.
      ret_xml = call_confirm_order_reference(amazon_order_reference_id)

      Hash.from_xml ret_xml.body
    end

    # オーソライズ
    def authorize(transation_timeout = 0)
      # オーソライズ呼び出し
      ret_xml = self.call_authorize(transation_timeout)

      # 結果を保存
      self.save_authorization_result(ret_xml)
      call_close_order_reference(amazon_order_reference_id)

      # エラー処理
      error_code = treat_error(ret_xml, :authorization_status_reason_code)
      raise AmazonOrderReferenceError, error_code if error_code

      Hash.from_xml ret_xml.body
    end

    # オーソライズのクローズ
    def close_authorization()
      self.call_close_authorization

      ret_xml = get_authorization_details

      path = 'GetAuthorizationDetailsResponse/GetAuthorizationDetailsResult/' \
             'AuthorizationDetails/AuthorizationStatus'

      self.authorization_status = ret_xml.get_element(path, 'State')
      self.save

      self.authorization_status == "Closed"
    end

    # オーソライズの結果をARに保持
    def save_authorization_result(ret_xml)

      path = 'AuthorizeResponse/AuthorizeResult/' \
             'AuthorizationDetails/AuthorizationStatus'


      self.authorization_status = ret_xml.get_element(path, 'State')
      # You will need the Amazon Authorization Id from the
      # Authorize API response if you decide to make the
      # Capture API call separately.
      self.amazon_authorization_id = ret_xml.get_element(
        'AuthorizeResponse/AuthorizeResult/AuthorizationDetails',
        'AmazonAuthorizationId'
      )

      result = Hash.from_xml ret_xml.body
      self.authorization_result = result.to_json

      self.save
    end

    def save_and_authorize(access_token, seller_order_id = nil)
      set_order_refernce_details(seller_order_id)
      confirm_order_reference

      if self.save!
        authorize

        response = get_order_reference_details(self.amazon_order_reference_id,
                                               access_token)

        copy_details(response)
        self.save
      end

      response
    end

    def capture
      ret_xml = call_capture

      path = 'CaptureResponse/CaptureResult' \
             '/CaptureDetails/CaptureStatus'

      self.capture_status = ret_xml.get_element(path, 'State')

      # エラー処理
      error_code = treat_error(ret_xml, :authorization_status_reason_code)
      raise AmazonOrderReferenceError, error_code if error_code

      response = Hash.from_xml ret_xml.body
      self.capture_result = response.to_json
      self.save

    end

    def captured?
      %w(Completed Closed).include? self.capture_status
    end

    def authorized?
      %w(Open).include? self.authorization_status
    end

    def cancel
      ret_xml = call_cancel_order_reference(amazon_order_reference_id)

      # エラー処理
      error_code = treat_error(ret_xml, :cancel_status_reason_code)
      raise AmazonOrderReferenceError, error_code if error_code

      inquire_order_status
    end

    def inquire_order_status
      # ステータス取得
      ret_xml = call_get_order_reference_details(self.amazon_order_reference_id)

      # エラー処理
      error_code = treat_error(ret_xml, :order_reference_status_reason_code)
      raise AmazonOrderReferenceError, error_code if error_code

      path = 'GetOrderReferenceDetailsResponse/GetOrderReferenceDetailsResult' \
             '/OrderReferenceDetails/OrderReferenceStatus'

      status = ret_xml.get_element(path, 'State')

      self.update_attribute(:order_reference_status, status)
    end

  end

end
