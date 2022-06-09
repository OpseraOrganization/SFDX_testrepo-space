({
	//Spinner Code Start
    showWaiting:function(cmp){
       // console.log(component.get("v.recordId"));
       cmp.set("v.IsSpinner",true);
    },
    hideWaiting:function(cmp){
        cmp.set("v.IsSpinner",false);  
    },
    //Spinner Code Ends
    cancelHwsCase : function(component, event, helper) {
        //console.log(component.get("v.recordId"));
        //console.log('####id:'+recordId);
        //alert('Checking ');
		helper.cancelHwsCaseHelper(component,event);
	},
     myAction: function(component, event, helper) {
         // helper.getFailureDescriptionPickListValues(component, event);
         helper.getCaseStatus(component, event);
    },
})