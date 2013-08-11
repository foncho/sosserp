$ ->
	$("#user_role").on "change", (e) ->
		console.log $(this).val()
		v = $(this).val()
		if v is "delegate"
			$(".user_zone").slideDown 300
		else
			$(".user_zone").slideUp 300

	$("#new_pass").on "change", (e) ->
		unless $(this).val() is ""
			$(".user_current_pass").slideDown 300
		else
			$(".user_current_pass").slideUp 300

			
	$(".zones").autocomplete
		source: "/zones"
		minLength: 1
	
		
	$("#bank_account_account_number").on "change", (e) ->
		entityCode = $("#bank_account_entity_code").val()
		branch = $("#bank_account_branch").val()
		controlDigit = $("#bank_account_control_digit").val()
		accountNumber = $(this).val()
		digit1 = digit2 = 0
		
		ec0 = ec1 = ec2 = ec3 = 0
		b0 = b2 = b2 = b3 = 0
		an0 = an1 = an2 = an3 = an4 = an5 = an6 = an7 = an8 = an9 = 0
		
		ec0 = parseInt entityCode.split("")[0] unless entityCode is ""
		ec1 = parseInt entityCode.split("")[1] unless entityCode is ""
		ec2 = parseInt entityCode.split("")[2] unless entityCode is ""
		ec3 = parseInt entityCode.split("")[3] unless entityCode is ""
		
		console.log ec0 + ' :: ' + ec1 + ' :: ' + ec2 + ' :: ' + ec3
		
		b0 = parseInt branch.split("")[0] unless branch is ""
		b1 = parseInt branch.split("")[1] unless branch is ""
		b2 = parseInt branch.split("")[2] unless branch is ""
		b3 = parseInt branch.split("")[3] unless branch is ""
		
		console.log b0 + ' :: ' + b1 + ' :: ' + b2 + ' :: ' + b3
		
		an0 = parseInt accountNumber.split("")[0] unless accountNumber is ""
		an1 = parseInt accountNumber.split("")[1] unless accountNumber is ""
		an2 = parseInt accountNumber.split("")[2] unless accountNumber is ""
		an3 = parseInt accountNumber.split("")[3] unless accountNumber is ""
		an4 = parseInt accountNumber.split("")[4] unless accountNumber is ""
		an5 = parseInt accountNumber.split("")[5] unless accountNumber is ""
		an6 = parseInt accountNumber.split("")[6] unless accountNumber is ""
		an7 = parseInt accountNumber.split("")[7] unless accountNumber is ""
		an8 = parseInt accountNumber.split("")[8] unless accountNumber is ""
		an9 = parseInt accountNumber.split("")[9] unless accountNumber is ""
		
		console.log an0 + ' :: ' + an1 + ' :: ' + an2 + ' :: ' + an3 + ' :: ' + an4 + ' :: ' + an5 + ' :: ' + an6 + ' :: ' + an7 + ' :: ' + an8 + ' :: ' + an9
		
		sum1 = (ec0*4) + (ec1*8) + (ec2*5) + (ec3*10) + (b0*9) + (b2*7) + (b2*3) + (b3*6)
		sum2 = (an0*1) + (an1*2) + (an2*4) + (an3*8) + (an4*5) + (an5*10) + (an6*9) + (an7*7) + (an8*3) + (an9*6)
		
		console.log sum1 + ' :: ' + sum2
		
		resto1 = sum1 % 11
		resto2 = sum2 % 11
		
		(if resto1 is 0 then (digit1 = resto1) else (digit1 = 11 - resto1))
		(if resto2 is 0 then (digit2 = resto2) else (digit2 = 11 - resto2))
		
		console.log digit1 + ' :: ' + digit2
		
		cd = digit1.toString() + digit2.toString()
		
		console.log cd
		
		alert "El dígito control es incorrecto. Por favor, revíse el número de cuenta antes de salvar." unless controlDigit == cd