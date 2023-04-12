({
    requestAssistance: function(component, event, helper){
        component.set("v.Spinner", true);
        var recordId = component.get("v.recordId");
        var workgroupName = component.get("v.workgroupName");
        var action = component.get("c.requestAssistanceToWG");
        action.setParams({
            caseId : recordId,
            wgName : workgroupName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.Spinner", false);
                var messageBox = component.find('messageBox'); 
                messageBox.displayToastMessage("You have successfully requested assistance to " + workgroupName);
            }
            else {
                component.set("v.Spinner", false);
                var messageBox = component.find('messageBox'); 
                messageBox.displayToastMessage("An error occurred. Your Request for Assistance did not succeed");
            }  
        });
        $A.enqueueAction(action);
    },
     handleWorkgroupInstructions : function(component, event, helper) {
		 var currWorkgroupID;
        var params = event.getParam('arguments');
        component.set('v.recordId', params.getRecordId);
		component.set('v.byPassCaseTeam', params.getRecValue);
		component.set("v.workgroupInstructions", "");
		component.set("v.Spinner", true); 
		component.set('v.WorkgroupId', params.getWorkgroupId);
        component.set('v.workgroupName', params.getWorkgroupName);
		helper.getWorkgroupInstructions(component ,component.get("v.WorkgroupId"))
           .then(function(result){
            component.set("v.workgroupInstructions", result.CH_WorkgroupInstructions__c);
            // Preset the text area to the height of the workgroup instructions
            var textArea = document.getElementById('workgroupInstructions');
            var heigth = (textArea.scrollHeight > textArea.clientHeight) ? (textArea.scrollHeight)+"px" : "60px";
            component.set("v.textAreaHeight", heigth);
            
        })
        component.set("v.Spinner", false);
    }
})