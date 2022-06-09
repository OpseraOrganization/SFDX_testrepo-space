({
    doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.accessCheck");
        action.setParams({ caseId : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.edit",response.getReturnValue());
            }
        });
         $A.enqueueAction(action);
    },
	handleSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully.",
            "type": "success"
        });
        toastEvent.fire();
		component.set("v.errorlogo", false);
    },
    update : function(component,event,helper) {
        component.find("recordEditForm").submit();
        $A.get('e.force:refreshView').fire();
    },
	
	handleOnError : function(component, event, helper) {
        try{
            component.set("v.errorlogo", true);      
            var errors = event.getParams();
            var error= errors.output.errors;            
            var fieldError=[];
            var fieldErrors= errors.output.fieldErrors;
            var keyList=Object.keys(fieldErrors);
            keyList.forEach(function(item) {   
                var itemList= fieldErrors[item]; 
				fieldError.push(itemList);     
                
            });                                   
            var pageLevelErrors=[];
            var fieldLevelErrors=[];
            console.log('ERRORS#####::'+JSON.stringify(error));
            error.forEach(function(item) {
                if(!$A.util.isEmpty(item.message)){
                    pageLevelErrors.push(item);
                }
                if(!$A.util.isEmpty(item.fieldLabel)){
                    fieldLevelErrors.push(item);
                }
            });                    
            fieldError.forEach(function(item) {
                item.forEach(function(row) {                    
                    /* If we want Field Label Error Texts to be displayed in Popover
                 // Uncomment this section
                    if(!$A.util.isEmpty(row.message)){
                        pageLevelErrors.push(row);
                    }*/                    
                    //if((!$A.util.isEmpty(row.fieldLabel)) && row.fieldLabel.Outage<2)                      
                    if(!$A.util.isEmpty(row.fieldLabel) ){
                        if(fieldLevelErrors.length==0){
                            fieldLevelErrors.push(row);
                        }
                        else{
                           var rowDataIndex=fieldLevelErrors.map(function(e){ return e.fieldLabel; }).indexOf(row.fieldLabel);
                            if(rowDataIndex===-1){
                                fieldLevelErrors.push(row);
                            }  
                        }
                        
                        
                    }
                });  
            });  
            console.log('ERRORS::'+JSON.stringify(fieldLevelErrors));
            component.set("v.pageLevelErrors",pageLevelErrors);
            component.set("v.fieldLevelErrors",fieldLevelErrors);            
            component.set("v.closePopupBtn",false);
        } catch (e) {
            // Handle Exception error
            console.error(e);                    
        } 
        
    },
    /***  NOKIASC-31156 */
    onchangeSeverity : function(component,event,helper) {
       var sevValue = component.find("oSeverity").get("v.value");
        if(sevValue == "Minor"){
            component.find("oOutage").set("v.value", "No");
		}
		else if(sevValue == "Critical" || sevValue == "Major"){
			component.find("oOutage").set("v.value", "");
		}
    },
     /***  NOKIASC-31156 */
    closePopup : function(component, event, helper) {
        component.set("v.closePopupBtn",true);
    },
	openPopup : function(component, event, helper) {
        component.set("v.closePopupBtn",false);
        
      
    },
})