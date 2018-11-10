class CreateOrderToFoodOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :order_to_food_options do |t|
      t.integer :order_id
      t.integer :food_option_id
      t.integer :quantity

      t.timestamps
    end
  end
end
