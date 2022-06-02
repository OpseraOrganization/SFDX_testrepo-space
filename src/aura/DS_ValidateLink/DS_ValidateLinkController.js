({
    moveTab : function(component, event, helper){
        
        var urlEvent = $A.get("e.force:navigateToURL");
        var link = window.location.pathname;
    	urlEvent.setParams({
      	"url": link+$A.get("$Label.c.DS_ValidateTabSetID"),
    	});
    urlEvent.fire();
       
    },
})