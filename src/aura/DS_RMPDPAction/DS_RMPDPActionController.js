({
    doInit : function(component, event, helper){  
        
     var actionstatusDetails = component.get("c.initialLoad"); 
        actionstatusDetails.setParams({
            "currentRecordId":component.get("v.recordId")
        });  
        
        actionstatusDetails.setCallback(this, function(response) {
        	if(response.getReturnValue()=== true ){
                component.set("v.showButtonValidate",true);
                
            }
            
            
        });
        $A.enqueueAction(actionstatusDetails);  
        
    },
    OpenComp : function(component, event, helper){
        
        var WaitMsg = component.find("divMessage");
                $A.util.addClass(WaitMsg,'slds-show');                            
                $A.util.removeClass(WaitMsg,'slds-hide'); 
    },
	
})