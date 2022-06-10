({
    doInit: function(component, event, helper) {
       //Check Partner User Or Internal
       var partnerFlagCheckAction = component.get("c.getPartnerUserType");
       partnerFlagCheckAction.setCallback(this, function(response) {
       var state = response.getState();
       if (state === "SUCCESS") {
          var res=response.getReturnValue();
          component.set("v.isPartneruser",res);               	  
          if(res)
          {
        var getPartnerUserDetailsAction = component.get("c.getPartnerUserDetails");
       	getPartnerUserDetailsAction.setCallback(this, function(response) {
       	var stateOfRes = response.getState();
       	if (stateOfRes === "SUCCESS") {
        var response1=response.getReturnValue();
        component.set("v.userDetailsMap",response1);
        
       }});
      $A.enqueueAction(getPartnerUserDetailsAction);  
          }
         }
         
       });
      $A.enqueueAction(partnerFlagCheckAction);
        
     
        
        var getpartnerCaseRecordTypeId = component.get("c.getPartnerCaseRecordTypeId");
       getpartnerCaseRecordTypeId.setCallback(this, function(response) {
       var state = response.getState();
       if (state === "SUCCESS") {
          var res=response.getReturnValue();
          component.set("v.CaseObj.RecordTypeId",res);
          component.set("v.recordTypeId",res);
          console.log('recordtype'+res);
       }});
      $A.enqueueAction(getpartnerCaseRecordTypeId);
        
      var getPickListVals = component.get("c.getPickListValues");
         getPickListVals.setCallback(this, function(response) {
       var state = response.getState();
       if (state === "SUCCESS") {
          var res=response.getReturnValue();
           var typeArr = [{'label':'None', 'value':''}];
           var commLangArr = [{'label':'None', 'value':''}];
           res['Type'].forEach(function(item){
               typeArr.push({'label': item, 'value': item});
           });
           res['PS_Communication_Language__c'].forEach(function(item){
               commLangArr.push({'label': item, 'value': item});
           });
         component.set("v.typeOptions", typeArr );
         component.set("v.langOptions", commLangArr);
       }});
$A.enqueueAction(getPickListVals);
      
   },
   openModel: function(component, event, helper) {
      // Set isModalOpen attribute to true
      component.set("v.isModalOpen", true);
      var caseRecordTypeId=component.get("v.recordTypeId");
      if(!component.get("v.CaseObj.RecordTypeId"))
      {
      component.set("v.CaseObj.RecordTypeId",caseRecordTypeId);
      }
       var isPartner=component.get("v.isPartneruser");
       console.log('isPartner'+isPartner);
        if(isPartner)
        {
        var val=component.get("v.userDetailsMap");
        var user=val["User"];
        var userArr=user.split(";");
        if(userArr)
        {
         component.set("v.userName",userArr[0]);
         //component.set("v.CaseObj.Country__c",userArr[1]);
         component.set("v.CaseObj.Issue_Reported_By__c",userArr[1]);
        }
        var account=val["Account"];
        var accountArr=account.split(";");
        if(accountArr)
        {
        component.set("v.accountName",accountArr[0])
        component.set("v.CaseObj.AccountId",accountArr[1]);
            
        }      
        }
        else
          {
           component.set("v.showSpinner",true) ;
           var partnerDiv=component.find("modal-content-id-2");
           var internalUserDiv=component.find("modal-content-id-3");
           var partnerUserFooter = component.find("PartnerUserFooter");
            
           $A.util.addClass(partnerDiv, "slds-hide");
           $A.util.removeClass(internalUserDiv, "slds-hide");
           $A.util.addClass(internalUserDiv, "slds-show");
               $A.util.addClass(partnerUserFooter, "slds-hide");

          }
   },
  
   closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false
      component.set("v.isModalOpen", false);
      component.set("v.CaseObj", {});
       
   },
    
   closeModalForInternal: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
      helper.resetField(component);
       
   },
  
   submitDetailsForExternal: function(component, event, helper) {
      // Set isModalOpen attribute to false
    var valid=helper.checkFieldValidityForExternal(component);
    if(valid)
    {
    component.set("v.showSpinner",true) ; 
    var caseObj=component.get("v.CaseObj");
    var createCaseAction = component.get("c.saveExternalCase");
       createCaseAction.setParams({objcase:caseObj});
       createCaseAction.setCallback(this, function(response) {
       var state = response.getState();
       if (state === "SUCCESS") {
          var res=response.getReturnValue();
          component.set("v.CaseObj.Id",res);
          var internalUserDiv=component.find("modal-content-id-2");
          $A.util.addClass(internalUserDiv, "slds-hide");
          var fileuploadDiv=component.find("fileUpload");
          $A.util.removeClass(fileuploadDiv, "slds-hide");
          $A.util.addClass(fileuploadDiv, "slds-show");
          var partnerUserFooter = component.find("PartnerUserFooter");
          $A.util.removeClass(partnerUserFooter, "slds-show");
          $A.util.addClass(partnerUserFooter, "slds-hide");
          component.set("v.showSpinner",false) ;
         
       }
           else{
               console.log(JSON.stringify(response.getError()));
           }});
      $A.enqueueAction(createCaseAction);
    }

   },
   handleSpinner: function(component, event, helper) {

    component.set("v.showSpinner",false) ;    
   },
   handleSuccessOnInternalCase: function(component,event,helper)
    {
    helper.resetField(component);
    var record = event.getParam("response");;
    component.set("v.CaseObj.Id",record.id);
    component.set("v.showSpinner",false) ; 
    var internalUserDiv=component.find("modal-content-id-3");
    $A.util.addClass(internalUserDiv, "slds-hide");
    var fileuploadDiv=component.find("fileUpload");
    $A.util.removeClass(fileuploadDiv, "slds-hide");
    $A.util.addClass(fileuploadDiv, "slds-show");        
    
    },
    handleUploadFinished: function(component,event,helper)
    {
    component.set("v.isModalOpen", false);
    component.set("v.CaseObj", {});
         var refreshListView = component.getEvent('refreshListView');
          refreshListView.fire();
    },
    
    closeFileModal : function(component,event,helper)
    {
      component.set("v.isModalOpen", false);
      component.set("v.CaseObj", {});
      var refreshListView = component.getEvent('refreshListView');
      refreshListView.fire();
    },   
     showSpinner : function(component,event,helper)
    {
        component.set("v.showSpinner",true) ; 
    },
    handleError : function(component,event,helper){
        component.set("v.showSpinner",false) ; 
        console.log('Error'+JSON.stringify(event.getParam('error')));
    },
    handleInternalSubmit: function(component,event,helper)
    {
    event.preventDefault();
    component.set("v.showSpinner",true) ;  
    component.find("recordEditForm").submit();   
    }
   
})