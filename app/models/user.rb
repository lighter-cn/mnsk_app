class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :card, dependent: :destroy
  has_many :services

  with_options presence: true do
    validates :name,     length: { maximum: 15, minimum: 4 }
    validates :birthday
  end
end
