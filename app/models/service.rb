class Service < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :user
  has_many_attached :images

  validates :category_id, numericality: { other_than: 1 }
end
