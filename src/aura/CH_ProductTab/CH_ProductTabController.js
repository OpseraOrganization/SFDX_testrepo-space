({
		       
    openProductPulldown : function(component, event, helper) {
        let object = component.get('v.object'), action;
        if(object === 'Case') {
            action = component.get('c.hasCaseEditAcess');
            action.setParams({ "caseRecordId" : component.get("v.recordId"), fields : [
                'ProductId', 'CH_Product_Release__c', 'CH_Product_Module__c', 'CH_ProductVariant__c', 
                'CH_Solution__c', 'CH_SW_Component__c', 'CH_SW_Release__c', 'CH_SW_Module__c',
                'CH_SW_Build__c', 'CH_HW_Component__c'
            ]});
        }
        else if(object === 'Asset') {
            action = component.get('c.hasAssetEditAcess');
            action.setParams({ "assetRecordId" : component.get("v.recordId"), fields : [
                'Product2Id', 'CH_ProductRelease__c', 'CH_ProductVariant__c', 'CH_Solution__c', //Changes added for NOKIASC-36197
				 'CH_SWRelease__c','CH_SWComponent__c','CH_SWModule__c','CH_SWBuild__c'
            ]});
        }
        action.setCallback(this,function(response){
            if (response.getState() === "SUCCESS") {
                if (response.getReturnValue() == '') {
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef: "c:CH_ProductPulldown",
                        componentAttributes:{
                            id : component.get("v.recordId"),
                            object : object,
                            type : object === 'Asset'?'Complete':(component.get("v.lockedFields")?'CompleteMinimalLocked':'Complete')
                        }            
                    });
                    evt.fire();
                  
                }
                else helper.showToastMessage('Error',response.getReturnValue());                            
            }
        });
        $A.enqueueAction(action);
	},
    updateEntitlement : function (component, event, helper){
        var action = component.get('c.enableReEntitlement');
        action.setParams({ "caseRecordId" : component.get("v.recordId") });
        action.setCallback(this,function(response){
            if (response.getState() === "SUCCESS") {
                if (response.getReturnValue() == '') {
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef: "c:CH_ReEntitlement",
                        componentAttributes:{
                            caseId : component.get("v.recordId")
                        }            
                    });
                    evt.fire();
                } else {
                    helper.showToastMessage('Error',response.getReturnValue()); 
                }                              
            }
        });
        $A.enqueueAction(action);
    }
})