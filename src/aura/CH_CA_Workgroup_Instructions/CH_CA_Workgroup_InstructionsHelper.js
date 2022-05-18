({
    // Get the workgroup Instructions
    getWorkgroupInstructions: function(component,currWorkgroupID){
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
           //resolve(sharedjs.apex(component, 'getWorkgroupInstructions',{ caseId : component.get("v.recordId"),workgroupId : component.get("v.WorkgroupId"), byPassCaseTeam:component.get("v.byPassCaseTeam")}));
              resolve(sharedjs.apex(component, 'getWorkgroupInstructions',{ caseId : component.get("v.recordId"),workgroupId : currWorkgroupID, byPassCaseTeam:component.get("v.byPassCaseTeam")}));
			  if(component.get("v.byPassCaseTeam")!='Case Team') {
                component.set("v.renderButton", false);
            }
            else
            {
                component.set("v.renderButton", true);
            }
        });           
        return promise; 
    },
	
})