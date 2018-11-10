class Order < ApplicationRecord
  attr_accessor :food_list, :quantity

  belongs_to :user, dependent: :destroy
  has_many :order_to_food_options, dependent: :destroy
  has_many :food_options, through: :order_to_food_options

  before_create :set_order_id_key
  after_create :associate_foods

  private
  def set_order_id_key
    begin
      self.oid = SecureRandom.urlsafe_base64
    end while Order.exists?(oid: self.oid)
  end

  def associate_foods
    food_list.each do |food_id|
      OrderToFoodOption.create(food_option_id: food_id, order_id: self.id, quantity: (self.quantity || 1))
    end
  end
end
