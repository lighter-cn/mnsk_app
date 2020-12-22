class Card < ApplicationRecord
  belongs_to :user

  validates :card_token,     presence: true
  validates :customer_token, presence: true
end
