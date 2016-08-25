# -*- coding: utf-8 -*-

Feature: Pay1

  @javascript
  Scenario: order
    Given '/amazon_payments/login'にアクセスする
    Then amazonにログイン
    Then access_tokenを取得
    Then order_reference_idを取得

    Then cancelする
    Then order_reference_statusが'Canceled'であること


  @javascript
  Scenario: logout & cancel
    Given '/amazon_payments/login'にアクセスする
    Then amazonにログイン
    Then access_tokenを取得
    Then order_reference_idを取得
    # Then amazonからlogoutする

    # Then pryを呼び出す
    Then orderを正しく呼べること

    Then cancelする
    Then order_reference_statusが'Canceled'であること
