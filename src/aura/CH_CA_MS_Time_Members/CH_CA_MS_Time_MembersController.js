({
    // Constructor
	displayAddMembersModal : function(component, event, helper) {
		var params = event.getParam('arguments');
        component.set('v.timeslotId', params.timeslotId);
        component.set('v.displayModal', true);
        component.set("v.Spinner", true);
        helper.refreshUserList(component)
        .then(function(result){
            helper.createTable(component, result);
            component.set("v.Spinner", false);
            
        });
	},
    // Close the modal
    close : function(component, event, helper){
        var componentEvent = component.getEvent("addMemberEvent");
        var buttonClickedId = event.getSource().getLocalId();
        componentEvent.setParams({"buttonClicked": buttonClickedId});
        componentEvent.fire();
        component.set('v.displayModal', false);
    },
    addMembers : function(component, event, helper) {  
        component.set("v.Spinner", true);
        var tableId = helper.getTableId(component);
        var table = $(tableId).DataTable();
        var selectedRows = table.rows({ selected: true }).ids(false).toArray();
        var schedules = [];
        selectedRows.forEach(function(element){
            var scheduleType = $(table.row('#' + element).node()).find("option:selected").val();
            if(scheduleType == 'none'){
                component.set("v.Spinner", false)
                var messageBox = component.find('messageBox'); 
                messageBox.displayToastMessage('Error: Schedule Type must be set for all selected rows', 'error');
                return;
            }
            else{
            	schedules.push(scheduleType);
            }                   
        });
        var action = component.get("c.addTimeSlotMembers");
        action.setParams({ timeslotId : component.get("v.timeslotId"), members : selectedRows, scheduleTypes : schedules });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var anotheraction = component.get("c.getEligableUsers");
        		anotheraction.setParams({ timeslotId : component.get("v.timeslotId")});
                anotheraction.setCallback(this, function(response) {
                    var anotherstate = response.getState();
                    if (anotherstate === "SUCCESS") {
                        table.clear().rows.add(response.getReturnValue()).draw();
                        var componentEvent = component.getEvent("addMemberEvent");
                        componentEvent.setParams({"buttonClicked": 'Close'});
                        componentEvent.fire();
                    }
                    component.set("v.Spinner", false)
                });
                $A.enqueueAction(anotheraction);
            }
            component.set("v.Spinner", false)
        });
        $A.enqueueAction(action);
    }
})