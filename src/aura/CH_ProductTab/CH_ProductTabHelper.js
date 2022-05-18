({
	showToastMessage: function(messageType, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : messageType,
            "mode" : 'sticky',
            "title" : messageType,
            "message" : message
        });
        toastEvent.fire();
    }
})