({
    doInit : function(component, event, helper) {
            var actionFileDetails = component.get("c.getFileReportList");
        	var optsAnnual=[];
        	actionFileDetails.setParams({
                "docId": component.get("v.recordId")
            });
            actionFileDetails.setCallback(this, function(response) {
                component.set("v.FileReport",response.getReturnValue());
                for(var i=0;i< response.getReturnValue().length;i++){                
                    optsAnnual.push(response.getReturnValue()[i].Id);
                }
                component.set("v.FileReportId",optsAnnual);
                
                var lastModifyBy = component.get("c.getFileReportHistory");
                lastModifyBy.setParams({
                    "reportId": component.get("v.FileReportId")
                });
                lastModifyBy.setCallback(this, function(response) {
                    component.set("v.wrapper",response.getReturnValue());
                });
                
                $A.enqueueAction(lastModifyBy);
            });
        	$A.enqueueAction(actionFileDetails);
	}
})