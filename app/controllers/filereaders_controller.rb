require 'csv'
require 'smarter_csv'

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
      data.each do |row|
        transaction = Transaction.create(description: row[:description], account_id: @filereader.account_id, account_name: Account.find(@filereader.account_id).name, period_name: row[:date], amount: row[:amount])
        if row.keys.include?(:debit)
          transaction.debit_or_credit = "debit"
        elsif row.keys.include?(:credit)
          transaction.debit_or_credit = "credit"
        end
      end
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
