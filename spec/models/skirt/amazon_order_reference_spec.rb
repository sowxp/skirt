require 'rails_helper'

module Skirt
  RSpec.describe AmazonOrderReference, type: :model do


    # 正常系はturnipで
    describe '非正常系' do
      
      it 'set_order_reference_details' do
        error = Skirt::AmazonOrderReferenceError
        aor = Skirt::AmazonOrderReference.new
        expect{ aor.set_order_refernce_details }.to raise_error(error)
      end
      
      it 'get_order_reference_details' do
        error = Skirt::AmazonOrderReferenceError
        aor = Skirt::AmazonOrderReference.new
        expect{ aor.get_order_reference_details(nil, nil) }.to raise_error(error)
      end

      it 'authorize' do
        error = Skirt::AmazonOrderReferenceError
        aor = Skirt::AmazonOrderReference.new
        aor.amount = 1
        expect{ aor.authorize }.to raise_error(error)
      end

    end

  end
end
