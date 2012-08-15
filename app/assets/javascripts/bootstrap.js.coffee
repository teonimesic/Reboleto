jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  
  $("#bank_bill_number").mask("99999.99999 99999.999999 99999.999999 9 99999999999999")