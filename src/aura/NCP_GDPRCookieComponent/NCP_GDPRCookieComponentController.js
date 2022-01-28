({
	doInit : function(component, event, helper) {
       var cookie = document.cookie.split('=');
       var cookieVal;
       if(cookie !='' && cookie !=null){
            for(var i = 0; i < cookie.length; i++) {
                cookieVal = cookie[1];
          }
       }
        if(cookieVal !='' && cookieVal !=null){
            component.set("v.cookiepopupcheck", false);
        }else{
            component.set("v.cookiepopupcheck", true);
        }
     
	},
    
    CookieInitiation : function(component, event, helper) {
          var user = helper.getCookie("DCP Consent");
      	  if (user == "") {
            helper.createCookie("DCP Consent", "DCP Consent", 1);
        } 
        component.set("v.cookiepopupcheck", false);
      },
    
    closeModel: function(component, event, helper) {
      component.set("v.cookiepopupcheck", false);
   },
    
  openActionWindow : function(component, event, helper) {
		 window.open("https://nokia.my.salesforce.com/sfc/p/58000000t8Dk/a/3h000000kFk8/5f065WJ_AMGKWCwyk6544RJedRY9r29Gf_EuSGBS.10");
	}

})