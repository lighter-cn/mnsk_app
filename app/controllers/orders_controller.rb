class OrdersController < ApplicationController
  before_action :authenticate_user!                      # ログイン状態のチェック
  before_action :pull_service                            # サブスク情報取得
  before_action :pull_user                               # ユーザー情報取得
  before_action :have_card?, only: [:new, :create]       # カード情報があるかチェック
  before_action :is_owner?                               # サブスク出品者のチェック
  before_action :find_order                              # orderの有無を確認
  before_action :did_buy?, only: [:new, :create]         # 購入済みのリダイレクト
  before_action :is_service_opened?, only: [:new, :create, :pause, :resume] # サブスク停止中かチェック

  def new
    @order = Order.new
  end

  def create
    sub = Order.create_sub(current_user.card.customer_token, @service.service_id)

    if !sub.id.nil?
      @order = Order.new(
        user_id: current_user.id,
        service_id: params[:service_id],
        subscription: sub.id
      )
      @order.save
      redirect_to service_path(params[:service_id])
    else
      render :new
    end
  end

  # サブスクの停止処理
  def pause
    @sub = @order.pause(@order.subscription)
  rescue StandardError => e
    @error = []
    @error << e.message
  end

  # サブスクの再開処理
  def resume
    @sub = @order.resume(@order.subscription)
  rescue StandardError => e
    @error = []
    @error << e.message
  end

  def good
    order = Order.find(params[:id])
    if order.good
      order.update(good: false)
    else
      order.update(good: true)
    end
    order = Order.find(params[:id])
    render json: {order: order}
  end

  def bad
    order = Order.find(params[:id])
    if order.bad
      order.update(bad: false)
    else
      order.update(bad: true)
    end
    order = Order.find(params[:id])
    render json: {order: order}
  end

  private

  def pull_service
    @service = Service.find(params[:service_id])
  end

  def pull_user
    @user = User.find(current_user.id) if user_signed_in?
  end

  def is_owner?
    redirect_to service_path(params[:service_id]) if current_user.id == @service.user_id
  end

  def find_order
    @order = Order.find_by user_id: current_user.id, service_id: params[:service_id]
  end

  def have_card?
    redirect_to new_card_path and return unless current_user.card.present?
  end

  def did_buy?
    redirect_to service_path(params[:service_id]) unless @order.nil?
  end

  def is_service_opened?
    redirect_to service_path(params[:service_id]) and return unless @service.service_status == 'open'
  end
end
