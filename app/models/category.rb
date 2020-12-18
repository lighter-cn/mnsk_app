class Category < ActiveHash::Base
  self.data = [
    { id: 1, name: '--' },
    { id: 2, name: 'フード' },
    { id: 3, name: 'ショップ' },
    { id: 4, name: '学習' },
    { id: 5, name: 'エンタメ' },
    { id: 6, name: 'スポーツ' },
    { id: 7, name: 'その他サービス' }
  ]

  include ActiveHash::Associations
  has_many :services
end
