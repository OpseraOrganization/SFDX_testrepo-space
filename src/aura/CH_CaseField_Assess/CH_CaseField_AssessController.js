({
    doInit : function(component, event, helper) {
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
	handleSuccess : function(component, event, helper) {
        component.set("v.reloadForm", false);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully.",
            "type": "success"
        });
        toastEvent.fire();
        
        component.set("v.reloadForm", true);
		component.set("v.errorlogo", false);
    },
    update : function(component,event,helper) {
        /*** Modified below code NOKIASC-18141  Added Check condition before Submit*/
        var outageValue = component.find("oType").get("v.value");
        var outageType = component.find("oValue").get("v.value");
        var initalDiag = component.find("initialdiagnosis").get("v.value");
        //if((outageValue == "Yes" && outageType =='') || (initalDiag == null || initalDiag =='')){
            var fieldLevelErrors=[];
            if(initalDiag == null || initalDiag =='')
            {
                fieldLevelErrors.push({"fieldLabel":"Initial Diagnosis"});        
                $A.util.addClass(component.find('initialdiagnosis'),'redOutLine');
                //document.getElementById("validaterequiredfields").innerHTML = '*All required fields must be completed.';
               }
                        
            /*if(outageValue == "Yes" && outageType =="")*/
            if((outageValue == 'Yes' && outageType == '--None--') || (outageValue == 'Yes' && outageType == '') || (outageValue == 'Yes' && outageType ==null))			
            {
                fieldLevelErrors.push({"fieldLabel":"Outage Type"});                                      
                $A.util.addClass(component.find('oValue'),'slds-has-error');
                //document.getElementById("validaterequiredfields").innerHTML = '*All required fields must be completed.';
              }
        
              if(fieldLevelErrors.length!=0) 
              {
                 component.set("v.fieldLevelErrors",fieldLevelErrors);            
                 component.set("v.errorlogo", true); 
                 component.set("v.closePopupBtn",false);
                  document.getElementById("validaterequiredfields").innerHTML = '*All required fields must be completed.';
                 } 
            else{
            document.getElementById("validaterequiredfields").innerHTML = '';
            $A.util.removeClass(component.find('oValue'),'slds-has-error');
            $A.util.removeClass(component.find('initialdiagnosis'),'redOutLine');
            component.find("recordEditForm").submit();
           component.set("v.errorlogo", false);
            component.set("v.closePopupBtn",true);
        }     
 
    },  
    /***  NOKIASC-31157 change outage based on severity*/
    onchangeSeverity : function(component,event,helper) {
       var sevValue = component.find("oSeverity").get("v.value");
		if(sevValue == "Minor"){
            component.find("oType").set("v.value", "No");
            component.set("v.outageflag",true);
		}
		else if(sevValue == "Critical" || sevValue == "Major"){
			component.find("oType").set("v.value", "");
		}
        else if(sevValue == ""){
            component.set("v.outageflag",true);
		}
    },
    /***  NOKIASC-31157 */
    /***  NOKIASC-18141 */
    onchangeOutage : function(component,event,helper) {
       var outageValue = component.find("oType").get("v.value");
        if(outageValue == "Yes"){
            component.set("v.outageflag",false);
        }else{
            component.set("v.outageflag",true);    
        }
    },
     /***  NOKIASC-18141 */
    onEditLoad : function(component,event,helper) {
       var outageValue = component.get("v.currentCaseRecord.CH_Outage__c");
        if(outageValue == "Yes"){
            component.set("v.outageflag",false);
        }else{
            component.set("v.outageflag",true);    
        }
		var caleaconfirmed= component.find("caleaconfirmed").get("v.value");
		if (caleaconfirmed == 'Yes' || caleaconfirmed =='No' ){
		component.set("v.isCaleaConfirmed",true); //NOKIASC-36514
		}
    },
	
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
                    /*If we want Field Label Error Texts to be displayed in Popover
                 // Uncomment this section
                    if(!$A.util.isEmpty(row.message)){
                        pageLevelErrors.push(row);
                    }*/
                    
                    if(!$A.util.isEmpty(row.fieldLabel) ){
                        if(fieldLevelErrors.length==0){
                            
                            fieldLevelErrors.push(row);
                        }
                        else{
                            var rowDataIndex=fieldLevelErrors.map(function(e){ return e.fieldLabel; }).indexOf(row.fieldLabel);
                            if(rowDataIndex===-1){
                                fieldLevelErrors.push(row);
                            }  
                        }
                        
                        
                    }
                });  
            });  
            component.set("v.pageLevelErrors",pageLevelErrors);
            component.set("v.fieldLevelErrors",fieldLevelErrors);            
            component.set("v.closePopupBtn",false);
        } catch (e) {
            // Handle Exception error
            //console.error(e);      NOKIASC-36296               
        } 
        
    },
    // This function will close the PopOver -NOKIASC-23325
    closePopup : function(component, event, helper) {
        component.set("v.closePopupBtn",true);
        
        
    },
    
    openPopup : function(component, event, helper) {
        component.set("v.closePopupBtn",false);
        
        
    },
    
    //NOKIASC-38611
    openProductPulldown : function(component, event, helper) {
        var action = component.get('c.hasCaseEditAcess');
        action.setParams({ "caseRecordId" : component.get("v.recordId"), fields : [
            'ProductId', 'CH_Product_Release__c', 'CH_Product_Module__c', 'CH_ProductVariant__c', 
            'CH_Solution__c', 'CH_SW_Component__c', 'CH_SW_Release__c', 'CH_SW_Module__c',
            'CH_SW_Build__c', 'CH_HW_Component__c'
        ]});
        action.setCallback(this,function(response){
            if (response.getState() === "SUCCESS") {
                let result = response.getReturnValue();
                if(result === '' || result === 'Entitlement related details cannot be modified once Restore, Temporary Solution or Solution Provided events have been completed.') {
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef: "c:CH_ProductPulldown",
                        componentAttributes:{
                            id : component.get("v.recordId"),
                            object : 'Case',
                            type : 'CompleteMinimalLocked'
                        }            
                    });
                    evt.fire();
                }
                else {
                    helper.showToastMessage('Error',result); 
                }
            }
        });
        $A.enqueueAction(action);
    },
   
})