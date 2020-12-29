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

  private

  def set_sub subscription
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    Payjp::Subscription.retrieve(subscription)
  end
end
