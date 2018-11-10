class Admin::WelcomeController < ApplicationController
  layout 'admin'
  before_action :check_is_admin

  def index
    @orders = Order.where.not(status: ["complete", "cancelled"])
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
      flash.now[:success] = "Order Successfully Updated"
    else
      flash.now[:error] = "There was an error."
    end
  end

  def show_order
    @order = Order.find_by_oid(params[:order_id])
  end

  def refresh_orders
    @orders = Order.where.not(status: ["complete", "cancelled"])
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
