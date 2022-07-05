({
    getPicklistValueonLoad : function(component, event, helper) {
      
         helper.getTechnologyHelper(component, event, helper);
         helper.getPOHelper(component, event, helper);
         component.set("v.contents",2);  
   
   },
    
    showSupportingMaterial: function(component, event, helper) {
      helper.showFiles(component, event, helper);
        
    }
   
   
})