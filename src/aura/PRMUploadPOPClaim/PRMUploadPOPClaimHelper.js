({
	//Function for sorting unrestrictedTable
    sortUnrestrictedTable : function(component, event, helper) 
    {
        $(document).ready(function(){
    	  $('#files').dataTable({
                    "retrieve": true,
              	    "bFilter": false,
              		"paging": false,
                    "bInfo": false });     
         	});
    },
   
    navigateToObject : function (component, event, helper)
    {        
        var contDocId = event.target.id;
        var navEvt = $A.get("e.force:navigateToSObject");        
        navEvt.setParams
        ({
          "recordId": contDocId,
          "slideDevName": "detail, related"
        });
        navEvt.fire();
	},
    deleteFileRecord: function(component, event, helper) {
        var contDocId = event.target.id;
        var action = component.get("c.deleteFileRecord");
        action.setParams({
            "ContentDocId":contDocId,
            "claimId": component.get("v.recordId")
        }); 
        action.setCallback(this, function(response) {
            var state = response.getReturnValue();  
            //alert(state);
            if (state === "SUCCESS") {
                helper.getFileRelatedList(component, event, helper);
                //component.set("v.RelatedList",response.getReturnValue());	
            }
            else{
                //alert(state);
                var errors = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: errors
                });
                toastEvent.fire();
                //alert(errors);
			}
        });
       $A.enqueueAction(action);
       
    },
    
    getFileRelatedList: function(component, event, helper) {
        //alert('HI');
      var fileList = component.get("c.getFileLists");
      fileList.setParams({
          "claimId": component.get("v.recordId")
      }); 
      fileList.setCallback(this, function(a) {
          component.set("v.RelatedList",a.getReturnValue());
      });
      $A.enqueueAction(fileList);
  },
})