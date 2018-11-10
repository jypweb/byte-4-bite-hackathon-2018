class Admin::WelcomeController < ApplicationController
  layout 'admin'
  before_action :check_is_admin

  def index
    @orders = Order.where.not(status: ["completed", "cancelled"])
  end

  private
  def check_is_admin
    return true if @current_user.is_admin
    flash[:error] = "You must be an admin to access that page"
    redirect_to login_path
  end
end
