require 'rails_helper'

RSpec.describe Card, type: :model do
  before do
    @card = FactoryBot.build(:card)
  end

  describe 'クレジットカード新規登録' do
    # 正常系
    it 'すべての項目を入力した場合、新規登録できる' do
      expect(@card).to be_valid
    end
    # 異常系
    it 'カードトークンが空白の場合、新規登録できない' do
      @card.card_token = ''
      @card.valid?
      expect(@card.errors.full_messages).to include "Card token can't be blank"
    end
    it 'カスタマートークンが空白の場合、新規登録できない' do
      @card.customer_token = ''
      @card.valid?
      expect(@card.errors.full_messages).to include "Customer token can't be blank"
    end
    it 'ユーザーIDが空白の場合、新規登録できない' do
      @card.user = nil
      @card.valid?
      expect(@card.errors.full_messages).to include 'User must exist'
    end
  end
end
