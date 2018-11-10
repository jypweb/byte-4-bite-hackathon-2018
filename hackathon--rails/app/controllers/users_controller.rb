class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:auth, :login, :create, :test]

  def auth
    authenticate params[:email], params[:password]
  end

  def login
    @user = User.new
  end

  def logout
    session[:user_id] = nil
    session[:expire] = nil
    flash[:notice] = "Logged out!"
    redirect_to login_path
  end

  def create
    # Create the user endpoint
    @user = User.new(user_params)
    if @user.save
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to 'login'
    end
  end

  def show
    # Show the user's open orders
  end

  def edit
    # Edit a users' profile view
  end

  def update
    # Update the user endpoint
  end

  def destroy
    # Destroy the user endpoint
  end

  def test
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 and return unless @current_user

    render json: {
      message: 'You have passed authentication and authorization test',
      currentUser: @current_user
    }
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :address1, :address2, :city, :state, :postal_code)
  end

  def authenticate(email, password)
    command = AuthenticateUser.call(email, password)

    if command.success?
      @current_user = User.find_by_email(email)
      session[:user_id] = @current_user.id
      session[:expire] = Time.current.to_s
      session[:jwt_token] = command.result
      if @current_user.is_admin
        redirect_to admin_welcome_path
      else
        redirect_to user_path(@current_user.id)
      end
    else
      flash[:error] = "Invalid Login"
      redirect_to login_path
    end
   end
end
