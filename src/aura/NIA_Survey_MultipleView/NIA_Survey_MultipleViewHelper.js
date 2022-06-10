({
	showToast : function(type,message) {
        var toast = $A.get("e.force:showToast");
        if (toast) {            
            toast.setParams({
                "type": type,
                "message": message
            });
            toast.fire();
        }
    }
})