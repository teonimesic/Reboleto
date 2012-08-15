class BankBillsController < ApplicationController
  def new
    @bank_bill = BankBill.new
  end
  
  def create
    # Date.civil(params[:range][:"start_date(1i)"].to_i,params[:range][:"start_date(2i)"].to_i,params[:range][:"start_date(3i)"].to_i)
    @bank_bill = BankBill.new(params[:bank_bill].except('expiration(3i)', 'expiration(2i)', 'expiration(1i)'))
    date = ->(x){ params[:bank_bill]["expiration(#{x}i)"].to_i } 
    @bank_bill.expiration = Date.new(date[1], date[2], date[3])
    if @bank_bill.valid?
      render :show
    else
      render :new
    end
  end
end