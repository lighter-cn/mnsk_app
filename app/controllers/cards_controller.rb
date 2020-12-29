class CardsController < ApplicationController
  before_action :authenticate_user! # ログイン状態の確認
  before_action :register_card?     # カード情報登録済みかのチェック
  before_action :pull_user          # ユーザー情報取得

  def new
  end

  def create
    if params[:card_token] != "null"
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
      card.save
      redirect_to root_path
    else
      @error = []
      @error << "No such token: null"
      render :new
    end
  end

  private

  def register_card?
    redirect_to root_path and return if current_user.card.present?
  end

  def pull_user
    @user = User.find(current_user.id)
  end
end
