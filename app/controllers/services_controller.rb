class ServicesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :pull_user
  before_action :pull_service, only: [:show, :edit, :update, :destroy]
  before_action :is_owner?, only: [:edit, :update, :destroy]
  before_action :register_card?, except: [:index, :show, :edit, :update]

  def index
    @services = Service.order('created_at DESC')
  end

  def show
    @order = Order.find_by user_id: current_user.id, service_id: params[:id] if user_signed_in?

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
    @error = []
    begin
      plan_name = "#{params[:service][:service_name]}_#{current_user.id}_#{Time.now.to_i}"
      Payjp.api_key = ENV['PAYJP_SECRET_KEY']
      plan = Payjp::Plan.create(
        name: plan_name,
        amount: params[:service][:price],
        currency: 'jpy',
        interval: 'month'
      )
    rescue StandardError => e
      @error << e.message
    end

    begin
      @service = Service.new(service_params(plan.id))
    rescue StandardError => e
      @service = Service.new(service_params(0))
    end
    if @service.save
      redirect_to root_path
    else
      @error.push(insert_error_message(@service))
      @error.flatten!
      render :new
    end
  end

  def edit
  end

  def update
    if @service.update(service_params(@service.service_id))
      redirect_to service_path(params[:id])
    else
      @error = insert_error_message @service
      render :edit
    end
  end

  def destroy
    @error = []
    #payjp情報取得
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    plan = Payjp::Plan.retrieve(@service.service_id)
    begin
      plan.delete
      @service.destroy
      redirect_to root_path
    rescue => e
      @error << e.message
      render :edit
    end
  end

  def pause
    
  end

  def resume
    
  end

  private

  def pull_user
    @user = User.find(current_user.id) if user_signed_in?
  end

  def pull_service
    @service = Service.find(params[:id])
  end

  def service_params(plan_id)
    params
      .require(:service).permit(:service_name, :price, :explanation, :category_id, images: []).merge(service_status: 'open', service_id: plan_id, user_id: current_user.id)
  end

  def register_card?
    redirect_to new_card_path and return unless current_user.card.present?
  end

  def is_owner?
    redirect_to root_path unless current_user.id == @service.user_id
  end

  def insert_error_message(service)
    arr = []
    service.errors.full_messages.each do |error|
      arr << error
    end
    arr
  end
end
