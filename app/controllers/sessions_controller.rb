class SessionsController < ApplicationController
  skip_before_action :require_login, only: [ :new, :create ]

  def new
  end

  def create
    email = params[:email].to_s.strip.downcase
    user = User.find_by(email: email)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to after_login_path
    else
      flash.now[:alert] = "メールアドレス、またはパスワードを正しく入力してください。"
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    reset_session
    redirect_to login_path
  end

  private

  def after_login_path
    session.delete(:return_to) || root_path
  end
end
