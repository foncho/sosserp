$ ->
	$("#days").change(->
		if $("#days").val() == "" 
			$("#block").hide()
		else 
			$("#block").show()
	).trigger "change"
