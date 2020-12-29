class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :card, dependent: :destroy
  has_many :services, dependent: :destroy

  with_options presence: true do
    validates :name,     length: { maximum: 15, minimum: 3 }
    validates :birthday
  end
end
