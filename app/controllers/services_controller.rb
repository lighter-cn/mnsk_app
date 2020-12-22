class ServicesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :pull_user
  before_action :register_card?, except: [:index, :show, :edit, :update]

  def index
    @services = Service.order('created_at DESC')
  end

  def show
    @service = Service.find(params[:id])
    @order = Order.find_by user_id: current_user.id, service_id: @service.id

    unless @order.nil?
      # payjpの処理
      Payjp.api_key = ENV['PAYJP_SECRET_KEY']
      customer_token = current_user.card.customer_token

      @sub = Payjp::Subscription.retrieve(@order.subscription)
    end
  end

  def new
    @service = Service.new
  end

  def create
    plan_name = "#{params[:service][:service_name]}_#{current_user.id}_#{get_data}"
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    plan = Payjp::Plan.create(
      name: plan_name,
      amount: params[:service][:price],
      currency: 'jpy',
      interval: 'month'
    )
    @service = Service.new(service_params(plan.id))
    if @service.save
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
    @service = Service.find(params[:id])
    is_owner?
    if @service.update(service_params(@service.service_id))
      redirect_to service_path(params[:id])
    else
      render :update
    end
  end

  private

  def pull_user
    @user = User.find(current_user.id) if user_signed_in?
  end

  def service_params(plan_id)
    params.require(:service).permit(:service_name, :price, :explanation, :category_id, images: []).merge(service_status: 'open',
                                                                                                         service_id: plan_id, user_id: current_user.id)
  end

  def register_card?
    redirect_to new_card_path and return unless current_user.card.present?
  end

  def is_owner?
    redirect_to root_path unless current_user.id == @service.user_id
  end

  def get_data
    DateTime.now
  end
end
