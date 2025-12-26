module LoginHelper
  def login_as(user)
    post login_path, params: {
      email: user.email,
      password: user.password
    }
  end
end
