({
     doInit : function(component, event, helper) {
         helper.getfiles(component, event, helper);
        helper.getcountoffiles(component, event, helper);
         
    },
    getSelected : function(component,event,helper){
        // display modle and set seletedDocumentId attribute with selected record Id   
        component.set("v.hasModalOpen" , true);
        component.set("v.selectedDocumentId" , event.currentTarget.getAttribute("data-Id")); 
        
    },
    closeModel: function(component, event, helper) {
        // for Close Model, set the "hasModalOpen" attribute to "FALSE"  
        component.set("v.hasModalOpen", false);
        component.set("v.selectedDocumentId" , null); 
    },
	getattachments : function(component, event, helper) {
		helper.attatchmentlist(component, event, helper);
	},
    openSingleFile : function (component,event){                
        var fireEvent = $A.get("e.lightning:openFiles");
        fireEvent.fire({
            recordIds: ["06956000000IXKPAA4"]
        });      
    }
    
})