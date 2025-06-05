class AuthController < ApplicationController
    skip_before_action :authorized, only: [ :login ]
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

    def login
        @user = User.find_by!(username: login_params[:username])
        if @user.authenticate(login_params[:password])
            @token = encode_token(user_id: @user.id)
            render json: {
                token: @token,
                sym_key_salt: @user.ensure_sym_key_salt
            }, status: :accepted
        else
            render json: { message: "Incorrect password" }, status: :unauthorized
        end
    end

    private

    def login_params
        params.permit(:username, :password)
    end

    def handle_record_not_found(e)
        render json: { message: "User doesn't exist" }, status: :unauthorized
    end
end
