({
    getDPonLoad: function(component, event, helper) {
         component.set('v.BenchMarkingFileURL',0); 
         component.set('v.UseCaseFileURL',0);
         component.set('v.MapViewFileURL',0);
         component.set('v.FeatureDetailsFileURL',0);
         component.set('v.InstructionsURL',0);
        // get the fields API name and pass it to helper function  
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldAPI = component.get("v.dependingFieldAPI");
        var objDetails = component.get("v.objDetail");
          helper.getEntitlementinfo(component,event,helper);
        	//alert('Call getTypeinfo method');
		 helper.getTypeinfo(component,event,helper);
         helper.getTechnologyHelper(component,event,helper,objDetails,controllingFieldAPI, dependingFieldAPI);
        
     }, 
    
    loadUseCase: function(component, event, helper) {
        
        var techselectedValue = component.find("tech").get("v.value");

        var newaction = component.get("c.getUseCaseOnTechnology");
        newaction.setParams({
			'selectedTechnology' : techselectedValue,			
		});
        newaction.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();  
                
                component.set("v.usecase", StoreResponse);
                // window.setTimeout(
                $A.getCallback( function() {
                    // Now set our preferred value
                    component.find("usecase1").set("v.value",'---None---');
                    component.set("v.selectedUsecaseCache",'---None---');
                });//);
                
            }
        });
         $A.enqueueAction(newaction);
    },
    
   
  onControllerFieldChange: function(component, event, helper) {     
        var controllerValueKey = component.find("tech").get("v.value");
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
       
        if (controllerValueKey != '--- None ---') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.getUseCasehelper(component, event,helper, ListOfDependentFields);    
            }
            else{
                component.set("v.bDisabledDependentFld" , false); 
                component.set("v.usecase", ['--- None ---']);
            }  
            
             } else {
            component.set("v.usecase", ['--- None ---']);
            component.set("v.bDisabledDependentFld" , false);
        }
    },
    
    filterDP: function(component, event, helper) {
     helper.filterDPHelper(component, event, helper);
     
     $A.get('e.force:refreshView').fire();
     
     
       
        
	},
     // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    },
    OpenPage: function(component, event, helper) {
    	var Id = event.getSource().get("v.name");
        
         var navEvt = $A.get("e.force:navigateToSObject");
    navEvt.setParams({
      "recordId": Id,
    });
    navEvt.fire();
        
     /*
      var urlEvent = $A.get("e.force:navigateToURL");
               var link = window.location.pathname;

      	//"url": link+"feedback",
    	urlEvent.setParams({
      		"url":"/swx-upsell-proposal/"+Id+"?type=DP",   //"/swx-upsell-proposal/"+Id+"?type=DP",
    	});
    	urlEvent.fire();
        */
   	},
    /*sortProposalName: function(component, event, helper) {
          var showbutton=component.get("v.showbutton");
         if(showbutton){
       component.set("v.selectedTabsoft", 'Name');
       helper.sortHelper(component, event, 'Analytics_File_Refer_ID__c');
         }
    },
    
    
     sortProposalRecommendationType: function(component, event, helper) {
           var showbutton=component.get("v.showbutton");
         if(showbutton){
       component.set("v.selectedTabsoft", 'RecommendationType');
       helper.sortHelper(component, event, 'Proposal_Recommendation_Type__c');
         }
    },
    */
    sortProposalStatus: function(component, event, helper) {
          var showbutton=component.get("v.showbutton");
         if(showbutton){
       component.set("v.selectedTabsoft", 'Status');
       helper.sortHelper(component, event, 'Proposal_Status__c');
         }
    },
     sortProposalId: function(component, event, helper) {
        var showbutton=component.get("v.showbutton");
         if(showbutton){
       component.set("v.selectedTabsoft", 'ProposalID');
       helper.sortHelper(component, event, 'Name');
         }
        
    },
 
    sortCreationDate: function(component, event, helper) {
          var showbutton=component.get("v.showbutton");
         if(showbutton){
       component.set("v.selectedTabsoft", 'CreationDate');
       helper.sortHelper(component, event, 'Creation_Date__c');
         }
    },
     
    sorttechnology: function(component, event, helper) {
          var showbutton=component.get("v.showbutton");
         if(showbutton){
       component.set("v.selectedTabsoft", 'Technology');
       helper.sortHelper(component, event, 'Technology__c');
         }

    },
    sortusecase: function(component, event, helper) {
          var showbutton=component.get("v.showbutton");
         if(showbutton){
       component.set("v.selectedTabsoft", 'usecase');
       helper.sortHelper(component, event, 'Use_Case__c');
         }

    },
    sortEntitlementinfo: function(component, event, helper) {
          var showbutton=component.get("v.showbutton");
         if(showbutton){
       component.set("v.selectedTabsoft", 'EntitlementInfo');
       helper.sortHelper(component, event, 'Entitlement_Info__c');
         }
    },
    sortTypeinfo: function(component, event, helper) {
          var showbutton=component.get("v.showbutton");
         if(showbutton){
       component.set("v.selectedTabsoft", 'TypeInfo');
       helper.sortHelper(component, event, 'Recommendation_Type__c');
         }
    },
    sortcollectiondates: function(component, event, helper) {
         var showbutton=component.get("v.showbutton");
         if(showbutton){
       component.set("v.selectedTabsoft", 'collectiondates');
       helper.sortHelper(component, event, 'Collection_Period_End_Date__c');
         } 
    },
    sortidentifiedcells: function(component, event, helper) {
          var showbutton=component.get("v.showbutton");
         if(showbutton){
       component.set("v.selectedTabsoft", 'Identifiedcells');
       helper.sortHelper(component, event, 'Identified_Cells__c');
         }
    },
     sortscope: function(component, event, helper) {
         var showbutton=component.get("v.showbutton");
         if(showbutton){
       component.set("v.selectedTabsoft", 'Scope');
       helper.sortHelper(component, event, 'Analysed_Cells__c');
         }

    },
    next: function (component, event, helper) {
     helper.next(component, event);
   },
    previous: function (component, event, helper) {
     helper.previous(component, event);
   }
    
})