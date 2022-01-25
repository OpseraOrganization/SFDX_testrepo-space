({
	navigateToNDA : function(component,event,helper) {
        var focId;
        var workspaceAPI = component.find("workspace");
		var caseId = component.get("v.recordId");
        var urlIs= component.get("v.ndaUrl");
        var ndaAlreadyOpen = false;
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            //console.log(JSON.stringify(response));
            for(var i=0;i<response.subtabs.length;i++)
            {
                if(response.subtabs[i].title=='Nokia Digital Assistance')
                {
                   focId=  response.subtabs[i].tabId;
                    workspaceAPI.focusTab({tabId : focId});
                    ndaAlreadyOpen = true;
                    break;
				}
            }
        	if(ndaAlreadyOpen !== true)
			{  
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
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            //console.log(JSON.stringify(response));
            for(var i=0;i<response.subtabs.length;i++)
            {
               // console.log('Tabid'+JSON.stringify(response.subtabs[i].tabId)+'Title'+JSON.stringify(response.subtabs[i].title));
                if(response.subtabs[i].title=='NCIB')
                {
                   focId=  response.subtabs[i].tabId;
                    workspaceAPI.focusTab({tabId : focId});
                    ncibAlreadyOpen = true;
                    break;
                   
				}
            }
        	if(ncibAlreadyOpen !== true)
        {  
        workspaceAPI.getEnclosingTabId().then(function(tabId) 
        {
            return workspaceAPI.openSubtab({
                parentTabId: tabId,
                recordId: caseId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__CH_NokiaNCIBLogin"
                    },
                    "state": {
                        "c__ncibUR": ncibUr
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
            console.log('Error logged for CH_NokiaNCIBLogin'+error);
        });
    }    
        })
        .catch(function(error) {
            console.log('my code'+error);
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
            
            for(var i=0;i<response.subtabs.length;i++)
            {
                if(response.subtabs[i].title=='FIR')
                {
                   focId=  response.subtabs[i].tabId;
                    workspaceAPI.focusTab({tabId : focId});
                    ndaAlreadyOpen = true;
                    break;
				}
            }
        	if(ndaAlreadyOpen !== true)
			{  
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
            console.log('Error in launching FIR'+error);
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
            
            for(var i=0;i<response.subtabs.length;i++)
            {
                if(response.subtabs[i].title=='Case Closure Report')
                {
                   focId=  response.subtabs[i].tabId;
                    workspaceAPI.focusTab({tabId : focId});
                    ndaAlreadyOpen = true;
                    break;
				}
            }
        	if(ndaAlreadyOpen !== true)
			{  
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
            console.log('Error in launching CCR'+error);
        });
			}    
        })
        .catch(function(error) {
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