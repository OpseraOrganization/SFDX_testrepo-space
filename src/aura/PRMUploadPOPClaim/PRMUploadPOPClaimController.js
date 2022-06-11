({
    doInit : function(component, event, helper) {
        helper.getFileRelatedList(component, event, helper);
        var claimData = component.get("c.getClaimData");
        claimData.setParams({
            "claimId": component.get("v.recordId")
        });
        claimData.setCallback(this, function(a) {
            component.set("v.ActivityType",a.getReturnValue());
            var POPdata = component.get("c.getPOPValues");
            var activityType = component.find("activity").get("v.value");
            POPdata.setParams({
                "activityId": activityType
            }); 
            POPdata.setCallback(this, function(a) {
                component.set("v.POP",a.getReturnValue());
            });
            $A.enqueueAction(POPdata);
        });
        $A.enqueueAction(claimData);
  },

  
  handleUploadFinished: function(component, event) {
        //Get the list of uploaded files
        var documentId;
        var uploadedFiles = event.getParam("files");
        var countryJSON = JSON.stringify(uploadedFiles);
      	JSON.parse(countryJSON, (key, value) => {
            if(key == 'documentId') {
            	documentId = value;
        	}
		});
      	var docVersion = component.get("c.updateContentVersion");
        var activity = component.find("activity").get("v.value");
        var pop = component.find("proof").get("v.value");
        docVersion.setParams({
            "docId":documentId,
            "activityType":activity,
            "pOP": pop,
            "claimId": component.get("v.recordId")
        }); 
      	docVersion.setCallback(this, function(a) {
            var fileList = component.get("c.getFileLists");
            fileList.setParams({
                "claimId": component.get("v.recordId")
            }); 
            fileList.setCallback(this, function(a) {
                component.set("v.RelatedList",a.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type" : "success",
                    "message": uploadedFiles.length+" files has been uploaded successfully!"
                });
                toastEvent.fire();
             
            $A.get('e.force:refreshView').fire();
         
            //Close the action panel
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            });
            $A.enqueueAction(fileList);
            
        });
        $A.enqueueAction(docVersion); 	
     },
    
    unrestrictedTableSorting : function (component, event, helper)
    {
        helper.sortUnrestrictedTable(component, event, helper);
    },
    //Function for navigating to the clicked file
    fileNavigate : function (component, event, helper)
    {
        helper.navigateToObject(component, event, helper);
	},
    //Function for delete attached file record
     deletefile : function (component, event, helper)
    {
        helper.deleteFileRecord(component, event, helper);
	},
	
})