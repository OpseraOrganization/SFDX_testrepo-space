({
	doInit : function(component, event, helper) {
        helper.incrementActionCounter(component);
        helper.setTabIcon(component);
        let object 		= component.get("v.object"),
            params		= object === 'Case'?{ caseId: component.get('v.id') }:(object === 'Asset'?{ assetId: component.get('v.id') }:{}),
            fieldMap 	= object === 'Case'?{
                'product': "Product", 'productRelease': "CH_Product_Release__r",
                'productVariant': "CH_ProductVariant__r", 'solution': "CH_Solution__r"
            }:{
                'product': "Product2", 'productRelease': "CH_ProductRelease__r",
                'productVariant': "CH_ProductVariant__r", 'solution': "CH_Solution__r",//Changes added for NOKIASC-36197
                'swComponent':"CH_SWComponent__r", 'swRelease':"CH_SWRelease__r",
                'swModule':"CH_SWModule__r",'swBuild':"CH_SWBuild__r"
            };
        helper.apexAction(component, 'c.get'+object, params, (error, result) => {
            helper.decrementActionCounter(component);
            if(error) {
                helper.showToast('error', 'Error', error && error[0] && error[0].message?error[0].message:"Something went wrong");
                return console.log(error);
            }
            let predefinedFields = {};
            Object.entries(fieldMap).forEach(([key, value], index, array) => {
        		predefinedFields[key] = result[value]?result[value]:null;
            	let selectedKey = (key.charAt(0).toUpperCase() + key.slice(1));
                selectedKey = selectedKey.replace('Sw', 'SW').replace('Hw', 'HW');
            	component.set('v.selected'+ selectedKey, result[value]?result[value]:null);
            	if(index == (array.length-1)) component.set('v.predefinedFields', predefinedFields);
            });
    	});
	},
    eventHandler : function(component, event, helper) {
        var message = event.getParam("message"), stage = component.get('v.stageNumber');
        switch(message){
            case 'incrementActionCounter':
                helper.incrementActionCounter(component);
                break;
            case 'decrementActionCounter':
                helper.decrementActionCounter(component);
                break;
            default:
                let target = event.getParam("target");
                let object = JSON.parse((event.getParam("object")==null?null:event.getParam("object")));
                component.set('v.selected'+target.split(' ').join(''), object);
                break;
        }
	},
    cancel : function(component, event, helper) {
        helper.closeTab(component);
	},
    saveHandler : function(component, event, helper) {
        if(!helper.isLoading(component)) {
			helper.incrementActionCounter(component);
            let object = component.get("v.object"), displayType = component.get('v.type');
            let sObject = {Id : component.get('v.id')};
            let productId = component.get('v.selectedProduct').Id;
            if(productId != null) {
                //
                sObject[object !== 'Case'?'Product2Id':'ProductId'] = productId;
                if(displayType === 'Minimal' || displayType === 'Complete') {
                    sObject.CH_Solution__c = component.get('v.selectedSolution')?component.get('v.selectedSolution').Id:null;
                    sObject.CH_ProductVariant__c = component.get('v.selectedProductVariant')?component.get('v.selectedProductVariant').Id:null;
                    if(object === 'Case') sObject.CH_Product_Release__c = component.get('v.selectedProductRelease')?component.get('v.selectedProductRelease').Id:null;
                    else if(object === 'Asset') sObject.CH_ProductRelease__c = component.get('v.selectedProductRelease')?component.get('v.selectedProductRelease').Id:null;
                }
				//Changes added for NOKIASC-36197
                if(displayType === 'CompleteMinimalLocked' || displayType === 'Complete') {
				 if(object === 'Case') {
				sObject.CH_Product_Module__c = component.get('v.selectedProductModule')?component.get('v.selectedProductModule').Id:null;
				sObject.CH_SW_Component__c = component.get('v.selectedSWComponent')?component.get('v.selectedSWComponent').Id:null;
				sObject.CH_SW_Release__c = component.get('v.selectedSWRelease')?component.get('v.selectedSWRelease').Id:null;
				sObject.CH_SW_Module__c = component.get('v.selectedSWModule')?component.get('v.selectedSWModule').Id:null;
				sObject.CH_SW_Build__c = component.get('v.selectedSWBuild')?component.get('v.selectedSWBuild').Id:null;
				sObject.CH_HW_Component__c = component.get('v.selectedHWComponent')?component.get('v.selectedHWComponent').Id:null;   
				 }
				else if(object === 'Asset') {
						sObject.CH_SWComponent__c = component.get('v.selectedSWComponent')?component.get('v.selectedSWComponent').Id:null;
						sObject.CH_SWRelease__c = component.get('v.selectedSWRelease')?component.get('v.selectedSWRelease').Id:null;
						sObject.CH_SWModule__c = component.get('v.selectedSWModule')?component.get('v.selectedSWModule').Id:null;
						sObject.CH_SWBuild__c = component.get('v.selectedSWBuild')?component.get('v.selectedSWBuild').Id:null;
						
					} 					 
                }
                //
                let params = object === 'Case'?{ operationType: 'update', oCase: sObject, withoutSharing: false}:
                							   (object === 'Asset'?{ operationType: 'update', oAsset: sObject, withoutSharing: false}:{});
                helper.apexAction(component, 'c.do'+object, params, (error, result) => {
                    helper.decrementActionCounter(component);
                    if(error) {
                        helper.showToast('error', 'Error', error && error[0] && error[0].message?error[0].message:"Something went wrong");
                        return console.log(error);
                    }
                    //
                    helper.closeTab(component);
                });
            }
            else helper.decrementActionCounter(component);            
        }
    }
})