class OrdersController < ApplicationController
  def new
    @order = Order.new
    @foods = FoodOption.all
  end

  def create
    @order = Order.new(order_params)
    @order.user_id = @current_user.id
    if @order.save
      $redis.publish "order-created", {user: @current_user.id, data: {order_id: @order.id}}.to_json
      flash[:success] = "Order Created"
      redirect_to user_path(@current_user.id)
    else
      flash[:error] = @order.errors.full_messages.to_sentence
      @foods = FoodOption.all
      render 'new'
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
      p "========================="
      p @order
      p "========================="
      if @order.update_attributes(status: "cancelled")
        flash[:success] = "Order cancelled"
      else
        flash[:error] = @order.errors.full_messages.to_sentence
      end
    else
      flash[:error] = "Order not found"
    end
    redirect_to user_path(@current_user.id)
  end

  def past_orders
    @orders = @current_user.orders.where(status: ["complete", "cancelled"])
  end

  private
  def order_params
    params.require(:order).permit(:quantity, :delivery_type, :food_list => [])
  end
end
