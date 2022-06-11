({
    //Helper Init method
    hideEscalate : true,
    doInit : function (component,event,helper){
        helper.incrementActionCounter(component);
        const parentResult = component.get("v.childCasesList");
        //let senttOSOO = parentResult[0].HWS_Sent_To_SOO__c != null;
		//NOKIASC-35262
		let senttOSOO = parentResult[0].HWS_Sent_To_SOO__c == true;
        let result = parentResult[0].Cases ? parentResult[0].Cases : null;
        let quotereqtrue = false, hideEscalate = helper.hideEscalate;
        //to check Any one of the child Is Quotion Required field is true
        if(result) {
            for(var i = 0; i < result.length; i++) {
                if(result[i].HWS_isQuoteRequired__c && quotereqtrue == false){
                    quotereqtrue = true;
                    break;
                }
            }
            for(var i = 0; i < result.length; i++) {                   
                if (typeof(result[i].Subject) != 'undefined') {
                    result[i].SubjectUrl = helper.getChildCaseURL(component, result[i].Id);
                }
                //
                if((result[i].HWS_WarrantyStatus__c =='Warranty Unknown') ||
                   (quotereqtrue == false && result[i].HWS_WarrantyStatus__c == 'Out of Warranty' && 
                    (result[i].HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c=='HWS_W_AND_Q_UC_1' || result[i].HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c=='HWS_W_AND_Q_UC_2A' || result[i].HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c =='HWS_W_AND_Q_UC_2B' || result[i].HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c =='HWS_W_AND_Q_UC_8' )))
                {
                    result[i].showClass = 'borderclr';
                }
                else { result[i].showClass = ''; }
                //
                if(senttOSOO == true) {
                    result[i].disableButton = true;
                }
                else{ //modified for NOKIASC-38074
                    if(result[i].HWS_WarrantyStatus__c == null || result[i].HWS_WarrantyStatus__c == 'In Warranty' || result[i].HWS_WarrantyStatus__c == 'Not Applicable' 
                       || result[i].Status == 'Cancelled' || result[i].HWS_Faulty_Serial_Number__c == '' || result[i].HWS_Faulty_Serial_Number__c == undefined || parentResult[0].CH_InternalStatus__c != 'Under Review'){
                        result[i].disableButton = true;
                    }
                    else{
                        result[i].disableButton = false;
                    }
                }
            }
            component.set("v.data",result);
            hideEscalate = result.length > 0 ? hideEscalate : true;
        }
        else { component.set("v.data",null), hideEscalate = true; }
        helper.setChildColumnsTable(component,event,helper);
        component.set('v.globalActions', hideEscalate ? [] : [{name:'escalate', label:'Escalate'}]);
        component.set('v.maxRowSelection', hideEscalate ? 0 : 2000);
        helper.decrementActionCounter(component);
    },
    //Initialize data table Referral Instructions
    setChildColumnsTable : function (component,event,helper){
        component.set('v.childCasesColumns', [
            {label: 'Support Ticket Reference', fieldName: 'SubjectUrl', type: 'url', sortable: 'true', typeAttributes: {label: { fieldName: 'Subject' }, target: '_self'},cellAttributes: {
                class: {
                    fieldName: 'showClass'
                }
            }},
            {label: 'Part Code', fieldName: 'HWS_Part_Code__c', type: 'text',sortable: 'true',cellAttributes: {
                class: {
                    fieldName: 'showClass'
                }
            }},
            {label: 'Part Serial Number', fieldName: 'HWS_Faulty_Serial_Number__c', type: 'text',sortable: 'true',cellAttributes: {
                class: {
                    fieldName: 'showClass'
                }
            }},
            {label: 'Order Status', fieldName: 'Status', type: 'text',sortable: 'true',cellAttributes: {
                class: {
                    fieldName: 'showClass'
                }
            }},
            {label: 'Warranty Status', fieldName: 'HWS_WarrantyStatus__c', type: 'text',sortable: 'true',cellAttributes: {
                class: {
                    fieldName: 'showClass'
                }
            }},
            //End
            {type: "button",  label: 'Action',"initialWidth": 150,size: 'xx-small', typeAttributes: {
                label: 'Edit',
                name: 'View_Action',
                title: 'View',
                iconPosition: 'left',
                onclick:'{! c.openModel }',
                variant:'brand',
                disabled: { fieldName: 'disableButton'},
            },cellAttributes: { alignment: 'left',class: {
                fieldName: 'showClass'
            } },}
        ]);
    },
    //Create URL to redirect child case from table to new tab
    getChildCaseURL: function(component,recordId) {
        if(!component.get("v.isPortalUser"))
        	return '/one/one.app?#/sObject/' + recordId + '/view';
        else
            return window.location.hostname+'/'+window.location.pathname.split('/')[1]+'/'+recordId;
        //return  window.location.hostname+'/'+recordId + '/view';
    },
     //NOKIASC-34220
    getWarrantyStatus : function(component, event, helper, row) {
        var action = component.get("c.getWarrantyStatus");        
        action.setParams({
            caseRecord : row[0],           
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            component.set("v.showSpinner",false);
            if(state == "SUCCESS") {
                component.set("v.isOpen",false);
                var event = component.getEvent('refreshParentEvent');
                event.fire();
            }
            else{
                var errors = response.getError();
                this.showToast('error', 'Error', errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
            }
        });
        $A.enqueueAction(action);
    },
    //
    apexAction: function(component, method, params, handleError) {
        let helper = this, action = component.get(method);
        helper.incrementActionCounter(component);
        return new Promise(function(resolve, reject) { 
        	if(params) action.setParams(params);
        	action.setCallback(helper, function(response) {
                let state = response.getState();
                helper.decrementActionCounter(component);
                if (state === "SUCCESS") {
                    resolve(response.getReturnValue());
                } else {
                    if(handleError) {
                        var error = response.getError();
                        var message =  error && error[0] && error[0].message ? error[0].message : "Something went wrong";
                        helper.showToast('error', 'Error', message);
                        resolve(null);
                    }
                    else reject(response.getError());
                }
            });
            $A.enqueueAction(action);
        });
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
    // Loading Framework
    isLoading: function(component) {
        return component.get("v.showSpinner");
    },
    incrementActionCounter: function(component) {
        var counter = component.get("v.actionCounter") + 1;
        if (counter === 1) {
            component.set("v.showSpinner", true);
        }
        component.set("v.actionCounter", counter);
    },
    decrementActionCounter: function(component) {
        var counter = component.get("v.actionCounter") - 1;
        if (counter === 0) {
            component.set("v.showSpinner", false);
        }
        component.set("v.actionCounter", counter);
    }
})