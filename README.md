# README

## アプリケーション名

MNSK(みんなのサブスク)

## 概要

個人でサブスクリプションを出品することや購入することができるサービスです。
出品者は購入者をQRコードを用いて判別する事ができます。
QRコードは購入者の端末の画面に表示され、そのQRコードを出品者が読み取ることで購入者かどうか確認することができます。
QRコードの期限は発行から24時間以内で、一度使用すると再度同じものを利用することができません。
また、未使用か使用済みかに関わらず、前回の発行から24時間以上経過した場合、再発行することができます。

## 目指した課題解決

近年電子マネー化やサービスのサブスクリプション化が行われる中、
小規模の企業や店舗が簡単にデジタル化を行えることで機会損失を防いだり、
個人で副業を行うための活動の場を提供したいと思い、このアプリケーションを作りました。

## URL

http://54.250.177.45/

## テスト用アカウント

- email: foo@foo
- password: foofoo

*Basic認証あり

## 機能

- ユーザー関連
  - ユーザー登録機能
  - ユーザー情報更新
  - ユーザー情報一覧機能
  - クレジットカード登録機能
  - ログイン / ログアウト機能
- サブスクリプション関連
  - 作成機能
  - 更新機能
  - 削除機能
  - 停止機能
  - 購入機能
  - 購入停止 / 再開機能
- QRコード関連
  - QRコード発行機能
  - QRコード確認機能
  - QRコード更新機能

## 利用方法

### ユーザー登録
  1. ヘッダー内の新規登録ボタンより新規登録画面へ
  2. すべての項目を入力し、「次へ」ボタンを押下
  3. 入力内容が問題なければユーザー登録自体は完了し、カード情報登録ページに遷移

### クレジットカード登録
  1. ユーザー登録後、もしくはユーザーページ内のリンクよりカード情報登録ページに遷移
  2. 以下のテストコードを入力
   - カード番号: 4242424242424242
   - セキュリティコード: 123
   - 有効期限: 入力日以降の未来の期日
  3.登録ボタンを押下し、登録完了

### ログイン
  *新規登録後は自動でログイン状態です。  
  
  1. ログアウト状態でヘッダーの「ログイン」ボタンを押下し、ログイン画面に遷移
  2. ログイン画面でメールアドレスとパスワードを入力し、「ログイン」ボタンを押下
  3. 問題がなければログイン成功し、トップページに遷移
  
  *ログインをしない場合でもトップページの閲覧、検索ページでの検索、およびサブスクの詳細ページは利用できます。
  
### ログアウト
  1. ログイン状態でヘッダーの「ログアウト」ボタンを押下
  
### サブスクを作る
  1. カード情報入力済みのアカウントでログイン
  2. トップページの「サブスクを作る」ボタンを押下し、作成画面に遷移
  3. すべての項目を記入した上で、「作成」ボタンを押下
  4. 登録完了し、トップページに遷移
  
### サブスクの購入
  1. カード情報入力済みのアカウントでログイン
  2. トップページのサブスク一覧または、検索画面よりサブスクを選択。
  3. サブスク詳細画面下部の「購入する」ボタンを押下。(クレジットカード未登録の場合、登録画面に遷移します)
  4. 確認画面で再度「購入する」ボタンを押下。
  5. 購入完了し、サブスク詳細画面に遷移。
  
### サブスクの購入停止
  1. サブスク購入済みアカウントで購入したサブスク詳細画面へ。
  2. 詳細画面下部より「停止」ボタンを押下
  3. 停止完了画面に遷移

### サブスクの購入再開
  1. サブスク購入済みアカウントで停止したサブスク詳細画面へ。
  2. 詳細画面下部より「再開」ボタンを押下
  3. 再開完了画面に遷移

### QRコードの利用
  1. (購入者)サブスク詳細画面より、「QRコード発行」ボタンを押下
  2. （購入者）QRコードが発行されたら、出品者にQRコードを提示するか、QRコード下のURLを提示。
  3. （出品者）QRコードを読み取るかURLを直接ブラウザに入力する。
  4. （出品者）QRコードが利用可能か表示されるので、「使用済みにする」ボタンを押下する。
  5. （出品者）QRコード使用完了の画面が表示されると完了。
  
### ユーザー情報画面
  ユーザー情報画面では、下記の情報を確認できます。
  - ユーザーの基本情報とクレジットカードの情報
  - ユーザー情報更新画面への遷移
  - クレジットカードの登録画面への遷移（未登録の場合のみ）
  - 出品したサブスクリプションの一覧とそれぞれの利用者数の確認
  - 購入したサブスクリプションの利用の可否、QRコード発行ボタンの一覧

## 実装予定の機能

- コミュニケーション関連
  - サブスクリプションの評価機能
  - コメント機能
  - 出品者の情報一覧
- 検索の強化
  - 金額帯の指定による絞り込み
  - タグ付け機能とタグによる絞り込み
  - 評価の高い順でのソート
  - ランキング機能
- サブスクリプション関係
  - 一出品者あたりの出品上限の設置と、上限数開放のためのプレミアム会員機能
  - 一日に利用できるQRコードの回数の指定

## ER図
![ER image](https://gyazo.com/97cf2205d4041e0aee0c719a3f5943f3)

