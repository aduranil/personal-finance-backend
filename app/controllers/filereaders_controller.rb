require 'csv'
require 'smarter_csv'
require 'classifier'
require "gsl"

class FilereadersController < ApplicationController
  before_action :set_filereader, only: [:show, :update, :destroy]

  # GET /filereaders
  def index
    @filereaders = Filereader.all

    render json: @filereaders
  end

  # GET /filereaders/1
  def show
    render json: @filereader
  end

  # POST /filereaders
  def create
    @filereader = Filereader.new(filereader_params)
    if @filereader.save
      data = open(@filereader.file_upload.path).read()
      File.open(@filereader.file_upload.path, 'w') { |file| file.write(data) }
      data = SmarterCSV.process(@filereader.file_upload.path,{ })
      classify = File.read("./classifier.dat")
      new_classifier = Marshal.load(classify)
      byebug
      data.each do |row|
        transaction = Transaction.create(account_id: @filereader.account_id, account_name: Account.find(@filereader.account_id).name)
        byebug
        if row.keys.include?(:category) && row[:category].length > 1
          byebug
          transaction.category_name= row[:category][0]
        elsif row.keys.include?(:category)
          byebug
          transaction.category_name= row[:category]
        elsif row.keys.include?(:description)
          byebug
          transaction.category_name = new_classifier.classify(row[:description])

        elsif row.keys.include?(:name)
          byebug
          transaction.category_name = new_classifier.classify(row[:name])
        else
          transaction.category_name = "Uncategorized"
        end
        byebug
        if row.keys.include?(:description)
          transaction.description = row[:description]
          transaction.merchant_name = row[:description]
        end
        byebug
        if row.keys.include?(:date)
          transaction.period_name = row[:date]
        elsif row.keys.include?(:posting_date)
          transaction.period_name = row[:posting_date]
        else
          Transaction.period_name = Date.today()
        end
        byebug
        if row.keys.include?(:amount)
          transaction.amount = row[:amount]
        else
          transaction.amount = row.values.select {|x| Integer(x) rescue nil }[0]
        end
        byebug
        if row.keys.include?(:debit)
          transaction.debit_or_credit = "debit"
        elsif row.keys.include?(:credit)
          transaction.debit_or_credit = "credit"
        elsif row.keys.include?(:transaction_type)
          transaction.debit_or_credit = row[:transaction_type]
        else
          transaction.debit_or_credit = "debit"
        end
        byebug
        transaction.save
        byebug
      end
      render json: @filereader
    else
      render json: @filereader.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /filereaders/1
  def update
    if @filereader.update(filereader_params)
      render json: @filereader
    else
      render json: @filereader.errors, status: :unprocessable_entity
    end
  end

  # DELETE /filereaders/1
  def destroy
    @filereader.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_filereader
      @filereader = Filereader.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def filereader_params
      params.permit(:file_upload, :account_id)
    end
end
