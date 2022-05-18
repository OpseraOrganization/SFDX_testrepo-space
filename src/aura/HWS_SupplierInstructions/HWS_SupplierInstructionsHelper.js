({
    //Helper Init method
    init: function (component,event,helper,parentCaseUpdateCheck) { 
        var parentCaseUpdateRequired=true;        
        component.set("v.selection",[]); 
        component.set("v.selectionReferral", []);
        component.set("v.isSpinner", true);
        this.setReferralInstructionsTable(component,event,helper);
        this.setEscalationInstructionsTable(component,event,helper);        
        this.getReferralInstructions(component,event,helper).then(function(result){
            var referralList=[];
            var escalationList=[];    
            component.set("v.referralInstructionsList", result);
            for(var i = 0; i < result.length; i++) {
                if (typeof(result[i].Subject) != 'undefined') {
                    result[i].SubjectUrl = helper.getChildCaseURL(result[i].Id);                    
                }
                if (typeof(result[i].CH_InternalStatus__c) != 'undefined') {
                    if (result[i].CH_InternalStatus__c=='Pending Referral Instruction'){
                        result[i].actionLabel='Complete';
                        result[i].actionName='Complete';
                        result[i].actionTitle='Complete';
                        result[i].actionDisabled=false;
                        parentCaseUpdateRequired=false;
                    }
                    else if (result[i].CH_InternalStatus__c=='Completed Referral Instruction'){                        
                        result[i].actionLabel='Completed';
                        result[i].actionName='Completed';
                        result[i].actionTitle='Completed';
                        result[i].actionDisabled=true; 
                    }
                    referralList.push(result[i]);
                }
                
                
            }
            component.set("v.referralList", referralList);
            component.set("v.escalationList", result);
            component.set("v.isSpinner", false);
            if (parentCaseUpdateCheck && parentCaseUpdateRequired){
                component.set("v.isSpinner", true);
                helper.updateParentCase(component,event,helper).then(function(result){
                    component.set("v.isSpinner", false);
                    $A.get('e.force:refreshView').fire();  
                });
            }
            
        });
    },
    //Initialize data table Referral Instructions
    setReferralInstructionsTable : function (component,event,helper){        
        component.set('v.referralColumns', [
            {type: "button",  label: 'Action',typeAttributes: {
                label: { fieldName: 'actionLabel'},
                name: 'Complete_Action',
                title: {fieldName: 'actionTitle'},
                disabled: {fieldName: 'actionDisabled'},
                iconPosition: 'left'
            },initialWidth: 120,cellAttributes: { alignment: 'left' }},
            {label: 'Child Case Number(RMA)', fieldName: 'SubjectUrl',type: 'url', sortable: 'true',hideDefaultActions: 'true', typeAttributes: {label: { fieldName: 'Subject' }, target: '_self'}},
            {label: 'Logistic Node Name', fieldName: 'HWS_LogisticNodeName__c', type: 'text',sortable: 'true',hideDefaultActions: 'true'},                       
            {label: 'Part Number', fieldName: 'HWS_Part_Code__c', type: 'text',initialWidth: 100,sortable: 'true',hideDefaultActions: 'true'},
            {label: 'Serial Number', fieldName: 'HWS_Faulty_Serial_Number__c', type: 'text',sortable: 'true',hideDefaultActions: 'true',cellAttributes: { alignment: 'left' }},
            {label: 'Internal Status', fieldName: 'CH_InternalStatus__c', type: 'text',wrapText: 'true',sortable: 'true'}
            
        ]); 
    },
    //Initialize data table Referral Instructions
    setEscalationInstructionsTable : function (component,event,helper){        
        component.set('v.escalationsColumns', [            
            {label: 'Child Case Number(RMA)', fieldName: 'SubjectUrl',          type: 'url', sortable: 'true', typeAttributes: {label: { fieldName: 'Subject' }, target: '_self'}},
            {label: 'Logistic Node Name', fieldName: 'HWS_LogisticNodeName__c', type: 'text',sortable: 'true'},                       
            {type: "button",  label: 'Action',typeAttributes: {
                label: 'View',
                name: 'View_Action',
                title: 'View',                
                iconPosition: 'left'
            },cellAttributes: { alignment: 'left' }}
            
        ]); 
    },
    //Create URL to redirect child case from table to new tab
    getChildCaseURL: function(recordId) {
        return '/one/one.app?#/sObject/' + recordId + '/view';
    },
    
    //Get ReferralInstructions against parent case 
    getReferralInstructions: function(component,event,helper){
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'getReferralInstructions',{caseId:component.get("v.recordId")}));
        });           
        return promise; 
    },
    //NOKIASC-31275:Change internal Status for child case
    changeInternalStatus: function(component,event,helper,childIDs){        
        var childCaseListToUpdate = [];        
        childIDs.forEach(function(c){
            childCaseListToUpdate = [...childCaseListToUpdate, {
                                     Id: c.Id}];
        });        
        var promise1 = new Promise( function( resolve , reject ) {
            const sharedjs1 = component.find("sharedJavaScript");
            resolve(sharedjs1.apex(component, 'changeInternalStatus',{childCaseIDs: JSON.stringify(childCaseListToUpdate)}));
        });           
        return promise1; 
    },
    
    //NOKIASC-31236:This method is uesd get Escalation Instruction from SOO calout
    GetEscalationInstruction: function(component,event,helper,childRow) {        
        component.set("v.isSpinner", true);
        var action =component.get("c.getEscalationInstruction");
        action.setParams({
            parentCaseId:component.get("v.recordId"),
            childCaseId : childRow.Id                
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var escalationInstruction=response.getReturnValue();
                if(!$A.util.isEmpty(escalationInstruction)){                    
                    component.set("v.dockedSectionBody",escalationInstruction);
                }
                component.set("v.showDocked", true);
                component.set("v.isSpinner", false);
            }
            else {
                var errors = response.getError();                
                this.showToast('error', 'Error','Get Escalation Instruction : '+ errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
                component.set("v.isSpinner",false);
            }            
        });
        $A.enqueueAction(action);
        
    },
    //update  parent case internal status 
    updateParentCase: function(component,event,helper){
        var promise2 = new Promise( function( resolve , reject ) {
            const sharedjs2 = component.find("sharedJavaScript");
            resolve(sharedjs2.apex(component, 'updateParentCase',{caseId:component.get("v.recordId")}));
        });           
        return promise2; 
    },
    //sort data of data table
    sortData: function (component,helper, fieldName, sortDirection,tableId) {
        var data=[];
        if (tableId==='referralDatatable')    {
            data = component.get("v.referralList"); 
        }    
        else if(tableId==='escalationDatatable'){
            data = component.get("v.escalationList"); 
        }        
        var reverse = sortDirection !== 'asc';        
        data = Object.assign([],
                             data.sort(this.sortBy(fieldName, reverse ? -1 : 1))
                            );        
        if (tableId==='referralDatatable')    {
            component.set("v.referralList", data); 
        }    
        else if(tableId==='escalationDatatable'){
            component.set("v.escalationList", data);             
        }
        
    },
    sortBy: function (field, reverse, primer) {
        var key = primer
        ? function(x) {
            return primer(x[field]);
        }
        : function(x) {
            return x[field];
        };        
        return function (a, b) {            
            var A = key(a)? key(a).toLowerCase() : '';
            var B = key(b)? key(b).toLowerCase() : '';
            return reverse * ((A > B) - (B > A));
            
        };
    },   
    // Generic Toast Message
    showToast: function(sType, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": sType,
            "duration":'10000',
            "mode": 'dismissible'
        });
        toastEvent.fire();
    },
})