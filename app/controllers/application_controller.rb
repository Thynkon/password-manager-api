class ApplicationController < ActionController::API
  before_action :authorized
  def encode_token(payload)
    now = Time.now.to_i
    payload[:iat] = now
    payload[:exp] = now + (24 * 60 * 60)

    JWT.decode(token, Rails.application.credentials.jwt_hmac!, true, { algorithm: "HS256" })
  end

  def decoded_token
    header = request.headers["Authorization"]
    if header
      token = header.split(" ")[1]
      begin
        JWT.decode(
          token,
          Rails.application.credentials.jwt_hmac!,
          true,
          { algorithm: "HS256" }
        )
      rescue JWT::ExpiredSignature
        render json: { message: "Token has expired" }, status: :unauthorized
      rescue JWT::DecodeError
        render json: { message: "Invalid token" }, status: :unauthorized
      end
    end
  end

  def current_user
        if decoded_token
            user_id = decoded_token[0]["user_id"]
            @user = User.find_by(id: user_id)
        end
  end

    def authorized
        unless !!current_user
          render json: { message: "Please log in" }, status: :unauthorized
        end
    end
end
