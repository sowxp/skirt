# -*- coding: utf-8 -*-

Feature: Pay

  @javascript
  Scenario: リダイレクトログインして購入
    Given '/amazon_payments/login'にアクセスする
    Then amazonにログイン
    Then ボタン'確定'をクリック

    Then order_reference_statusが'Closed'であること
    Then authorization_statusが'Open'であること

  @javascript
  Scenario: ポップアップログインして購入
    Given '/amazon_payments/login?popup=true'にアクセスする
    Then amazonにポップアップログイン
    Then ボタン'確定'をクリック

  @javascript
  Scenario: set_order_refernce_details
    Given '/amazon_payments/login'にアクセスする
    Then amazonにログイン
    Then access_tokenを取得
    Then order_reference_idを取得
    Then set_order_refernce_detailsを正しく呼べること

  @javascript
  Scenario: get_order_reference_details
    Given '/amazon_payments/login'にアクセスする
    Then amazonにログイン
    Then access_tokenを取得
    Then order_reference_idを取得
    Then get_order_refernce_detailsを正しく呼べること

  @javascript
  Scenario: confirm_order_reference
    Given '/amazon_payments/login'にアクセスする
    Then amazonにログイン
    Then access_tokenを取得
    Then order_reference_idを取得
    Then confirm_order_refernceを正しく呼べること

  @javascript
  Scenario: authorize
    Given '/amazon_payments/login'にアクセスする
    Then amazonにログイン
    Then access_tokenを取得
    Then order_reference_idを取得
    Then authorizeを正しく呼べること

  @javascript
  Scenario: close_authorization
    Given '/amazon_payments/login'にアクセスする
    Then amazonにログイン
    Then access_tokenを取得
    Then order_reference_idを取得
    Then authorizeを正しく呼べること
    Then close_authorizeを正しく呼べること

  @javascript
  Scenario: save_and_authorize
    Given '/amazon_payments/login'にアクセスする
    Then amazonにログイン
    Then access_tokenを取得
    Then order_reference_idを取得
  #    Then save_and_authorizeを正しく呼べること

  @javascript
  Scenario: capture
    Given '/amazon_payments/login'にアクセスする
    Then amazonにログイン
    Then access_tokenを取得
    Then order_reference_idを取得

    Then 0秒でauthorizeしてcaptureする
    Then capture_statusが'Completed'であること

  @javascript
  Scenario: cancel
    Given '/amazon_payments/login'にアクセスする
    Then amazonにログイン
    Then access_tokenを取得
    Then order_reference_idを取得

    Then cancelする
    Then order_reference_statusが'Canceled'であること
