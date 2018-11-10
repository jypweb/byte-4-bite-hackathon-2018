class FoodOption < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :order_to_food_options
  has_many :orders, through: :order_to_food_options
end
