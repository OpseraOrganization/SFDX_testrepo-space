({
	showHide : function(component) {
        var acceptRejectDialog = component.find("acceptRejectDialog");
        $A.util.toggleClass(acceptRejectDialog, "slds-hide");
        var overlay = component.find("overlay");
        $A.util.toggleClass(overlay, "slds-hide");
    }
})