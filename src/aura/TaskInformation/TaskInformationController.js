({
    doInit:  function(component, event, helper) 
    { 
        var device = $A.get("$Browser.formFactor");
        if(device === "PHONE" || device === "TABLET")
        {            
            var mblView = component.find("mblModaldiv");
            $A.util.removeClass(mblView, "slds-hide");
            $A.util.addClass(mblView, "slds-show");
        }
        else{
            var mblView = component.find("mblModaldiv");
            $A.util.removeClass(mblView, "slds-show");
            $A.util.addClass(mblView, "slds-hide");
        }
        
        helper.getSubDetailsHelper(component,event, helper);
        helper.getPhaseValue(component,event, helper); 
    }, 
    
    cancelFunction : function(component, event, helper)
    {
        var recId = component.get("v.recordId");
        var navEvent = $A.get("e.force:navigateToSObject");  
        navEvent.setParams({
            "recordId": recId
        });
        navEvent.fire();     
    },
    onChange: function(component, event, helper)
    {
        //var dynamicCmp = component.find("taskCreatedAt").get("v.value");
        var evntsource = event.getSource();
        var picklistValue =evntsource.get("v.value");
        
        component.set("v.GateValue", picklistValue);
        
        var IdenntifiedValue = component.get("v.GateValue");
        if( IdenntifiedValue == undefined || IdenntifiedValue == '--none--')
        {
            component.set("v.dateValidationError" , true);
        }else    
            component.set("v.dateValidationError" , false);
        
    },
    
    saveFunction : function(component, event, helper) 
    { 
        var IdenntifiedValue = component.get("v.GateValue");
        var Working = true;
        
        if( IdenntifiedValue == undefined || IdenntifiedValue == '--none--')
        {
            var showToast;
            component.set("v.dateValidationError" , true);
            Working = false;
        }  
        
        var action1 = component.get("c.getAssignedToVal");      
        action1.setParams({
            assignVal: component.get("v.task.OwnerId"),
            myDate: component.get("v.task.ActivityDate")     
        });
        action1.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var resultUpdatedDoc = response.getReturnValue();
                var showToast;    
                if(resultUpdatedDoc == 1){
                    var recId = component.get("v.recordId");
                    showToast = $A.get('e.force:showToast');
                    //set the title and message params
                    showToast.setParams(
                        {
                            'message': 'Selected "Due date" cannot be of past date !',
                            'type' : 'warning'
                        }
                    );
                    showToast.fire();
                    //$A.get('e.force:refreshView').fire();                
                }
                else if(resultUpdatedDoc == 2){
                    var recordId = component.get("v.recordId");
                    showToast = $A.get('e.force:showToast');
                    //set the title and message params
                    showToast.setParams(
                        {
                            'message': '"Due date" format is incorrect !',
                            'type'   : 'warning'
                        }
                    );
                    showToast.fire();
                    //$A.get('e.force:refreshView').fire();
                }
                    else if(resultUpdatedDoc == 3){
                        var recordId = component.get("v.recordId");
                        showToast = $A.get('e.force:showToast');
                        //set the title and message params
                        showToast.setParams(
                            {
                                'message': '"Assigned To" cannot be left blank and "Selected date" cannot be a past date !',
                                'type'   : 'warning'
                            }
                        );
                        showToast.fire();
                        //$A.get('e.force:refreshView').fire();
                    }
                        else if(resultUpdatedDoc == 4){
                            var recId = component.get("v.recordId");
                            showToast = $A.get('e.force:showToast');
                            //set the title and message params
                            showToast.setParams(
                                {
                                    'message': '"Assigned To" cannot be left blank !',
                                    'type'   : 'warning'
                                }
                            );
                            showToast.fire();
                            //$A.get('e.force:refreshView').fire();
                        }
                            else if(resultUpdatedDoc == 5){
                                var recId = component.get("v.recordId");
                                showToast = $A.get('e.force:showToast');
                                //set the title and message params
                                showToast.setParams(
                                    {
                                        'message': '"Assigned To" and "Due date" cannot be left blank !',
                                        'type'   : 'warning'
                                    }
                                );
                                showToast.fire();
                                //$A.get('e.force:refreshView').fire();
                            }
                                else if(resultUpdatedDoc == 6){
                                    var recId = component.get("v.recordId");
                                    showToast = $A.get('e.force:showToast');
                                    //set the title and message params
                                    showToast.setParams(
                                        {
                                            'message': '"Due date" cannot be left blank !',
                                            'type'   : 'warning'
                                        }
                                    );
                                    showToast.fire();
                                    //$A.get('e.force:refreshView').fire();
                                } else{
                                    if(Working)
                                        helper.saveTaskInformation(component, event, helper); 
                                }             	
            }           
        });
        $A.enqueueAction(action1);  
    }
})