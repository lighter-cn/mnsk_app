require 'rails_helper'

RSpec.describe Service, type: :model do
  before do
    @service = FactoryBot.build(:service)
  end

  describe "ユーザー新規登録" do
    # 正常系
    it "すべての項目を入力した場合、新規登録できる" do
      expect(@service).to be_valid
    end
    # 異常系
    it "サブスク名を未入力の場合、新規登録できない" do
      @service.service_name = ""
      @service.valid?
      expect(@service.errors.full_messages).to include "Service name can't be blank"
    end
    it "サブスク名が10文字未満の場合登録できない" do
      @service.service_name = "１２３４５６７８９"
      @service.valid?
      expect(@service.errors.full_messages).to include "Service name is too short (minimum is 10 characters)"
    end
    it "サブスク名が30文字より多い場合登録できない" do
      @service.service_name = "1234567890123456789012345678901"
      @service.valid?
      expect(@service.errors.full_messages).to include "Service name is too long (maximum is 30 characters)"
    end
    it "説明文が空白の場合登録できない" do
      @service.explanation = ""
      @service.valid?
      expect(@service.errors.full_messages).to include "Explanation can't be blank"
    end
    it "説明文が30文字未満の場合登録できない" do
      @service.explanation = "12345678901234567890123456789"
      @service.valid?
      expect(@service.errors.full_messages).to include "Explanation is too short (minimum is 30 characters)"
    end
    it "説明文が300文字より多い場合登録できない" do
      @service.explanation = "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901"
      @service.valid?
      expect(@service.errors.full_messages).to include "Explanation is too long (maximum is 300 characters)"
    end
    it "月額が空白の場合登録できない" do
      @service.price = ""
      @service.valid?
      expect(@service.errors.full_messages).to include "Price can't be blank"
    end
    it "月額が¥100未満の場合登録できない" do
      @service.price = 99
      @service.valid?
      expect(@service.errors.full_messages).to include "Price must be greater than or equal to 100"
    end
    it "月額が¥100000より多い場合登録できない" do
      @service.price = 100001
      @service.valid?
      expect(@service.errors.full_messages).to include "Price must be less than or equal to 100000"
    end
    it "カテゴリーが空白の場合登録できない" do
      @service.category_id = ""
      @service.valid?
      expect(@service.errors.full_messages).to include "Category can't be blank"
    end
    it "カテゴリーが未選択の場合登録できない" do
      @service.category_id = 1
      @service.valid?
      expect(@service.errors.full_messages).to include "Category must be other than 1"
    end
    it "添付画像がない場合登録できない" do
      @service.images = []
      @service.valid?
      expect(@service.errors.full_messages).to include "Images can't be blank"
    end
    it "添付画像が10枚より多い場合登録できない" do
      @service.images.attach(io: File.open('public/images/sample.png'), filename: 'sample.png')
      @service.valid?
      expect(@service.errors.full_messages).to include "Images is too long (maximum is 10 characters)"
    end
    it "ステータスが空白の場合登録できない" do
      @service.service_status = ""
      @service.valid?
      expect(@service.errors.full_messages).to include "Service status can't be blank"
    end
    it "ユーザー情報が空白の場合登録できない" do
      @service.user = nil
      @service.valid?
      expect(@service.errors.full_messages).to include "User must exist"
    end
  end
end
