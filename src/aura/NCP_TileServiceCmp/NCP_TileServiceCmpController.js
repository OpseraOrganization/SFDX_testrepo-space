({
    doInit: function(cmp, evt, hlp) {
         hlp.checkAuth(cmp);
         hlp.serviceTilesAction(cmp);
        var action = cmp.get("c.getResourceURL"); //getting attachment from apex
        action.setParams({
            resourceName : 'BulkRMATemplate',
        })
        
        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log('response value#####'+response.getReturnValue());
            if (state === "SUCCESS") {
                cmp.set("v.downloadURL", response.getReturnValue());
                var urldownload = cmp.get('v.downloadURL');
                console.log("download URL##"+urldownload);
            } 
            else {
                console.log("Failed with state: " + state);
            }
        })                           
        $A.enqueueAction(action);
    }
})