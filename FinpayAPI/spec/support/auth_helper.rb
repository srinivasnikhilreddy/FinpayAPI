module AuthHelper
  def auth_headers(user)
    post "/login", params: {
      user: {
        email: user.email,
        password: "Password@123"
      }
    }, as: :json

    { "Authorization" => response.headers["Authorization"] }
  end
end