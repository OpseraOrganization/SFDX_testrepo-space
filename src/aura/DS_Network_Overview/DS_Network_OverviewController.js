({
    getDPonLoad: function(component, event, helper) {
       
         component.set('v.NetworkTrendFileUrl',0); 
         component.set('v.BenchmarkingFileUrl',0);
         component.set('v.InstalledBaseFileUrl',0);
         helper.getTechnologyHelper(component, event, helper);
   
   },
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    },
  
   filterDP: function(component, event, helper) {
    helper.showFiles(component, event, helper);
        $A.get('e.force:refreshView').fire();
    }
   
    
})