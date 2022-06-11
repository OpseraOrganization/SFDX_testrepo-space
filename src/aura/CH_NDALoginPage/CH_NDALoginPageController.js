({
	doInit : function(component, event, helper) {  
     	//var pageReference = component.get("v.pageReference");
     	var ndaLabel=$A.get("$Label.c.NDAURL_Utility");
        var ndaPartUrl=ndaLabel.substring(0, ndaLabel.lastIndexOf('&'));
        //console.log('ndaLabel2'+abc);
       // console.log('ndaLabel'+ndaLabel);
       // var param2 = "https://staging.digital-assistant.nokia.com/saml/login?idp=extrafed&botId=16";
        component.set("v.ndaUR",ndaLabel);
     }

})