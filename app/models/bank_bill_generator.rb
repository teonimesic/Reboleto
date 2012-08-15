class BankBillGenerator
  attr_accessor :number, :price, :bank, :currency, :days,
    :price, :our_number, :transferor, :verifier_digit1, :verifier_digit2,
    :verifier_digit3, :general_verifier_digit

  def initialize(number=nil)
    @number = number.gsub(/\.| /,'')
    @number =~ /^(\d{3})(\d)(\d{5})(\d)(\d{5})(\d{5})(\d)(\d{10})(\d)(\d)(\d{4})(\d{10})$/
    @bank, @currency, @days, @price = $1, $2, $11, $12
    @our_number = $3 + $5
    @transferor = $6 + $8
    @verifier_digit1 = $4
    @verifier_digit2 = $7
    @verifier_digit3 = $9
    @general_verifier_digit = $10
  end

  def expiration_date_code(new_date)
    (new_date - Date.new(1997,10,7)).to_i.to_s
  end

  def price_code(new_price)
    new_price = new_price.to_s.gsub(/,|\./, '')
    "0"*(10 - new_price.length) + new_price
  end

  def validation_digit(new_date, new_price)
    calculate_digit bank + currency + expiration_date_code(new_date) + price_code(new_price) + our_number + transferor
  end

  def generate_number(new_date, new_price = nil)
    new_price = price_code(new_price || @price)
    "#{@bank}#{@currency}#{@our_number[0]}.#{@our_number[1..4]}#{@verifier_digit1} #{@our_number[5..9]}.#{@transferor[0..4]}#{@verifier_digit2} #{@transferor[5..9]}.#{@transferor[10..14]}#{@verifier_digit3} #{validation_digit(new_date, new_price)} #{expiration_date_code(new_date)}#{new_price}"
  end

  private
    def calculate_digit(line)
      sum = 0
      line.reverse.chars.each.with_index {|c, i| sum += (i%8 + 2)*c.to_i }
      sum = 11 - (sum % 11)
      sum = 1 if sum > 9
      sum.to_s
    end
end