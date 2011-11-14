var cc = {
	init:function(){
		//set initial values for fx.rates and fx.base override when json arrives
		fx.base = "USD";
		fx.rates = {
			"EUR" : 0.74510096, // eg. 1 USD === 0.74510096 EUR
			"GBP" : 0.64771034,
			"HKD" : 7.78191949,
			"USD" : 1          // always include the base rate (1:1)
			/* etc */
		};
		this.selectFrom = document.getElementById("fromSelect");
		this.selectTo = document.getElementById("toSelect");
		$.ajaxSetup({
            cache: false
        });
		this.keys = [];
		this.values = [];
    
        this.retrieveOEData();
	},
	max_height:function(){
		
	    var h = $('div[data-role="header"]').outerHeight(true);
	    var f = $('div[data-role="footer"]').outerHeight(true);
	    var w = $(window).height();
	    var c = $('div[data-role="content"]');
	    var c_h = c.height();
	    var c_oh = c.outerHeight(true);
	    var c_new = w - h - f - c_oh + c_h;
	    var total = h + f + c_oh;
	    if(c_h<c.get(0).scrollHeight){
	        c.height(c.get(0).scrollHeight);
	    }else{
	        c.height(c_new);
	    }
	},
	retrieveOEData:function(){
        $.ajax({
          url:'http://openexchangerates.org/latest.json',
          dataType: 'json',
          success:function(data) {
                      // Check money.js has finished loading:
                      if ( typeof fx !== "undefined" && fx.rates ) {
                          fx.rates = data.rates;
                          fx.base = data.base;
                      } else {
                          // If not, apply to fxSetup global:
                          var fxSetup = {
                              rates : data.rates,
                              base : data.base
                             };
                      }
                      if(data.timestamp){
                          $(".date-data").text(cc.timeConverter(data.timestamp));
                      }  
                   cc.buildOptionBox();
                  },
          error:function(){
                    $("#result").text("Please try again later data couldn't be loaded now");
                    return;
                }          
        });
    },
    timeConverter:function(timestamp){
    var a = new Date(timestamp*1000);
    var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
        var year = a.getFullYear();
        var month = months[a.getMonth()];
        var date = a.getDate();
        var hour = a.getHours();
        var min = a.getMinutes();
        var sec = a.getSeconds();
        var time = date+','+month+' '+year+' '+hour+':'+min+':'+sec ;
        return time;
    },
	buildOptionBox:function(){
			$.getJSON(
		        'js/currencies.json',
		        function(data) {
					this.curValue = jQuery.parseJSON(data);
				    for(var key in data){
				      cc.keys.push(key);
				    }
					for(var key in data){
				      cc.values.push(data[key]);
		   	     }
					for(var i=0;i<cc.keys.length;i++){
						 var objOption = document.createElement("option");
						  objOption.text = cc.keys[i]+"-"+cc.values[i];
						  objOption.value = cc.keys[i];
						  document.getElementById("fromSelect").add(objOption,null);
					   }
					for(var i=0;i<cc.keys.length;i++){
						 var objOption = document.createElement("option");
						  objOption.text = cc.keys[i]+"-"+cc.values[i];
						  objOption.value = cc.keys[i];
						  document.getElementById("toSelect").add(objOption,null);
					   }
						cc.fromValue = document.getElementById("fromSelect").value;
						cc.toValue = document.getElementById("toSelect").value;
						
						
							
						$("#fromSelect").change(
							function(){cc.fromValue = this.value;}
						);
						$("#toSelect").change(
							function(){cc.toValue = this.value;}
						);
						$("#go").click(function(){
							cc.showRes();
							}	
						);
						
						
				}
			);
			
	},
	showRes:function(){
        this.amt =$("#amount").val();
       if(isNaN(this.amt)){
           $("#result").text("Please enter a valid amount");
       }   
       else if(this.fromValue === "CF"){
           $("#result").text("Please select from which currency to convert");
       }else if(this.toValue === "CT"){
           $("#result").text("Please select to which currency to convert");
       }else{
    		fx.settings = { from: this.fromValue, to: this.toValue };
    		this.money = fx.convert(this.amt);
    		$("#result").text(accounting.formatMoney(cc.money, { 
    			symbol: cc.toValue,  
    			format: {
    				pos : "%v %s ",
    				neg : "(%v) %s",
    				zero: "-- %s"
    			} 
    		}));
        }
	}
	
};

$(document).ready(function(){
    
    $(window).bind('pageshow resize orientationchange', function(e){
        cc.max_height();
    });

	cc.init();
    
});


