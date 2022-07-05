({
	createArticleButton : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.disablebuttoncheckcreateArticle");
        action.setParams({ caseId : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var statusCheck = response.getReturnValue(); 
               // console.log("statuscheck",statusCheck); NOKIASC-36296
                if(statusCheck == true)
                {
                        component.set('v.disableButtonCreateArt',true);
                }
                else
                {
                        component.set('v.disableButtonCreateArt',false);
                }
            }
        });
        $A.enqueueAction(action);
    }
})