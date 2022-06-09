({
    
    doinit : function(component,event,helper){
     
     	var pageReference = component.get("v.pageReference");
        var param = pageReference.state.c__omsName;
        var param2= pageReference.state.c__disable;
        component.set("v.omsName",param);
        if(param!=null){
        
        component.set("v.updateEnable",true);
        component.set("v.createEnable",false);    
        component.set("v.disable",param2);
        var title = "Edit "+param;
        component.set("v.titleName",title);
        var action = component.get("c.getOMS");
        action.setParams({ "omName" : param });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(response.getState()==="SUCCESS")
            {
                var mappingRecord = component.get("v.mappingRecord");
                component.set("v.mappingRecord", response.getReturnValue());
            }

        });

        $A.enqueueAction(action);
    }
        else
        {
            component.set("v.updateEnable",false);
            component.set("v.createEnable",true); 
            var title = "Create Outbound Message Setting ";
            component.set("v.titleName",title);
            
        }
     
    },
	onCheck : function(component,event,helper){
        
        var mappingRecord = component.get("v.mappingRecord");
        var name = component.find("NameValue").get("v.value");
        mappingRecord.Name = name;
        var first = component.find("casefedEmailIR").get("v.value");
        mappingRecord.CaseFeedEmailInitialResponse__c = first;
        var second = component.find("casefeedEmailCAR").get("v.value");
        mappingRecord.CaseFeedEmailCauseAnalysisReport__c = second;
        var Third = component.find("casefedEmailCIR").get("v.value");
        mappingRecord.CaseFeedEmailCustomerInformationRequest__c = Third;
        var casefedEmailR = component.find("casefedEmailR").get("v.value");
        mappingRecord.CaseFeedEmailRestoration__c = casefedEmailR;
        var casefedEmailSDR = component.find("casefedEmailSDR").get("v.value");
        mappingRecord.CaseFeedEmailServiceDisruptionReport__c = casefedEmailSDR;
        var casefedEmailS = component.find("casefedEmailS").get("v.value");
        mappingRecord.CaseFeedEmailSolution__c = casefedEmailS;
        var casefedEmailT = component.find("casefedEmailT").get("v.value");
        mappingRecord.CaseFeedEmailTemporary__c = casefedEmailT;
        var casefedEmailU = component.find("casefedEmailU").get("v.value");
        mappingRecord.CaseFeedEmailUpdate__c = casefedEmailU;
        var caseStageAssetRespond = component.find("caseStageAssetRespond").get("v.value");
        mappingRecord.CaseStageAssetRespond__c = caseStageAssetRespond;
        var caseStageClose = component.find("caseStageClose").get("v.value");
        mappingRecord.CaseStageClose__c = caseStageClose;
        var caseStageDTA = component.find("caseStageDTA").get("v.value");
        mappingRecord.CaseStageDiagnosisTechnicalAnalysis__c = caseStageDTA;
        var caseStageIR = component.find("caseStageIR").get("v.value");
        mappingRecord.CaseStageInvestigateRestore__c = caseStageIR;
        var caseStageRegister = component.find("caseStageRegister").get("v.value");
        mappingRecord.CaseStageRegister__c = caseStageRegister;
        var caseStageResolve = component.find("caseStageResolve").get("v.value");
        mappingRecord.CaseStageResolve__c = caseStageResolve;
        var caseStageRoute = component.find("caseStageRoute").get("v.value");
        mappingRecord.CaseStageRoute__c = caseStageRoute;
        var caseStageCreate = component.find("caseStageCreate").get("v.value");
        mappingRecord.CaseCreation__c = caseStageCreate;
        cmp.set("v.mappingRecord", mappingRecord);
         
    },
    doCreate: function (component, event, helper) {
        try{
            var name = component.find("NameValue").get("v.value");
        }
		catch(err)
        {
            console.log('exception is '+err);
        }
        var first = component.find("casefedEmailIR").get("v.value");
        var second = component.find("casefeedEmailCAR").get("v.value");
       var Third = component.find("casefedEmailCIR").get("v.value");
        var caseCreate=component.find("caseStageCreate").get("v.value");
        var mappingRecord = component.get("v.mappingRecord");
        mappingRecord.Name = name;
        mappingRecord.CaseFeedEmailInitialResponse__c = first;
        mappingRecord.CaseFeedEmailCauseAnalysisReport__c = second;
        mappingRecord.CaseFeedEmailCustomerInformationRequest__c = Third;
        mappingRecord.CaseCreation__c = caseCreate;
        component.set("v.mappingRecord", mappingRecord);
   		var action = component.get("c.upsertOutBoundRecord");
        action.setParams({record : component.get("v.mappingRecord")});

        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.loading",true);
            if (state === "SUCCESS") 
            {
                if (response.getReturnValue() !== null && response.getReturnValue() === 'sucess') {
                          var toastEvent = $A.get("e.force:showToast");
    			toastEvent.setParams({
       				 "title": "Success!",
       					 "message": "The record has been Created successfully.",
                    duration:' 8000',
   					 });
    				toastEvent.fire(); 
                    var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            $A.get('e.force:refreshView').fire();
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
                    
                } else {
                    component.set("v.loading",false);
                   component.set("v.dupExist",true);
               
                    component.set('v.errorMessage',response.getReturnValue());
                    component.set('v.error',true);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                   
                    }
                } else {
                    
                }
            }
        });

        $A.enqueueAction(action);
       
    },
    closeTab : function(component, event, helper){
         
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
},
    doUpdate: function (component, event, helper) {
       
        var toastEvent = $A.get("e.force:showToast");
    			toastEvent.setParams({
       				 "title": "Success!",
       					 "message": "The record has been Updated successfully."
   					 });
    				toastEvent.fire();
        try{
            var name = component.find("NameValue").get("v.value");
        }
		catch(err)
        {
            console.log('exception is '+err);
        }
        var first = component.find("casefedEmailIR").get("v.value");
        var second = component.find("casefeedEmailCAR").get("v.value");
       var Third = component.find("casefedEmailCIR").get("v.value");
        var caseCreate=component.find("caseStageCreate").get("v.value");
        var mappingRecord = component.get("v.mappingRecord");
        mappingRecord.Name = name;
        mappingRecord.CaseFeedEmailInitialResponse__c = first;
        mappingRecord.CaseFeedEmailCauseAnalysisReport__c = second;
        mappingRecord.CaseFeedEmailCustomerInformationRequest__c = Third;
        mappingRecord.CaseCreation__c = caseCreate;
        component.set("v.mappingRecord", mappingRecord);
   var action = component.get("c.upsertOutBoundRecord");
        action.setParams({record : component.get("v.mappingRecord")});

        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.loading",false);
            if (state === "SUCCESS") {
                if (response.getReturnValue() !== null && response.getReturnValue() === 'sucess') {
            
                   
                    
                      var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            
            $A.get('e.force:refreshView').fire();
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
                   
                } else {
                   
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                      
                    }
                } else {
                    
                }
            }
        });

        $A.enqueueAction(action);
        
      
    },
    duplicateCheckOne : function(component,event,helper) {
      
        var name = component.find("NameValue").get("v.value");
     
		var action = component.get("c.isOMSPresent");
     
        action.setParams({"omName" : name});
      
        action.setCallback(this,function(response) {
         
     
            var state = response.getState();

            if (state === "SUCCESS") 
            {
           
                if ( response.getReturnValue()) 
                {
                    component.set("v.dupExist",true);

                }
                else
                {
					component.set("v.dupExist",false); 
                    component.set('v.error',false);
                }
            }
		});
        $A.enqueueAction(action);
                           }
    
})