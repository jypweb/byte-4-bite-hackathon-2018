class AddDeliveryTypeAndCommentsToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :delivery_type, :string, default: "Pickup"
    add_column :orders, :comments, :text
  end
end
