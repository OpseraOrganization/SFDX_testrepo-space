({
    // When a save is complete display a message
    saveCompleted: function(component,event,helper){
        helper.closeConsoleTAB(component);
        // Display the status of the save                        
        var messageBox = component.find('messageBox'); 
        messageBox.displayToastMessage('Workgroup member is saved');
    },
    // When cancel is pressed
    cancel: function(component,event,helper){
        helper.closeConsoleTAB(component);
    },
    // When a new type is selected, the screen needs to be refresh with the new type
    typeChanged: function(component,event,helper){
        var selectedType = component.find("selectType").get("v.value");
        component.set("v.selectedType", selectedType);
    },
    // Default fields when a new record is created
    loadQueue : function(component, event, helper) {
        var recUi = event.getParam("recordUi");
        
        if (recUi.record.fields["CH_User__c"].value == null){
            helper.getQueueUserId(component)
            .then(function(result){
                component.find("userqueue").set("v.value", result);
            });            
        }
    },
    // When the user is loaded
    loadUser : function(component, event, helper) {
        // The refersh is needed to refresh the dependend picklist
        component.set("v.refresh", true);
        component.find("type").set("v.value","User");
    },
	
	showDependency:function(component,event,helper){ //Add method to show picklist when the component is rendered. 
        // The refersh is needed to refresh the dependend picklist 
        component.set("v.refresh", true); 
    },
	
    // When save on a hotline is clicked
    saveHotline: function(component,event,helper){
        event.preventDefault();
        var fields = event.getParam("fields");
        var message = "";
        // Validate the input fields
        if (!fields["Name"]){
            message += "A name needs to be entered. ";
        }
        if (!fields["CH_HotlinePhone__c"]){
            message += "A phonenumber needs to be entered. ";
        }  
        if (!fields["CH_Workgroup__c"] && !component.get("v.recordId")){
            message += "A workgroup needs to be selected. ";
        }
        // If there is an error message
        if (message != ""){
            message = "Hotline cannot be saved. \n" + message;
        	var messageBox = component.find('messageBox'); 
        	messageBox.displayToastMessage(message);
        }
        else{
            fields["CH_Role__c"] = "Hotline";
            fields["CH_Workgroup_Member_Type__c"] = component.get("v.selectedType");
            component.find("workgroupMemberHotlineForm").submit(fields);
        }
    },
    // When save on a user is clicked
    saveUser: function(component,event,helper){
        event.preventDefault();
        var fields = event.getParam("fields");
        var message = "";
        // Validate the input fields
        if (!fields["CH_User__c"]){
            message += "A User needs to be selected. ";
        }
        if (!fields["CH_Role__c"]){
            message += "A role needs to be selected. ";
        }
        if (!fields["CH_Workgroup__c"] && !component.get("v.recordId")){
            message += "A workgroup needs to be selected. ";
        }
        // If there is an error message
        if (message != ""){
            message = "User cannot be saved. \n" + message;
        	var messageBox = component.find('messageBox'); 
        	messageBox.displayToastMessage(message);
        }
        else{
            var userId = component.find("user").get("v.value");
            helper.getUserName(component,userId)
            .then(function(result){
            	fields["Name"] = result;
            	fields["CH_Workgroup_Member_Type__c"] = component.get("v.selectedType");
                component.find("workgroupMemberUserForm").submit(fields);  
            });
        }        
    },
    // When save on a queue is clicked
    saveQueue: function(component,event,helper){
        event.preventDefault();
        var fields = event.getParam("fields");
        var message = "";
        // Validate the input fields
        if (!fields["Name"]){
            message += "A Queue name needs to be entered. ";
        }
        if (!fields["CH_Workgroup__c"] && !component.get("v.recordId")){
            message += "A workgroup needs to be selected. ";
        }
        // If there is an error message
        if (message != ""){
            message = "User cannot be saved. \n" + message;
        	var messageBox = component.find('messageBox'); 
        	messageBox.displayToastMessage(message);
        }
        else{
            fields["CH_Role__c"] = "Queue";          		
            fields["CH_Workgroup_Member_Type__c"] = component.get("v.selectedType");
            component.find("workgroupMemberQueueForm").submit(fields);  
        }         
    },
	
	onInit : function(component,event,helper){
       //Afif Add
       if (component.get("v.selectedType") =="User" && (!component.get("v.edit")) ){
        helper.onInit(component,event,helper); 
		component.set("v.getValue","slds-hidden");		
       } 
		 //30651
        var recordId = component.get("v.recordId");  
        if(recordId!==""&& recordId!=undefined && recordId!="undefined"){
            component.set("v.showCloneButton",true);
        }
        if(component.get("v.cloneRecordId")){ 
            //Asssign value here 30651
            helper.getCloneData(component)
            .then(function(result){
                console.log(result);
                if(result.CH_Workgroup_Member_Type__c == 'User')
                {
                 component.find("user").set("v.value",result.CH_User__c);
                 component.find("role").set("v.value",result.CH_Role__c); 
                 component.find("workgroup").set("v.value",result.CH_Workgroup__c);
                 component.find("offduty").set("v.value",result.CH_Off_Duty__c);
                }
                if(result.CH_Workgroup_Member_Type__c == 'Hotline')
                {
                 component.find("name").set("v.value",result.Name);
                 component.find("description").set("v.value",result.CH_Description__c); 
                 component.find("phone").set("v.value",result.CH_HotlinePhone__c); 
                 component.find("workgroup").set("v.value",result.CH_Workgroup__c);
                 
                }
                if(result.CH_Workgroup_Member_Type__c == 'Queue')
                {
                 component.find("name").set("v.value",result.Name);
                 component.find("description").set("v.value",result.CH_Description__c); 
                 component.find("queueemail").set("v.value",result.CH_Queue_Email__c); 
                 component.find("userqueue").set("v.value",result.CH_User__c);
                 component.find("workgroup").set("v.value",result.CH_Workgroup__c);                
                }
            });
        }
        //30651 	
    },
    saveWGMember :function(component, event, helper) {        
        helper.editWGMember(component, event, helper);        
    },
	  submit: function(component, event, helper) {

        var action = component.get("c.updateWorkgroupMember");
        action.setParams({ getRecordId : component.get("v.recordId") , offDutyValue : component.get("v.OffDutyButtonValue")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                /*var messageBox = component.find('messageBox'); 
                messageBox.displayToastMessage('Workgroup member is saved');
                $A.get('e.force:refreshView').fire();
                helper.closeConsoleTAB(component); */
				helper.closeConsoleTABAfterEdit(component);
                var messageBox = component.find('messageBox'); 
        		messageBox.displayToastMessage('Workgroup member is saved');
            }
        });
        $A.enqueueAction(action);       
    },
	handleError: function(component, event,helper) {
        var errors = event.getParams();
        console.log("response", JSON.stringify(errors));
		//NOKIASC-38811
		var errorMsg = JSON.parse(JSON.stringify(errors));
        if(errorMsg.detail.includes($A.get("$Label.c.CH_WG_Member_Update_Error"))){
            component.set("v.isQueueError",false);
            helper.showToast('error',errorMsg.message,errorMsg.detail,'sticky');
        }
    },
    openAssignment : function(component, event, helper) {
        helper.openSubTab(component,'c__CH_CA_WorkgroupMember',component.get('v.recordId'),'Clone Workgroup Member');
    },
    
    openSubtab: function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__CH_WorkgroupMember",
                        "actionName": "new"
                    },
                    "state": {
                        "uid": "1",
                        "c__recordTypeId": component.get("v.recordTypeId"),
                        "c__edit": true,
                        "c__cloneRecordId": component.get("v.recordId"),
                        "c__selectedType": component.get("v.selectedType"),
                        
                    }
                }
            }).then(function(subtabId) {
                workspaceAPI.setTabLabel({
                    tabId: subtabId,
                    label: "Clone WorkgroupMember"
                });
                console.log("The new subtab ID is:" + subtabId);
            }).catch(function(error) {
                console.log("error");
            });
        });
    }

})