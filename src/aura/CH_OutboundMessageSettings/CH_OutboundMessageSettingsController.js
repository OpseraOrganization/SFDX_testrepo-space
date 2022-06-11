({
	fetchAcc : function(component, event, helper) {
        
        helper.accessCheck(component,event,helper);
        
           var actions =  [{ label: 'View', name: 'show_details' },
            { label: 'Delete', name: 'delete' },
            { label: 'Edit', name: 'edit' }];
       

        component.set('v.columns', [
            { label: 'Name', fieldName: 'Name', type: 'text' },
            { label: 'Case Feed Email Cause Analysis Report', fieldName: 'CaseFeedEmailCauseAnalysisReport__c', type: 'boolean'},
              { label: 'Case FeedEmailCustomerInformationRequest', fieldName: 'CaseFeedEmailCustomerInformationRequest__c', type: 'boolean'},
              { label: 'Case Feed Email Initial Response', fieldName: 'CaseFeedEmailInitialResponse__c', type: 'boolean'},
              { label: 'Case Feed Email Restoration', fieldName: 'CaseFeedEmailRestoration__c', type: 'boolean'},
              { label: 'Case Feed Email Service DisruptionReport', fieldName: 'CaseFeedEmailServiceDisruptionReport__c', type: 'boolean'},
              { label: 'Case Feed Email Solution', fieldName: 'CaseFeedEmailSolution__c', type: 'boolean'},
              { label: 'Case Feed Email Temporary', fieldName: 'CaseFeedEmailTemporary__c', type: 'boolean'},
              { label: 'Case Feed Email Update', fieldName: 'CaseFeedEmailUpdate__c', type: 'boolean'},
              { label: 'Case Stage Asset and Respond', fieldName: 'CaseStageAssetRespond__c', type: 'boolean'},
              { label: 'Case Stage Close', fieldName: 'CaseStageClose__c', type: 'boolean'},
              { label: 'Case Stage Diagnosis and Tech Analysis', fieldName: 'CaseStageDiagnosisTechnicalAnalysis__c', type: 'boolean'},
              { label: 'Case Stage Investigate and Restore', fieldName: 'CaseStageInvestigateRestore__c', type: 'boolean'},
              { label: 'Case Stage Register', fieldName: 'CaseStageRegister__c', type: 'boolean'},
              { label: 'Case Stage Resolve', fieldName: 'CaseStageResolve__c', type: 'boolean'},
            { label: 'Case Stage Route', fieldName: 'CaseStageRoute__c', type: 'boolean'},
            { label: 'Case Creation', fieldName: 'CaseCreation__c', type: 'boolean'},
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);

        helper.fetchData(component, event, helper);
		console.log('in controller');
	},
    handleRowAction : function(component, event, helper) {
		 var action = event.getParam('action');
        var row = event.getParam('row');
        var nameOfRow = row.Name;
        component.set('v.rowToBeDeleted',nameOfRow);
        var idOfRow = row.Id;
        var casefeedEmailCAR = row.CaseFeedEmailCauseAnalysisReport__c;
        var casefedEmailCIR= row.CaseFeedEmailCustomerInformationRequest__c ;
        var casefedEmailIR = row.CaseFeedEmailInitialResponse__c ;
        var casefedEmailR = row.CaseFeedEmailRestoration__c ;
        var casefedEmailSDR = row.CaseFeedEmailServiceDisruptionReport__c ;
        var casefedEmailS = row.CaseFeedEmailSolution__c ;
        var casefedEmailT = row.CaseFeedEmailTemporary__c ;
        var casefedEmailU = row.CaseFeedEmailUpdate__c ;
        var caseStageAssetRespond = row.CaseStageAssetRespond__c ;
        var caseStageClose = row.CaseStageClose__c ;
        var caseStageDTA = row.CaseStageDiagnosisTechnicalAnalysis__c ;
        var caseStageIR = row.CaseStageInvestigateRestore__c ;
        var caseStageRegister = row.CaseStageRegister__c ;
        var caseStageResolve = row.CaseStageResolve__c ;
        var caseStageRoute  = row.CaseStageRoute__c ;
        var caseStageCreate=row.CaseCreation__c;
        switch (action.name) {
            case 'show_details':
                component.set('v.IdValue',idOfRow);
                component.set('v.omsName',nameOfRow);
                component.set('v.casefedEmailCAR',casefeedEmailCAR);
                component.set('v.casefedEmailCIR',casefedEmailCIR);
                component.set('v.casefedEmailIR',casefedEmailIR);
                component.set('v.casefedEmailR',casefedEmailR);
                component.set('v.casefedEmailSDR',casefedEmailSDR);
                component.set('v.casefedEmailS',casefedEmailS);
                component.set('v.casefedEmailT',casefedEmailT);
                component.set('v.casefedEmailU',casefedEmailU);
                component.set('v.caseStageAssetRespond',caseStageAssetRespond);
                component.set('v.caseStageClose',caseStageClose);
                component.set('v.caseStageDTA',caseStageDTA);
                component.set('v.caseStageIR',caseStageIR);
                component.set('v.caseStageRegister',caseStageRegister);
                component.set('v.caseStageResolve',caseStageResolve);
                component.set('v.caseStageRoute',caseStageRoute);
                component.set('v.caseStageCreate',caseStageCreate);
                component.set('v.isOpen',true);
                break;
            case 'delete':
                helper.handleConfirmDialog(component, event, helper);
                
                break;
            case 'edit':
                
                var workspaceAPI = component.find("workspace");
                workspaceAPI.getFocusedTabInfo().then(function(response) {
                   
            
           	workspaceAPI.getEnclosingTabId().then(function(tabId) {
              
            return workspaceAPI.openTab({
                
                parentTabId: tabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__CH_OutboundMessageCreate"
                    },
                    "state": {
                        "c__omsName": nameOfRow,
                        "c__disable" : true
                        }
                },
                focus: true
            });
        })
        .then(function(response) {
            var focusedTabId = response;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Edit "+nameOfRow
            });
        })
        .catch(function(error) {
            console.log('Error logged for CH_OutboundMessageSetting'+error);
        });
			   
        })

        }      
       
	},
    pageSwitcher : function(component, event, helper) {
		component.set('v.isEditPage',true);
                component.set('v.isDetailPage',false);
        component.set('v.mappingRecord.Id',null);
        component.set('v.mappingRecord.Name',"");
        component.set('v.mappingRecord.CaseFeedEmailCauseAnalysisReport__c',false);
        component.set('v.mappingRecord.CaseFeedEmailCustomerInformationRequest__c',false) ;
        component.set('v.mappingRecord.CaseFeedEmailInitialResponse__c',false) ;
        component.set('v.mappingRecord.CaseFeedEmailRestoration__c',false);
        component.set('v.mappingRecord.CaseFeedEmailServiceDisruptionReport__c',false) ;
        component.set('v.mappingRecord.CaseFeedEmailSolution__c',false) ;
        component.set('v.mappingRecord.CaseFeedEmailTemporary__c',false) ;
        component.set('v.mappingRecord.CaseFeedEmailUpdate__c',false) ;
        component.set('v.mappingRecord.CaseStageAssetRespond__c',false) ;
        component.set('v.mappingRecord.CaseStageClose__c',false) ;
        component.set('v.mappingRecord.CaseStageDiagnosisTechnicalAnalysis__c',false) ;
        component.set('v.mappingRecord.CaseStageInvestigateRestore__c',false) ;
        component.set('v.mappingRecord.CaseStageRegister__c',false) ;
        component.set('v.mappingRecord.CaseStageResolve__c',false) ;
        component.set('v.mappingRecord.CaseStageRoute__c',false) ;
        component.set('v.mappingRecord.CaseCreation__c',false);
	},
    closeModel : function(component,event,helper)
    {
        component.set('v.isOpen',false);
    },
    likenClose  : function(component,event,helper)
    {
        component.set('v.isOpen',false);
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
        cmp.set("v.mappingRecord", mappingRecord);
        
    },
    editPage: function (component, event, helper) {
        var name= event.getParam("editRecord");
        var action = component.get("c.getOMS");
        action.setParams({ "omName" : name });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(response.getState()==="SUCCESS")
            {
                var mappingRecord = component.get("v.mappingRecord");
                component.set("v.mappingRecord", response.getReturnValue());
            }

        });

        $A.enqueueAction(action);
    },
    doCreate : function (component, event, helper) {
              var workspaceAPI = component.find("workspace");
                workspaceAPI.getFocusedTabInfo().then(function(response) {
           	workspaceAPI.getEnclosingTabId().then(function(tabId) {
               
            return workspaceAPI.openTab({
                
                parentTabId: tabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__CH_OutboundMessageCreate"
                    },
                    "state": {
                        "c__omsName": null,
                        "c__disable" : true
                        }
                },
                focus: true
            });
        })
        .then(function(response) {
            var focusedTabId = response;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Create Outbound Message Setting"
            });
        })
        .catch(function(error) {
            console.log('Error logged for CH_OutboundMessageSetting'+error);
        });
			   
        })
        
        
    },
    doUpdate: function (component, event, helper) {
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
        var mappingRecord = component.get("v.mappingRecord");
        mappingRecord.Name = name;
        mappingRecord.CaseFeedEmailInitialResponse__c = first;
        mappingRecord.CaseFeedEmailCauseAnalysisReport__c = second;
        mappingRecord.CaseFeedEmailCustomerInformationRequest__c = Third;
        component.set("v.mappingRecord", mappingRecord);
   var action = component.get("c.upsertOutBoundRecord");
        action.setParams({record : component.get("v.mappingRecord")});

        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.loading",false);
            if (state === "SUCCESS") {
                if (response.getReturnValue() !== null && response.getReturnValue() === 'sucess') {
                    // fire table refresh event
					  helper.showSuccess(component);
                    $A.get('e.force:refreshView').fire();
                    
                } else {
                    helper.showError(component, response.getReturnValue());
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showError(component, errors[0].message);
                    }
                } else {
                    helper.showError(component, "Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
    },
    handleConfirmDialogNo : function (component, event, helper) {
        component.set('v.showConfirmDialog', false);
    },
    handleConfirmDialogYes : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
        console.log('access value'+component.get("v.accessExist"));
        if(component.get("v.accessExist")==='SYSADMIN' )
        {
                var namedRow=component.get('v.rowToBeDeleted');
        		helper.deleteSetting(component, namedRow);
           
        }
       else
       {
        
            var toastEvent = $A.get("e.force:showToast");
    			toastEvent.setParams({
       				 "title": "Error",
       					 "message": "Insufficient Access, only Admin can delete the entry.",
                    "type":"error"
   					 });
    				toastEvent.fire();
       }
  
    }
   
})