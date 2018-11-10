class OrderToFoodOption < ApplicationRecord
  belongs_to :food_option
  belongs_to :order
end
