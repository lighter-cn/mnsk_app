class Service < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :user
  has_many_attached :images

  with_options presence: true do
    validates :user_id
    validates :service_name, length: { minimum: 10, maximum: 30 }
    validates :service_status
    validates :price,        numericality: { only_integer: true, greater_than_or_equal_to: 100, less_than_or_equal_to: 100_000 }
    validates :explanation,  length: { maximum: 300, minimum: 30 }
    validates :category_id,  numericality: { other_than: 1 }
    validates :images,       length: { maximum: 10 }
  end

  def self.create_pln(service_name, user_id, service_price)
    plan_name = "#{service_name}_#{user_id}_#{Time.now.to_i}"
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    Payjp::Plan.create(
      name: plan_name,
      amount: service_price,
      currency: 'jpy',
      interval: 'month'
    )
  end

  def destroy_service(service)
    # payjp情報取得
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    plan = Payjp::Plan.retrieve(service.service_id)
    subs = Payjp::Subscription.all(plan: service.service_id)

    if last_user_limit(subs) < Time.now.to_i # 最終期限が現在以前の際の処理
      subs.each do |subscription|
        sub = Payjp::Subscription.retrieve(subscription.id)
        sub.delete
      end
      plan.delete
      destroy
    else
      raise StandardError, 'Limit is not yet.'
    end
  end

  def pause(service_id)
    # すべてのsubを取得する
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    subs = Payjp::Subscription.all(plan: service_id)

    # すべてのsubを停止する
    subs.each do |subscription|
      if subscription.status == 'active'
        sub = Payjp::Subscription.retrieve(subscription.id)
        sub.pause
      end
    end
    update(service_status: 'close')
  end

  def resume
    update(service_status: 'open')
  end

  # サービスごとの利用者数を取得
  def self.getServiceUserCount(uid)
    service_user = []
    services = Service.where('user_id=?', uid)
    if services.length > 0
      services.each do |service|
        service_name = service.service_name
        count = Order.where('service_id=?', service.id)
        service_user << { id: service.id, name: service_name, num: count }
      end
    end
    service_user
  end

  private

  def last_user_limit(subs)
    last_limit = 0
    subs.each do |sub|
      last_limit = sub.current_period_end if last_limit <= sub.current_period_end
    end
    last_limit
  end
end
