class Service < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :user
  has_many_attached :images

  with_options presence: true do
    validates :user_id
    validates :service_name
    validates :service_status
    validates :price,        numericality: { only_integer: true, greater_than: 100, less_than: 100_000 }
    validates :explanation,  length: { maximum: 300, too_long: '最大300字までです。' }
    validates :category_id,  numericality: { other_than: 1 }
    validates :images,       length: { maximum: 10, too_logn: '添付可能な画像は10枚までです。' }
  end
end
