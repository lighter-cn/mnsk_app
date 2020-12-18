class ServicesController < ApplicationController
  # before_action :authenticate_user!
  
  def index
    pull_user
  end

  def new
    pull_user
  end

  private

  def pull_user
    if user_signed_in?
      @user = User.find(current_user.id)
    end
  end
end
