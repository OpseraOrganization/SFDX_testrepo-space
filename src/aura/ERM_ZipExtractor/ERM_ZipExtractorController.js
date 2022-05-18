({
    init : function(component, event, helper) {
        console.log(component);
        console.log(event);
        var action = component.get('c.initClass');
        action.setParams({recordID: component.get('v.recordId')});
        action.setCallback(this,function(response){
            var state = response.getState();
            let lstOfFiles = response.getReturnValue().lstOfFiles;
            if(state === "ERROR" || state === "SUCCESS" && Object.keys(lstOfFiles).length === 0 && lstOfFiles.constructor === Object) {
                $(".zipWindowTitle").eq(0).html('No documents found in the event\'s sessions...');
                $(".zipWindowIcon").eq(0).hide();  
                $(".zipWindowIcon").eq(2).show();
            }
            else {
            	var zip = new JSZip();
                for(let name in lstOfFiles)
                    zip.file(name, lstOfFiles[name], {base64: true});
                zip.generateAsync({type:"blob"})
                .then(function(content) {
                    $(".zipWindowTitle").eq(0).html('Documents ready.');
                    $(".zipWindowIcon").eq(0).hide();
                    $(".zipWindowIcon").eq(1).show();
                    window.saveFile(content, response.getReturnValue().eventName+".zip");
                });
            }
        });
        $A.enqueueAction(action);
    },
    closeQuickAction : function(component, event, helper) { 
        // Close the action panel 
        var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
        dismissActionPanel.fire(); 
    }
})