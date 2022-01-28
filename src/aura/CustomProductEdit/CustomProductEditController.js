({
    doInit:  function(component, event, helper) 
    {
        helper.getQuoteType(component, event, helper);
        helper.callDoInt(component, event, helper);
    },
    
    recordLoaded : function(component, event, helper) {
        component.set("v.showSpinner", false);
    },
    
    LIrecordLoaded : function(component, event, helper) {
        component.set("v.showSpinner", false);
    },
    
    handleSubmit: function(component, event, helper) {
        component.set("v.has_error", false);
        //  var haserror = helper.Validation(component, event, helper);
        
        // if(! haserror)
        //   return ;
        helper.setLIValues(component, event, helper);
        console.log("helper return");
    },
    
    handleSuccess: function(component, event, helper) {
        console.log("handle suceess");
		
		 var cmpEvent = component.getEvent("ShowModalevt"); 
        component.set("v.showSpinner", false);
        component.set("v.showModal", false);
       
        var cmpEvent = component.getEvent("ShowModalevt"); 
        cmpEvent.setParams({ "ShowMessage" : true,"ShowParentModal" : true}); 
        cmpEvent.fire(); 
        
        //helper.createMaint(component, event, helper);
        
        
    },
    
    cancel: function(component, event, helper) {
        //alert(JSON.stringify('Click Event11'));
		//window.location.reload();
         var cmpEvent = component.getEvent("ShowModalevt"); 
        component.set("v.showSpinner", false);
        component.set("v.showModal", false);
       
        var cmpEvent = component.getEvent("ShowModalevt"); 
        cmpEvent.setParams({ "ShowMessage" : true,"ShowParentModal" : true}); 
        cmpEvent.fire(); 
        //location.reload();
    },
    
    onCheck: function(component, event) {
        var checkCmp = component.find("NFM").get("v.value");
        if(checkCmp == 2)
            component.set("v.isNetwork",true);
        else
            component.set("v.isNetwork",false);
       
        
    }
})