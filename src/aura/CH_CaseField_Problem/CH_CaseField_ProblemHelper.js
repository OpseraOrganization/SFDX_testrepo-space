({
    myAction : function(component,event,helper)
    {
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
	doInit : function(component,event,helper)
    {
       	var action = component.get("c.getCaseDetails");
        var caseId = component.get("v.recordId");
        action.setParams({"CaseId": caseId});
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var caseRecord = response.getReturnValue();
				component.set("v.record", caseRecord);
                //console.log('#caseRecord:' + caseRecord.CH_Problem__c);
				component.set("v.incidentHasProblem", caseRecord.CH_Problem__c != null);
                if(caseRecord.CH_Problem__c != null){
                    component.set("v.problemSubject", caseRecord.CH_Problem__r.Subject);
                }                
            }
            if (response.getState() == "ERROR") {
                helper.showToastMessage('Error', response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    postToProblem : function (component,event,helper){
    	
    	component.set("v.toggleSpinner", true);
    	var action = component.get("c.newPostToProblem");
        action.setParams({"caseId" : component.get('v.recordId')});
        action.setCallback(this, function(response) {
        		component.set("v.toggleSpinner", false);
            if (response.getState() == "SUCCESS") {
                //$A.get('e.force:refreshView').fire();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({title : 'Chatter Post Created', message: 'Your request has been sent successfully', type : 'Success', mode: 'dismissible'});
                toastEvent.fire();
            }
            if (response.getState() == "ERROR") {
                helper.showToastMessage('Error', response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    disassociateProblem : function (component,event,helper){
    	
    	component.set("v.toggleSpinner", true);
    	var action = component.get("c.disassociateNewProblem");
        action.setParams({"caseId" : component.get('v.recordId')});
        action.setCallback(this, function(response) {
        	
            if (response.getState() == "SUCCESS") {
                component.set("v.theProblem.Subject", ""); // problemSubject
                component.set("v.incidentHasProblem", false);
                //component.find("CH_Problem__c").set("v.value", "");
                component.set("v.toggleSpinner", true);
                //component.set("v.toggleSpinner", false);
                $A.get('e.force:refreshView').fire();
                $A.get('e.force:refreshView').fire();
            }
            if (response.getState() == "ERROR") {
            	component.set("v.toggleSpinner", false);
                helper.showToastMessage('Error', response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    
    },
    
    createProblem : function (component,event,helper){
    	var action = component.get("c.checkpausedSinceDate");
        action.setParams({ getCaseId : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.pasedSinceDate", response.getReturnValue());
                var creationIsValid = true, record = component.get('v.record');
                //Changes added as a part of NOKIASC-35322
                var action = component.get("c.checkSolutionTargetDate");
                action.setParams({"caseId" : component.get('v.recordId')});
                action.setCallback(this, function(response) {
                    if (response.getState() == "SUCCESS") {
                        var getSolutionTargetDate=response.getReturnValue();
                        $A.createComponent(
                            "c:CH_CreateProblemFlow",
                            {
                                "problemId": component.get("v.recordId"),
                                "headerMessage": "Create Problem",
                                "solutionTargetDate":getSolutionTargetDate,
                                "pausedSinceDate":component.get('v.pasedSinceDate')
                            },
                            function(msgBox){                
                                if (component.isValid()) {
                                    var cmp = component.find('createproblemmodal');
                                    var body = cmp.get("v.body");
                                    body.push(msgBox);
                                    cmp.set("v.body", body); 
                                }
                            }
                        );
                        $A.get('e.force:refreshView').fire();
                    }
                    if (response.getState() == "ERROR") {
                        component.set("v.toggleSpinner", false);
                        helper.showToastMessage('Error', response.getError()[0].message);
                    }
                });
                $A.enqueueAction(action);
            }
            if (response.getState() == "ERROR") {
                component.set("v.toggleSpinner", false);
                helper.showToastMessage('Error', response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
        
       /* if(!component.get('v.theProblem.Subject')){
            helper.showToastMessage('Error','Problem subject is required');
            creationIsValid = false;
        }
        if(!component.find('CH_ProblemCreationReason__c').get('v.value')){
            helper.showToastMessage('Error','Problem Creation Reason is required');
            creationIsValid = false;
        }
        if(!component.find('CH_IssueDescription__c').get('v.value')){
            helper.showToastMessage('Error','Issue Description is required');
            creationIsValid = false;
        }
                
        if(!record.ProductId){
            helper.showToastMessage('Error','Product is required');
            creationIsValid = false;
        }
        
    	if(creationIsValid){
    		component.set("v.toggleSpinner", true);
    		component.set('v.theProblem.CH_IssueDescription__c', component.find('CH_IssueDescription__c').get('v.value'));
	        component.set('v.theProblem.CH_CustomerDescription__c', component.find('CH_IssueDescription__c').get('v.value'));
	        component.set('v.theProblem.CH_Defect__c', component.find('CH_Defect__c').get('v.value'));
	        component.set('v.theProblem.CH_ProblemCreationReason__c', component.find('CH_ProblemCreationReason__c').get('v.value'));
	        component.set('v.theProblem.ProductId', record.ProductId);
	        component.set('v.theProblem.CH_Product_Release__c', record.CH_Product_Release__c);
	        component.set('v.theProblem.CH_Product_Module__c', record.CH_Product_Module__c);
	        component.set('v.theProblem.CH_ProductVariant__c', record.CH_ProductVariant__c);
	        component.set('v.theProblem.CH_Solution__c', record.CH_Solution__c);
	        component.set('v.theProblem.CH_SW_Release__c', record.CH_SW_Release__c);
	        component.set('v.theProblem.CH_SW_Module__c', record.CH_SW_Module__c);
	        component.set('v.theProblem.CH_SW_Build__c', record.CH_SW_Build__c);
	        component.set('v.theProblem.CH_SW_Component__c', record.CH_SW_Component__c);
	        component.set('v.theProblem.CH_HW_Component__c', record.CH_HW_Component__c);
	       
	        var action = component.get("c.createNewProblem");
	        action.setParams({"problemRecord": component.get('v.theProblem'),
	                          "incidentId" : component.get('v.recordId')});
	        action.setCallback(this, function(response) {
	            if (response.getState() == "SUCCESS") {
	                var caseRecord = response.getReturnValue();
	                component.set("v.incidentHasProblem", true);
	                component.set("v.problemSubject", caseRecord.Subject);
	                $A.get('e.force:refreshView').fire();
	                component.set("v.toggleSpinner", true);
	            }
	            if (response.getState() == "ERROR") {
	            	component.set("v.toggleSpinner", false);
                    helper.showToastMessage('Error', response.getError()[0].message);
	            }
	        });
	        $A.enqueueAction(action);
	        
    	}else{
            
            //helper.showToastMessage('Error', errorCreationMessage);
            
    	}*/
    
    },
    
    showToastMessage: function(messageType, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : messageType,
            "mode" : 'sticky',
            "title" : messageType,
            "message" : message
        });
        toastEvent.fire();
    },
    
    
})