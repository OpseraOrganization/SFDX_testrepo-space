({
   onfocus : function(component,event,helper){
       $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
         var getInputkeyWord = '';
         var selectedContractLineItem = component.get("v.selectedContractLineItem");
         helper.searchHelper(component,event,getInputkeyWord,selectedContractLineItem);
    },
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        var accountRetro = component.find("accountretroId"); 
         $A.util.addClass(accountRetro, 'slds-hide');
    },
    keyPressController : function(component, event, helper) {
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        var selectedContractLineItem = component.get("v.selectedContractLineItem");
       // check if getInputKeyWord size id more then 0 then open the lookup result List and 
       // call the helper 
       // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
             var forOpen = component.find("searchRes");
               $A.util.addClass(forOpen, 'slds-is-open');
               $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord, selectedContractLineItem);
        }
        else{  
             component.set("v.listOfSearchRecords", null ); 
             var forclose = component.find("searchRes");
               $A.util.addClass(forclose, 'slds-is-close');
               $A.util.removeClass(forclose, 'slds-is-open');
          }
        helper.loadCountryList(component,event);
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
         component.set("v.selectedRecord", {} ); 
         component.set("v.CountryDisabled",true);
		 component.set("v.selecteCountryList", ""); 
        var compEvent = component.getEvent("sampleComponentEvent");
        compEvent.setParams({
            "selectedCountry" : '',
            "selectedAccountId":  '',
			"selectedAccountName": ''
        });
        compEvent.fire();
    },
    
  // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
    // get the selected Account record from the COMPONETN event 	 
       var selectedAccountGetFromEvent = event.getParam("recordByEvent");
	   component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
       var selectedAccount = component.get("v.selectedRecord");
       component.set("v.selectedRetroAccountId" , component.get('v.selectedRecord').Id); 
		component.set("v.selectedCountry", ""); 
        component.set("v.selecteCountryList", ""); 
        
       var selectedId = component.get("v.selectedRetroAccountId");
       var action = component.get("c.getCountryList");
        var storeResponse;
       //console.log('storeResponse==='+JSON.stringify(storeResponse));
      // set param to method  
        action.setParams({
            'retroAccountId': selectedId
          });
      // set a callBack    
        action.setCallback(this, function(response) {
          
            var state = response.getState();
            console.log('state===='+state);
            if (state === "SUCCESS") {
                storeResponse = response.getReturnValue();
                component.set("v.selecteCountryList" , storeResponse);
                var selectedList = component.get("v.selecteCountryList");
                for (var i=0; i <selectedList.length; i++ ) {
                	var firstValue =  selectedList[0];  
                    component.set("v.selectedCountry", firstValue);
                    component.set("v.CountryDisabled",false);
                }
				if(selectedList.length == 1){
                    component.set("v.CountryDisabled",true);
                }
                var countryName = component.get("v.selectedCountry");
                var compEvent = component.getEvent("sampleComponentEvent");
				var accountName =  component.get('v.selectedRecord').HWS_Account__c != null &&  component.get('v.selectedRecord').HWS_Account__c != undefined ? component.get('v.selectedRecord').HWS_Account__r.Name: '';
                
                compEvent.setParams({
                    "selectedCountry" : countryName,
                    "selectedAccountId":  component.get('v.selectedRecord').HWS_Account__c,
					"selectedAccountName": accountName
                });
                compEvent.fire();
            }
        });
      // enqueue the Action  
        $A.enqueueAction(action);
       
        //var accountRetro = component.find("accountretroId"); 
        // $A.util.removeClass(accountRetro, 'slds-hide');
        var forclose = component.find("lookup-pill");
           $A.util.addClass(forclose, 'slds-show');
           $A.util.removeClass(forclose, 'slds-hide');
  
        var forclose = component.find("searchRes");
           $A.util.addClass(forclose, 'slds-is-close');
           $A.util.removeClass(forclose, 'slds-is-open');
        //$A.util.removeClass(forclose, 'slds-hide');
        
        var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');  
      
	},
    
    
    setCountryName:function(component, event, helper) {
        var countryName = component.get("v.selectedCountry");
        var compEvent = component.getEvent("sampleComponentEvent");
        var accountName =  component.get('v.selectedRecord').HWS_Account__c != null &&  component.get('v.selectedRecord').HWS_Account__c != undefined ? component.get('v.selectedRecord').HWS_Account__r.Name: '';
        compEvent.setParams({
            "selectedCountry" : countryName,
            "selectedAccountId" :component.get('v.selectedRecord').HWS_Account__c,
			"selectedAccountName": accountName
        });
        compEvent.fire();
        
    },
    setLookupVal:function(component, event, helper) {	
        var params = event.getParam('arguments');	
        var cName = params.CountryName;	
        var accountName = params.selectedAccountName;	
        var accId = params.accountId;	
        var tempLength = JSON.stringify(accountName).length;	
        if (tempLength > 2) {	
            var forclose = component.find("lookup-pill");	
            $A.util.addClass(forclose, 'slds-show');	
            $A.util.removeClass(forclose, 'slds-hide');	
            var forclose = component.find("searchRes");	
            $A.util.addClass(forclose, 'slds-is-close');	
            $A.util.removeClass(forclose, 'slds-is-open');	
            var lookUpTarget = component.find("lookupField");	
            $A.util.addClass(lookUpTarget, 'slds-hide');	
            $A.util.removeClass(lookUpTarget, 'slds-show');	
            var action = component.get("c.getCountryList");	
            var storeResponse;	
            action.setParams({	
                'retroAccountId': accId	
            });	
            action.setCallback(this, function(response) {	
            var state = response.getState();	
            if (state === "SUCCESS") {	
                storeResponse = response.getReturnValue();	
                component.set("v.selecteCountryList" , storeResponse);	
                component.set("v.CountryDisabled", false);	
            }	
            });	
            $A.enqueueAction(action);	
        } else {	
            component.set("v.CountryDisabled", true);	
        }	
        component.set("v.selectedRecord",accountName);	
        component.set("v.selecteCountryList",cName);	
        component.set("v.selectedCountry", cName);
    }
})