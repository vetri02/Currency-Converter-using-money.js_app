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
		@countryTo = $("toSelect")
		@keys = []
		@values = []

		$.ajaxSetup
			cache:false

		@retrieveOpenExchangeData()

		return true

	retrieveOpenExchangeData: () ->
		$.ajax
			url: 'http://openexchangerates.org/latest.json'
			datatype: 'json'
			success: (data) ->
				if fx? and fx.rates?
					fx.rates = data.rates
					fx.base = data.base
				else
					fxSetup = 
						rates : data.rates
						base : data.base

				if data.timestamp
					$(".data-data").text(@timeConverter(data.timestamp))

				@buildOptionsBox()

	timeConverter: () ->
	buildOptionsBox: () ->
	showResults: () ->