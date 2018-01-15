class MerchantsController < ApplicationController
  before_action :set_account, only: [:show]

  def index
    @merchants = Merchant.all
    render json: @merchants.sort_by {|merchant| merchant[:name]}
  end

  def show
    render json: @merchant
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @merchant = Merchant.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def account_params
      params.require(:merchant).permit(:name)
    end
end
