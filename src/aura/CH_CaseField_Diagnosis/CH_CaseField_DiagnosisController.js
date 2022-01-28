({
   doInit: function(component, event, helper) {
       helper.myAction1(component);
       helper.myAction2(component);
       helper.myAction3(component);
       //helper.statusval(component);
       helper.generatesdrval(component);
       var recordId = component.get("v.recordId");
   },
   handleSuccess : function(component, event, helper) {
       try{
           var toastEvent = $A.get("e.force:showToast");
           toastEvent.setParams({
               "title": "Success!",
               "message": "The record has been updated successfully.",
               "type": "success"
           });
           toastEvent.fire();
            helper.myAction3(component);
			component.set("v.errorlogo", false);
       }catch(e){
           console.log('Error Occured------------------->'+e.getMessage());
       }
       var test = component.find('TCA').get("v.value");
       if(test==true)
       {
           let button = component.find('disablebuttonidwrite');
           button.set('v.disabled',false);
       }
       else
       {
           let button = component.find('disablebuttonidwrite');
           button.set('v.disabled',true);
       }
   },
    handleError : function(component, event, helper) {
       try{
           var toastEvent = $A.get("e.force:showToast");
           toastEvent.setParams({
               /*"title": "Error!",
               "message": "Please enter the Required Fields!:Issue Description/Technical Analysis/Case Cause",
               "type": "error"*/
           });
           toastEvent.fire();
       }catch(e){
           console.log('Error Occured------------------->'+e.getMessage());
       }
       
       
   },
    
       update : function(component,event,helper) {
        //Changes have been done by Gouri on 26.08.2020 to separate three fields' error-Initial Diagnosis,Technical Analysis and Case Cause 
        var errorFlag = false;
        component.set('v.showSpinner', true);
        var fieldLevelErrors=[];
        var pageLevelErrors=[];
        
        if(component.find('CH_IssueDescription__c').get("v.value") ==null || component.find('CH_IssueDescription__c').get("v.value") =='')
        {
            fieldLevelErrors.push({"fieldLabel":"Issue Description"});
            // pageLevelErrors.push({"message":"Please enter Issue Description"});
            $A.util.addClass(component.find('CH_IssueDescription__c'),'redOutLine'); // to highlight the field which has error
			
        }
        else
        {
            $A.util.removeClass(component.find('CH_IssueDescription__c'), 'redOutLine');
            
        }
        if(component.find('CH_TechnicalAnalysis__c').get("v.value") ==null|| component.find('CH_TechnicalAnalysis__c').get("v.value") =='')
        {
            fieldLevelErrors.push({"fieldLabel":"Technical Analysis"});
            // pageLevelErrors.push({"message":"Please enter Technical Analysis"});
           $A.util.addClass(component.find('CH_TechnicalAnalysis__c'),'redOutLine'); // to highlight the field which has error
			
        }
        else
        {
            $A.util.removeClass(component.find('CH_TechnicalAnalysis__c'), 'redOutLine');
            
        }
        if(component.find('CH_CaseCause__c').get("v.value") =='--None--'|| component.find('CH_CaseCause__c').get("v.value") =='' || component.find('CH_CaseCause__c').get("v.value") ==null )
        {
            fieldLevelErrors.push({"fieldLabel":"Case Cause"});
            // pageLevelErrors.push({"message":"Please enter Case Cause"});
            $A.util.addClass(component.find('CH_CaseCause__c'),'slds-has-error'); // to highlight the field which has error
			
        }
        else
        {
            $A.util.removeClass(component.find('CH_CaseCause__c'), 'slds-has-error');
            
        }
        
        
        if( fieldLevelErrors.length!=0 || pageLevelErrors.length!=0 ) 
        //if erros are there then show them via popover
        {
            component.set("v.fieldLevelErrors",fieldLevelErrors); 
            component.set("v.pageLevelErrors",pageLevelErrors);       
            component.set("v.errorlogo", true); 
            component.set("v.closePopupBtn",false);
            component.set("v.validaterequiredfields",'*All required fields must be completed.' );
            errorFlag = true;
        }     
        
		 if(!errorFlag){
         //if error is not there then submit the recordedit form
            component.find("recordEditForm").submit();
            component.set("v.errorlogo", false);
            component.set("v.closePopupBtn",true); 
            component.set("v.validaterequiredfields",'' );
            $A.get('e.force:refreshView').fire();
             
            
            
        }else{
            var errmsg = component.get('c.handleError');
            $A.enqueueAction(errmsg);
            component.set('v.showSpinner', false);
            //v.Spinner
            
        }
        /* try{
           component.find("recordEditForm").submit();
           $A.get('e.force:refreshView').fire();
       }catch(e){
           console.log('Error Occured------------------->'+e.getMessage());
       }*/
   },
      
   generateCar: function (component, event, helper) {
       var recordId = component.get("v.recordId");
       var url = '/apex/CH_GenerateCAR?id=' + recordId;
       var urlEvent = $A.get("e.force:navigateToURL");
       urlEvent.setParams({
           "url": url
       });
       urlEvent.fire();
   },
   associateUsages: function (component, event, helper) {
       var recordId = component.get("v.recordId");
       var url = '/apex/CH_GeneratePdf?id=' + recordId;
       var urlEvent = $A.get("e.force:navigateToURL");
       urlEvent.setParams({
           "url": url
       });
       urlEvent.fire();
   },
   finalSolution : function (component,event,helper) {
       //Change for NOKIASC-17514-Start
        /*component.set("v.issueResolvedFinished",true);
        var flow = component.find("issueResolved");
        var inputVariables = [
            { name : "recordId", type : "String", value: component.get("v.recordId") }
        ];
        flow.startFlow("CH_ResolveCase",inputVariables);*/
    var recordId = component.get("v.recordId");
    var action = component.get("c.checkODRValidationQuery");
    action.setParams({ caseId: recordId });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var storeResponse = response.getReturnValue();
        if (storeResponse) {
          try {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
              title: "Failure!",
              message: "You cannot close this support ticket with outage reported or assessed if following no all End dates in the Outage Duration Records (ODR) are populated.",
              type: "error"
            });
            toastEvent.fire();
          } catch (e) {
            console.log("Error Occured------------------->" + e.getMessage());
          }
        } else {
          component.set("v.issueResolvedFinished", true);
		  component.set("v.issueResolvedFinish", true);
          var flow = component.find("issueResolved");
          var inputVariables = [
            {
              name: "recordId",
              type: "String",
              value: component.get("v.recordId")
            }
          ];
          flow.startFlow("CH_ResolveCase", inputVariables);
        }
        //Change for NOKIASC-17514-End
      }
    });
    $A.enqueueAction(action);
   },
   handleIssueResolvedFinishedChange : function (component,event,helper) {
       if(event.getParam("status") === "FINISHED") {
           component.set("v.Spinner", true);
           component.set("v.issueResolvedFinished",false);
		   component.set("v.issueResolvedFinish", false);
           $A.get('e.force:refreshView').fire();
           window.setTimeout(function(){component.set("v.Spinner", false)}, 4000);
       }
   },
   
   //23319
    handleOnError : function(component, event, helper) {
        try{
            component.set("v.errorlogo", true);      
            var errors = event.getParams();
            var error= errors.output.errors;            
            var fieldError=[];
            var fieldErrors= errors.output.fieldErrors;
            var keyList=Object.keys(fieldErrors);
            keyList.forEach(function(item) {   
                var itemList= fieldErrors[item]; 
				fieldError.push(itemList);     
                
            });                                   
            var pageLevelErrors=[];
            var fieldLevelErrors=[];
            console.log('ERRORS#####::'+JSON.stringify(error));
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
                 // Uncomment this section
                    if(!$A.util.isEmpty(row.message)){
                        pageLevelErrors.push(row);
                    }*/                    
                    //if((!$A.util.isEmpty(row.fieldLabel)) && row.fieldLabel.Outage<2)                      
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
            console.log('ERRORS::'+JSON.stringify(fieldLevelErrors));
            component.set("v.pageLevelErrors",pageLevelErrors);
            component.set("v.fieldLevelErrors",fieldLevelErrors);            
            component.set("v.closePopupBtn",false);
        } catch (e) {
            // Handle Exception error
            console.error(e);                    
        } 
        
    },
    
    closePopup : function(component, event, helper) {
        component.set("v.closePopupBtn",true);
    },
    
    openPopup : function(component, event, helper) {
        component.set("v.closePopupBtn",false);
    },
	close: function (component, event, helper) {
        component.set("v.issueResolvedFinish", false);
        $A.get('e.force:refreshView').fire();
    },
})