({
	init : function(component, helper, articleId) {
        helper.action(component, 'c.getArticleProductsAndReleases', {articleId: articleId}, (relatedList) => {
            let result = [];
            let releases = {};
            for(let i in relatedList) {
                if(relatedList[i].CH_Parent_Release__c && relatedList[i].CH_Parent_Product__c){
                    if(releases[relatedList[i].CH_Parent_Product__r.Id]){
                    	releases[relatedList[i].CH_Parent_Product__r.Id] = [...releases[relatedList[i].CH_Parent_Product__r.Id] ,{Id : relatedList[i].CH_Parent_Release__r.Id, Name : relatedList[i].CH_Parent_Release__r.Name}];
                	}
            		else releases[relatedList[i].CH_Parent_Product__r.Id] = [{Id : relatedList[i].CH_Parent_Release__r.Id, Name : relatedList[i].CH_Parent_Release__r.Name}];
            	}
                else if(!relatedList[i].CH_Parent_Release__c) {
            		result = [...result, {Id : relatedList[i].CH_Parent_Product__r.Id, Name : relatedList[i].CH_Parent_Product__r.Name, releases : []}];
            	}
        	}
            for(let i in result){
    			result[i].releases = releases[result[i].Id]?releases[result[i].Id]:[];
            }
        	component.set('v.products', result);
        });
        helper.action(component, 'c.canEdit', {articleId: articleId}, (result) => {
        	component.set('v.editable', !result);
        });
	},
	action : function(component, action, params, callback) {
        this.incrementActionCounter(component);
        var action = component.get(action);
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            this.decrementActionCounter(component);
            if (state === "SUCCESS"){
                callback(response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.log(errors && errors[0] && errors[0].message?("Error message: " + errors[0].message):"Unknown error");
                this.showToast('Error', 'Internal Error', errors && errors[0] && errors[0].message?errors[0].message:"Unknown error");
            }
        });
        $A.enqueueAction(action);
	},
    incrementActionCounter : function(component) {        
        var counter = component.get("v.actionCounter") + 1;
        if(counter === 1) {
            component.set("v.showSpinner", true);
        }
        component.set("v.actionCounter", counter);        
    },
    decrementActionCounter : function(component) {
        var counter = component.get("v.actionCounter") - 1;
        if(counter === 0) {
            component.set("v.showSpinner", false);
        }
        component.set("v.actionCounter", counter);    
    },
    showToast: function(sType, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": sType
        });
        toastEvent.fire();
    }
})