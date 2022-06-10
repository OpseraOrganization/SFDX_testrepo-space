({
	doInit : function(component, event, helper) {
            var actionFileDetails = component.get("c.getFileData");
        	actionFileDetails.setParams({
                "docId": component.get("v.recordId")
            });
            actionFileDetails.setCallback(this, function(response) {
                
                var doc = response.getReturnValue();
                    var lastModifyBy = component.get("c.getFileReportData");
                    lastModifyBy.setParams({
                        "docId": component.get("v.recordId")
                    });
                    lastModifyBy.setCallback(this, function(response) {
                        component.set("v.FileReportDetail",response.getReturnValue());
                    });
                    $A.enqueueAction(lastModifyBy);
                component.set("v.DocumentDetail",response.getReturnValue());
                
            });

        	$A.enqueueAction(actionFileDetails);
        	
	},
    
    navigateAccount : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
                var relatedObjId = component.get("v.FileReportDetail.Parent_Account__c");        
            urlEvent.setParams({
             "url": '/'+relatedObjId
        });
        urlEvent.fire();
	},
    
    navigateOpportunity : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
                var relatedObjId = component.get("v.FileReportDetail.Related_Opportunity__c");  
            urlEvent.setParams({
             "url": '/'+relatedObjId
        	});
        urlEvent.fire();
	},
    
    navigateOffer : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
                var relatedObjId = component.get("v.FileReportDetail.Related_Offer__c");
            urlEvent.setParams({
             "url": '/'+relatedObjId
        });
        urlEvent.fire();
	}
})