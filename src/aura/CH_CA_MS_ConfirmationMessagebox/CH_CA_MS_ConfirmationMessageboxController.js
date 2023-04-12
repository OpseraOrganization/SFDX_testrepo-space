({
    // Constructor
	displayModelMessage : function(component, event, helper) {
		var params = event.getParam('arguments');
        component.set('v.sourceButton', params.sourceButton);
        component.set('v.message', params.message);
        component.set('v.confirmOK', params.confirmOK);
        component.set('v.confirmDelete', params.confirmDelete);
        component.set('v.displayMessagebox', params.displayMessageBox);
	},
    // When a button is clicked an event is fired
    fireEvent : function(component, event, helper) {
        var componentEvent = component.getEvent("messageboxEvent");
        var buttonClickedId = event.getSource().getLocalId();

        componentEvent.setParams({"popupButtonClicked": buttonClickedId});
        componentEvent.setParams({"sourceButtonClicked": component.get('v.sourceButton')});
        componentEvent.fire();

        // Close the messagebox
        component.set('v.displayMessagebox', false);
	},
    // Display a toast message
    displayToastMessage: function(component, event, helper) {
        var params = event.getParam('arguments');
        var message = params.message;
        var variant = params.variant;
        
        component.find('notifLib').showToast({
            "variant": variant,
            "message": message
        });
    }
})