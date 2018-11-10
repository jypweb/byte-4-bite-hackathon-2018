class OrdersController < ApplicationController
  def new
    @order = Order.new
    @foods = FoodOption.all
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      $redis.publish "order-created", {user: @current_user.id, data: {order_id: @order.id}}.to_json
      flash[:success] = "Order Created"
      redirect_to user_path(@current_user.id)
    else
    end
  end

  def show
    @order = @current_user.orders.find_by_oid(params[:id])
    if !@order
      flash[:error] = "Order not found"
      redirect_to user_path(@current_user.id)
    end
  end

  def cancel
    @order = @current_user.orders.find_by_oid(params[:order_id])
    if @order
      @order.update_attributes(status: "cancelled")
    else
      flash[:error] = "Order not found"
      redirect_to user_path(@current_user.id)
    end
  end

  def past_orders
    @orders = @current_user.orders.where(status: "complete")
  end

  private
  def order_params
    params.require(:order).permit(:food_list => [])
  end
end
