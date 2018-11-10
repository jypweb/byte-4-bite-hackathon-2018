class Admin::WelcomeController < ApplicationController
  layout 'admin'
  before_action :check_is_admin

  def index
    @orders = Order.where.not(status: ["complete", "cancelled"]).order(:id)
  end

  def update_order
    @order = Order.find_by_oid(params[:order_id])
    new_params = order_params
    if @order.status == "pending"
      new_params[:status] = "processing"
    elsif @order.status == "processing"
      new_params[:status] = "complete"
    end
    if @order.update_attributes(new_params)
      @order.reload
      $redis.publish "order-updated", {user: @order.user.id, data: {order_id: @order.oid, status: @order.status}}.to_json
      flash.now[:success] = "Order Successfully Updated"
    else
      flash.now[:error] = "There was an error."
    end
  end

  def show_order
    @order = Order.find_by_oid(params[:order_id])
  end

  def cancel_order
    @order = Order.find_by_oid(params[:order_id])
    if @order.update_attributes(status: "cancelled")
      @order.reload
      $redis.publish "order-cancelled", {user: @order.user.id, data: {order_id: @order.oid, status: @order.status}}.to_json
      flash.now[:success] = "Order Successfully Cancelled"
    else
      flash.now[:error] = @order.errors.full_messages.to_sentence
    end
  end

  def refresh_orders
    p "=============+GOT HERE=================="
    @orders = Order.where.not(status: ["complete", "cancelled"]).order(:id)
  end

  private
  def order_params
    params.require(:order).permit(:comments)
  end

  def check_is_admin
    return true if @current_user.is_admin
    flash[:error] = "You must be an admin to access that page"
    redirect_to login_path
  end
end
