({
    doInit: function(component, event, helper) {
        var recordId = component.get("v.recordId");	
        var action = component.get("c.deleteKnowledgeArticle");
        action.setParams({
            "recordID": recordId
        });
       helper.helperActionExecute(component, event, action);
    },
})