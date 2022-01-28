({
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.createProj",true);
        component.set("v.isOpen", true);
      
      
    },
    doInit : function(component, event, helper){
	
        var country= component.get("v.shippingCountry");
         
    },
    shipToPartyError : function(component, event, helper){
        var inputCmp = component.find("strNameAcc");
        //alert('inputCmp1'+inputCmp);
       inputCmp.set("v.value",null); //alert('inputCmp*'+inputCmp);
       inputCmp.set("v.errors", [{message:"Error message"}]);

      
    },
    dosearchProject : function(component,event,helper){
        
        // Get the search string, input element and the selection container
        var searchString = component.get('v.strSearchProjectName');
        
        var inputElement = component.find('strNamePilot');
        var contactList  = component.get("v.projectList");
        var lookupList   = component.find('lookuplistPilot');
        var objectName = component.get("v.objectName");
        var returnValue = component.get("v.returnValue");
        //var lookupList = component.find('lookuplist');
        
        // Clear any errors and destroy the old lookup items container
        inputElement.set('v.errors', null);
        
        // We need at least 2 characters for an effective search
        if (typeof searchString === 'undefined' || searchString.length < 3)
        {
            // Hide the lookuplist
            $A.util.addClass(lookupList, 'slds-hide');
            return;
        }
        //Show the lookuplist
        $A.util.removeClass(lookupList, 'slds-hide');
        // Create an Apex action
        var action = component.get('c.findContactListFromConsole');   //('c.getContactlistNameBased');
        // Mark the action as abortable, this is to prevent multiple events from the keyup executing
        action.setAbortable();
        //alert("searchString(setting in class)-->"+searchString);
        // Set the parameters
        action.setParams({ "searchKey" : searchString,
                          "objectName" : objectName,
                          "returnValue" : returnValue
                         });
        
        // Define the callback
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert("state-->"+state);
            // Callback succeeded
            if (component.isValid() && state === "SUCCESS")
            {
                // Get the search matches
                var projectList = response.getReturnValue();
                
                //alert(JSON.stringify(projectList));
                
                // If we have no matches, return nothing
                if (projectList.length === 0)
                {
                    component.set('v.projectList', null);
                    //component.set('v.strSearchContactName','');
                    return;
                }
                // Store the results
                component.set('v.projectList', projectList);
               // alert('**'+JSON.stringify(projectList));
                //component.set('v.contactList', contactList);
                //component.set('v.strSearchContactName','');
            }
            else if (state === "ERROR") // Handle any error by reporting it
            {
                var errors = response.getError();
                
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        //this.displayToast('Error', errors[0].message);
                        //helper.alertTostFun(component,'There is some error, please contact to System Admin.','error');
                        //helper.displayToast(component,'Deal Request',errors[0].message,'error');
                       // alert("Error-->"+errors[0].message);
                    }
                }
                else
                {
                    //this.displayToast('Error', 'Unknown error.');
                    //helper.alertTostFun(component,'There is some error, please contact to System Admin.','error');
                    //  helper.displayToast(component,'Deal Request','Unknown error.','error');
                   // alert("Error : Unknown error.");
                }
            }
        });
        
        // Enqueue the action                  
        $A.enqueueAction(action);                
        
    },
    
    dosearchShiptoParty : function(component,event,helper){
        
        // Get the search string, input element and the selection container
        var searchString = component.get('v.strSearchProjectName');
        var selectedAsset = component.get("v.SelectedAsset");
        var inputElement = component.find('strNamePilot');
        var contactList  = component.get("v.projectList");
        var lookupList   = component.find('lookuplistPilot');
        var objectName = component.get("v.objectName");
        var returnValue = component.get("v.returnValue");
        var pickupAdd = component.get("v.pickupAddr");
        var legalAccRec = component.get('v.passingAccount');		
        var jsonAcc = JSON.stringify(legalAccRec);
        // Clear any errors and destroy the old lookup items container
        inputElement.set('v.errors', null);
        
        // We need at least 2 characters for an effective search
        if (typeof searchString === 'undefined' || searchString.length < 3)
        {
            // Hide the lookuplist
            $A.util.addClass(lookupList, 'slds-hide');
            return;
        }
        //Show the lookuplist
        $A.util.removeClass(lookupList, 'slds-hide');
        // Create an Apex action
        var action = component.get('c.searchShiptoParty');   //('c.getContactlistNameBased');
        // Mark the action as abortable, this is to prevent multiple events from the keyup executing
        action.setAbortable();
        //alert("searchString(setting in class)-->"+searchString);
        // Set the parameters
        action.setParams({ "searchKey" : searchString,
                          "objectName" : objectName,
                          "returnValue" : returnValue,
                          "parentAccountValue" : component.get("v.otherValues"),
                          "addrType" : pickupAdd,
                          "selectedAsset" : selectedAsset,
                          "legalAccRec" : jsonAcc,
                          "triggeredFrom" : component.get("v.triggeredFrom"),
                          "lineItemCountry" : component.get("v.shippingCountry")
                         });
        
        // Define the callback
        action.setCallback(this, function(response) {
            var state = response.getState();
           
            // Callback succeeded
            if (component.isValid() && state === "SUCCESS")
            {
                // Get the search matches
                var projectList = response.getReturnValue();
                
                // If we have no matches, return nothing
                if (projectList.length === 0)
                {
                    component.set('v.projectList', null);
                    //component.set('v.strSearchContactName','');
                    return;
                }
                // Store the results
                component.set('v.projectList', projectList);				
                //alert('**'+JSON.stringify(projectList));
                //component.set('v.contactList', contactList);
                //component.set('v.strSearchContactName','');
            }
            else if (state === "ERROR") // Handle any error by reporting it
            {
                var errors = response.getError();
                
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        //this.displayToast('Error', errors[0].message);
                        //helper.alertTostFun(component,'There is some error, please contact to System Admin.','error');
                        //helper.displayToast(component,'Deal Request',errors[0].message,'error');
                        //alert("Error-->"+errors[0].message);
                    }
                }
                else
                {
                    //this.displayToast('Error', 'Unknown error.');
                    //helper.alertTostFun(component,'There is some error, please contact to System Admin.','error');
                    //  helper.displayToast(component,'Deal Request','Unknown error.','error');
                    //alert("Error : Unknown error.");
                }
            }
        });
        
        // Enqueue the action                  
        $A.enqueueAction(action);                
        
    },
    
    
    selectProjectName:function(component,event,helper){
        
        var objectId = event.currentTarget.dataset.id;
        
       // alert('**'+JSON.stringify(component.get('v.projectList')));
        component.set("v.projectId",objectId);
        var projList =component.get('v.projectList');
        for(var i=0;i<projList.length;i++){
            var projectSelected =projList[i];
            var objectLabel = '';
            //console.log('teamMemberSelected.contactId:'+teamMemberSelected.contactId+'===objectId:'+objectId);
            if(projectSelected.currentworkingTitleId==objectId){
                //alert('**'+projectSelected.currentworkingTitleName);
                objectLabel = projectSelected.currentworkingTitleName;
                component.set("v.projectName",objectLabel);
                component.set("v.projectAddr1", projectSelected.addressLine1);
                component.set("v.projectAddr2", projectSelected.addressLine2);
                component.set("v.projectAddr3", projectSelected.addressLine3);
                component.set("v.projectCity", projectSelected.cityStateCountry);
				component.set("v.shipToPartyAccount", projectSelected.shipToPartyAccount);
                break;
               // return;
            }
        }
        var projectsId = component.get("v.projectsId");
        //var objectLabel = event.currentTarget.innerText;
        component.set("v.strSearchProjectName",'');
        component.set("v.projectsId",'');
        //component.set("v.projectName",'');
        //component.set("v.selectedContact","true");
        
        var lookupList = component.find('lookuplistPilot');
        $A.util.addClass(lookupList, 'slds-hide');
        
        $A.util.addClass(component.find('idSearchboxPilotSeries'),'slds-hide');
        var projectListResult = component.get("v.projectListResult");
        var projectSelected = new Array();
        var projectSelected = { 'currentworkingTitleId' : objectId, 
                               'currentworkingTitleName' : objectLabel
                              };
        projectListResult.push(projectSelected);
        component.set("v.projectListResult",projectListResult);
        var cmpEvent = component.getEvent("HWS_LookupReturnValueEvent");
        cmpEvent.setParams({
            "ParentRecordId" : objectId,
            "objectNameId" : component.get("v.objectName"),
			"shipToPartyAccount" : component.get("v.shipToPartyAccount")
        });
        cmpEvent.fire();
        
    },
    removeProjectName:function(component,event,helper){
        
        $A.util.removeClass(component.find('idSearchboxPilotSeries'),'slds-hide');  
        var objectId = event.currentTarget.dataset.id;
        var objectLabel = event.currentTarget.innerText;
        //console.log('objectId--'+objectId+'===objectLabel'+objectLabel);
        var projectList = component.get("v.projectListResult");
        
        var projectSelected = new Array();
        var projectSelected = { 'currentworkingTitleId' : objectId, 
                               'currentworkingTitleName' : objectLabel
                              };
        
        //lstTeamMembers.push(teamMemberSelected);
        
        for(var iSelMem=0;iSelMem<projectList.length;iSelMem++){
            var projectSelected =projectList[iSelMem];
            //console.log('teamMemberSelected.contactId:'+teamMemberSelected.contactId+'===objectId:'+objectId);
            if(projectSelected.currentworkingTitleId==objectId){
                projectList.splice(iSelMem,1);
            }
        }
        
        component.set("v.projectListResult",projectList); 
        component.set("v.projectId",'');
        component.set("v.projectName",'');
        component.set("v.projectAddr1",'');
        component.set("v.projectAddr2",'');
        component.set("v.projectAddr3",'');
        component.set("v.projectCity",'');
        var cmpEvent = component.getEvent("HWS_LookupReturnValueEvent");
        cmpEvent.setParams({
            "ParentRecordId" : '',
            "objectNameId" : component.get("v.objectName")
        });
        cmpEvent.fire();
    },
    handleComponentEvent : function(component, event, helper){
        var objectId = event.getParam("ParentRecordId");
        var objectLabel = event.getParam("ParentRecordName");
        var ObjectnameId = event.getParam("Objectname");
		var shipToPartyAccount = event.getParam("shipToPartyAccount");
        if(objectLabel == 'canceled'){
            component.set("v.createProj",false);
            component.set("v.isOpen", false);
        }
        else{
            component.set("v.createProj",false);
            component.set("v.isOpen", false);
            var addr1 = event.getParam("AddrLine1");
            var addr2 = event.getParam("AddrLine2");
            var addr3 = event.getParam("AddrLine3");
            var citystatecountry = event.getParam("CityStateCountry");
            var objectId1 = component.get('v.projectId');
            var objectLabel1 = component.get('v.projectName');
            var projectList = component.get("v.projectListResult");
            
            var projectSelected = new Array();
            var projectSelected = { 'currentworkingTitleId' : objectId1, 
                                   'currentworkingTitleName' : objectLabel
                                   
                                  };
            
            //lstTeamMembers.push(teamMemberSelected);
            
            for(var iSelMem=0;iSelMem<projectList.length;iSelMem++){
                var projectSelected =projectList[iSelMem];
                //console.log('teamMemberSelected.contactId:'+teamMemberSelected.contactId+'===objectId:'+objectId);
                if(projectSelected.currentworkingTitleId==objectId1){
                    projectList.splice(iSelMem,1);
                }
            }
            
            component.set("v.projectListResult",projectList); 
            
            component.set("v.projectId",objectId);
            
            var projectsId = component.get("v.projectsId");
            component.set("v.projectName",objectLabel);
            component.set("v.projectAddr1",addr1);
            component.set("v.projectAddr2",addr2);
            component.set("v.projectAddr3",addr3);
            component.set("v.projectCity",citystatecountry);
            component.set("v.strSearchProjectName",'');
            component.set("v.projectsId",'');
            var lookupList = component.find('lookuplistPilot');
            $A.util.addClass(lookupList, 'slds-hide');
            
            $A.util.addClass(component.find('idSearchboxPilotSeries'),'slds-hide');
            var projectListResult = component.get("v.projectListResult");
            var projectSelected = new Array();
            var projectSelected = { 'currentworkingTitleId' : objectId, 
                                   'currentworkingTitleName' : objectLabel
                                  };
            projectListResult.push(projectSelected);
            component.set("v.projectListResult",projectListResult);
            var cmpEvent = component.getEvent("HWS_LookupReturnValueEvent");
            
            cmpEvent.setParams({
                "ParentRecordId" : objectId,
                "objectNameId" : ObjectnameId,
				"shipToPartyAccount" : shipToPartyAccount
                
            });
            cmpEvent.fire();
        }
        
    },
    createRecord : function(component, event, helper){
        component.set("v.createProj",true);
        
    },
	
	//added for bug  HWST-3544:
    removeShiptoPartyMethod:function(component,event,helper){
       // alert('removeShiptoPartyMethod');
        $A.util.removeClass(component.find('idSearchboxPilotSeries'),'slds-hide');
        component.set("v.projectListResult",[]); 
        component.set("v.projectId",'');
        component.set("v.projectName",'');
        component.set("v.projectAddr1",'');
        component.set("v.projectAddr2",'');
        component.set("v.projectAddr3",'');
        component.set("v.projectCity",'');
        var cmpEvent = component.getEvent("HWS_LookupReturnValueEvent");
        cmpEvent.setParams({
            "ParentRecordId" : '',
            "objectNameId" : component.get("v.objectName")
        });
        cmpEvent.fire();
    }
    //Ends here
})