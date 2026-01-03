class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  # stale_when_importmap_changes

  before_action :require_login

  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    return if current_user

    store_location
    redirect_to login_path, alert: "ログインしてください"
  end

  # 未ログイン時にリクエスト先を保存する
  # ログイン後にリクエスト先へ戻す
  def store_location
    # Getリクエストのみ保存する
    return unless request.get? || request.head?

    # ログイン画面は保存しない
    return if request.path == login_path

    session[:return_to] = request.fullpath
  end
end
