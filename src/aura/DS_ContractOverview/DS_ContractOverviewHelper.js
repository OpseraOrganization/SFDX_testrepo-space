({
        getTechnologyHelper : function(component, event, helper){
             var newaction = component.get("c.getFrameContractReference");
             newaction.setCallback(this, function(response) {
             var state = response.getState();
             if (response.getState() === "SUCCESS") {
                    var returnStringVal = response.getReturnValue();    
                    component.set("v.FrameContractRef",returnStringVal);
                }
            });
            $A.enqueueAction(newaction);
        },
    
        getPOHelper : function(component, event, helper){    
             var newaction = component.get("c.getPO");
             newaction.setCallback(this, function(response) {
                var state = response.getState();
                if (response.getState() === "SUCCESS") {
                    var returnStringVal = response.getReturnValue();       
                    component.set("v.PO",returnStringVal);
                  }
            });
            $A.enqueueAction(newaction);
        },
    
      showFiles : function(component, event, helper) {        
              var frameContractRef = component.find("fc").get("v.value");	 
              var po = component.find("po").get("v.value");
              var actionstatusDetails = component.get("c.getFiles"); 
              actionstatusDetails.setParams({
                "frameContractRef": frameContractRef,
                "po": po
            });
            actionstatusDetails.setCallback(this, function(response) {
            component.set('v.contents',response.getReturnValue());
            var contacts = component.get("v.contents");//Getting Map and Its value      
            if(contacts === "NO URL"){
               component.set("v.contents",1);   
             }
             if(contacts === "None"){
               component.set("v.contents",2);   
             }          
          });
            $A.enqueueAction(actionstatusDetails); 
        }
    
    })