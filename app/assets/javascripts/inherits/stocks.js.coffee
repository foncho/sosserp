$ ->
	$("table > tbody > tr > td > a#example").on "click", (e) ->
		e.preventDefault()

	$("table > tbody > tr > td > a#example").popover
		html: true
		animation: true
		placement: 'right'
		
	$("#search-button").click ->
		$(".wait").show()
		$(".wait-backdrop").show()
