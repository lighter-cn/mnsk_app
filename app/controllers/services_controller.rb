class ServicesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :search]
  before_action :pull_user
  before_action :pull_service,       except: [:index, :new, :create, :search]
  before_action :is_owner?,          except: [:index, :show, :new, :create, :search]
  before_action :register_card?,     only: [:new, :create]

  PER = 20 # ページネーションの1ページあたりの表示項目数

  def index
    @services = Service.order('created_at DESC').take(8)
  end

  def show
    if user_signed_in?
      @order = Order.find_by user_id: current_user.id, service_id: params[:id]
      unless @order.nil? # 購入済みならサブスク情報を持ってくる
        Payjp.api_key = ENV['PAYJP_SECRET_KEY']
        @sub = Payjp::Subscription.retrieve(@order.subscription)
        # select count(orders.id) from orders inner join services on services.id=orders.service_id where orders.service_id = 6 and orders.good
        @good = Order.where('service_id=?',params[:id]).where('good',true).count;
        @bad = Order.where('service_id=?',params[:id]).where('bad',true).count;
      end
    end
  end

  def search
    params[:q][:category_id_eq] = '' if !params[:q].nil? && (params[:q][:category_id_eq] == '1')
    @q = Service.ransack(params[:q])
    @services = @q.result(distinct: true).page(params[:page]).per(PER)
  end

  def new
    @service = Service.new
  end

  def create
    @error = []
    begin
      plan = Service.create_pln(params[:service][:service_name], current_user.id, params[:service][:price])
    rescue StandardError => e
      @error << e.message
    end

    @service = if plan.present?
                 Service.new(service_params(plan.id))
               else
                 Service.new(service_params(0))
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
    @service.destroy_service @service
    redirect_to root_path
  rescue StandardError => e
    @error = []
    @error << e.message
    render :edit
  end

  def pause
    @service.pause(@service.service_id)
    redirect_to edit_service_path(params[:id])
  end

  def resume
    @service.resume
    redirect_to edit_service_path(params[:id])
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
  end
end
