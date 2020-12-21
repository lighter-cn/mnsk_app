class Service < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :user
  has_many_attached :images

  with_options presence: true do
    validates :user_id
    validates :service_name, uniqueness: true
    validates :price
    validates :explanation
    validates :category_id, numericality: { other_than: 1 }
  end
end
