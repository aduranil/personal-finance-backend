class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :update, :destroy]

  # GET /transactions
  def index
    @transactions = Transaction.all

    render json: @transactions
  end

  # GET /transactions/1
  def show
    render json: @transaction
  end

  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params)
    d= @transaction.period_name.split('-')
    month = d[1]
    day = d[2]
    year = d[0]
    if month[0] == "0"
      month = month[1]
    end
    if day[0] == 0
      day = day[1]
    end
    @transaction.period_name = month +'/'+ day +'/'+ year
    if @transaction.category_id == ""
      @transaction.category_id = Category.find_or_create_by(name: @transaction.category_name)
    end

    @transaction.merchant = Merchant.find_or_create_by(name: @transaction.merchant_name)
    @transaction.period = Period.find_or_create_by(date: @transaction.period_name)
    @transaction.save
    if @transaction.save
      render json: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /transactions/1
  def update
    if @transaction.update(transaction_params)
      render json: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /transactions/1
  def destroy
    @transaction.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def transaction_params
      params.permit(:category_id, :merchant_id, :account_id, :period_name, :period_id, :debit_or_credit, :category_name, :merchant_name, :account_name,:amount)
    end
end
