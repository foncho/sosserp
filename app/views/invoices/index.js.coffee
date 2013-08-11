$(".invoices").html "<%= j render @invoices %>"
$("#paginator").html "<%= j paginate(@invoices, remote: true).to_s %>"
$(".results").html "<%= j render 'results' %>"

$(".wait").hide()
$(".wait-backdrop").hide()