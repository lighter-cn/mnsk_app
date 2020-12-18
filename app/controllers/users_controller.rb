class UsersController < ApplicationController
  before_action :get_user, only: [:show,:edit, :update]
  def show
    # カード情報取得
    
  end

  def edit
  end

  def update
    if current_user.update(update_params)
      redirect_to user_path
    else
      render :edit
    end
  end

  private 

  def get_user
    @user = User.find(current_user.id)
  end

  def update_params
    params.require(:user).permit(:name, :email)
  end
end
