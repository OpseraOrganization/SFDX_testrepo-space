({
    helperActionExecute : function(component, event, action) {
        action.setCallback(this, function(response) {
            var state = response.getState();
            var response = response.getReturnValue();
             
            if(state == "SUCCESS" && response!=null){
                component.set("v.rId", response);
                
            }else{
                $A.get("e.force:closeQuickAction").fire();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "You do not have permission to create Problem ",
                    "message": "Please contact Admin",
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        
        
        
            
    },
    
    helperActiontoGetProductUsage : function(component, event, action) {
        var recordId = component.get("v.recordId");	
        
        var action = component.get("c.getProductDataUsageForStandAloneProblem");
        action.setParams({ 'productId' : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var response = response.getReturnValue();
            if(state == "SUCCESS" && response!=null){
                
                component.set("v.dataUsage", response);
                ////my change 
        $A.createComponent( 
            "c:CH_CreateProblemFlow",
            {
                
                "problemId": component.get("v.recordId"),
                "headerMessage": "Create Problem",
               // "caseRecord": component.get("v.caseRecord")
            },
            function(msgBox){                
                if (component.isValid()) {
                    var cmp = component.find('createproblemmodal');
                    var body = cmp.get("v.body");
                     
                    body.push(msgBox);
                    cmp.set("v.body", body); 
                    
                }
            }
        );
        
        ////mychange
            }
        });
        $A.enqueueAction(action);
        
        
    }
})