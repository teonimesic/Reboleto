require 'spec_helper'

describe BankBillGenerator do
  let(:bill){ BankBillGenerator.new('10498600248909002350103888563875754210000007744') }
  it "should initialize by bill number" do
    bill.number.should == "10498600248909002350103888563875754210000007744"
  end

  it "should remove any punctuation from number" do
    bill = BankBillGenerator.new('10498.60024.89090.023501 03888.563875 7 54210000000000')
    bill.number.should == "10498600248909002350103888563875754210000000000"
  end

  it "should be able to calculate the new expiration date code" do
    bill.expiration_date_code(Date.new(2012, 8, 17)).should == "5428"
  end

  it "should be able to calculate the new price code" do
    bill.price_code('29.34').should   == "0000002934"
    bill.price_code('0.23').should    == "0000000023"
    bill.price_code('135.00').should  == "0000013500"
  end

  it "should calculate validation digit for a new price and date" do
    bill.validation_digit(Date.new(2012, 8, 10), '0.0').should == "7"
  end

  it "should calculate validation digit for a new price and date" do
    bill.validation_digit(Date.new(2012, 8, 17), '78.99').should == "3"
    bill2 = BankBillGenerator.new("00190.00009 01238.798779 77700.168188 2 37690000013500")
    bill2.validation_digit(Date.new(2008, 2, 1), '135.00').should == "2"
  end

  it "should know the bank identifier number" do
    bill.bank.should == "104"
  end

  it "should know the currency code" do
    bill.currency.should == "9"
  end

  it "should know the days_code" do
    bill.days.should == "5421"
  end

  it "should know the price_code" do
    bill.price.should == "0000007744"
  end

  it "should know the our number" do
    bill.our_number.should == "8600289090"
  end

  it "should know the transferor" do
    bill.transferor.should == "023500388856387"
  end

  it "should know the verifier_digit1" do
    bill.verifier_digit1.should == "4"
  end

  it "should know the verifier_digit2" do
    bill.verifier_digit2.should == "1"
  end

  it "should know the verifier_digit3" do
    bill.verifier_digit3.should == "5"
  end

  describe "new number" do
    it "should generate a new number for a new date" do
      bill.generate_number(Date.new(2012, 8, 17)).should == "10498.60024 89090.023501 03888.563875 1 54280000007744"
    end

    it "should generate a new number for a new date and price" do
      bill.generate_number(Date.new(2012, 8, 17), '78.99').should == "10498.60024 89090.023501 03888.563875 3 54280000007899"
    end
  end
end