class UsersController < ApplicationController
  before_action :authenticate_user! # ログイン状態の確認
  before_action :pull_user, only: [:show, :edit, :update]
  def show
    @owner = User.find(params[:id])
    if @owner == @user
      # カード情報取得
      Payjp.api_key = ENV['PAYJP_SECRET_KEY']
      card = Card.find_by(user_id: @user.id)

      if card.present?
        customer = Payjp::Customer.retrieve(card.customer_token)
        @card = customer.cards.first
      else
        @card = nil
      end
      @orders = Order.getBuyOrders(@user.id)
    end

    @services = Service.getServiceUserCount(@owner.id)
  end

  def edit
    redirect_to user_path unless current_user.id == @user.id
  end

  def update
    redirect_to user_path unless current_user.id == @user.id

    if @user.update(update_params)
      redirect_to user_path
    else
      @user = User.find(current_user.id)
      render :edit
    end
  end

  private

  def pull_user
    @user = User.find(current_user.id) if user_signed_in?
  end

  def update_params
    params.require(:user).permit(:name, :email)
  end
end
