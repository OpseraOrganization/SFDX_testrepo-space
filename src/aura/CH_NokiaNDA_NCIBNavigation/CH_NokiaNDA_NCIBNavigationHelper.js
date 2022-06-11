({
    navigateToNDA : function(component,event,helper) { 
        var focId;
        var workspaceAPI = component.find("workspace");
        var caseId = component.get("v.recordId");
        var urlIs= component.get("v.ndaUrl");
        var ndaAlreadyOpen = false;
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;           
            if(response.isSubtab)
            {
                return workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__recordPage",
                        "attributes": {                               
                            "recordId": caseId,
                            "actionName":"view"
                        },
                        "state": { }
                    },
                    focus: true,
                    overrideNavRules: true
                }).then(function(response) {
                    var focusedParentTabId = response;
                    workspaceAPI.openSubtab({
                        parentTabId: response,
                        recordId: caseId,
                        pageReference: {
                            "type": "standard__component",
                            "attributes": {
                                "componentName": "c__CH_NokiaNDALogin",
                                "customtitle":"Nokia Digital Assistance",
                                "title":"Nokia Digital Assistance"
                            },
                            "state": {
                                "c__ndaUR": urlIs,
                                "c_ParentTab":focusedTabId
                            }
                        },
                        focus: true
                        
                    }).then(function(response) {
                         workspaceAPI.focusTab(response);
                        workspaceAPI.setTabLabel({
                            tabId: response,
                            label: "Nokia Digital Assistance"
                        });
                       
                        workspaceAPI.focusTab(response);
                      
                    })
                }).catch(function(error) {
                    console.log(error);
                });
            }
            else{
                
              
                    workspaceAPI.getEnclosingTabId().then(function(tabId) {
                        return workspaceAPI.openSubtab({
                            parentTabId: tabId,
                            recordId: caseId,
                            pageReference: {
                                "type": "standard__component",
                                "attributes": {
                                    "componentName": "c__CH_NokiaNDALogin"
                                },
                                "state": {
                                    "c__ndaUR": urlIs
                                }
                            },
                            focus: true
                        });
                    })
                    .then(function(response) {
                        var focusedTabId = response;
                        workspaceAPI.setTabLabel({
                            tabId: focusedTabId,
                            label: "Nokia Digital Assistance"
                        });
                    })
                    .catch(function(error) {
                        console.log('Error logged for CH_NokiaDigitalAssistant'+error);
                    });
              
            }
            
        })
        .catch(function(error) {
            console.log('Error is'+error);
        });
        
    },
    
	navigateToNCIB : function(component,event,helper) {
        if(component.get("v.ncibUrl")!='noValue')
        {
            var focId;
            var caseId = component.get("v.recordId");
            var ncibAlreadyOpen = false;
            var ncibUr= component.get("v.ncibUrl");
            var workspaceAPI = component.find("workspace");
            var closingTabId;
             workspaceAPI.getFocusedTabInfo().then(function(response) {
       
	   			var focusedTabId = response.tabId;  
                 closingTabId = response.tabId;  
                 var focusedParentTabId;		 
				 				 
            if(response.isSubtab)
			{   			
                
                return workspaceAPI.openTab({
                     
                    pageReference: {
                        "type": "standard__recordPage",
                        "attributes": {                               
                            "recordId": caseId,
                            "actionName":"view"
                        },
                        "state": { }
                    },
                    focus: true,
                    overrideNavRules: true
                }).then(function(response) {
                     focusedParentTabId = response;
                    workspaceAPI.openSubtab({
                        parentTabId: response,
                        recordId: caseId,
                        pageReference: {
                            "type": "standard__component",
                            "attributes": {
                                "componentName": "c__CH_NokiaNCIBLogin",
                                "customtitle":"NCIB",
                                "title":"NCIB"
                            },
                            "state": {
                                "c__ncibUR": ncibUr,
                                "c_ParentTab":focusedTabId
                            }
                        },
                        focus: true
                        
                    }).then(function(response) {
                        workspaceAPI.focusTab(response);
                        workspaceAPI.setTabLabel({
                            tabId: response,
                            label: "NCIB"
                        });
                       workspaceAPI.focusTab(response);
                       
                    })
                }).catch(function(error) {
                    console.log(error);
                });   
			
            
            }//ifsubtab 
			else{               
                  
                    workspaceAPI.getEnclosingTabId().then(function(tabId) {
                        return workspaceAPI.openSubtab({
                            parentTabId: tabId,
                            recordId: caseId,
                            pageReference: {
                                "type": "standard__component",
                                "attributes": {
                                    "componentName": "c__CH_NokiaNCIBLogin"
                                },
                                "state": {
                                    "c__ncibUR": ncibUr,
                                }
                            },
                            focus: true
                        });
                    })
                    .then(function(response) {
                        var focusedTabId = response;
                        workspaceAPI.setTabLabel({
                            tabId: focusedTabId,
                            label: "NCIB"
                        });
                    })
                    .catch(function(error) {
                        console.log('Error logged for NCIB'+error);
                    });              
			}
			}).catch(function(error) {
                    console.log(error);
                });
		
		}
		else{
            var toastEvent = $A.get("e.force:showToast");
            var Msg='error';
    		toastEvent.setParams({
            			"title": "Error!",
                		"type" : "error",
       					 "message": "The NCIB URL could not be identified as either NCIB Url or the country value on the case is blank"
    					});
    				toastEvent.fire();
        }
		
	},
     
    navigateToFIR : function(component,event,helper) {
        var focId;
        var workspaceAPI = component.find("workspace");
        var caseId = component.get("v.recordId");
        var urlIs= component.get("v.firUrl");
        var ndaAlreadyOpen = false;
        workspaceAPI.getFocusedTabInfo().then(function(response) {           
            var focusedTabId = response.tabId;  
              if(response.isSubtab)
            {
               
                    return workspaceAPI.openTab({
					pageReference: {
                        "type": "standard__recordPage",
                        "attributes": {                               
                            "recordId": caseId,
                            "actionName":"view"
                        },
                        "state": { }
                    },
					focus: true,
                    overrideNavRules: true
                }).then(function(response) {
                    var focusedParentTabId = response;
                    workspaceAPI.openSubtab({				
					
                        parentTabId: response,
                        recordId: caseId,
                        pageReference: {
                            "type": "standard__component",
                            "attributes": {
                                "componentName": "c__CH_FIRLogin",
								 "customtitle":"FIR",
                                "title":"FIR"
                            },
                            "state": {
                                "c__firURI": urlIs,
								"c_ParentTab":focusedTabId
                            }
                        },
                        focus: true
                    });
                })
                .then(function(response) {
					workspaceAPI.focusTab(response);					
                    workspaceAPI.setTabLabel({
                        tabId: response,
                        label: "FIR"
                    });
					 workspaceAPI.focusTab(response);
                })
                .catch(function(error) {
                    console.log('Error in launching FIR'+error);
                });
            }
			else{             
               
                    workspaceAPI.getEnclosingTabId().then(function(tabId) {
                        return workspaceAPI.openSubtab({
                            parentTabId: tabId,
                            recordId: caseId,
                            pageReference: {
                                "type": "standard__component",
                                "attributes": {
                                    "componentName": "c__CH_FIRLogin"
                                },
                                "state": {
                                    "c__firURI": urlIs
                                }
                            },
                            focus: true
                        });
                    })
                    .then(function(response) {
                        var focusedTabId = response;
                        workspaceAPI.setTabLabel({
                            tabId: focusedTabId,
                            label: "FIR"
                        });
                    })
                    .catch(function(error) {
                        console.log('Error logged for FIR'+error);
                    });
               
            }
            
        })
        .catch(function(error) {
            console.log('Error is'+error);
        });
        
       
    },
    navigateToCaseClosureReport : function(component,event,helper) {
        var focId;
        var workspaceAPI = component.find("workspace");
        var caseId = component.get("v.recordId");
        var urlIs= component.get("v.caseClosureUrl");
        var ndaAlreadyOpen = false;
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            
            var focusedTabId = response.tabId;
			if(response.isSubtab)
            {  
              return workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__recordPage",
                        "attributes": {                               
                            "recordId": caseId,
                            "actionName":"view"
                        },
                        "state": { }
                    },
                    focus: true,
                    overrideNavRules: true
                }).then(function(response) {
                    var focusedParentTabId = response;
                    workspaceAPI.openSubtab({
                        parentTabId: response,
                        recordId: caseId,
                        pageReference: {
                            "type": "standard__component",
                            "attributes": {
                                "componentName": "c__CH_CaseClosureReport",
                                "customtitle":"Case Closure Report",
                                "title":"Case Closure Report"
                            },
                            "state": {
                                "c__ccrURI": urlIs,
                                "c_ParentTab":focusedTabId
                            }
                        },
                        focus: true
						
					}).then(function(response) {
                    
					workspaceAPI.focusTab(response);
                    workspaceAPI.setTabLabel({
                        tabId: response,
                        label: "Case Closure Report"
                    });
					workspaceAPI.focusTab(response);
                   })
                }).catch(function(error) {
                    console.log(error);
                });
            }
			else{               
                                  
                    workspaceAPI.getEnclosingTabId().then(function(tabId) {
                        return workspaceAPI.openSubtab({
                            parentTabId: tabId,
                            recordId: caseId,
                            pageReference: {
                                "type": "standard__component",
                                "attributes": {
                                    "componentName": "c__CH_CaseClosureReport"
                                },
                                "state": {
                                    "c__ccrURI": urlIs
                                }
                            },
                            focus: true
                        });
                    })
                    .then(function(response) {
                        var focusedTabId = response;
                        workspaceAPI.setTabLabel({
                            tabId: focusedTabId,
                            label: "Case Closure Report"
                        });
                    })
                    .catch(function(error) {
                        console.log('Error logged for CaseClosureReport'+error);
                    });
               
            }
         }).catch(function(error) {
            console.log('Error is'+error);
        });
        
    },
    enableFIR: function(component, event, helper) {
        var caseId = component.get("v.recordId");
        var action = component.get("c.getCaseDetails");
        action.setParams({ caseId : caseId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state is'+state);
            if (state === "SUCCESS") {
                component.set("v.disableFir",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})