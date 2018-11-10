class ApplicationController < ActionController::Base

  before_action :authenticate_request
  attr_reader :current_user

  include ExceptionHandler

  private

  def authenticate_request
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    if session[:user_id] && session[:expire]
      if session[:expire] >= 30.minutes.ago.to_s
        session[:expire] = Time.current.to_s
      else
        session[:user_id] = nil
        session[:expire] = nil
        redirect_to login_path
      end
    else
      flash[:warning] = "Please login"
      redirect_to login_path
    end
  end
end
