class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :oid
      t.integer :user_id
      t.string :status, default: "pending"

      t.timestamps
    end
  end
end
