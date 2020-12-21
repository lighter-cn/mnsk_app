class ServicesController < ApplicationController
  before_action :authenticate_user!, except: [:index] # 後でshowも足す
  before_action :register_card?, except: [:index] # 後でshowも足す
  
  def index
    pull_user
  end

  def new
    pull_user

    @service = Service.new
  end

  def create
    @service = Service.new(service_params)
    if @service.save
      redirect_to root_path
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

  def service_params
    params.require(:service).permit(:service_name, :price, :explanation, :category_id, images: []).merge(service_status: "open", user_id: current_user.id)
  end

  def register_card?
    redirect_to new_card_path and return unless current_user.card.present?
  end
end
