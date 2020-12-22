class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :pull_user
  def new
    @service = Service.find(params[:service_id])
    @order = Order.new
  end
  def create
    @order = Order.new(params_order)
  end

  private

  def pull_user
    if user_signed_in?
      @user = User.find(current_user.id)
    end
  end

  def params_order
  end
end
