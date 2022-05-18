({
	doInit : function(component, event, helper) {
		component.set('v.tableColumns', [
            {label: 'Select', type: 'button-icon', cellAttributes: { alignment: 'left' }, typeAttributes: { iconName : {fieldName: 'iconName'}, variant : {fieldName: 'iconVariant'}, alternativeText: { fieldName: 'actionLabel' }, name: 'toggle', title: {fieldName: 'actionLabel'}}},
            {label: 'Log Type', fieldName: 'CH_LogType__c', type: 'text', sortable: 'true', searchable: 'true'},
            {label: 'Log Category', fieldName: 'CH_Category__c', type: 'text', sortable: 'true', searchable: 'true'},
            {label: 'Log Collection Process', fieldName: 'LogCollectionProcess', type: 'text', sortable: 'true', searchable: 'true'},
        ]);
        component.set('v.selectedLogRequest', []);
        let caseId = component.get('v.recordId');
        helper.apexAction(component, 'c.isCaseOwnerOrTeamMember', { caseId : caseId }, true)
        .then((res) => (component.set('v.authorized', res), helper.apexAction(component, 'c.getCaseProductLogType', { caseId : caseId }, true)))
        .then((result) => component.set('v.logTypes', result.map((cur) => {
            cur.LogCollectionProcess = cur.CH_AutoLogCollection__c ? 'Automatic' : 'One Touch';
            cur.iconName = 'utility:add';
            cur.actionLabel = 'Add';
            cur.iconVariant = '';
            cur.active = false;
            return cur;
        })));
	},
    requestLog : function(component, event, helper) {
        helper.apexAction(component, 'c.getCase', { caseId : component.get('v.recordId') }, true).then((result) => {
            component.set('v.selectedNEA', result.CH_NetworkElementAsset__r);
            component.set('v.legalEntity', result.Account);
            component.set('v.product', result.Product);
            component.set('v.caseSite', result.CH_Site__c);
			component.set('v.logRequestWindow', true);
        });
	},
    selectNEA : function(component, event, helper) {
		component.set('v.selectNEAScreen', true);
	},
    cancelNEASelection : function(component, event, helper) {
		component.set('v.selectNEAScreen', false);
	},
    confirmNEASelection : function(component, event, helper) {
        if(component.get('v.temporaryNEA') != null){
            component.set('v.manualNEA', null);
        	component.set('v.selectedNEA', component.get('v.temporaryNEA'));    
        } else if(component.get('v.manualNEA') != ''){
            component.set('v.temporaryNEA', null);
            component.set('v.selectedNEA', null);
            component.set('v.manualNEA', component.get('v.manualNEA'));
        }
		component.set('v.selectNEAScreen', false);		
	},
    eventHandlerNEA : function(component, event, helper) {
        if(event.getParam("target") === 'NEA') {
            switch(event.getParam("message")) {
                case 'incrementActionCounter':
                    helper.incrementActionCounter(component);
                    break;
                case 'decrementActionCounter':
                    helper.decrementActionCounter(component); 
                    break;
                case 'select':
					component.set('v.temporaryNEA', JSON.parse((event.getParam("object")==null?null:event.getParam("object"))));
                    break;
                case 'noRecordFound':
                    component.set('v.noNEAsAvailable', true);
                    break;
            }
        }
	},
    cancelRequest : function(component, event, helper) {
        component.set('v.logRequestWindow', false);
		component.set('v.selectNEAScreen', false);
        component.set('v.manualNEA', null);
        component.set('v.selectedNEA', null);
        component.set('v.temporaryNEA', null);
        component.set('v.selectedLogRequest', []);
        let caseId = component.get('v.recordId');
        helper.apexAction(component, 'c.getCaseProductLogType', { caseId : caseId }, true)
        .then((result) => component.set('v.logTypes', result.map((cur) => {
            cur.LogCollectionProcess = cur.CH_AutoLogCollection__c ? 'Automatic' : 'One Touch';
            cur.iconName = 'utility:add';
            cur.actionLabel = 'Add';
            cur.iconVariant = '';
            cur.active = false;
            return cur;
        })));
	},
    submitRequest : function(component, event, helper) {
        console.log('component.get(v.selectedLogRequest) ' +component.get('v.selectedLogRequest'));
        if(component.get('v.selectedLogRequest').length > 0) {
            console.log('component.get(v.selectedNEA) ' + component.get('v.selectedNEA'));
            console.log('component.get(v.manualNEA) ' + component.get('v.manualNEA'));
            helper.apexAction(component, 'c.sendlogCollectionRequesttoNDA', { caseId : component.get('v.recordId'), selectedNEA : component.get('v.selectedNEA'), manualNEA : component.get('v.manualNEA'), selectedLogs : component.get('v.selectedLogRequest') }, true)
			.then((result) => {
                if(result === '200'){
                helper.showToast('success', 'Success', 'Log collection request sent successfully');
            }else{
                  helper.showToast('error', 'Error', 'Failed to send log collection request');
                  }
            });
        }
        component.set('v.logRequestWindow', false);
		component.set('v.selectNEAScreen', false);
        component.set('v.manualNEA', null);
        component.set('v.selectedNEA', null);
        component.set('v.temporaryNEA', null);
        component.set('v.selectedLogRequest', []);
        let caseId = component.get('v.recordId');
        helper.apexAction(component, 'c.getCaseProductLogType', { caseId : caseId }, true)
        .then((result) => component.set('v.logTypes', result.map((cur) => {
            cur.LogCollectionProcess = cur.CH_AutoLogCollection__c ? 'Automatic' : 'One Touch';
            cur.iconName = 'utility:add';
            cur.actionLabel = 'Add';
            cur.iconVariant = '';
            cur.active = false;
            return cur;
        })));
	},
    handleRowAction : function(component, event, helper) {
        let action = event.getParam('action'), row = event.getParam('row');
        let logTypes = component.get('v.logTypes');
        switch (action) {
            case 'toggle':
                if(row.active) {
                    row.iconName = 'utility:add';
                    row.actionLabel = 'Add';
                	row.iconVariant = '';
                    row.active = false;
                } else {
                    row.iconName = 'utility:check';
                    row.actionLabel = 'Remove';
                	row.iconVariant = 'brand';
                    row.active = true;
                }
            	let selectedRows = [];
                for(let i = 0, len = logTypes.length; i < len; i++) {
            		if(row.Id === logTypes[i].Id) { logTypes[i] = row; }
                	if(logTypes[i].active) { selectedRows = [...selectedRows, logTypes[i]]; }
                }
        		component.set('v.logTypes', logTypes);
        		component.set('v.selectedLogRequest', selectedRows);
                break;
        }
    }
})