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
    if transactions.length > 0
      transactions.each do |row|
        transaction = Transaction.create(
          account_id: account.id,
          account_name: account.name,
          amount: row['amount'],
          merchant_name: row['name'],
          description: row['name'])
        if row.keys.include?('date')
          d = Date.parse(row['date'])
          d = d.strftime('%Y-%m-%d')
          transaction.period_name = d
        elsif row.keys.include?('posting_date')
          d = Date.parse(row['posting_date'])
          d = d.strftime('%Y-%m-%d')
          transaction.period_name = d
        else
          d = Date.today()
          d = d.strftime('%Y-%m-%d')
          transaction.period_name = d
        end
        transaction.save
        if row.keys.include?('category') && row['category'] != nil && row['category'].length > 1
          transaction.category_name= row['category'][0]
        elsif row.keys.include?('category') && row['category'] != nil
          transaction.category_name= row['category']
        # elsif row.keys.include?('description')
        #   transaction.category_name = new_classifier.classify(row['description'])
        #   byebug
        # elsif row.keys.include?('name')
        #   transaction.category_name = new_classifier.classify(row['name'])
        else
          transaction.category_name = "Uncategorized"
        end

        transaction.save
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
