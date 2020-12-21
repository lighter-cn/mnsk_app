class ServicesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :pull_user
  before_action :register_card?, except: [:index, :show]
  
  def index
  end

  def show
    @service = Service.find(params[:id])
  end

  def new
    @service = Service.new
  end

  def create
    @service = Service.new(service_params)
    if @service.save
      plan_name = "#{@service.service_name}_#{@service.user_id}_#{@service.created_at}"
      Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
      Payjp::Plan.create(
        name: plan_name,
        amount: @service.price,
        currency: 'jpy',
        interval: 'month'
      )
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @service = Service.find(params[:id])
    is_owner?
  end

  def update
    is_owner?
  end

  private

  def pull_user
    if user_signed_in?
      @user = User.find(current_user.id)
    end
  end

  def service_params
    params.require(:service).permit(:service_name, :price, :explanation, :category_id, images: []).merge(service_status: "open", user_id: current_user.id)
  end

  def register_card?
    redirect_to new_card_path and return unless current_user.card.present?
  end

  def is_owner?
    redirect_to root_path unless current_user.id == @service.user_id
  end
end
