class CardsController < ApplicationController
  before_action :authenticate_user! # ログイン状態の確認
  before_action :register_card? # カード情報登録済みかのチェック

  def new
    @user = User.find(current_user.id)
  end

  def create
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    customer = Payjp::Customer.create(
      description: 'test',
      card: params[:card_token]
    )
    card = Card.new(
      card_token: params[:card_token],
      customer_token: customer.id,
      user_id: current_user.id
    )
    if card.save
      redirect_to root_path
    else
      redirect_to 'new'
    end
  end

  private

  def register_card?
    redirect_to root_path and return if current_user.card.present?
  end
end
