class SecretsController < ApplicationController
  before_action :set_secret, only: %i[ show update destroy ]
  before_action :check_belongs_to_user, only: %i[show update destroy]

  # GET /secrets
  def index
    user = current_user
    @secrets = user.secrets

    render json: @secrets
  end

  # GET /secrets/1
  def show
    render json: @secret
  end

  # POST /secrets
  def create
    @secret = Secret.new(secret_params)

    if @secret.save
      render json: @secret, status: :created, location: @secret
    else
      render json: @secret.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /secrets/1
  def update
    if @secret.update(secret_params)
      render json: @secret
    else
      render json: @secret.errors, status: :unprocessable_entity
    end
  end

  # DELETE /secrets/1
  def destroy
    @secret.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_secret
      @secret = Secret.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def secret_params
      params.expect(secret: [ :value, :user_id ])
    end

  def check_belongs_to_user
    user = current_user

    unless @secret.user == user
      render json: { message: "This secrent does not belong to the user!" }, status: :forbidden
    end
  end
end
