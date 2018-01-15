class CategoriesController < ApplicationController
  before_action :set_account, only: [:show]

  def index
    @categories = Category.all
    render json: @categories.sort_by {|category| category[:name]}
  end

  def show
    render json: @category
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @category = Category.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def account_params
      params.require(:category).permit(:name)
    end
end
