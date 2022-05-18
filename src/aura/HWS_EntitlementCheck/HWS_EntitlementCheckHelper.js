({
    
    //Helper Init method
    init: function (component,event,helper) {
        component.set("v.isSpinner", true);
        var action =component.get("c.getChildCaseDetails");
        action.setParams({
            caseId:component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var childCaseMap = {};
                var isErrorCase2;
                var isErrorCase1;
                //NOKIASC-34880
                if(result.length>0){
                    
                    component.set("v.disableQuoteButton",result[0].Parent.HWS_Sent_To_SOO__c);        
                    component.set("v.disableSubmit",result[0].Parent.CH_Status__c=='Closed'?true:false);
                }
                var checkStatus = false;
                for(var i = 0; i < result.length; i++) {
                    isErrorCase1 =  result[i].Parent.HWS_ErrorReason__c;
                    //Updated on 08-April-2021 | NOKIASC-35318 | Start
                    result[i].disableEdit = result[i].Parent.HWS_Sent_To_SOO__c==true?true:((result[i].HWS_WarrantyStatus__c == 'Not Applicable' || result[i].Status == 'Cancelled' || result[i].HWS_Faulty_Serial_Number__c == '')?true: false);   
                    //Updated on 08-April-2021 | NOKIASC-35318 | End					
                    if (typeof(result[i].Subject) != 'undefined') {
                        result[i].SubjectUrl = helper.getChildCaseURL(result[i].Id);
                    }
                    //NOKIASC-34636-Enable Warranty Check when Exception= Warranty Check Failed
                    result[i].disableCheckWarranty = typeof(result[i].CH_EntitlementException__c)=='undefined'?true:(result[i].CH_EntitlementException__c!= 'Warranty Status Check Failed'?true:false);
                    childCaseMap[result[i].Id] = result[i];
                    if(result[i].Status !='Cancelled' && result[i].Status != 'Ordered'){
                        checkStatus = true;
                        
                    }
                }
                if(checkStatus){
                   //NOKIASC-36899
                    component.set("v.disableSplit",(result.length<=1));
                    if(result.length<=1){
                        component.set("v.instructionMsg","Click on Validate & Submit Button");
                     }	
                    component.set("v.disableSubmit",false);
                }
                else{
                    component.set("v.disableSplit",true);
                    component.set("v.disableSubmit",true);
                    component.set("v.instructionMsg","Click on Validate & Submit Button");

                }
                //NOKIASC-37634
                if(result.length >0 && (result[0].Status=='Cancelled' || result[0].Status == 'Ordered')){
                	component.set("v.isMsgSectionVisible",false); 
                }
                
                component.set("v.isSpinner",false);
                component.set("v.childCasesList",result);
                component.set("v.childCaseMap",childCaseMap);
                //  isErrorCase = isErrorCase == true ? true : false;
                isErrorCase2 = isErrorCase1 == 'BulkWarrantyCheckFailed' ? true : false;
                component.set("v.isErrorCase", isErrorCase2);
                this.setChildColumnsTable(component,event,helper);
            }
            else {
                component.set("v.isSpinner",false);
                var errors = response.getError();
                this.showToast('error', 'Error', errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
            }            
        });
        $A.enqueueAction(action);
    },
    retryHelper:function(component,event,helper) {	
        component.set("v.isSpinner", true);	
        var action=component.get('c.retryTosync');	
        action.setParams({caseId : component.get("v.recordId")});	
        action.setCallback(this, function(response) {	
            var state = response.getState();	
            //console.log('state===='+state);	
            var result = response.getReturnValue();
            //console.log('result===='+JSON.stringify(result));
            
            if (state === "SUCCESS") {	
                if (result != null && result.statusCode != null && result.statusCode == 200) {
                    //console.log('Success here');
                    component.set("v.isErrorCase", false);
                    this.showToast('success','Success Message','Warranty Check Request Successfully Submitted.');   
                } else {
                    //console.log('fail here');
                    component.set("v.isErrorCase", true);
                    this.showToast('error','error Message','Warranty Check Failed , Please retry again , if the problem persists please contact Admin.');	
                }
                
            } else {
                component.set("v.isErrorCase", true);		
                this.showToast('error','error Message','Warranty Check Failed , Please retry again , if the problem persists please contact Admin.');	
            }	
            component.set("v.isSpinner", false);	
            $A.get('e.force:refreshView').fire();	
        });	
        $A.enqueueAction(action);	
    },
    checkInternalStatus: function(component,event,helper){
        var action=component.get('c.getInternalStatus');
        action.setParams({parentCaseId : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() === true){
                    this.showToast('error','Error Message','Please resolve all Unknown Warranty Cases before Submit');
                }
                else{
                    var conditions = ['HWS_W_AND_Q_UC_1', 'HWS_W_AND_Q_UC_8','HWS_W_AND_Q_UC_2A','HWS_W_AND_Q_UC_2B'];
                    var actionCancelled=component.get('c.cancelChildCases');
                    actionCancelled.setParams({parentCaseId : component.get("v.recordId"), condition : conditions});
                    action.setCallback(this, function(response) {
                    });
                    $A.enqueueAction(actionCancelled);			
                    this.submitHWSCase(component,event,helper);
                }
            }
        });
        $A.enqueueAction(action); 
    },
    
    checkPayPerUse : function(component,event,helper) {
        component.set("v.isSpinner", true);
        var parentCaseId=component.get("v.recordId"); 
        var action=component.get('c.getPayPerUse');
        action.setParams({
            parentCaseId : parentCaseId});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                /* if(response.getReturnValue()==='Quotation Error'){
                    this.showToast('error','Error Message','Please populate the Customer Purchase Order Number with details provided by the Warranty & Quotation team.');
                }*/
                if(response.getReturnValue()==='PO Error'){
                    this.showToast('error','Error Message','Please enter Customer Purchase Order Number, or escalate to Customer Care Manager.');
                }
                /*  else if(response.getReturnValue()==='WarrantyError'){
                        this.showToast('error','Error Message','Support Ticket cannot be submitted because Warranty Verification required for one or more parts added. Please check Entitlement tab and also the Purchase Order Number is required, please escalate to the Warranty & Quotation team.');
                    }
                        else if(response.getReturnValue()==='WarrantyNullError'){
                            this.showToast('error','Error Message','Purchase Order Number is required, please escalate to the Warranty & Quotation team.');
                        } */
                else{
                    this.checkInternalStatus(component,event,helper);
                }
            }
            component.set("v.isSpinner", false);
        }));
        $A.enqueueAction(action);     
    },
    /* checkWarrantyVerification : function(component,event,helper) {
        
        component.set("v.isSpinner", true);
        var caseList =component.get("v.CaseList",result);
        component.set("v.isSpinner", false);
        var childCaseList =caseList[0].Cases;
        var verificationRequired = false;
       
        items.some(function(item){
            if(!$A.util.isEmpty(item.CH_InternalStatus__c) && item.CH_InternalStatus__c =='Warranty Verification Required'){
                verificationRequired = true;
                return verificationRequired;
            }
        });
       
        if(verificationRequired){
            this.showToast('error','Error Message','Support Ticket cannot be submitted because Warranty Verification required for one or more parts added. Please check Entitlement tab');
        }              
        else{
            this.submitHWSCase(component,event,helper);
        }        
        component.set("v.isSpinner", false);
    },*/    
    submitHWSCase : function(component,event,helper) {
        component.set("v.IsSpinner", true);
        var actionCallout = component.get("c.makeSOOCallout");
        var caseId=component.get("v.recordId");   
        var actionCallout=component.get('c.makeSOOCallout');
        actionCallout.setParams({
            parentCaseId : caseId});
        actionCallout.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            component.set("v.ProcessResponse", response.getReturnValue());
            var processResponse=component.get("v.ProcessResponse");
            if (state === "SUCCESS") {
                
                component.set("v.IsSpinner", false);
                if(processResponse!=null){
                    var statuscode=processResponse.statusCode;
                    var Status=processResponse.Status;
                    
                    if(statuscode==200 && Status!='Fail'){
                        this.showToast('success','Success Message','The Case has been Successfully Submitted to SOO');
                        
                    }
                    else
                    {
                        if(statuscode==200 && Status=='Fail'){
                            
                            this.showToast('error','Error Message','Cancelled Cases connot be submitted');    
                        }else{
                            this.showToast('info','Info Message','Case was not submitted to SOO');    
                        }
                        
                    }
                }
                else{
                    this.showToast('info','Info Message','Case was not submitted to SOO');
                }
                $A.get('e.force:refreshView').fire();
                
                
            }
            else if (state === "INCOMPLETE") {
                component.set("v.IsSpinner", false);
            }
                else if (state === "ERROR") {
                    component.set("v.IsSpinner", false);
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        }));
        $A.enqueueAction(actionCallout);
        
    },
    showToast: function(sType, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": sType
        });
        toastEvent.fire();
    },    
    //Initialize data table Referral Instructions
    setChildColumnsTable : function (component,event,helper){        
        component.set('v.childCasesColumns', [
            {label: 'Support Ticket Reference', fieldName: 'SubjectUrl', type: 'url', sortable: 'true',wrapText:'true', typeAttributes: {label: { fieldName: 'Subject' }, target: '_self'}},
            {label: 'Part Code', fieldName: 'HWS_Part_Code__c',type: 'text',sortable: 'true'},
            {label: 'Part Serial Number', fieldName: 'HWS_Faulty_Serial_Number__c', type: 'text',sortable: 'true'},
            {label: 'Case Status', fieldName: 'Status', type: 'text',sortable: 'true'},
            {label: 'Warranty Status', fieldName: 'HWS_WarrantyStatus__c', type: 'text',sortable: 'true',wrapText:'true'},
            {label: 'Entitlement Status', fieldName: 'CH_EntitlementStatus__c', type: 'text',sortable: 'true',wrapText:'true'},
            {label: 'Edit',type: 'button' ,typeAttributes: {
                label: 'Edit',
                name: 'editExceptionStatus',
                title: 'Edit',
                align:'left',
                iconPosition: 'left',
                variant:'brand',                
                disabled: { fieldName: 'disableEdit'}
            }},
            {type: "button",  label: 'Action',size: 'xx-small',initialWidth: 125,typeAttributes: {
                label: 'Check Warranty',
                name: 'View_Action',
                title: 'View',
                position:'left',
                iconPosition: 'left',
                variant:'brand',                
                disabled: { fieldName: 'disableCheckWarranty'}
            },cellAttributes: { alignment: 'left' }}            
        ]);        
    },
    
    //Create URL to redirect child case from table to new tab
    getChildCaseURL: function(recordId) {
        return '/one/one.app?#/sObject/' + recordId + '/view';
    },
    
    //sort data of data table
    sortData: function (component,helper, fieldName, sortDirection,tableId) {
        var data= component.get("v.childCasesList");
        var reverse = sortDirection !== 'asc';
        data = Object.assign([],
                             data.sort(this.sortBy(fieldName, reverse ? -1 : 1))
                            );
        component.set("v.childCasesList", data);
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
    getRecordValues : function(component,event){
        var action = component.get("c.validateUser");
        action.setParams({
            parentCaseId: component.get("v.recordId")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                var msg =response.getReturnValue();
                if($A.util.isEmpty(msg)){
                    var childCaseId = event.getParam('row').Id;
                    component.set("v.rowId",childCaseId);
                    var actionName = event.getParam('action').name;
                    if(actionName == 'editExceptionStatus'){
                        component.set("v.editExceptionStatus",true);
                    }
                    //NOKIASC-36696:UAT3.3 QCRM3: Handle Warranty Manager/Quotation
                    var faultySerial=$A.util.isEmpty(event.getParam('row').HWS_Faulty_Serial_Number__c)?'':event.getParam('row').HWS_Faulty_Serial_Number__c
                    component.set("v.faultySerialNumber", faultySerial);
                    component.find("serialNumber").set("v.value",faultySerial); 
                    var entitlementExcep=$A.util.isEmpty(event.getParam('row').CH_EntitlementException__c)?'':event.getParam('row').CH_EntitlementException__c;
                    component.set("v.entitlementException", entitlementExcep);
                    var entitleStatus=$A.util.isEmpty(event.getParam('row').CH_EntitlementStatus__c)?'':event.getParam('row').CH_EntitlementStatus__c;
                    component.set("v.entitlementStatus", entitleStatus); 
                    component.find("status").set("v.value",entitleStatus);
                    this.fetchPicklistValues(component);  
                }
                else{
                    var errors = response.getError();
                    this.showToast('error', 'Error', msg);
                }
            }
            else{
                var errors = response.getError();
                this.showToast('error', 'Error', errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
            }
            component.set("v.isSpinner",false);
        });
        $A.enqueueAction(action);                
    },    
    //NOKIASC-36696:UAT3.3 QCRM3: Handle Warranty Manager/Quotation
    fetchPicklistValues: function(component) {
        component.set("v.isSpinner",true);
        // call the server side function  
        var action = component.get("c.getDependentMap");
        // pass paramerters [object definition , contrller field name ,dependent field name] -
        // to server side function 
        action.setParams({
            'objDetail' : component.get("v.objDetail"),
            'contrfieldApiName': component.get("v.controllingFieldAPI"),
            'depfieldApiName':  component.get("v.dependingFieldAPI") 
        });
        //set callback   
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                
                // once set #StoreResponse to depnedentFieldMap attribute 
                component.set("v.depnedentFieldMap",StoreResponse);
                
                // create a empty array for store map keys(@@--->which is controller picklist values) 
                var listOfkeys = []; // for store all map keys (controller picklist values)
                var ControllerField = []; // for store controller picklist value to set on lightning:select. 
                
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }                
                //set the controller field value for lightning:select
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push('--None--');
                }
                
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push(listOfkeys[i]);
                }                  
                // set the ControllerField variable values to country(controller picklist field)
                component.set("v.listControllingValues", ControllerField);
                var entitlementExcep=component.get("v.entitlementException");               
                if(!$A.util.isEmpty(entitlementExcep)){
                    component.find("entitlementException").set("v.value",entitlementExcep);
                    component.controllerFieldChange();
                }
                component.set("v.isSpinner",false);
            }else{
                component.set("v.isSpinner",false);
                //  alert('Something went wrong..');
            }
        });
        $A.enqueueAction(action);
    },
    //NOKIASC-36696:UAT3.3 QCRM3: Handle Warranty Manager/Quotation
    fetchDepValues: function(component, ListOfDependentFields) {
        // create a empty array var for store dependent picklist values for controller field  
        var dependentFields = [];
        dependentFields.push('--None--');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set("v.listDependingValues", dependentFields);
        
    },
    saveTableValues : function(component, event, helper) {
        var editedRecords =  event.getParam('draftValues');
        var action = component.get("c.updateCaseValues");
        action.setParams({
            'editedCaseList' : editedRecords
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                var caseReturnList = response.getReturnValue();
                component.find( "childDatatable" ).set("v.draftValues", null);
                this.init(component,event,helper);
            }
            else{
                var errors = response.getError();
                this.showToast('error', 'Error', errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
            }
            component.set("v.isSpinner",false);
        });
        $A.enqueueAction(action);
    },    
    updateCaseValues : function(component, event, helper, row) {
        var childList=[];
        var action = component.get("c.updateCaseValues");
        action.setParams({
            'editedCaseList' : row,
            'parentCaseId':component.get("v.recordId")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                //NOKIASC-36933:Internal status to update automatically for verified Quotation cases
                this.updateParentInternalStatusToQuoteReq(component, event, helper);
                component.set("v.editExceptionStatus",false);
            }
            else if(response.getState() === "ERROR")
            {
                var errorMessage;
                var errors = response.getError();
                component.set("v.editExceptionStatus",false);
                component.set("v.isSpinner",false);
                this.showToast('error', 'Error', errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");                       
                
            }
                else{
                    component.set("v.editExceptionStatus",false);
                    component.set("v.isSpinner",false);
                    var errors = response.getError();
                    this.showToast('error', 'Error', errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");            
                }
            //this.init(component,event,helper);
            
        });
        $A.enqueueAction(action); 
    },
    //NOKIASC-36933:Internal status to update automatically for verified Quotation cases
    updateParentInternalStatusToQuoteReq : function(component, event, helper) {
        component.set("v.isSpinner",true);
        var action = component.get("c.modifyInternalStatusToQuoteReq");
        action.setParams({
            'parentCaseId' : component.get("v.recordId")
        });        
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                var result= response.getReturnValue();
                if(!$A.util.isEmpty(result)){
                    var wgName=result.CH_Workgroup__r.Name;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        duration:'10000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'sticky',
                        message: 'This is a required message',
                        messageTemplate: 'Case has been assigned to another workgroup: {0}',
                        messageTemplateData: [
                            {
                                url: '/'+result.CH_Workgroup__c,
                                label: wgName,
                            }
                        ]
                    });
                    toastEvent.fire();    
                }
                this.init(component,event,helper);
            }
            else{
                var errors = response.getError();
                this.showToast('error', 'Error', errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
            }
            component.set("v.isSpinner",false);
        });
        $A.enqueueAction(action); 
    },
    getWarrantyStatus : function(component, event, helper, row) {
        component.set("v.isSpinner",true);
        var action = component.get("c.getWarrantyStatus");        
        action.setParams({
            caseRecord : row,           
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                component.set("v.editExceptionStatus",false);
                this.init(component,event,helper);
            }
            else{
                var errors = response.getError();
                this.showToast('error', 'Error', errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
            }
        });
        $A.enqueueAction(action);
    },
    
    updateParentInternalStatus : function(component, event, helper) {
        component.set("v.isSpinner",true);
        var action = component.get("c.updateParentInternalStatus");
        action.setParams({
            'parentCaseId' : component.get("v.recordId")
        });        
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                this.init(component,event,helper);
            }
            else{
                var errors = response.getError();
                this.showToast('error', 'Error', errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
            }
            //component.set("v.isSpinner",false);
        });
        $A.enqueueAction(action);
    },
    //NOKIASC-34261
    cloneAllCases: function(component, event, helper) {
        component.set("v.isSpinner", true);
        var cloneCases =[];
        cloneCases = component.get("v.selectedRowDetails");
        var parentCaseId=component.get("v.recordId"); 
        var action=component.get('c.cloneCases');
        action.setParams({parentCaseId : parentCaseId,
                          childCaseLst : cloneCases,
                          emailType	: 'HWS Pending Order Summary Manual Split'});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //NOKIASC-36633
                var result= JSON.parse(response.getReturnValue())
                component.set("v.isSpinner", false);  
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    duration:'20000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'sticky',
                    message: 'This is a required message',
                    messageTemplate: 'NOTICE: Child case(s) requiring warranty verification or quotation have been escalated to a Nokia Specialist under new parent case number: {0}',
                    messageTemplateData: [
                        {
                            url: '/'+result.Id,
                            label: result.CaseNumber,
                        }
                    ]
                });
                toastEvent.fire();
                helper.init(component, event, helper);
                this.updateParentInternalStatus(component, event, helper);
            }
            else{
                component.set("v.isSpinner", false); 
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                this.showToast('error','Error Message',message);
            }
        }));
        $A.enqueueAction(action);     
    },
    // NOKIASC-34877:Action on click of Accept Quote/ Reject Quote
    clickAccetRejectQuoteDate : function(component, event, helper,childSet,btnAction) { 
        component.set("v.isSpinner", true);
        var buttonLabel=(btnAction=='acceptQuote'?'Accept Quote':'Reject Quote');
        var action = component.get("c.acceptRejectQuoteDate");
        action.setParams({
            'caseSet' : childSet,
            'action': btnAction
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                this.init(component,event,helper);
                this.showToast('success', 'Success', "Selected RMA's " + buttonLabel +" updated successfully.");
            }
            else{
                var errors = response.getError();
                this.showToast('error', 'Error', errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
            }            
            component.set("v.isSpinner",false);
        });
        $A.enqueueAction(action);
    },  
})