({
    doInit : function(component, event, helper) {
        //component.set("v.Spinner", false);
        var recordId = component.get("v.recordId");
        var action = component.get("c.accessCheck");
        action.setParams({ caseId : recordId });
        action.setCallback(this, function(response) {
            $A.util.toggleClass(component.find('spinner'),'slds-hide');
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.edit",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        helper.createArticleButton(component);
        
        
    },
        handleOnLoad : function(component, event, helper) {        
        var handleOnChange = component.get('c.handleOnChange');
        $A.enqueueAction(handleOnChange);       
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
        component.set("v.errorlogo", false); // Close the PopOver on save success-NOKIASC-23322
    },
    handleOnChange:function(component,event,helper) {        
        let btnDisable=false;
        let arrayOfField=["ReportedBy","Discoveredin","DiscoveredDuring","Repeatability","ProblemCategory",
                          "ProblemType","Problems","Severity","Urgency","Priority","ps",
                          "StepstoReproduceIssue","CauseoftheIncident","ListofContributingCauses",
                          "SummaryofAnalysis","Root_Cause_Description","ValidationofRootCause","Caused_By",
                          "Cause_Type","Root_Cause","ActionTaken","PreventiveActions","CorrectiveActions"];
        for (let i=0;i<arrayOfField.length;i++){
            let fieldValue= component.find(arrayOfField[i]).get("v.value");            
            if ($A.util.isEmpty(fieldValue)){ 
                if ((component.find("ReportedBy").get("v.value")=="Supplier" ||component.find("ReportedBy").get("v.value")=="External" )
                    && (arrayOfField[i]=="Discoveredin"||arrayOfField[i]=="DiscoveredDuring")){                     
                    continue;
                }
                else
                {
                    btnDisable=true;
                    break;  
                }
            }                         
        }
	
        component.set("v.disableBtnShareUpdate",btnDisable);        
    },
    update : function(component,event,helper) {
        /*NOKIASC-38624*/
        var probCategory = component.find("ProblemCategory").get("v.value");
        if(probCategory == 'Product Defect'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
            title : 'Warning',
            message: 'Complete/Check the Product Information',
            duration:'5000',
            key: 'info_alt',
            type: 'warning',
        });
        	toastEvent.fire();
        }/*NOKIASC-38624*/
        component.find("recordEditForm").submit();
       /* $A.get('e.force:refreshView').fire();*/
    },
    launchOutageStatusUpdate : function (component,event,helper) {
        component.set("v.flowFinished",true);
        var flow = component.find("flowData");
        var inputVariables = [
            { name : "recordId", type : "String", value: component.get("v.recordId") }
        ];
        flow.startFlow("CH_Update_RCA_Provided",inputVariables);
        let button = component.find('disablebuttonid');
        button.set('v.disabled',true);
    },
    cancelProblem : function (component,event,helper) {
        
        component.set("v.createProblemFinished",true);
        component.set("v.closeProblem", false);
        var flow = component.find("createProblemFinished");
        var inputVariables = [
            { name : "recordId", type : "String", value: component.get("v.recordId") }
        ];
        flow.startFlow("CH_CancelProblemAndNotifyIncidents",inputVariables);
    },
    createKnownError : function (component,event,helper) {
		component.set("v.disableButtonCreateArt",true);
        component.set("v.createKnownErrorFinished",true);
        component.set("v.closeProblem", false);
        var flow = component.find("createKnownError");
        var inputVariables = [
            { name : "recordId", type : "String", value: component.get("v.recordId") }
        ];
        flow.startFlow("Create_Article_from_Case",inputVariables);
		$A.get('e.force:refreshView').fire();
    },
    handleCreateKnownErrorChange : function (component,event,helper) {
        if(event.getParam("status") === "FINISHED") {
            component.set("v.createKnownErrorFinished",false);
        }
    },        
    handleStatusChange : function (component,event,helper) {
        if(event.getParam("status") === "FINISHED") {
            component.set("v.flowFinished",false);
            let button = component.find('disablebuttonid');
            button.set('v.disabled',false);
			$A.get('e.force:refreshView').fire();
			//NOKIASC-36708 Changes
            $A.get("e.force:showToast")
            .setParams({duration: 5000,message: 'Please update the Status Reason as it has been automatically cleared.',type : 'success'})
            .fire();
        }
    },
    handleCreateProblemFinished : function (component,event,helper) {
        if(event.getParam("status") === "FINISHED") {
            component.set("v.createProblemFinished",false);
        }
    },
    handleShowActiveSectionName: function (component, event, helper) {
        alert(component.find("accordion").get('v.activeSectionName'));
    },
    handleSetActiveSectionA: function (component) {
        if(component.find("accordion").get('v.activeSectionName') !='B'){
            component.find("accordion").set('v.activeSectionName', 'B');
        }else{
            component.find("accordion").set('v.activeSectionName', 'A');
        }
    },
    handleSetActiveSection: function (component) {
        alert(component.get('v.openSection') );
        if(component.get("v.openSection") =='A'){
            component.set("v.openSection","B");
            component.find("accordion").set('v.activeSectionName', 'B');
        }else{
            component.set("v.openSection","A");
            component.find("accordion").set('v.activeSectionName', 'A');
        }
        
    },
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');
    },
    closeProblem : function( cmp, event, helper ) {
        var actionAPI = cmp.find("quickActionAPI");
        alert(cmp.get("v.recordId"));
        var fields = {CH_Closure_Reason__c: {value:"Solution Provided" }
                     };
        var args = {actionName: "Case.CH_Close_Problem_COE"};
        actionAPI.selectAction(args).then(function(){
            alert("test");
            
            //    actionAPI.invokeAction(args);
        }).catch(function(e){
            alert("test"+e.errors);
            console.log('Er'+actionAPI.getAvailableActions());
            console.error(e.errors);
        });
    },
    resetProblem: function (component, event) {
        $A.get('e.force:refreshView').fire();
    },
    refreshPage: function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
        
        
/*
 * https://jiradc2.int.net.nokia.com/browse/NOKIASC-24360
 As per this defect business doesn't want the page to be refreshed while editing any 
 record in detail page.  Hence, commenting the  location.reload();  
 */
    },
    
    refreshFocusedTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            alert(focusedTabId);
            workspaceAPI.refreshTab({
                tabId: focusedTabId,
                includeAllSubtabs: true
            });
        })
        .catch(function(error) {
            alert('error'+error);
            console.log(error);
        });
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
    // When button clicked display the workgroup instructions
    handleWorkgroupInstructions : function(component,event,helper){
        component.set("v.Spinner", true); 
        var recordId = component.get("v.recordId");
        var assignFunction = component.get("c.displayWorkgroupInstructions");
        assignFunction.setParams({
            fieldId : recordId
        });
        assignFunction.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.Spinner", false);
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'An Error Occured',
                    message: errorMessage,
                    type : 'Error',
                    mode: 'sticky'
                });
                toastEvent.fire();                
            }
        });
        $A.enqueueAction(assignFunction);
    },
    // This function will handle the all the Errors -NOKIASC-23322
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
    // This function will close the PopOver -NOKIASC-23322
    closePopup : function(component, event, helper) {
        component.set("v.closePopupBtn",true);
       
    },
     // This function will Open the PopOver -NOKIASC-23322
    openPopup : function(component, event, helper) {
        component.set("v.closePopupBtn",false);
      
    },
	// This function will close the Popup- Nokiasc-31282
	closeArticlepopup: function (component, event, helper) {
        component.set("v.createKnownErrorFinished", false);
        $A.get('e.force:refreshView').fire();
    }
    
})