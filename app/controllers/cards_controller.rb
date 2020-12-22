class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :register_card?

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

  # すでに登録済みかチェックし、二重で登録させないようにする
  def register_card?
    redirect_to root_path and return if current_user.card.present?
  end
end
