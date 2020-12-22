class Order < ApplicationRecord
  validates :subscription, presence: true
end
