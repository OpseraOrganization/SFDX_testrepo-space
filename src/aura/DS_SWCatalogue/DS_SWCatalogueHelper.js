({
    
    getTechnologyHelper : function(component,event,helper,objDetails,controllerField, dependentField){
          //('Inside getTechnologyHelper');
		//Below code will load the technology value.
			var newaction = component.get("c.getTechnologies");
            
			newaction.setCallback(this, function(response) {
				var state = response.getState();
				
				if (response.getState() === "SUCCESS") {
					//store the return response from server (map<string,List<string>>)  
					var StoreResponse = response.getReturnValue();
				  
					component.set("v.technology", StoreResponse);
                    
                     window.setTimeout(
                			$A.getCallback( function() {
                   			 // Now set our preferred value
                    		
                            //below code will check for the Status Value. If it exists in the cachae , then will update it to cachae value.
							if(window.localStorage.getItem("v.selectedTechCataloguecache") === undefined || window.localStorage.getItem("v.selectedTechCataloguecache") ===null &&  window.localStorage.getItem("v.selectedTechCataloguecache") ===''){

							}
							else{
							   component.set("v.selectedTechCataloguecache",localStorage.getItem("v.selectedTechCataloguecache"));
							   component.find("Technology").set("v.value", localStorage.getItem("v.selectedTechCataloguecache"));
                            }
                            //alert('Inside set time out Selected Tech Value'+component.find("tech").get("v.value"));
							
							//Below Code will load the usecase values. 
							var selectedTechnologyValue = component.find("Technology").get("v.value");
							//alert('Selected Technology onload'+selectedTechnologyValue);
							if(selectedTechnologyValue == '---None---') {
								 component.set("v.selectedUseCaseCataloguecache",'---None---');
							}
							//else {
									var newactionUsecase = component.get("c.getUseCaseOnTechnology");
									newactionUsecase.setParams({
										'selectedTechnology' : selectedTechnologyValue,			
									});
									newactionUsecase.setCallback(this, function(response) {
									state = response.getState();
                                        
									if (response.getState() === "SUCCESS") {
									//store the return response from server (map<string,List<string>>)  
										var StoreResponse = response.getReturnValue();  
										component.set("v.useCase", StoreResponse);
										
										 window.setTimeout(
											$A.getCallback( function() {
												
												if(window.localStorage.getItem("v.selectedUseCaseCataloguecache") === undefined || window.localStorage.getItem("v.selectedUseCaseCataloguecache") ===null &&  window.localStorage.getItem("v.selectedUseCaseCataloguecache") ===''){

												}
												else{
													component.set("v.selectedUseCaseCataloguecache",localStorage.getItem("v.selectedUseCaseCataloguecache"));
													component.find("useCase").set("v.value", localStorage.getItem("v.selectedUseCaseCataloguecache"));
												}
																								
											}));
										
									  if((window.localStorage.getItem("v.selectedTechCataloguecache")!== null &&window.localStorage.getItem("v.selectedTechCataloguecache")!== '' && window.localStorage.getItem("v.selectedTechCataloguecache").length > 0 )
									   ||
									   (window.localStorage.getItem("v.selectedUseCaseCataloguecache")!== null &&window.localStorage.getItem("v.selectedUseCaseCataloguecache")!== '' && window.localStorage.getItem("v.selectedUseCaseCataloguecache").length > 0)
									   ||
                                        (window.localStorage.getItem("v.selectedAgreementCache")!== null &&window.localStorage.getItem("v.selectedAgreementCache")!== '' && window.localStorage.getItem("v.selectedAgreementCache").length > 0) 
                                       ||
                                        (window.localStorage.getItem("v.selectedPOcache")!== null &&window.localStorage.getItem("v.selectedPOcache")!== '' && window.localStorage.getItem("v.selectedPOcache").length > 0) 
                                        ||
                                         (window.localStorage.getItem("v.selectedStatusCatalogueCache")!== null &&window.localStorage.getItem("v.selectedStatusCatalogueCache")!== '' && window.localStorage.getItem("v.selectedStatusCatalogueCache").length > 0) 
                                        ) {
											//alert('This will call the Filter DP Record');
											// This will call the automated Search fucntionality.
												var techselectedValue = window.localStorage.getItem("v.selectedTechCataloguecache") ;
												var useCaseselectedValue = window.localStorage.getItem("v.selectedUseCaseCataloguecache");
												var agreementselectedValue = window.localStorage.getItem("v.selectedAgreementCache");		
                                          		var poselectedValue = window.localStorage.getItem("v.selectedPOcache");
												var sinselectedValue = window.localStorage.getItem("v.selectedStatusCatalogueCache");
                                          		
                                                //var statusSelectedValue = window.localStorage.getItem("v.selectedStatusCache");
												//alert('Technology value before passing to filter'+techselectedValue);
												//alert('useCaseselectedValue value before passing to filter'+useCaseselectedValue);
												//alert('statusSelectedValue value before passing to filter'+statusSelectedValue);
												var newFilteraction = component.get("c.getFeature");

													newFilteraction.setParams({
														
                                                        "agreement": agreementselectedValue,
                                                        "poNum": poselectedValue,
                                                        "tech": techselectedValue,
														"uCase": useCaseselectedValue,
                                                        "sin": sinselectedValue
                                                        
														//"statusInfo": statusSelectedValue
													});
													newFilteraction.setCallback(this, function(response) {
														var state = response.getState();
														//alert('*****Total Number of Record Count********'+ response.getReturnValue().length);
														if (response.getState() == "SUCCESS") {
															var pageSize = component.get("v.pageSize");

															// hold all the records into an attribute named "DPData"
															component.set('v.DPData', response.getReturnValue());
															// get size of all the records and then hold into an attribute "totalRecords"
															component.set("v.totalRecords", component.get("v.DPData").length);
															// set star as 0
															//alert('***Total number of Records ****'+component.get("v.DPData").length)
                                                            component.set("v.startPage",0);

															component.set("v.endPage",pageSize-1);
															var PaginationList = [];
															for(var i=0; i< pageSize; i++){
																if(component.get("v.DPData").length> i)
																	PaginationList.push(response.getReturnValue()[i]);    
															}
															component.set('v.contents', PaginationList);
															component.set('v.isSending',false);
														}
													});
													$A.enqueueAction(newFilteraction); 
										}	
									}
									else {
										
									}
								});
								$A.enqueueAction(newactionUsecase);  
							//}
									
									
						}));
					
				}	
				
			});
			$A.enqueueAction(newaction);
        },

	 getAgreementHelper : function(component, event, helper){
        var newaction = component.get("c.getFrameContractReference");
             newaction.setCallback(this, function(response) {
             var state = response.getState();
             if (response.getState() === "SUCCESS") {
                    var returnStringVal = response.getReturnValue();    
                    component.set("v.FrameContractRef",returnStringVal);
					
					var agreementselectedValue = window.localStorage.getItem("v.selectedAgreementCache");
				 	//alert('****Agreement Selected value from cachae***'+agreementselectedValue);	
                 
                 window.setTimeout(
                    $A.getCallback( function() {
                        // Now set our preferred value
                        if(window.localStorage.getItem("v.selectedAgreementCache") === undefined || window.localStorage.getItem("v.selectedAgreementCache") ===null &&  window.localStorage.getItem("v.selectedAgreementCache") ===''){
                            
                        }
                        else{
                            component.set("v.selectedAgreementCache",localStorage.getItem("v.selectedAgreementCache"));
                            component.find("agreement").set("v.value", localStorage.getItem("v.selectedAgreementCache"));
                        }
                }));
                 
                 
                 
               
			   }
            });
            $A.enqueueAction(newaction);
        },
    
        getPOHelper : function(component, event, helper){ 
             var newaction = component.get("c.getPO");
             newaction.setCallback(this, function(response) {
                var state = response.getState();
                if (response.getState() === "SUCCESS") {
                    var returnStringVal = response.getReturnValue();    
                    component.set("v.PO",returnStringVal);
                    
                    /*window.setTimeout(
                        $A.getCallback( function() {
                        var poselectedValue = window.localStorage.getItem("v.selectedPOcache");
                  //  alert('***poselectedValue from cachae*****'+ poselectedValue);
					if(window.localStorage.getItem("v.selectedPOcache") === undefined || window.localStorage.getItem("v.selectedPOcache") ===null &&  window.localStorage.getItem("v.selectedPOcache") ===''){

							}
							else{
							     component.set("v.selectedPOcache",localStorage.getItem("v.selectedPOcache"));
                                // Now set our preferred value
                            	component.find("cpo").set("v.value", localStorage.getItem("v.selectedPOcache"));

							}
                        }));*/
					
					
					
                  }
            });
            $A.enqueueAction(newaction);
        },
    fetchPicklistValues: function(component,objDetails,controllerField, dependentField) {
     		var newaction = component.get("c.getTechnologies");
             
			newaction.setCallback(this, function(response) {
				var state = response.getState();
				
				if (response.getState() === "SUCCESS") {
					//store the return response from server (map<string,List<string>>)  
					var StoreResponse = response.getReturnValue();
				  
					//component.set("v.Technology", StoreResponse);
                }
            });
        $A.enqueueAction(newaction);
    },
    
    fetchDepValues: function(component, ListOfDependentFields) {
        // create a empty array var for store dependent picklist values for controller field  
        var dependentFields = [];
        dependentFields.push('--- None ---');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set("v.listDependingValues", dependentFields);
        
    },
     filterDPHelper: function(component, event, helper) {
      //  alert('*******inside filterdphelper***'+window.localStorage.getItem('v.selectedAgreementCache'));
         if(window.localStorage.getItem('v.selectedAgreementCache')!= null && window.localStorage.getItem('v.selectedAgreementCache').length > 0){
          var agreement = window.localStorage.getItem('v.selectedAgreementCache');
         }else{
              var agreement = component.find("agreement").get("v.value");
         }
       //  alert('*******inside filterdphelperagreement***'+agreement);
         if(window.localStorage.getItem('v.selectedPOcache')!= null && window.localStorage.getItem('v.selectedPOcache').length > 0){
          var po = window.localStorage.getItem('v.selectedPOcache');
         }else{
              var po = component.find("cpo").get("v.value");
         }
         
          if(window.localStorage.getItem('v.selectedTechCataloguecache')!= null && window.localStorage.getItem('v.selectedTechCataloguecache').length > 0){
          var tech = window.localStorage.getItem('v.selectedTechCataloguecache');
         }else{
              var tech = component.find("Technology").get("v.value");
         }
         
          if(window.localStorage.getItem('v.selectedUseCaseCataloguecache')!= null && window.localStorage.getItem('v.selectedUseCaseCataloguecache').length > 0){
          var ucase = window.localStorage.getItem('v.selectedUseCaseCataloguecache');
         }else{
              var ucase = component.find("useCase").get("v.value"); 
         }
         
         if(window.localStorage.getItem('v.selectedStatusCatalogueCache')!= null && window.localStorage.getItem('v.selectedStatusCatalogueCache').length > 0){
          var sin = window.localStorage.getItem('v.selectedStatusCatalogueCache');
         }else{
              var sin = component.find("SIN").get("v.value"); 
         }
     /*   
          var po = component.find("cpo").get("v.value"); 
           var tech = component.find("Technology").get("v.value"); 
           var ucase = component.find("useCase").get("v.value"); 
           var sin = component.find("SIN").get("v.value"); */
        
         // alert('agreement=--->'+agreement)
         // alert('po=--->'+po)
         // alert('tech=--->'+tech)
        //  alert('ucase=--->'+ucase)
         
        
              var actionstatusDetails = component.get("c.getFeature"); 
              actionstatusDetails.setParams({
                "agreement": agreement,
                "poNum": po,
                "tech": tech,
                "uCase": ucase,
                "sin": sin
            });
            actionstatusDetails.setCallback(this, function(response) {
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
    showSpinner: function (component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    hideSpinner: function (component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    next : function(component, event){
        var sObjectList = component.get("v.DPData");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++){
            if(sObjectList.length > i){
                Paginationlist.push(sObjectList[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.contents', Paginationlist);
    },
    /*
     * Method will be called when use clicks on previous button and performs the 
     * calculation to show the previous set of records
     */
    previous : function(component, event){
        var sObjectList = component.get("v.DPData");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                Paginationlist.push(sObjectList[i]);
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.contents', Paginationlist);
    }
    
})