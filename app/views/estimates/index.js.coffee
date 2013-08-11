$(".estimates").html "<%= j render @estimates %>"
$("#paginator").html "<%= j paginate(@estimates, remote: true).to_s %>"

$(".wait").hide()
$(".wait-backdrop").hide()