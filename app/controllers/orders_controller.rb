class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :is_owner?
  before_action :pull_user
  before_action :already_buy?

  def new
    @service = Service.find(params[:service_id])
    @order = Order.new
  end
  
  def create
    # カード未所持のときのリダイレクト
    redirect_to new_card_path and return unless current_user.card.present?

    service = Service.find(params[:service_id])
    # payjpの処理
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    customer_token = current_user.card.customer_token

    # サブスクの購入
    sub = Payjp::Subscription.create(
      customer: customer_token,
      plan: service.service_id
    )
    if sub.id != nil
      @order = Order.new(
        user_id: current_user.id,
        service_id: params[:service_id]
      )
      @order.save
      redirect_to service_path(params[:service_id])
    else
      render :new
    end
  end

  private

  def pull_user
    if user_signed_in?
      @user = User.find(current_user.id)
    end
  end

  def is_owner?
    service = Service.find(params[:service_id])
    if current_user.id == service.user_id
      redirect_to service_path(params[:service_id])
    end
  end

  def already_buy?
  end
end
