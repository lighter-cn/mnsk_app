class CodesController < ApplicationController
  before_action :authenticate_user! # ログイン状態のチェック
  before_action :pull_user

  def show
    code = Code.find(params[:id])
    service = Service.find(code.order_id)

    @error = []
    # owner check
    @error << 'このサブスクのオーナーではありません' unless current_user.id == service.user_id
    # limit check
    @error << 'このコードは有効期限切れです' unless code.created_at > Time.now.yesterday
    @error << 'このコードは使用済みです' unless code.status == 'not used'
    @error << 'このコードは正しくありません' unless code.code == params[:code]
  end

  def create
    order = Order.find(params[:order_id])
    service = Service.find(params[:service_id])
    # subを引っ張ってくる
    if current_user.id == order.user_id && service.id == order.service_id
      Payjp.api_key = ENV['PAYJP_SECRET_KEY']
      customer_token = current_user.card.customer_token
      sub = Payjp::Subscription.retrieve(order.subscription)
    end

    # ユーザーがオーダーを所持しているかと、オーダーとサービスが紐付いているかチェック
    if service.id == order.service_id && order.user_id == current_user.id
      # 処理
    end

    # error check
    @error = []
    @error << 'サブスクを購入してません' unless customer_token == sub.customer # ユーザーが購入済みかチェック
    @error << 'サブスクの期限が切れています' unless sub.current_period_end > Time.now.to_i # 期限内かチェック
    exists_code = Code.where(order_id: order.id).where('created_at > ?', Time.now.yesterday).last # 24時間以内に発行したデータを引っ張る
    if exists_code.present?
      if exists_code.status == 'not used'
        @code = exists_code
      else
        @error << '本日の使用上限に達しました'
      end
    else
      unless @error.present?
        # コード生成
        new_cord = create_code

        begin
          @code = Code.create(
            code: new_cord,
            status: 'not used',
            order_id: order.id
          )
        rescue StandardError => e
          @error = e.message
        end
      end
    end

    if @code.present?
      get_url = request.url
      @url = get_url.sub!(/\?.*/,'')+"/#{@code.id}?code=#{@code.code}"
    end

  end

  def update
    # 使用済みにする
    code = Code.find(params[:id])
    code.update(status: 'used')
  end

  private

  def pull_user
    @user = User.find(current_user.id) if user_signed_in?
  end

  def create_code
    Faker::Internet.password(min_length: 10, max_length: 12)
  end
  
end
