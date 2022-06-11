({
	doInit : function(component, event, helper) {
		var key = component.get("v.key");
        var map = component.get("v.map");
        component.set("v.value" , map[key]);
	},
     /*#DSI-760-Sprint-14*/
    closeModel: function(component, event, helper) {
     	component.set("v.displayFeature", false);
     },
    /*#DSI-760-Sprint-14*/
    OpenComp : function(component, event, helper){
        
         var Prodcode = event.getSource().get("v.name");
       
        var action1 = component.get("c.getLineItemRec");
          action1.setParams({
            "ProdCode":Prodcode,
        });
        
        action1.setCallback(this, function(response){
             var name = response.getState();
          
          if(name === "SUCCESS") {
            component.set("v.FeatureList", response.getReturnValue());
              component.set("v.displayFeature",true);
              
          }
         });
        $A.enqueueAction(action1);

    },
    
})