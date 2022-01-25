({
    doInit: function(component, event, helper) {
        let object = component.get("v.object"),
            params = object === 'Case' ? {
                caseId: component.get('v.id')
            } : {};
        helper.apexAction(component, 'c.permissionToChangeCaseTag', null, true)
        .then(authorized => helper.apexAction(component, 'c.get' + object, params, true)
        .then(oCase => {
            component.set('v.oldCaseTag', oCase.CH_Tag__r?oCase.CH_Tag__r:{ CH_Product__c : oCase.ProductId });
            helper.getTagDetails(component, 'CH_IssueType__c', { CH_Product__c : oCase.ProductId })
            .then(tags => component.set('v.authorized', (authorized && tags.length > 0)));
        }));
    },
    openPopUp: function(component, event, helper) {
        let tag = JSON.parse(JSON.stringify(component.get('v.oldCaseTag')));
        component.set('v.newCaseTag', tag);
        component.set('v.visible', true);
        //
        component.set('v.issueTypesList', []);
        helper.getTagDetails(component, 'CH_IssueType__c', tag)
        .then(result => {
            component.set('v.issueTypesList', result.map(cur => {
            	return { label: cur, value: cur, visible: true };
            }));
    		component.find('iType').setSelectedValue(tag.CH_IssueType__c);
        });
    	//
        component.set('v.issueDetailsList', []);
        helper.getTagDetails(component, 'CH_IssueDetails__c', tag)
        .then(result => {
            component.set('v.issueDetailsList', result.map(cur => {
            	return { label: cur, value: cur, visible: true };
            }));
    		component.find('iDetails').setSelectedValue(tag.CH_IssueDetails__c);
        });
    	//
        component.set('v.additionalDetailsList', []);
        helper.getTagDetails(component, 'CH_AdditionalDetails__c', tag)
        .then(result => {
            component.set('v.additionalDetailsList', result.map(cur => {
            	return { label: cur, value: cur, visible: true };
            }));
    		component.find('aDetails').setSelectedValue(tag.CH_AdditionalDetails__c);
        });
    },
    onChangeIssueType: function(component, event, helper) {
        let tag = JSON.parse(JSON.stringify(component.get('v.newCaseTag')));
        tag.CH_IssueType__c = event.getParam('value');
        tag.CH_IssueDetails__c = null;
        tag.CH_AdditionalDetails__c = null;
        component.set('v.newCaseTag', tag);
        //
        component.set('v.issueDetailsList', []);
        component.set('v.additionalDetailsList', []);
        helper.getTagDetails(component, 'CH_IssueDetails__c', tag)
        .then(result => {
            component.set('v.issueDetailsList', result.map(cur => {
            	return { label: cur, value: cur, visible: true };
            }));
        });
    },
    onChangeIssueDetails: function(component, event, helper) {
        let tag = JSON.parse(JSON.stringify(component.get('v.newCaseTag')));
        tag.CH_IssueDetails__c = event.getParam('value');
        tag.CH_AdditionalDetails__c = null;
        component.set('v.newCaseTag', tag);
        //
        component.set('v.additionalDetailsList', []);
        helper.getTagDetails(component, 'CH_AdditionalDetails__c', tag)
        .then(result => {
            component.set('v.additionalDetailsList', result.map(cur => {
            	return { label: cur, value: cur, visible: true };
            }));
        });
    },
    onChangeAdditionalDetails: function(component, event, helper) {
        let tag = JSON.parse(JSON.stringify(component.get('v.newCaseTag')));
        tag.CH_AdditionalDetails__c = event.getParam('value');
        component.set('v.newCaseTag', tag);
    },
    newTagRedirect: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": 'https://nokia.sharepoint.com/sites/E2ENwProg/Lists/TagRequest/NewForm.aspx'
        });
        urlEvent.fire();
    },
    closePopUp : function(component, event, helper) {
        component.set('v.visible', false);
    },
    save: function(component, event, helper) {
        if (!helper.isLoading(component)) {
            let object = component.get("v.object");
            let sObject = {
                Id: component.get('v.id')
            };
        	let tag = JSON.parse(JSON.stringify(component.get('v.newCaseTag')));
            helper.apexAction(component, 'c.getTag', {
                productId : tag.CH_Product__c,
                issueType : tag.CH_IssueType__c,
                issueDetails : tag.CH_IssueDetails__c,
                additionalDetails : tag.CH_AdditionalDetails__c
            }, true).then(resultTag => {
                sObject.CH_Tag__c = resultTag.Id;
                let params = object === 'Case' ? {
                    operationType: 'update',
                    oCase: sObject,
                    withoutSharing: false
                } : {};
                helper.apexAction(component, 'c.do' + object, params, true).then(result => {
                    $A.get('e.force:refreshView').fire();
                    component.set('v.visible', false);                
            	});
            });
        }
    }
})