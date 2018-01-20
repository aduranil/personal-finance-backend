

class AuthenticatorsController < ApplicationController
  before_action :set_authenticator, only: [:show, :update, :destroy]

  # GET /authenticators
  def index
    @authenticators = Authenticator.all

    render json: @authenticators
  end

  # GET /authenticators/1
  def show
    render json: @authenticator
  end

  # POST /authenticators
  def create

    @authenticator = Authenticator.new(authenticator_params)
    if @authenticator.save
      render json: @authenticator, status: :created, location: @authenticator
    else
      render json: @authenticator.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /authenticators/1
  def update
    if @authenticator.update(authenticator_params)
      render json: @authenticator
    else
      render json: @authenticator.errors, status: :unprocessable_entity
    end
  end

  # DELETE /authenticators/1
  def destroy
    @authenticator.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_authenticator
      @authenticator = Authenticator.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def authenticator_params
      params.require(:authenticator).permit(:user_id, :token =>[{:institution => [:name], :account=> [:name, :type]}])
    end
end
