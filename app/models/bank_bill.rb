# encoding: UTF-8
class BankBill
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :number, :fine, :fine_per_day, :expiration, :bill
  
  validates_presence_of :number, :expiration
  validates_format_of :number, with: /^\d{5}\.\d{5} \d{5}\.\d{6} \d{5}.\d{6} \d \d{14}$/, allow_blank: true
  validates_format_of :fine_per_day, with: /^\d+,\d{2}$/, allow_blank: true, message: "precisa estar no formato R$ X,XX"
  validates_format_of :fine, with: /^\d+,\d{2}$/, allow_blank: true, message: "precisa estar no formato R$ X,XX"
  validate :expired
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
  def generate_number
    bill.generate_number(expiration, calculated_price)
  end
  
  def bill
    @bill ||= BankBillGenerator.new(number)
  rescue
    nil
  end
  
  def calculated_price
    (bill.price.to_i + fine_price).to_s
  end
  
  def fine_price
    return 0 if bill.price.to_i.zero?
    price = 0
    price += fine.sub(',','').to_i if fine.present?
    price += fine_per_day.sub(',','').to_i * days_since_expiration if fine_per_day.present?
    price
  end
  
  def days_since_expiration
    (expiration - Date.new(1997,10,7)).to_i - bill.days.to_i
  end
  
  def expired
    if bill.present?
      errors.add(:expiration, "precisa estar no passado") if Date.today - Date.new(1997,10,7) <= bill.days.to_i
      errors.add(:number,     "não tem data de vencimento e pode ser pago a qualquer momento") if bill.days.to_i.zero?
    end
  end
end