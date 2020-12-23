class Code < ApplicationRecord
  belongs_to :order

  validates :code, presence: true
  validates :status, presence: true
  validates :order, presence: true
end
