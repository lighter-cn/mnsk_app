class OrdersController < ApplicationController
  before_action :authenticate_user!                      # ログイン状態のチェック
  before_action :pull_service                            # サブスク情報取得
  before_action :pull_user                               # ユーザー情報取得
  before_action :is_owner?                               # サブスク出品者のチェック
  before_action :already_buy?, except: [:pause, :resume] # 既にサブスク購入済みかのチェック
  before_action :find_order, only: [:pause, :resume] # orderの有無を確認

  def new
    @order = Order.new
  end

  def create
    redirect_to new_card_path and return unless current_user.card.present? # カード未所持のときのリダイレクト

    # payjpの処理
    customer_token = get_customer_token

    # サブスクの購入
    sub = Payjp::Subscription.create(
      customer: customer_token,
      plan: @service.service_id
    )
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
    change_sub_status('pause')
  end

  # サブスクの再開処理
  def resume
    change_sub_status('resume')
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

  def already_buy?
    order = Order.find_by user_id: current_user.id, service_id: @service.id
    redirect_to service_path(params[:service_id]) unless order.nil?
  end

  def get_customer_token
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    current_user.card.customer_token
  end

  def find_order
    @order = Order.find_by user_id: current_user.id, service_id: params[:service_id]
  end

  def change_sub_status(status)
    unless @order.nil?
      customer_token = get_customer_token
      @sub = Payjp::Subscription.retrieve(@order.subscription)
      begin
        if status == 'pause'
          @sub.pause
        elsif status == 'resume'
          @sub.resume
        end
      rescue StandardError => e
        @error = e
      end
    end
  end
end
