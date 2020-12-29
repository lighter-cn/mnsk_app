class Service < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :user
  has_many_attached :images

  with_options presence: true do
    validates :user_id
    validates :service_name, length: { minimum: 10, maximum: 30 }
    validates :service_status
    validates :price,        numericality: { only_integer: true, greater_than_or_equal_to: 100, less_than_or_equal_to: 100_000 }
    validates :explanation,  length: { maximum: 300, minimum: 30 }
    validates :category_id,  numericality: { other_than: 1 }
    validates :images,       length: { maximum: 10 }
  end

  def pause
  end

  def resume
    self.update(service_status: 'open')
  end
end
