###
	Project: CurrencyConverter
	File: app.js
	Author : Vetri

###

class CurrencyConverter

	constructor: () ->
	init: () ->
		#set initial values for fx.rates and fx.base override when json arrives
		
		fx.base = "USD"
		fx.rates = 
			"EUR" : 0.74510096, # eg. 1 USD === 0.74510096 EUR
			"GBP" : 0.64771034,
			"HKD" : 7.78191949,
			"USD" : 1          # always include the base rate (1:1)
			#etc
		
		@countryFrom = $("#fromSelect")
		@countryTo = $("#toSelect")
		@keys = []
		@values = []

		$.ajaxSetup
			cache:false

		@getValues()	
		@retrieveOpenExchangeData()

	retrieveOpenExchangeData: () ->
		$.ajax
			url: 'http://openexchangerates.org/latest.json'
			datatype: 'json'
			success: (data) =>

				objData = jQuery.parseJSON(data) || data
				$(".noDataMsg").text ""

				if fx? and fx.rates?
					fx.rates = objData.rates
					fx.base = objData.base
				else
					fxSetup = 
						rates : objData.rates
						base : objData.base

				if objData.timestamp
					timeStamp = @timeConverter(objData.timestamp)
					$(".timeStamp").text timeStamp

				@buildOptionsBox()
			error: (data) ->
				$(".noDataMsg").text "Please, try again later data couldn't be fetched now"

	timeConverter: (timestamp) ->
		a = new Date timestamp*1000
		months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']
		year = a.getFullYear()
		month = months[a.getMonth()]
		date = a.getDate()
		hour = a.getHours()
		min = a.getMinutes()
		sec = a.getSeconds()
		time = date+', '+month+' '+year+' '+hour+':'+min+':'+sec

	buildOptionsBox: () ->
		url = 'js/currencies.json'
		$.getJSON url , (data) =>
			for key of data
				@keys.push(key)
			
			for key of data
				@values.push(data[key])

			for sym,i in @keys
				objOption = document.createElement("option")
				objOption.text = @keys[i]+"-"+@values[i]
				objOption.value = @keys[i]
				@countryFrom.get(0).add(objOption,null)

			for sym,i in @keys
				objOption = document.createElement("option")
				objOption.text = @keys[i]+"-"+@values[i]
				objOption.value = @keys[i]
				@countryTo.get(0).add(objOption,null)	
				
			@countryFrom.hide().show()
			@countryTo.hide().show()

			@countryFrom.change =>
				@getValues()
				@showResults()

			@countryTo.change =>
				@getValues()
				@showResults()
			
			$("#amount").change =>
				@showResults()

			$("#go").click =>
				#if($("#go").find("img").hasClass("rotate"))
					#$("#go").find("img").removeClass("rotate")

				if(@fromValue == "CF" || @toValue == "CT")
					return false
				#$("#go").find("img").addClass("rotate")
				@countryFrom.val(@toValue);
				@countryTo.val(@fromValue)
				fromText = @countryFrom.find('option:selected').text()
				toText = @countryTo.find('option:selected').text()
				@countryFrom.siblings('span').text(fromText)
				@countryTo.siblings('span').text(toText)
				@getValues()
				@showResults()


	getValues: () =>
		@fromValue = $("#fromSelect").val()
		@toValue = $("#toSelect").val()

	showResults: () =>
		@amt = $("#amount").val()
		if(isNaN(@amt) or @amt == "")
			$("#result").text("Please enter a valid amount")
		else if(@fromValue == "CF")
			$("#result").text("Please select from which currency you want to convert")
		else if(@toValue == "CT")
			$("#result").text("Please select to which currency you want to convert")
		else if(@fromValue == "CF" && @toValue == "CT")
			$("#result").text("Please select from and to which currency you want to convert")
		else
			fx.settings = 
				from: @fromValue
				to: @toValue

			@money = fx.convert(@amt)
			str = @money+"";
			if (str.indexOf("e") >= 0)
				$("#result").text(@money +" "+ @toValue)
			else
				params = 
					pos : "%v %s "
					neg : "(%v) %s"
					zero: "-- %s"
				args = 
					symbol: @toValue  
					format: params
				
				$("#result").text accounting.formatMoney(@money, args)
				
cc = new CurrencyConverter()

$ () ->
	if navigator.onLine == true
		cc.init()
	else
		$(".noDataMsg").text "Please, connect to the internet and try again"
	if (!$.browser.opera) 
		$('select.select').each ->
			title = $(@).attr('title')
			if( $('option:selected', @).val() != ''  )
				title = $('option:selected',@).text()
			$(this)
				.css({'z-index':10,'opacity':0,'-khtml-appearance':'none'})
				.after('<span class="select selectBg">' + title + '</span>')
				.change ->
					val = $('option:selected',@).text()
					$(this).next().text(val)

