({  
    //This method used to fetch Parent case with Child records and display message
    checkWarrantyQuotationCondition: function(component,event,helper){
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'checkWarrantyQuotationCondition',{parentCaseID : component.get("v.recordId"),refreshChildOnly:component.get("v.refreshChildOnly")}));
        });           
        return promise; 
    },
    //This method used to initialize all attribute value 
    initializeComponentAttribute : function(component,event,helper,result) {
        
       // component.set("v.existingCaseNumber", result.listofCases[0].CaseNumber);//Commented out for blocker issue-Nokiasc-36056
        component.set("v.CaseList", result.listofCases);
        //NOKIASC-34093
        if(result.sLabelName !=null && result.sLabelName !='' && result.sLabelName != undefined ){
			//NOKIASC-36633
            //if(result.sLabelName[0].includes('FewWUorQR,HWS_WCheck_UnKnowns')){
		     if(result.sLabelName[0].includes('FewWUorQR,HWS_WCheck_UnKnowns_Split')||result.sLabelName[0].includes('FewWUorQR,HWS_WCheck_All_QuoteRequired_Split')){ 
                var arrayLabel = result.sLabelName[0].split(',');
                component.set("v.LabelList", arrayLabel[1]);
                component.set("v.fewWUorQRTrue", true);
            }
            else{
                component.set("v.LabelList", result.sLabelName);
            }
        }
        component.set("v.afterLabelName", result.sAfterLabelName);        
        var isMessageButtonVisible=result.listofCases[0].CH_InternalStatus__c=='Under Review'?true:false;
        component.set("v.isMessageButtonVisible",isMessageButtonVisible);
        if(isMessageButtonVisible){
            this.displayMessageButton(component,event,helper);  
        } 
    },
    //This method used to initialize displayMessage and button in component
    displayMessageButton : function(component,event,helper) {
        if(component.get("v.LabelList").length==1 ){            
			//added for NOKIASC-37056 - Start
			if(component.get("v.LabelList")[0] === 'HWS_MSG_WarrantyCheckInProgress'){
                component.set("v.isDisableValidateButton",true);
            }
			//added for NOKIASC-37056 - End
            var labelName= $A.getReference("$Label.c." + component.get("v.LabelList")[0]);
            component.set("v.instructionMsg", labelName);
			//NOKIASC-36633
            if (component.get("v.LabelList")[0] == 'HWS_WCheck_UnKnowns' || component.get("v.LabelList")[0] == 'HWS_WCheck_UnKnowns_Split' || component.get("v.LabelList")[0] == 'HWS_PO_MISSING'||component.get("v.LabelList")[0] == 'HWS_WCheck_All_QuoteRequired'||component.get("v.LabelList")[0] == 'HWS_WCheck_All_QuoteRequired_Split') {
                component.set("v.isUnknowWarranty", true); 
            } else {
                component.set("v.isUnknowWarranty", false);    
            }
        }
        /*else{
            helper.showToast('error',"Error","Invalid Value") ;
        }*/
    },
    checkPayPerUse : function(component,event,helper) {
        component.set("v.isSpinner", true);
        var parentCaseId=component.get("v.recordId"); 
        var action=component.get('c.getPayPerUse');
        action.setParams({parentCaseId : parentCaseId});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.isSpinner", false);                
                if(response.getReturnValue()==='PO Error'){
                    this.showToast('error','Error Message','Please enter Customer Purchase Order Number, or escalate to Customer Care Manager.');
                }
                else{
                    this.cancelHWSCase(component,event,helper);
                }
            }
        }));
        $A.enqueueAction(action);     
    }, 
    cancelHWSCase : function(component,event,helper) {
        if(component.get("v.LabelList")[0] == 'HWS_WCheck_OOW'){
            component.set("v.isSpinner", true);
            var parentCaseId=component.get("v.recordId"); 
            var conditions = ['HWS_W_AND_Q_UC_1', 'HWS_W_AND_Q_UC_8','HWS_W_AND_Q_UC_2A','HWS_W_AND_Q_UC_2B'];
            var action=component.get('c.cancelChildCases');
            action.setParams({parentCaseId : parentCaseId, condition : conditions});
            action.setCallback(this, $A.getCallback(function (response) {
                component.set("v.isSpinner", false);                
                var state = response.getState();
                if (state === "SUCCESS") {
                     component.set("v.isSpinner", false);                
                    var childCaseList=component.get('v.CaseList')[0].Cases;
                    var cancelCaseList =  childCaseList.filter(function(item) {
                        return item.HWS_WarrantyStatus__c == "Out of Warranty"
                        && item.Status!=="Cancelled" 
                        && (item.HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c=='HWS_W_AND_Q_UC_1' || item.HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c=='HWS_W_AND_Q_UC_2A' 
                        || item.HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c=='HWS_W_AND_Q_UC_8' || item.HWS_Contract_Line_Item__r.HWS_W_AND_Q_CONDITION__c=='HWS_W_AND_Q_UC_2B');

                    });
                    
                    if(cancelCaseList.length==childCaseList.length &&  response.getReturnValue()==true ){
                       component.set("v.isSpinner", true);  
                        helper.updateParentCaseStatusBlank(component,event,helper);
                        component.set('v.isSubmittedDone',true);
                        component.set("v.isDisableSubmitButton",true);
                        helper.refreshChildComponentOnValidate(component,event,helper)	
                         
                    }
                    else{
                        this.submitHWSCase(component,event,helper);
                    }
                }
            }));
            $A.enqueueAction(action);     
        } else {
            this.submitHWSCase(component,event,helper);
        }
    },
    submitHWSCase : function(component,event,helper) {
        component.set("v.isSpinner", true);
        var actionCallout = component.get("c.makeSOOCallout");
        var caseId=component.get("v.recordId");           
        actionCallout.setParams({parentCaseId : caseId});
        actionCallout.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            component.set("v.ProcessResponse", response.getReturnValue());
            var processResponse=component.get("v.ProcessResponse");
            if (state === "SUCCESS") {
                component.set("v.isSpinner", false);
                if(processResponse!=null){
                    var statuscode=processResponse.statusCode;
                    var Status=processResponse.Status;
                    if(statuscode==200 && Status!='Fail'){
                        component.set("v.isSpinner", true);
                        helper.updateParentCaseStatus(component,event,helper)
                        .then(function(result){ 
                            //component.set("v.isSpinner", false);
                            helper.refreshChildComponentOnValidate(component,event,helper);
                        });
                        this.showToast('success','Success Message','The Case has been Successfully Submitted to SOO'); // NOKIASC-36610
                        //$A.get('e.force:refreshView').fire(); // NOKIASC-36610
                       // this.showToast('success','Success Message',$A.getReference(component.get("v.afterLabelName")));
                    }
                    else
                    {
                        if(statuscode==200 && Status=='Fail'){
                            this.showToast('error','Error Message','Cancelled Cases connot be submitted');    
                        }else{
                            //this.showToast('error','Error Message','Case was not submitted to SOO');    
                        }                        
                    }
                }
                else{
                    this.showToast('error','Error Message','Case was not submitted to SOO');
                }                               
            }
            else if (state === "INCOMPLETE") {
                component.set("v.isSpinner", false);
            }
                else if (state === "ERROR") {
                    component.set("v.isSpinner", false);
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            this.showToast('error','Error Message',errors[0].message);
                        }
                        else if (errors[0] && errors[0].pageErrors) {
                            this.showToast('error','Error Message',errors[0].pageErrors[0].message);                        	
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        }));
        $A.enqueueAction(actionCallout);
        
    },
	//This method is used to update parent case internal status either Warranty required or Quotation required
    updateParentCaseStatusWarrantyQuote : function(component,event,helper){
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'updateParentCaseStatusWarrantyQuote',{childCaseId : component.get("v.recordId")}));
        });          
        return promise;
    },
    //This method is used to update parent case internal status after validation 
    updateParentCaseStatus: function(component,event,helper){
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'updateParentCaseStatus',{childCaseId : component.get("v.recordId")}));
        });           
        return promise; 
    },
	//This method is used to update parent case internal status as blank when all case are cancelled
    updateParentCaseStatusBlank: function(component,event,helper){
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'updateParentCaseStatusBlank',{parentCaseId : component.get("v.recordId")}));
        });           
        return promise; 
    },
    //This method used to initialize all attribute value 
    refreshChildComponentOnValidate : function(component,event,helper) {
        var rc=this;
        component.set("v.refreshChildOnly",true);
        component.set("v.CaseList", []);
        rc.checkWarrantyQuotationCondition(component,event,helper)
        .then(function(result){              
            component.set("v.CaseList", result.listofCases);
            var labelName= $A.getReference("$Label.c." + component.get("v.afterLabelName"));
            component.set("v.instructionMsg", labelName);
            component.set("v.refreshChildOnly",false);
            component.set("v.isButtonSectionVisible",false);            
            component.set("v.isSpinner",false);
			if(component.get("v.LabelList")[0] != 'HWS_WCheck_OOW'){
			setTimeout($A.getCallback(function() {
            $A.get('e.force:refreshView').fire();
            }), 5000);
			}
        });    
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
	//NOKIASC-34093
    cloneAllCases: function(component, event, helper) {
        component.set("v.isSpinner", true);
        var cloneCases =[];
        component.get("v.CaseList")[0].Cases.forEach(function(row) { 
            if(row.HWS_WarrantyStatus__c =='Warranty Unknown' || row.HWS_isQuoteRequired__c){
                cloneCases.push(row);
            }
        });
        var parentCaseId=component.get("v.recordId"); 
        var action=component.get('c.cloneCases');
        action.setParams({parentCaseId : parentCaseId,
                          childCaseLst : cloneCases,
                          emailType	: 'Pending Order Summary Auto split'});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result= JSON.parse(response.getReturnValue())//NOKIASC-36633
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
							 //NOKIASC-36633
                            url: '/'+result.Id,
                            label: result.CaseNumber,
                             
                        }
                        
                    ]
                });
                toastEvent.fire();
                helper.callInit(component, event, helper);
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
    //Executing Init method --> NOKIASC-34093
     callInit : function(component, event, helper) {        
        component.set("v.isSpinner",true);
         component.set("v.LabelList", []);
         component.set("v.fewWUorQRTrue", false);
         component.set("v.isUnknowWarranty", false); 
         component.set("v.isButtonSectionVisible",false);  
         component.set("v.CaseList",null);
        component.set("v.isDisableOkButton",false); 
        component.set("v.isButtonSectionVisible",true);  
        component.set('v.isSubmittedDone',false);
         component.set("v.instructionMsg", '');
        helper.checkWarrantyQuotationCondition(component,event,helper)
        .then(function(result){             
            helper.initializeComponentAttribute(component,event,helper,result); 
            component.set("v.isSpinner",false);
        });         
    },
})