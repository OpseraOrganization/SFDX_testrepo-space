({
    doInit : function(component, event, helper) {
		var action = component.get("c.validateCaseStatus");
        action.setParams({
            "caseId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var buttonDisable=response.getReturnValue(); 
                component.set("v.viewAddMemberButton",buttonDisable);                               
            }
            else {
                var errors = response.getError();                
                this.showToast('error', 'Error','Add Member Button : '+ errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
            }
            
        });
        $A.enqueueAction(action);
        component.set('v.columns', [
            {label: 'Team Member', fieldName: 'MemberURL', sortable: 'true', type: 'url', typeAttributes: {
                label: { fieldName: 'MemberName' }, target : '_self',
                tooltip: { fieldName: 'MemberName' }
            }},
            {label: 'Member Role', fieldName: 'TeamRoleName', sortable: 'true', type: 'text'},
            {label: 'Engagement Date', fieldName: 'CreatedDate', sortable: 'true', type: 'datetime'},
            { type: 'action', typeAttributes: { rowActions: [{ label: 'Delete', name: 'delete' }]}}
        ]);
        helper.init(component);
    },
    toggleView: function (component, event, helper) {
        component.set('v.viewToggle',!component.get('v.viewToggle'));
        var element = document.getElementById("customDatatable");
        if(component.get('v.viewToggle')){
            element.classList.remove("max-height");
        }
        else {
            element.classList.add("max-height");            
        }
    },
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');

        switch (action.name) {
            case 'delete':
                helper.deleteMember(component, {'Id': row.Id});
                break;
        }
    },
    sort : function(component, event, helper) {
        var fieldName = event.getParam('fieldName'),
        	sortDirection = event.getParam('sortDirection'),
        	reverse = sortDirection !== 'asc',
        	data = component.get("v.members");
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        // sorts the rows based on the column header that's clicked
        if(fieldName == 'MemberURL') {
            data.sort(helper.sortBy('MemberName', reverse));
        } else {
            data.sort(helper.sortBy(fieldName, reverse));
        }
        component.set("v.members", data);
    },
	 // When clicked display the CaseTeam in newtab
    openAssignment : function(component,event,helper) {
        var caseId = component.get("v.recordId");
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId()
        .then(function(tabId) {
            return workspaceAPI.openSubtab({
                parentTabId: tabId,
                recordId: caseId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__CH_CA_CaseTeam_Page"
                    },
                    "state": {
                        "uid": "1",
                        "c__recordId": caseId
                    }
                },
                focus: true
            });
        })
        .then(function(response) {
            var focusedTabId = response;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Case Team"
            });
        })
        .catch(function(error) {
            console.log('Error logged for CH_CA_CaseTeam_Page:'+error);
        });        
    },
})