({
	createArticleButton : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.disablebuttoncheckcreateArticle");
        action.setParams({ caseId : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var statusCheck = response.getReturnValue(); 
               // console.log("statuscheck",statusCheck);  NOKIASC-36296
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
    },
     generateshareval : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.disableSharebutton");
        action.setParams({ caseId : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var statusCheck = response.getReturnValue(); 
                //console.log("statuscheck",statusCheck);
                if(statusCheck == true)
                {
                    //let button = component.find('disablebuttonidwrite');
                  // button.set('v.disabled',true);
                      component.set('v.disableShareUpdate',true);
                }
                else
                {
                    //let button = component.find('disablebuttonidwrite');
                  //button.set('v.disabled',false);
                        
                   component.set('v.disableShareUpdate',false);
                }
            }
        });
        $A.enqueueAction(action);
    } 
})