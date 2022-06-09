({
    doInit:function(component,event,helper){
     
   helper.picklistValues(component,event);
	 if(component.get("v.rId")!=null){
            component.set("v.requiredField", true);
        }else{
             component.set("v.requiredField", false);
        }        
    },
  
	keyPressController : function(component, event, helper) {
      // get the search Input keyword   
		var getInputkeyWord = component.get("v.SearchKeyWord");
        var getselectProduct =component.get("v.ProductDisplay");
        console.log('getselectProduct'+getselectProduct);
        
   //   var compEvent=component.getEvent("oSelectedAccountEvent");
   //   compEvent.setParams({"accountByEvent" : getselectProduct });  
    // fire the event  
      //   compEvent.fire();
      // check if getInputKeyWord size id more then 0 then open the lookup result List and 
      // call the helper 
      // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
             var forOpen = component.find("searchRes");
               $A.util.addClass(forOpen, 'slds-is-open');
               $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
             var forclose = component.find("searchRes");
               $A.util.addClass(forclose, 'slds-is-close');
               $A.util.removeClass(forclose, 'slds-is-open');
          }
         
	},
  
  // function for clear the Record Selaction 
    clear :function(component,event,heplper){
      
         var pillTarget = component.find("lookup-pill");
         var lookUpTarget = component.find("lookupField"); 
        
         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');
        
         $A.util.addClass(lookUpTarget, 'slds-show');
         $A.util.removeClass(lookUpTarget, 'slds-hide');
      
         component.set("v.SearchKeyWord",null);
         component.set("v.listOfSearchRecords", null );
    },
    
  // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
     
    // get the selected Account record from the COMPONETN event 	 
       var selectedAccountGetFromEvent = event.getParam("accountByEvent");
	   
	   component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
        
         var checkingunit =component.get("v.selectedRecord");
       // alert('picklist checkingunit'+checkingunit);
         var selectingunit =component.get("v.productUnitsdata");
        //alert('selectingunit'+selectingunit);
        // alert(JSON.stringify(checkingunit.Unit__c ));
         var cmpEvent = component.getEvent("CH_ProductDisplayEvent");
                cmpEvent.setParams({
                    "SelectedUnitId" :checkingunit.Unit__c,
                    "showSection" :2
                   
                });
                cmpEvent.fire();
       
        var forclose = component.find("lookup-pill");
           $A.util.addClass(forclose, 'slds-show');
           $A.util.removeClass(forclose, 'slds-hide');
      
        
        var forclose = component.find("searchRes");
           $A.util.addClass(forclose, 'slds-is-close');
           $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');  
      
	},
  // automatically call when the component is done waiting for a response to a server request.  
    hideSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();    
    },
 // automatically call when the component is waiting for a response to a server request.
    showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();    
    },
    
  onChange: function(component, event, helper) {
        // get the value of select option
      //  alert('@@@@'+event.getSource().get("v.value"));
      console.log(component.find("select").get("v.value"));
      var valueofpicklist = component.find("select").get("v.value");
      //alert(' valueofpicklist @@'+valueofpicklist);
       var cmpEvent = component.getEvent("CH_ProductDisplayEvent");
                cmpEvent.setParams({
                    "PicklistUnitId" :valueofpicklist,
                    "showSection" :3
                   
                });
                cmpEvent.fire();
      
     component.set("v.errorMessageShow",false);

    }
    
})