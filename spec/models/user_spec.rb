require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    # 正常系
    it 'すべての項目を入力した場合、新規登録できる' do
      expect(@user).to be_valid
    end
    # 異常系
    it '名前を未入力の場合、新規登録できない' do
      @user.name = ''
      @user.valid?
      expect(@user.errors.full_messages).to include "Name can't be blank"
    end
    it '名前が3文字未満の場合、新規登録できない' do
      @user.name = 'ab'
      @user.valid?
      expect(@user.errors.full_messages).to include 'Name is too short (minimum is 3 characters)'
    end
    it '名前が8文字より多い場合、新規登録できない' do
      @user.name = 'abcdefghi'
      @user.valid?
      expect(@user.errors.full_messages).to include 'Name is too long (maximum is 8 characters)'
    end
    it '生年月日を未入力の場合、新規登録できない' do
      @user.birthday = ''
      @user.valid?
      expect(@user.errors.full_messages).to include "Birthday can't be blank"
    end
    it '生年月日に日付以外を入力した場合、新規登録できない' do
      @user.birthday = 'あいうえお'
      @user.valid?
      expect(@user.errors.full_messages).to include "Birthday can't be blank"
    end
    it 'メールアドレスを未入力の場合、新規登録できない' do
      @user.email = ''
      @user.valid?
      expect(@user.errors.full_messages).to include "Email can't be blank"
    end
    it 'メールアドレスのフォーマットが異なる場合、新規登録できない' do
      @user.email = 'あいうえお'
      @user.valid?
      expect(@user.errors.full_messages).to include 'Email is invalid'
    end
    it 'パスワードが未入力の場合、新規登録できない' do
      @user.password = ''
      @user.valid?
      expect(@user.errors.full_messages).to include "Password can't be blank"
    end
    it 'パスワードが6文字未満の場合、新規登録できない' do
      @user.password = 'abcde'
      @user.valid?
      expect(@user.errors.full_messages).to include 'Password is too short (minimum is 6 characters)'
    end
    it 'パスワードと確認用パスワードが一致しない場合、新規登録できない' do
      @user.password = 'abcdef'
      @user.valid?
      expect(@user.errors.full_messages).to include "Password confirmation doesn't match Password"
    end
  end
end
