({
     // Get all workgroup members that can be assigned to a case
    doInit : function(component, event, helper)
    {
        // Waiting for the loading of the external scripts to be completed
        var waitForScriptLoaded = function(){ 
            window.setTimeout(function(){
                if (!component.get('v.scriptLoaded')){
                    console.log('first if');
                    waitForScriptLoaded();
                }
                else{
                    console.log('second if')
                    helper.init(component);
                }
            }, 100);            
        }
        waitForScriptLoaded(component);  
    },
    scriptsLoaded : function(component, event, helper){
        component.set("v.scriptLoaded", true);
    },
    handleToggleChanged : function(component, event, helper){
        var checked = component.get("v.checked");
        checked ? component.set("v.checked", false) : component.set("v.checked", true);
        helper.init(component);
    },
	handleWorkgroupInstructions : function(component, event,helper) {
        //component.set("v.showworkgroupInstructions", true);
        //var modal = component.find('workgroupInstructionsModal');  
        if(component.get("v.isReassignment")==false){
            component.set("v.showworkgroupInstructions", true);
            var modal = component.find('workgroupInstructionsModal');  
			//Commented as a part of 27604
           // modal.displayworkgroupInstructionsModal(null,"",component.get("v.recordId"), "");
		    modal.displayworkgroupInstructionsModal(component.get("v.captureWorkgroupId"),component.get("v.captureWorkgroupName"),component.get("v.recordId"), "initialAssignment");
        }
        else{
            component.set("v.showworkgroupInstructions", true);
            var modal = component.find('workgroupInstructionsModal');        
            modal.displayworkgroupInstructionsModal(component.get("v.captureWorkgroupId"),component.get("v.captureWorkgroupName"),component.get("v.recordId"),"reAssignment");
            
        }
        
    },
})