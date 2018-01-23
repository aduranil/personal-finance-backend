require 'plaid'
require 'json'
require 'classifier'
require "gsl"

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
    client = Plaid::Client.new(env: :sandbox,
                           client_id: ENV['client_id'],
                           secret: ENV['secret'],
                           public_key: ENV['public_key'])

    token = JSON.parse(@authenticator.token.to_json)["public_token"]
    account = Account.create(name:@authenticator.token["institution"]["name"], user_id: @authenticator.user_id)
    response = client.item.public_token.exchange(token)
    access_token = response['access_token']
    transaction_response = client.transactions.get(access_token, '2016-07-12', '2017-01-09')
    transactions = transaction_response['transactions']
    data = File.read("./classifier.dat")
    new_classifier = Marshal.load(data)
    byebug
    transactions = transactions[0..2]
    if transactions.length > 0
      transactions.each do |row|
        byebug
        transaction = Transaction.create(
          account_id: account.id,
          account_name: account.name,
          amount: row['amount'],
          period_name: row['date'],
          merchant_name: row['name'],
          description: row['name'])
        if row.keys.include?(:category) && row[:category].length > 1
          transaction.category_name= row[:category][0]
        elsif row.keys.include?(:category)
          transaction.category_name= row[:category]
        elsif row.keys.include?(:description)
          transaction.category_name = new_classifier.classify(row[:description])
          byebug
        elsif row.keys.include?(:name)
          transaction.category_name = new_classifier.classify(row[:name])
        else
          transaction.category_name = "Uncategorized"
        end
        transaction.save
        byebug
      end
    end
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
      params.require(:authenticator).permit(:user_id, :token =>[:public_token,{:institution => [:name]}])
    end
end
