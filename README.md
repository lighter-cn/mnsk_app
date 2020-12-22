# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
* System dependencies
* Configuration
* Database creation
* Database initialization
* How to run the test suite
* Services (job queues, cache servers, search engines, etc.)
* Deployment instructions
* ...

# テーブル設計

## users テーブル

| Column             | Type   | Options     |
| ------------------ | ------ | ----------- |
| email              | string | null: false |
| encrypted_password | string | null: false |
| name               | string | null: false |
| birthday           | date   | null: false |

### Association

- has_many :services
- has_many :orders
- has_one :card

## services テーブル

| Column         | Type       | Options                        |
| -------------- | ---------- |------------------------------- |
| service_name   | string     | null: false                    |
| price          | integer    | null: false                    |
| explanation    | text       | null: false                    |
| service_status | string     | null: false                    |
| service_id     | text       | null: false                    |
| category_id    | integer    | null: false                    |
| user           | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- has_many :orders
- has_many_attached :images
- belongs_to :category

## orders テーブル

| Column       | Type       | Options                        |
| ------------ | ---------- | ------------------------------ |
| user         | references | null: false, foreign_key: true |
| service      | references | null: false, foreign_key: true |
| subscription | text       | null: false                    |

### Association

- belongs_to :user
- belongs_to :service
- has_many    :codes

## codes テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| code   | string     | null: false                    |
| status | string     | null: false                    |
| order  | references | null: false, foreign_key: true |

### Association

- belongs_to :order

## cards テーブル

| Column         | Type       | Options                        |
| -------------- | ---------- | ------------------------------ |
| customer_token | string     | null: false                    |
| card_token     | string     | null: false                    |
| user           | references | null: false, foreign_key: true |

### Association

- belongs_to :order