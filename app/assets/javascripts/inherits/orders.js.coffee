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