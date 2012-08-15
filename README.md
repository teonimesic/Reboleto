# Reboleto

Esta aplicação foi desenvolvida para facilitar a postergação do vencimento de boletos bancários.

Você pode acessar a interface web e informar o número do boleto, data de vencimento e multas para gerar um novo número, ou pode acessar diretamente pelo console rails:

    bill = BankBillGenerator.new('10498.60024 89090.023501 03888.563875 1 54210000007744')
    bill.generate_number(Date.new(2012, 8, 17), '78.99') #=> "10498.60024 89090.023501 03888.563875 3 54280000007899"

Caso deseje informar multas através do console, pode utilizar:

    bill = BankBill.new
    bill.number = '10498.60024 89090.023501 03888.563875 1 54210000007744'
    bill.expiration = Date.new(2012,9,20) # data de vencimento desejada
    bill.fine = '13,34' # valor da multa
    bill.fine_per_day = '2,13' # valor da multa diária
    bill.generate_number #=> "10498.60024 89090.023501 03888.563875 3 54620000017811"
