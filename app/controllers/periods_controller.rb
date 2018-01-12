class PeriodsController < ApplicationController
  before_action :set_account, only: [:show]

  def index
    @periods = Period.all

    render json: @periods
  end

  def show
    render json: @period
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @period= Period.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def account_params
      params.require(:period).permit(:period)
    end
end
