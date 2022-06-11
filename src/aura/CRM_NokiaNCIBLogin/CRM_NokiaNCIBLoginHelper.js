({
    showToast : function(title, message, variant) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "mode": "sticky",
            "variant": variant
        });
        toastEvent.fire();
    }
})