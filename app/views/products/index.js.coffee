$(".products").html "<%= j render @products %>"
$("#paginator").html "<%= j paginate(@products, remote: true).to_s %>"