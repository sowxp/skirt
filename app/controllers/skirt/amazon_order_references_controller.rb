require_dependency "skirt/application_controller"

module Skirt
  class AmazonOrderReferencesController < ApplicationController

    def show
      @reference_id = params[:orderReferenceId]
      @access_token = params[:access_token]
      @aor = AmazonOrderReference.new

      response = @aor.get_order_reference_details(@reference_id, @access_token)
      @aor.copy_details(response)

      render text: @aor.to_json

    rescue AmazonOrderReferenceError => e
      render text: [].to_json
    end

  end
end
