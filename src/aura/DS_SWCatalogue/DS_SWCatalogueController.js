({
	getPicklistValueonLoad : function(component, event, helper) {
       helper.getAgreementHelper(component, event, helper);
       helper.getPOHelper(component, event, helper);
        
        // get the fields API name and pass it to helper function  
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldAPI = component.get("v.dependingFieldAPI");
        var objDetails = component.get("v.objDetail");
        // call the helper function
     //helper.fetchPicklistValues(component,objDetails,controllingFieldAPI, dependingFieldAPI);
     helper.filterDPHelper(component, event, helper);
     helper.getTechnologyHelper(component,event,helper,objDetails,controllingFieldAPI, dependingFieldAPI);
   
   },
    loadUseCase: function(component, event, helper) {
        
        var techselectedValue = component.find("Technology").get("v.value");
        var newaction = component.get("c.getUseCaseOnTechnology");
        newaction.setParams({
			'selectedTechnology' : techselectedValue,			
		});
        newaction.setCallback(this, function(response) {
            
            if (response.getState() === "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();  
                
                component.set("v.useCase", StoreResponse);
                 window.setTimeout(
                $A.getCallback( function() {
                    // Now set our preferred value
                  	
                    component.find("useCase").set("v.value",'---None---');
                    component.set("v.selectedUseCaseCataloguecache",'---None---');
                }));
                
            }
        });
         $A.enqueueAction(newaction);
    },
     onControllerFieldChange: function(component, event, helper) {     
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
       // alert('controllerValueKey=--->'+controllerValueKey) 
        if (controllerValueKey != '--- None ---') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                //helper.getUseCasehelper(component, event,helper, ListOfDependentFields);  
            }else{
                component.set("v.bDisabledDependentFld" , false); 
                component.set("v.listDependingValues", ['--- None ---']);
            }  
            
        } else {
            component.set("v.listDependingValues", ['--- None ---']);
            component.set("v.bDisabledDependentFld" , false);
        }
    },
    OpenPage: function(component, event, helper) {
    	var Id = event.getSource().get("v.name");
     	var urlEvent = $A.get("e.force:navigateToURL");
    	urlEvent.setParams({
      		"url": "/swx-upsell-proposal/"+Id+"?type=RMP",
    	});
    	urlEvent.fire();
   	},
    filterDP: function(component, event, helper) {
        
          
           var agreement = component.find("agreement").get("v.value"); 
           var po = component.find("cpo").get("v.value"); 
           var tech = component.find("Technology").get("v.value"); 
           var ucase = component.find("useCase").get("v.value"); 
           var sin = component.find("SIN").get("v.value");
           
            if(agreement.length >0) {
                window.localStorage.setItem('v.selectedAgreementCache',agreement);
            }
            else {
                 window.localStorage.setItem('v.selectedAgreementCache','');
                
            }
        	
            if(po.length >0) {
                window.localStorage.setItem('v.selectedPOcache',po);
            }
            else {
                window.localStorage.setItem('v.selectedPOcache','');
                
            }
        
            if(tech.length >0) {
                window.localStorage.setItem('v.selectedTechCataloguecache',tech);
            }
            else {
                window.localStorage.setItem('v.selectedTechCataloguecache','---None---');
                
            }
            if(ucase.length >0) {
                window.localStorage.setItem('v.selectedUseCaseCataloguecache',ucase);
            }
            else {
                window.localStorage.setItem('v.selectedUseCaseCataloguecache','---None---');
                
            }
        
            if(sin.length >0) {
                window.localStorage.setItem('v.selectedStatusCatalogueCache',sin);
            }
            else {
                window.localStorage.setItem('v.selectedStatusCatalogueCache','');
                
            }
		 
			
          $A.get('e.force:refreshView').fire();
        
   
        var actionstatusDetails = component.get("c.getFeature"); 
              actionstatusDetails.setParams({
                "agreement": agreement,
                "poNum": po,
                "tech": tech,
                "uCase": ucase,
                "sin": sin
            });
            actionstatusDetails.setCallback(this, function(response) {
                //alert('*******response.getReturnValue()*********'+response.getReturnValue().length);
                var pageSize = component.get("v.pageSize");
                component.set('v.DPData', response.getReturnValue());
                component.set("v.totalRecords", component.get("v.DPData").length);
                component.set("v.startPage",0);
					component.set("v.endPage",pageSize-1);
                
                var PaginationList = [];
					for(var i=0; i< pageSize; i++){
					if(component.get("v.DPData").length> i)
						PaginationList.push(response.getReturnValue()[i]);    
					}

            component.set('v.contents',PaginationList);
                
            var contacts = component.get("v.contents");//Getting Map and Its value      
           
          });
            $A.enqueueAction(actionstatusDetails); 
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
    next: function (component, event, helper) {
     helper.next(component, event);
   },
    previous: function (component, event, helper) {
     helper.previous(component, event);
   }
    
    
})