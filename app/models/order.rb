class Order < ApplicationRecord
  validates :subscription, presence: true
  has_many :codes

  def self.create_sub(token, service_id)
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    customer_token = token
    sub = Payjp::Subscription.create(
      customer: customer_token,
      plan: service_id
    )
    return sub
  end

  def pause subscription
    sub = set_sub(subscription)
    sub.pause
  end

  def resume subscription
    sub = set_sub(subscription)
    sub.resume
  end

  def self.getBuyOrders(uid)
    orders_info = []
    orders = Order.where('user_id=?',uid)
    if orders.length > 0
      orders.each do |order|
        sub_status = "利用不可"
        # payjpのsubの期限確認
        Payjp.api_key = ENV['PAYJP_SECRET_KEY']
        sub = Payjp::Subscription.retrieve(order.subscription)
        sub_status = "利用可" if sub.current_period_end > Time.now.to_i

        service = Service.find(order.service_id)

        orders_info << {
          id: order.id,
          name: service.service_name,
          service_id: service.id,
          status: sub_status
        }
      end
    end
    return orders_info
  end

  private

  def set_sub subscription
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    Payjp::Subscription.retrieve(subscription)
  end
end
