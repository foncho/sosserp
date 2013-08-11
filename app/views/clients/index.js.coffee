$(".clients").html "<%= j render @clients %>"
$("#paginator").html "<%= j paginate(@clients, remote: true).to_s %>"