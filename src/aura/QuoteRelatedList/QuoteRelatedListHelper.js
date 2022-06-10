({
	 getAllProposal : function(component, event, helper) {
       var quoteId=component.get("v.recordId");
        var action1 = component.get("c.getProposalLineItemMapping");
          action1.setParams({
            "QuoteID": component.get("v.recordId"),
        });
        action1.setCallback(this, function(a){
            var length=a.getReturnValue().length;
            var state = a.getState();
            var arr=[];
            if (state === "SUCCESS") {
            component.set("v.netPrice", a.getReturnValue());
                for(var i=0; i<length;i++ ){
                    if(a.getReturnValue()[i].DS_Grouping_Name != undefined){
                    arr.push(a.getReturnValue()[i].DS_Grouping_Name);
                    }
                }
               this.getGroupingRelatedData(component, event, helper,arr,quoteId);
            }
         });
        $A.enqueueAction(action1);
         
         
         
        var action = component.get("c.getProposalLineItem");
          action.setParams({
            "QuoteID": component.get("v.recordId"),
        });
        action.setCallback(this, function(a){
            component.set("v.proposalLineItem", a.getReturnValue());
           // alert(length)
         });
        $A.enqueueAction(action);
    },
    
   getAllProposal1 : function(component, event, helper) {
 
        var action1 = component.get("c.getProductInfoLineItem");
          action1.setParams({
            "QuoteID": component.get("v.recordId"),
        });
        action1.setCallback(this, function(a){
            component.set("v.ProductInfoLineItem", a.getReturnValue());
         });
        $A.enqueueAction(action1);
    }, 
    
     getServiceInfoItems : function(component, event, helper) {
 
        var action2 = component.get("c.getServiceInfoLineItem");
          action2.setParams({
            "QuoteID": component.get("v.recordId"),
        });
        action2.setCallback(this, function(a){
            component.set("v.ServiceInfoLineItem", a.getReturnValue());
         });
        $A.enqueueAction(action2);
    }, 
    
    getGroupingRelatedData : function(component, event, helper,arr,quoteId) {
       
        var action = component.get("c.getProposalLineItemGrouping");
        action.setParams({
            "QuoteID": quoteId,
            "CustomerGroup":arr
        });
        action.setCallback(this, function(a){
             var state = a.getState();
            
          var arrayMapKeys = [];
           var result = a.getReturnValue();
           component.set('v.myGroupMap', result);
             for (var key in result) {
                    arrayMapKeys.push(key);
                }
                component.set('v.keyList', arrayMapKeys);
        });
        $A.enqueueAction(action);
    
}
})