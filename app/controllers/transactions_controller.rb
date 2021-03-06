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
    account = Account.find(@transaction.account_id)
    account.balance += @transaction.amount
    account.save
    if @transaction.valid?
      @transaction.save
      render json: current_user
    else
      render json: {
        errors: @transaction.errors, status: :unprocessable_entity
      }
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
    account = Account.find(@transaction.account_id)
    account.balance -= @transaction.amount
    account.save
    render json: current_user
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def transaction_params
      params.require(:transaction).permit(:debit_or_credit, :category_name, :merchant_name, :account_name,:amount, :account_id, :period_name)
    end
end
