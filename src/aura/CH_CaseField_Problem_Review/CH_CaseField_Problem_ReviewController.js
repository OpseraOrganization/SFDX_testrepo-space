({
    doInit : function(component, event, helper) {
        helper.generateshareval(component);
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
        helper.createArticleButton(component);

        var actionTransferRndShowButton = component.get("c.transferRndAccessCheck");
        actionTransferRndShowButton.setParams({ caseId : recordId });
        actionTransferRndShowButton.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.transferRndShowButton",response.getReturnValue().length > 0);
                component.set("v.interfaceType",response.getReturnValue().toLowerCase());
            }
        });
        $A.enqueueAction(actionTransferRndShowButton);
       
    },
	        handleOnLoad : function(component, event, helper) {        
               
        $A.get('e.force:refreshView').fire();
       
    },
    
    handleSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully.",
            "type": "success"
        });
        toastEvent.fire();
        component.set("v.errorlogo", false); // Close the PopOver on save success-NOKIASC-23324
        //NOKIASC-26534
        var recordId = component.get("v.recordId");
        var action = component.get("c.disableSharebutton");
        action.setParams({ caseId : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("statuscheck",state);
            if (state === "SUCCESS") {
                var statusCheck = response.getReturnValue(); 
                console.log("statuscheckvalue",statusCheck);
                if(statusCheck == true)
                {
                    let button = component.find('disablebuttonidwrite');
                   button.set('v.disabled',true);
                      //component.set('v.disableShareUpdate',true);
                }
                else
                {
                    let button = component.find('disablebuttonidwrite');
                  button.set('v.disabled',false);
                        
                   //component.set('v.disableShareUpdate',false);
                }
            }
        });
        $A.enqueueAction(action);
        
        
        
        $A.get('e.force:refreshView').fire();
    },
    update : function(component,event,helper) {
        component.find("recordEditForm").submit();
        
        $A.get('e.force:refreshView').fire();
    },
    shareTemporarySolution : function (component,event,helper) {
        component.set("v.shareTemporarySolutionFinished",true);
        var flow = component.find("shareTemporarySolution");
        var inputVariables = [
            { name : "recordId", type : "String", value: component.get("v.recordId") }
        ];
        flow.startFlow("CH_ProvideTemporarySolution",inputVariables);
    },
    shareSolution : function (component,event,helper) {
        component.set("v.shareSolutionFinished",true);
        var flow = component.find("shareSolution");
        var inputVariables = [
            { name : "recordId", type : "String", value: component.get("v.recordId") }
        ];
        flow.startFlow("CH_PopulateSolutionFromProblem",inputVariables);
    },
    withdrawTemporarySolution : function (component,event,helper) {
        component.set("v.withdrawTemporarySolutionFinished",true);
        var flow = component.find("withdrawTemporarySolution");
        var inputVariables = [
            { name : "recordId", type : "String", value: component.get("v.recordId") }
        ];
        flow.startFlow("CH_WithdrawTemporarySolution",inputVariables);
    },
    transferToRnd : function (component,event,helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.transferRndRequiredFieldsCheck");
        action.setParams({ caseId : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()) {
                    $A.createComponent(
                        "c:CH_TransferRndInteraction",
                        {
                            "interfaceType": component.get("v.interfaceType").toLowerCase(),
                            "problemId": component.get("v.recordId"),
                            "headerMessage": "Transfer to R&D"
                        },
                        function(msgBox){                
                            if (component.isValid()) {
                                var cmp = component.find('transferRndModal');
                                var body = cmp.get("v.body");
                                body.push(msgBox);
                                cmp.set("v.body", body); 
                                msgBox.setDefaultOutboundRndInteractionProperties();
                            }
                        }
                    );
                } else {
                    $A.createComponent(
                        "c:CH_TransferRndInteraction",
                        {
                            "showValidationError": "true",
                            "headerMessage": "Transfer to R&D"
                        },
                        function(msgBox){                
                            if (component.isValid()) {
                                var cmp = component.find('transferRndModal');
                                var body = cmp.get("v.body");
                                body.push(msgBox);
                                cmp.set("v.body", body); 
                            }
                        }
                    );
                }
            }
        });
        $A.enqueueAction(action);
    },
    closeTransferToRnd : function (component,event,helper) {
        $A.util.removeClass(component.find("transferRndModal"), "slds-fade-in-open");
        $A.util.removeClass(component.find("transferRndModalBack"), "slds-fade-in-open");
    },
    createKnownError : function (component,event,helper) {
		component.set("v.disableButtonCreateArt",true);
        component.set("v.createKnownErrorFinished",true);
        component.set("v.createArticleFinish", true);
        var flow = component.find("createKnownError");
        var inputVariables = [
            { name : "recordId", type : "String", value: component.get("v.recordId") }
        ];
        flow.startFlow("Create_Article_from_Case",inputVariables);
		$A.get('e.force:refreshView').fire();
    },
    cancelProblem : function (component,event,helper) {
        component.set("v.createProblemFinished",true);
        var flow = component.find("createProblemFinished");
        var inputVariables = [
            { name : "recordId", type : "String", value: component.get("v.recordId") }
        ];
        flow.startFlow("CH_CancelProblemAndNotifyIncidents",inputVariables);
    },
    handleShareTemporarySolutionChange : function (component,event,helper) {
        if(event.getParam("status") === "FINISHED") {
            component.set("v.shareTemporarySolutionFinished",false);
			//NOKIASC-36708 Changes
           	$A.get('e.force:refreshView').fire();
            $A.get("e.force:showToast")
            .setParams({duration: 5000,message: 'Please update the Status Reason as it has been automatically cleared.',type : 'success'})
            .fire();
        }
    },
    handleShareSolutionChange : function (component,event,helper) {
        if(event.getParam("status") === "FINISHED") {
            component.set("v.shareSolutionFinished",false);
        }
    },
    handleWithdrawTemporarySolutionChange : function (component,event,helper) {
        if(event.getParam("status") === "FINISHED") {
            component.set("v.withdrawTemporarySolutionFinished",false);
        }
    },
    handleCreateProblemFinished : function (component,event,helper) {
        if(event.getParam("status") === "FINISHED") {
            //component.set("v.Spinner", true);
            component.set("v.createProblemFinished",false);
            // $A.get('e.force:refreshView').fire();
           //window.setTimeout(function(){component.set("v.Spinner", false)}, 4000);
        }
    },
    handleCreateKnownErrorChange : function (component,event,helper) {
       if(event.getParam("status") === "FINISHED") {
            component.set("v.createKnownErrorFinished",false);
            component.set("v.Spinner", true);
           
            component.set("v.createArticleFinish", false);
             component.set("v.Spinner", false);
            $A.get("e.force:refreshView").fire();
        }
    },
     handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');
    },
    openTab: function(component, event, helper) {
        component.set("v.closeProblem", true);
    },
    saveCloseProblem: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var cReason = component.find("cReason").get("v.value");
        if(cReason !=null && cReason !=''){
            $A.util.removeClass(component.find('cReason'),'slds-has-error');
        var action = component.get("c.closeProblemRecord");
        action.setParams({ recordId : recordId,
                          closureReason:cReason  });
        action.setCallback(this, function(response) {
            var state = response.getState();
                if (state === "SUCCESS") {
                component.set("v.closeProblem",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record has been closed successfully.",
                    "type": "success"
                });
                toastEvent.fire();
                 $A.get('e.force:refreshView').fire();
               
            }
            else {
                var errors = response.getError();  
                var toastEvent = $A.get("e.force:showToast");
                var errorMessage;
                if (errors) {
                        if (errors[0] && errors[0].message) {
                            // System error
                            errorMessage = errors[0].message;
                        }
                        else if (errors[0] && errors[0].pageErrors) {
                            // DML Error
                            errorMessage = errors[0].pageErrors[0].message;
                        }
                    }
                toastEvent.setParams({
                    "title": "Error!",
                    "message": errorMessage,
                    "type": "error",
                    "duration":"7000"
                });
                toastEvent.fire();
                
            }
        });
        $A.enqueueAction(action);
        }
        else{
             $A.util.addClass(component.find('cReason'),'slds-has-error');
        }
    },
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    },
    // This function will handle the all the Errors -NOKIASC-23324
    handleOnError : function(component, event, helper) {
        try{
            component.set("v.errorlogo", true);      
            var errors = event.getParams();
            var error= errors.output.errors;            
            var fieldError=[];
            var fieldErrors= errors.output.fieldErrors;
            var keyList=Object.keys(fieldErrors);
            keyList.forEach(function(item) {   
                var itemList=fieldErrors[item]; 
                fieldError.push(itemList);     
                
            });             
            var pageLevelErrors=[];
            var fieldLevelErrors=[];
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
                 * Uncomment this section
                    if(!$A.util.isEmpty(row.message)){
                        pageLevelErrors.push(row);
                    }
                */
                    if(!$A.util.isEmpty(row.fieldLabel)){
                        fieldLevelErrors.push(row);
                    }
                });  
            });  
            component.set("v.pageLevelErrors",pageLevelErrors);
            component.set("v.fieldLevelErrors",fieldLevelErrors);            
            component.set("v.closePopupBtn",false);
        } catch (e) {
            // Handle Exception error
            console.error(e);                    
        } 
        
    },
    // This function will close the PopOver -NOKIASC-23324
    closePopup : function(component, event, helper) {
        component.set("v.closePopupBtn",true);
       
    },
     // This function will Open the PopOver -NOKIASC-23324
    openPopup : function(component, event, helper) {
        component.set("v.closePopupBtn",false);
      
    },
    closeArticlepopup: function (component, event, helper) {
        component.set("v.createArticleFinish", false);
        $A.get('e.force:refreshView').fire();
    }
})