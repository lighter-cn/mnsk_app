class ServicesController < ApplicationController
  # before_action :authenticate_user!
  
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
end
