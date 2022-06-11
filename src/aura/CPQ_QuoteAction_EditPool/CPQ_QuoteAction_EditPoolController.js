({
    doInit : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var action3 = component.get('c.getPricingPoolOnQuote');
        
        action3.setParams({ recordId : recId })
        action3.setCallback(this,function(response){
            var state = response.getState();
            console.log(state);
            if(state === 'SUCCESS' || state === 'DRAFT'){
                var wrapperData = response.getReturnValue();
                console.log("Data ... ",wrapperData);
                component.set("v.pricingPoolList", wrapperData.poolData);
                component.set("v.opportunityId", wrapperData.quoteData.Apttus_Proposal__Opportunity__c);
               
                component.set("v.pricingPoolValPick", wrapperData.quoteData.CPQ_Pricing_Pool__c);
                
                component.set("v.priceConValPick", wrapperData.quoteData.CPQ_Contractual_Price_Condition__c);
                
                console.log("Wrapper quoteData ",wrapperData.quoteData.CPQ_Pricing_Pool__c);
                console.log("wrapperData.quoteData.CPQ_Contractual_Price_Condition__c ",wrapperData.quoteData.CPQ_Contractual_Price_Condition__c);
                console.log("Id>>> ",wrapperData.quoteData.Id);
                var poolDataId=" ";
                console.log("i Value "+poolDataId);
                for(var i=0;i<wrapperData.poolData.length;i++){
                    if(wrapperData.quoteData.CPQ_Pricing_Pool__c === wrapperData.poolData[i].CPQ_Pricing_Pool_Name__c){
                        poolDataId=wrapperData.poolData[i].Id;
                        console.log("if condition "+wrapperData.poolData[i].Id);
                    }else{
                        console.log("i Value "+i);
                    }
                    console.log("Name ",wrapperData.poolData[i].CPQ_Pricing_Pool_Name__c+" = "+wrapperData.poolData[i].Id);
                }
                console.log("poolDataId   ",poolDataId);
                //var oppId = component.get("v.opportunityId");
        		//var ppValue = component.get("v.pricingPoolValPick");
        		helper.pricingPoolHelper(component, event, helper,poolDataId);//"aFk030000008OOUCA2"
            }
        });
        $A.enqueueAction(action3);    


    },
    
    handlePricingPool: function(component, event, helper) {
        component.set("v.priceConList", null);
        var oppId = component.get("v.opportunityId");
        var ppValue = component.get("v.pricingPoolValPick");
        console.log('RRR1 :: ', ppValue);
        var res = ppValue.split("---");
        console.log('RRR1 :: res ', res);
        
        component.set("v.pricingPoolVal", res[0]);
        
        var action3 = component.get('c.getPricingConditions');
        console.log(res[1]);
        action3.setParams({ recordId : oppId, ppId : res[1] })
        action3.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS' || state === 'DRAFT'){
                var priceConList = response.getReturnValue();
                console.log("priceConList ",priceConList[0].CPQ_Description__c);
                component.set("v.priceConList", priceConList);
            }
        });
        $A.enqueueAction(action3);
    },
    
    handlePriceCondition: function(component, event, helper) {
        var ppConValue = component.get("v.priceConValPick");
        console.log('RRR2 :: ', ppConValue);
        var res = ppConValue.split("---");
        console.log('RRR2 :: res ', res);
        
        component.set("v.priceConVal", res[0]);
        component.set("v.priceConCodeVal", res[1]);
    },
    
    handleSubmit : function(component, event, helper) {
        component.set("v.isLoading", 'true');
    },
    
    handleError : function(component, event, helper) {
        component.set("v.isLoading", 'false');
    },
    
    handleSuccess : function(component, event, helper) {
        component.set("v.isLoading", 'false');
        console.dir('onsuccess: ');
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully.",
            "type": "success"
        });
        toastEvent.fire();
        
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})