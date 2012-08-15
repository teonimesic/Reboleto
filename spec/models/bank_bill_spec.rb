require 'spec_helper'

describe BankBill do
  let(:bill){ BankBill.new(valid_attributes) }
  subject{ bill }
  let(:valid_attributes){ {number: "10498.60024 89090.023501 03888.563875 7 54210000001000", expiration: 5.days.from_now.to_date } }
  
  it "should be valid with valid attributes" do
    bill.should be_valid
  end
  
  it "should not be valid without a number" do
    BankBill.new(expiration: 1.day.ago).should_not be_valid
  end
  
  it "should be able to generate a new bill" do
    bill.generate_number.should include("10498.60024 89090.023501 03888.563875")
  end
  
  it "should be able to generate a new bill with a fine" do
    bill.fine = "120,00"
    bill.generate_number.should =~ /0000013000$/
  end
  
  it "should be able to generate a new bill with a fine per day" do
    bill.stub(expiration: Date.new(2012, 8, 15))
    bill.fine_per_day = "2,00"
    bill.generate_number.should =~ /0000002000$/
  end
  
  it "should be able to generate a new bill with a fine per day and total" do
    bill.fine = "120,00"
    bill.stub(expiration: Date.new(2012, 8, 14))
    bill.fine_per_day = "2,00"
    bill.generate_number.should =~ /0000013800$/
  end
  
  it "should not change price digits if no price digit is specified on the original" do
    bill = BankBill.new(number: "10498.60024 89090.023501 03888.563875 7 54210000000000", expiration: 5.days.from_now.to_date)
    bill.fine = "120,00"
    bill.stub(expiration: Date.new(2012, 8, 14))
    bill.fine_per_day = "2,00"
    bill.generate_number.should =~ /0000000000$/
  end

  it "should not allow to regenerate bill not expired" do
    Date.stub(today: Date.new(2012, 8, 17))
    bill = BankBill.new(number: "10498.60024 89090.023501 03888.563875 7 54280000000000", expiration: 5.days.from_now.to_date)
    bill.should_not be_valid
    bill = BankBill.new(number: "10498.60024 89090.023501 03888.563875 7 54270000000000", expiration: 5.days.from_now.to_date)
    bill.should be_valid
  end
  
  it "should not allow to regenerate bill with no expiration date" do
    bill = BankBill.new(number: "10498.60024 89090.023501 03888.563875 7 00000000000000", expiration: 5.days.from_now.to_date)
    bill.should_not be_valid
  end
end