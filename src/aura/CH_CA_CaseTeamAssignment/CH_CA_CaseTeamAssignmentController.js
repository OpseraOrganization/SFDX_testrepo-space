({
    // Get all workgroup members that can be added to the case team
    doInit : function(component, event, helper){
        // Waiting for the loading of the external scripts to be completed
        var waitForScriptLoaded = function(){
            window.setTimeout(function(){
                if (!component.get('v.scriptLoaded')){
                    waitForScriptLoaded();
                }
                else{
                    helper.init(component);
                }
            }, 100);            
        }
        waitForScriptLoaded(component);    
        helper.loadOptions(component,helper);
    },
    // When add is clicked in the assign role window
    addMemberToTeam : function(component, event, helper) {
        // Check if a role is selected
        if (component.find("caseTeamRole").get("v.value") == null){
            var messageBox = component.find('messageBox'); 
            messageBox.displayToastMessage("Select a role", "error");
            return;
        }
        component.set("v.Spinner", true);
        helper.addUserToCaseTeam(component)
        .then(function(result){
            component.set("v.showSelectRoleModal",false);
            component.set("v.Spinner", false);
            var messageBox = component.find('messageBox'); 
            messageBox.displayToastMessage("Member added to the case team", "success");
            $A.get('e.force:refreshView').fire();
        })
        .catch(function(error) {
            component.set("v.showSelectRoleModal",false);
            component.set("v.Spinner", false);
            var messageBox = component.find('messageBox'); 
            messageBox.displayToastMessage("An error occured. " + error, "error");
		})
    },
    // When cancel is clicked in the assign role window
    closePopup : function(component) {
        component.set("v.showSelectRoleModal",false);
        component.set("v.Spinner", false);
    },
    // When the search button is clicked search for the workgroup members
    search : function(component, event, helper){
        //34648
        var wgType = component.find("workgroupType").get("v.value");
        if(component.find("serviceType").get("v.value") == 'Hardware Support' && wgType != null && wgType != '' && wgType != undefined && wgType !='Warranty Only' && wgType !='Quotation Only' && wgType !='Warranty and Quotation'){
			//component.find('errMessage').setError('Undefined error occured');
			component.find("workgroupTypeError").set("v.errors", [{message:"The selected workgroup type is not applicable for team member search for HWS. \n Select any of the values 1)Warranty Only 2)Quatation Only 3) Warranty and Quotation"}]);
        }
        else{
			component.find("workgroupTypeError").set("v.errors", [{message: null}]);
            component.set("v.Spinner", true);
            helper.searchWorkgroupMembers(component)
            .then(function(result){
                component.set('v.workgroupMembers', result);
                helper.refreshTable(component, result);
                if(result!=0  && result != null){
                    helper.displayWorkgrpInstructions(component, result);
                }
                component.set("v.Spinner", false);
            })
            .catch(function(error) {
                component.set("v.Spinner", false);
                var messageBox = component.find('messageBox'); 
                messageBox.displayToastMessage("An error occured. " + error, "error");
            });
        }
    },
    scriptsLoaded : function(component, event, helper){
        component.set("v.scriptLoaded", true);
    },
    typeChanged: function(component,event,helper){
        var selectedType = component.find("mySelect").get("v.value");
        component.set("v.selectedValue", selectedType);
    },
	handleWorkgroupInstructions : function(component, event,helper) {
        component.set("v.showworkgroupInstructions", true);
         var modal = component.find('workgroupInstructionsModal');        
        modal.displayworkgroupInstructionsModal(component.get("v.captureWorkgroupId"),component.get("v.captureWorkgroupName"),component.get("v.recordId"),"Case Team");
    }
})