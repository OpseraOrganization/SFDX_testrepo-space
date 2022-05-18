({
	doInit : function(component, event, helper) {
        helper.init(component, helper, component.get("v.recordId"));
	},
    addProduct : function(component, event, helper) {
        helper.action(component, 'c.getValidArticleProducts', {articleId: component.get("v.recordId")}, (relatedList) => {
            let result = [];
            for(let i in relatedList) {
            	result = [...result, relatedList[i].CH_Product__r];
        	}
            component.set('v.selectHandler', result);
            component.set('v.select', "Product");
        });
    },
    addProductRelease : function(component, event, helper) {
        var productId = event.getSource().get("v.value");
    	helper.action(component, 'c.getValidProductReleases', {articleId: component.get("v.recordId"), productId: productId}, (relatedList) => {
        	component.set('v.selectParent', productId);
            component.set('v.selectHandler', relatedList);
            component.set('v.select', "Product Release");
        });
    },
    cancelSelection : function(component, event, helper) {
        component.set('v.select', "");
        component.set('v.selectParent', "");
        component.set('v.selectHandler', []);
    },
    saveSelection : function(component, event, helper) {
        var articleId = component.get("v.recordId");
        var id = document.getElementById("smartSelector").value;
        var parentId = component.get("v.selectParent");
        var target = component.get('v.select');
        component.set('v.select', "");
        component.set('v.selectParent', "");
        component.set('v.selectHandler', []);
        if(id !== '' && id !== 'None'){
            let productRelation = {CH_Knowledge__c : articleId};
            if(target === "Product") productRelation["CH_Parent_Product__c"] = id;
            else if(target === "Product Release") productRelation["CH_Parent_Product__c"] = parentId, productRelation["CH_Parent_Release__c"] = id;
            helper.action(component, 'c.saveProductRelation', {articleId: articleId, productRelation : JSON.stringify(productRelation)}, (result) => {
                helper.init(component, helper, articleId);
            });
        }
        else helper.showToast('Error', 'Error', "No "+target+" selected.");
    },
    removeProduct : function(component, event, helper) {
        component.set('v.remove', "Product");
        component.set('v.removeHandler', event.getSource().get("v.value"));
    },
    removeProductRelease : function(component, event, helper) {
        component.set('v.remove', "Product Release");
        component.set('v.removeHandler', event.getSource().get("v.value"));
    },
    cancelRemove : function(component, event, helper) {
        component.set('v.remove', "");
        component.set('v.removeHandler', "");
    },
    confirmRemove : function(component, event, helper) {
        var articleId = component.get("v.recordId");
        var target = component.get("v.remove");
        var id = component.get("v.removeHandler");
        component.set('v.remove', "");
        component.set('v.removeHandler', "");
        helper.action(component, 'c.removeProductOrReleaseRelation', {articleId: articleId, target: target, objId: id}, (relatedList) => {
            helper.init(component, helper, articleId);
        });
    }
})