class CodesController < ApplicationController
  before_action :authenticate_user! # ログイン状態のチェック
  before_action :pull_user
  before_action :pull_code, only: [:show, :update]

  def show
    service = Service.find(@code.order.service_id)
    error_check(type: 'show', opt1: @code, opt2: service)
  end

  def create
    order = Order.find(params[:order_id])
    service = Service.find(params[:service_id])

    # ユーザーがオーダーを所持しているかと、オーダーとサービスが紐付いているかチェックしsubを引っ張ってくる
    if current_user.id == order.user_id && service.id == order.service_id
      Payjp.api_key = ENV['PAYJP_SECRET_KEY']
      customer_token = current_user.card.customer_token
      sub = Payjp::Subscription.retrieve(order.subscription)
    end

    error_check(type: 'create', opt1: customer_token, opt2: sub)
    exists_code = Code.where('order_id = ? and created_at > ?', order.id, Time.now.yesterday).last # 24時間以内に発行?
    if exists_code.present?
      if exists_code.status == 'not used'
        @code = exists_code
      else
        @error << '本日の使用上限に達しました'
      end
    else
      @code = Code.create(code: create_code, status: 'not used', order_id: order.id) unless @error.present?
    end
    return @url = request.url.sub!(/\?.*/, '') + "/#{@code.id}?code=#{@code.code}" if @code.present?
  end

  def update
    @code.update(status: 'used') # 使用済みにする
  end

  private

  def pull_user
    @user = User.find(current_user.id) if user_signed_in?
  end

  def pull_code
    @code = Code.find(params[:id])
  end

  def create_code
    Faker::Internet.password(min_length: 10, max_length: 12)
  end

  def error_check(**arg)
    @error = []
    if arg[:type] == 'show'
      @error << '出品者はではありません' unless current_user.id == arg[:opt2][:user_id]
      @error << 'このコードは有効期限切れです' unless arg[:opt1][:created_at] > Time.now.yesterday
      @error << 'このコードは使用済みです' unless arg[:opt1][:status] == 'not used'
      @error << 'このコードは正しくありません' unless arg[:opt1][:code] == params[:code]
    elsif arg[:type] == 'create'
      @error << 'サブスクを購入してません' unless arg[:opt1] == arg[:opt2][:customer]
      @error << 'サブスクの期限が切れています' unless arg[:opt2][:current_period_end] > Time.now.to_i
    end
    @error
  end
end
