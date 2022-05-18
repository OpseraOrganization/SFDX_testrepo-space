({
	onInit: function(component,event,helper) {
        // Refresh the UI
		component.set("v.Spinner", true);
        var action = component.get("c.getRoleList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue=response.getReturnValue(); 
                console.log(response.getReturnValue());
                var roleOptions = [];
                for (var i = 0; i < response.getReturnValue().length; i++) {
                    var item = {
                        "label": returnValue[i],
                        "value":returnValue[i]
                    };
                    roleOptions.push(item);
                } 
                component.set("v.wgMemberRoles", roleOptions);
                this.getWorkgroupMemberDetails(component, event, helper);
                component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    getWorkgroupMemberDetails: function(component, event, helper){
        //calling method from controller        
        let action = component.get('c.getWorkgroupMemberDetails');
        action.setParams({ wgMemberId: component.get('v.recordId')});        
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //Initialize component value
                var returnValue=response.getReturnValue();  
                var recordUser = returnValue[0].CH_User__r.Id ; //debanjan
                var value = { 
                    label: returnValue[0].CH_User__r.Name, 
                    value: returnValue[0].CH_User__r.Id, 
                }; 
                component.set("v.defaultselectedRecord",value);
                //component.find("userLookup").set("v.value",returnValue[0].CH_User__r.Id);
                
                var value = { 
                    label: returnValue[0].CH_Workgroup__r.Name, 
                    value: returnValue[0].CH_Workgroup__r.Id, 
                }; 
                component.set("v.selectedWorkgroup",value);
                //component.find("workgroupLookup").set("v.value",returnValue[0].CH_Workgroup__r.Id);
               // component.find("wgMemberRole").set("v.value", returnValue[0].CH_Role__c);
                //component.find("wgoffDuty").set("v.value", returnValue[0].CH_Off_Duty__c);
                component.set("v.selectedType", returnValue[0].CH_Workgroup_Member_Type__c);
                component.set("v.chkOffDuty",returnValue[0].CH_Off_Duty__c);                                
                let action = component.get('c.checkloggedUser');       
                action.setCallback(this,function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var loggedUser=response.getReturnValue();  
                        //alert ('loggedUser -->'+loggedUser);
                        if (recordUser == loggedUser)
                        {
                            //alert ('inside logged user');
                            component.set("v.disableOffDuty",false);
                            component.set("v.disableSaveButton",false);
                        }
                    }           
                })
                $A.enqueueAction(action); 
            }
            
        });
        $A.enqueueAction(action);   
    },
    editWGMember: function(component, event, helper){
        // Refresh the UI
		component.set("v.Spinner", true);        
        var chkOffDuty;
        chkOffDuty=component.get("v.chkOffDuty");
        let action = component.get('c.editWorkgroupMember');
        action.setParams({ Id: component.get('v.recordId'),
                          chkOffDuty: chkOffDuty}
                        );        
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue=response.getReturnValue();                
                this.closeConsoleTABAfterEdit(component);
                 component.set("v.Spinner", false);
                // Display the status of the save                        
                var messageBox = component.find('messageBox'); 
                messageBox.displayToastMessage('Workgroup member is saved');
            }
            
        })
        $A.enqueueAction(action);         
    },
    //End

    // Close the current tab that was created for editing or creating a workgroup member
    closeConsoleTAB: function(component) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        });  
    },
	
	 closeConsoleTABAfterEdit: function(component) {       
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
            
            var refreshParentTab=response.parentTabId;
            workspaceAPI.refreshTab({
                tabId: refreshParentTab                    
            });
            
        })
        .catch(function(error) {
            console.log("CH_CA:closeConsoleTAB Error:"+ error);
        });
    },
	
    // Get the user information
    getUserName: function(component, userId){
        var promise = new Promise( function( resolve , reject ) {
        	const sharedjs = component.find("sharedJavaScript");
        	resolve(sharedjs.apex(component, 'getUserName',{ userId : userId}));
        });           
        return promise; 
    },
    // Get the dummy queue userid
    getQueueUserId: function(component, userId){
        var promise = new Promise( function( resolve , reject ) {
        	const sharedjs = component.find("sharedJavaScript");
        	resolve(sharedjs.apex(component, 'getQueueUserId',{ }));
        });           
        return promise; 
    },
	getCloneData: function(component){
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'getCloneData',{ recordId:component.get("v.cloneRecordId") }));
        });           
        return promise; 
    },
	 // Generic Toast Message NOKIASC-38811
    showToast: function(sType, title, message,mode) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": sType,
            "mode": mode
        });
        toastEvent.fire();
    },
})