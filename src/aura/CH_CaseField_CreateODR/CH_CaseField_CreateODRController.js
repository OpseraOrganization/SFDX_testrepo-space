({
    init : function (component,event,helper) {
        var myPageRef = component.get("v.pageReference");
        var name = myPageRef && myPageRef.state ? myPageRef.state.c__recordId : "";
        component.set("v.recordId", name);
        
        var flow = component.find("ODRCreation");
        var value1=component.get("v.recordId");
        
        var inputVariables = [
            { name : "recordId", type : "String", value: component.get("v.recordId") }
        ];
        
        flow.startFlow("CH_Create_ODR",inputVariables);
        
        
        
    },
    
    handlePageChange: function(component,event,helper) {
        var myPageRef = component.get("v.pageReference");
        var name = myPageRef && myPageRef.state ? myPageRef.state.c__recordId : "";
        component.set("v.recordId", name);
    },
    
    handleCreateODR : function (component,event,helper) {
        
        if(event.getParam("status") === "FINISHED") {
            
            component.set("v.createODR",false);
            helper.closeConsoleTAB(component,event,helper);
            
        }
    }
    
    
    
})