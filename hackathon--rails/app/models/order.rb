class Order < ApplicationRecord
  attr_accessor :food_list

  belongs_to :user, dependent: :destroy
  has_many :order_to_food_options, dependent: :destroy
  has_many :food_options, through: :order_to_food_options

  before_create :set_order_id_key

  private
  def set_order_id_key
    begin
      self.oid = SecureRandom.urlsafe_base64
    end while Order.exists?(oid: self.oid)
  end
end
