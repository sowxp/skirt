# -*- coding: utf-8 -*-

step ':pathにアクセスする' do |path|
  page.save_screenshot("tmp/poltergeist.png", full: true)
  visit path
end

step 'html' do
  p page.html
end

step 'screenshot:name' do |name|
  page.save_screenshot("tmp/poltergeist_#{name}.png")
end

step ':selectorをクリック' do |selector|
  find(selector).click
end

step 'ボタン:nameをクリック' do |name|
  click_button name
end

step 'amazonにログイン' do

  sleep(1)

  selector = '#OffAmazonPaymentsWidgets0'
  find(selector).click

  sleep(1)

  fill_in "ap_email", :with => ENV["AMAZON_PAYMENTS_TEST_USER_MAIL"]
  fill_in "ap_password", :with => ENV["AMAZON_PAYMENTS_TEST_USER_PASSWORD"]

  #click_button "Sign in using our secure server"
  #page.first(".signin-button-text").click
  selector = '.signin-button-text'
  find(selector).click

  sleep(3)
end


step 'amazonにポップアップログイン' do

  sleep(3)

  selector = '#OffAmazonPaymentsWidgets0'

  find(selector).click

  sleep(1)
  popup = page.driver.window_handles.last
  page.within_window popup do

    fill_in "ap_email", :with => ENV["AMAZON_PAYMENTS_TEST_USER_MAIL"]
    fill_in "ap_password", :with => ENV["AMAZON_PAYMENTS_TEST_USER_PASSWORD"]

    #click_button "Sign in using our secure server"
    selector = '.signin-button-text'
    find(selector).click
end


  sleep(3)
end


step 'sleep :seconds' do |seconds|
  sleep seconds.to_i
end

step 'access_tokenを取得' do
  current_url =~ /access_token=([^&]*).*/

  @access_token = URI.unescape( $1 )
end

step 'order_reference_idを取得' do
  current_url =~ /access_token=([^&]*).*/
  @order_reference_id = find('#orderReferenceId').value
end

step 'set_order_refernce_detailsを正しく呼べること' do

  @aor = Skirt::AmazonOrderReference.new
  @aor.amount = 10
  @aor.amazon_order_reference_id = @order_reference_id

  response = @aor.set_order_refernce_details
  state = response["SetOrderReferenceDetailsResponse"]["SetOrderReferenceDetailsResult"]["OrderReferenceDetails"]["OrderReferenceStatus"]["State"]
  expect(state).to eq 'Draft'

end

step 'get_order_refernce_detailsを正しく呼べること' do

  @aor = Skirt::AmazonOrderReference.new
  @aor.amount = 10
  @aor.amazon_order_reference_id = @order_reference_id

  sleep 1
  response = @aor.get_order_reference_details(@order_reference_id, @access_token)

  state = response["GetOrderReferenceDetailsResponse"]["GetOrderReferenceDetailsResult"]["OrderReferenceDetails"]["OrderReferenceStatus"]["State"]
  expect(state).to eq 'Draft'

end

step "confirm_order_refernceを正しく呼べること" do
  @aor = Skirt::AmazonOrderReference.new
  @aor.amount = 10
  @aor.amazon_order_reference_id = @order_reference_id

  @aor.set_order_refernce_details
  response = @aor.confirm_order_reference
  expect(response["ConfirmOrderReferenceResponse"]).to be_present
end


step "authorizeを正しく呼べること" do
  @aor = Skirt::AmazonOrderReference.new
  @aor.amount = 10
  @aor.amazon_order_reference_id = @order_reference_id

  @aor.set_order_refernce_details
  @aor.confirm_order_reference

  response = @aor.authorize
  details = response["AuthorizeResponse"]["AuthorizeResult"]["AuthorizationDetails"]

  expect(details).to be_present
end

step "close_authorizeを正しく呼べること" do
  @aor.close_authorization
  expect(@aor.authorization_status).to eq 'Closed'
end

step "authorization_statusが:stateなこと" do |state|
  response = @aor.get_authorization_details

  hash =  Hash.from_xml response.body
  _state = hash["GetAuthorizationDetailsResponse"]["GetAuthorizationDetailsResult"]["AuthorizationDetails"]["AuthorizationStatus"]["State"]

  expect(_state).to eq state
end


step "0秒でauthorizeしてcaptureする" do
  @aor = Skirt::AmazonOrderReference.new
  @aor.amount = 10
  @aor.amazon_order_reference_id = @order_reference_id

  @aor.set_order_refernce_details
  @aor.confirm_order_reference

  response = @aor.authorize(0)
  response = @aor.capture
end

step "save_and_authorizeを正しく呼べること" do
  @aor = Skirt::AmazonOrderReference.new
  @aor.amount = 10
  @aor.amazon_order_reference_id = @order_reference_id

  response = @aor.save_and_authorize(@access_token)
  state = response["GetOrderReferenceDetailsResponse"]["GetOrderReferenceDetailsResult"]["OrderReferenceDetails"]["OrderReferenceStatus"]["State"]
  expect(state).to eq "Closed"
end

step "order_reference_statusが:statusであること" do |status|
  aor = Skirt::AmazonOrderReference.last
  expect(aor.order_reference_status).to eq status
end

step "authorization_statusが:statusであること" do |status|
  aor = Skirt::AmazonOrderReference.last
  expect(aor.authorization_status).to eq status
end

step "capture_statusが:statusであること" do |status|
  aor = Skirt::AmazonOrderReference.last
  expect(aor.capture_status).to eq status
end

step "cancelする" do
  @aor = Skirt::AmazonOrderReference.new
  @aor.amount = 10
  @aor.amazon_order_reference_id = @order_reference_id

  @aor.set_order_refernce_details
  @aor.confirm_order_reference

  response = @aor.cancel
end
