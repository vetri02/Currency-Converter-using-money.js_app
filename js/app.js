fx.base = "USD";
fx.rates = {
	"EUR" : 0.74510096, // eg. 1 USD === 0.74510096 EUR
	"GBP" : 0.64771034,
	"HKD" : 7.78191949,
	"USD" : 1,          // always include the base rate (1:1)
	/* etc */
}
// Load exchange rates data via the cross-domain/AJAX proxy:
$.getJSON(
    'http://openexchangerates.org/latest.json',
    function(data) {
		var selectFrom = document.getElementById("fromSelect");
		var selectTo = document.getElementById("toSelect");
		var value = data.rates;
		 var keys = [];
		   for(var key in value){
		      keys.push(key);	
		   }
		   for(var i=0;i<=keys.length;i++){
			 var objOption = document.createElement("option");
			  objOption.text = keys[i];
			  objOption.value = keys[i];
			  selectFrom.add(objOption);
		   }
		   for(var i=0;i<=keys.length;i++){
			 var objOption = document.createElement("option");
			  objOption.text = keys[i];
			  objOption.value = keys[i];
			  selectTo.add(objOption);
		   }
			
		console.log(keys); 
        // Check money.js has finished loading:
        if ( typeof fx !== "undefined" && fx.rates ) {
            fx.rates = data.rates;
            fx.base = data.base;
        } else {
            // If not, apply to fxSetup global:
            var fxSetup = {
                rates : data.rates,
                base : data.base
            }
        }
		
		
    }
);