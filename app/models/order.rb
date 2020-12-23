class Order < ApplicationRecord
  validates :subscription, presence: true
  has_many :codes
end
