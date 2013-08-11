$ ->
	$.datepicker.regional["es"] =
		closeText: "Cerrar"

	currentText: "Hoy"
	monthNames: ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
	monthNamesShort: ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
	dayNames: ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"]
	dayNamesShort: ["Dom", "Lun", "Mar", "Mié", "Juv", "Vie", "Sáb"]
	dayNamesMin: ["Do", "Lu", "Ma", "Mi", "Ju", "Vi", "Sá"]
	dateFormat: "dd/mm/yy"
	firstDay: 1
	isRTL: false
	showMonthAfterYear: false

	$.datepicker.setDefaults $.datepicker.regional["es"]

	$(".datepicker").datepicker
		showButtonPanel: true
		dateFormat: "dd/mm/yy"
		
	$realInputField = $('#expense_file')

	$realInputField.change ->
		$('#file-display').val $(@).val().replace(/^.*[\\\/]/, '')
	
	$('#upload-btn').click ->
	    $realInputField.click()

	showPaymentDate = (value) ->
		if (value isnt "") and (value is "Pagada")
			$("#payment-date").show()
		else
			$("#payment-date").hide()
		
	refreshCostCalculations = (item) ->
		quantity = item.parent().parent().parent().parent().find("#number").val()
		unit_cost = item.parent().parent().parent().parent().find("#unit-cost").val()
		tax = item.parent().parent().parent().parent().find("#tax_id").val()
		partial = item.parent().parent().parent().parent().find("#partial-cost")
	
		setPartialCostsAmount quantity, unit_cost, tax, partial
		setTotalCostAmount $(".tc")

	setPartialCostsAmount = (q, uc, t, tag) ->
		console.log uc + " :: " + q + " :: " + t
		tax = 0
		tax = t.split(";")[1] / 100  unless t is ""
		subtotal = (uc * q)
		tax_calculation = (subtotal * tax)
		console.log subtotal + " :: " + tax_calculation
		result = subtotal + tax_calculation
		tag.val result.toFixed(2)
	
	setTotalCostAmount = (objs) ->
		result = 0
		objs.each ->
			result += parseFloat($(this).val())
		
		final = result
		$("#total").val final.toFixed(2)

	showPaymentDate = (value) ->
		if (value isnt "") and (value is "Pagada")
			$(".payment-date").show()
		else
			$(".payment-date").hide()
	
	$(document).on "change", "#number", (e) ->
		refreshCostCalculations $(this)
		
	$(document).on "change", "#unit-cost", (e) ->
		refreshCostCalculations $(this)
		
	$(document).on "change", "#tax_id", (e) ->
		refreshCostCalculations $(this)
		
	# Inicializamos el form
	$(".tc").each ->
		refreshCostCalculations $(this)
		