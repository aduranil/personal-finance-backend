require 'csv'
require 'smarter_csv'
require 'classifier-reborn'
require 'chronic'

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
      classify = File.read("./categories.dat")
      new_classifier = Marshal.load(classify)
      merchant = File.read("./merchants.dat")
      merchant_classifier = Marshal.load(merchant)
      data.each do |row|
        t = Transaction.create(account_id: @filereader.account_id, account_name: Account.find(@filereader.account_id).name)

        if row.keys.include?(:category) && row[:category] != nil && row[:category].length > 1
          t.category_name= row[:category][0]
        elsif row.keys.include?(:category) && row[:category] != nil
          t.category_name= row[:category]
        elsif row.keys.include?(:category)

          t.category_name= row[:category]
        elsif row.keys.include?(:description)

          t.category_name = new_classifier.classify(row[:description])

        elsif row.keys.include?(:name)

          t.category_name = new_classifier.classify(row[:name])
        else
          t.category_name = "Uncategorized"
        end

        if row.keys.include?(:merchant) && row[:merchant] != nil && row[:merchant].length > 1
          t.merchant_name= row[:merchant][0]
        elsif row.keys.include?(:merchant) && row[:merchant] != nil
          t.merchant_name= row[:merchant]
        elsif row.keys.include?(:merchant)
          t.merchant_name= row[:merchant]
        elsif row.keys.include?(:description)
          t.merchant_name = merchant_classifier.classify(row[:description])
        elsif row.keys.include?(:name)
          t.merchant_name = merchant_classifier.classify(row[:name])
        else
          t.merchant_name = "Uncategorized"
        end


        if row.keys.include?(:description)
          t.description = row[:description]
        end

        if row.keys.include?(:date)
          d = Chronic.parse(row[:date])
          if d == nil
            d = Date.today()
          end
          d = d.strftime('%Y-%m-%d')
          t.period_name = d
        elsif row.keys.include?(:posting_date)
          d = Chronic.parse(row[:posting_date])
          if d == nil
            d = Date.today()
          end
          d = d.strftime('%Y-%m-%d')
          t.period_name = d
        else
          d = Date.today()
          d = d.strftime('%Y-%m-%d')
          t.period_name = d
        end

        if row.keys.include?(:amount)
          t.amount = row[:amount]

        else

          t.amount = 0
        end

        if row.keys.include?(:debit)
          t.debit_or_credit = "debit"
        elsif row.keys.include?(:credit)
          t.debit_or_credit = "credit"
        elsif row.keys.include?(:transaction_type)
          t.debit_or_credit = row[:transaction_type]
        else
          t.debit_or_credit = "debit"
        end

        t.save

      end
      render json: current_user
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
