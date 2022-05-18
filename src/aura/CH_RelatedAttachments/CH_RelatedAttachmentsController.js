({
	doInit : function(component, event, helper) {
        const logCollection = component.get('v.logCollection');
        const dateType = { year: 'numeric', month: 'short', day: '2-digit', hour: '2-digit', minute: '2-digit' };
        let aGlobalActions =  [], lGlobalActions =  [];
        if(logCollection) {
            //Log Columns
            component.set('v.lTableColumns', [
                {label: 'Request Id', fieldName: 'URL', sortable: 'true', searchable: 'true', type: 'url', typeAttributes: {
            		label: { fieldName: 'CH_LogCollectionRequestID__c' }, tooltip : { fieldName: 'description' }, title : { fieldName: 'description' }
                }},
                {label: 'Log Type', fieldName: 'CH_LogType__c', sortable: 'true', searchable: 'true', type: 'text' },
                {label: 'Log Category', fieldName: 'CH_LogCategory__c', sortable: 'true', searchable: 'true', type: 'text' },
                {label: 'Log Collection Process', fieldName: 'LogCollectionProcess', sortable: 'true', searchable: 'true', type: 'boolean' },            
                {label: 'NEA', fieldName: 'CH_NetworkElementAsset__c', sortable: 'true', searchable: 'true', type: 'text' },
                {label: 'Requested', fieldName: 'CH_RequestDate__c', sortable: 'true', searchable: 'true', type: 'date', typeAttributes : dateType },
                {label: 'Status', fieldName: 'CH_RequestStatus__c', sortable: 'true', searchable: 'true', type: 'text' },
                {label: 'File Name', fieldName: 'File_Name__c', sortable: 'true', searchable: 'true', type: 'text' },
                { type: 'action', typeAttributes: { rowActions: [
                    { label: 'Show Details', name: 'show_details' },
                    { label: 'Log Analysis', name: 'log_analysis' }
                ]}},
            ]);
            //
            aGlobalActions =  [{name:'toggle', label:'Logs Collection'}];
            lGlobalActions =  [{name:'toggle', label:'Attachments'}];
        }
        helper.apexAction(component, 'c.getUserAttachmentActionsAuthorization', { caseId : component.get('v.recordId') }, true)
        .then(result => {
            if(result.download) {
                aGlobalActions = [...aGlobalActions, {name:'download', label:'Download'}];
                lGlobalActions = [...lGlobalActions, {name:'download', label:'Download'}];
        	}
            if(result.delete) {
                aGlobalActions = [...aGlobalActions, {name:'delete', label:'Delete'}];
        	}
            if(result.share) {
                aGlobalActions = [...aGlobalActions, {name:'share', type: 'dropdown', label:'Share with R&D'}];
        	}
            if(result.link) {
                aGlobalActions = [...aGlobalActions, {name:'link', type: 'dropdown', label:'Link to Problem'}];
        	}
            if(result.unlink) {
                aGlobalActions = [...aGlobalActions, {name:'unlink', type: 'dropdown', label:'Unlink from Problem'}];
        	}
        	component.set('v.capsInstance', result.capsInstance);
        	component.set('v.baseUrl', result.baseUrl);
        	component.set('v.rndInterface', result.rndInterface);
        	component.set('v.aGlobalActions', [...aGlobalActions, {name:'refresh', type: 'dropdown', label:'Refresh'}]);
        	component.set('v.lGlobalActions', [...lGlobalActions, {name:'refresh', type: 'dropdown', label:'Refresh'}]);
        });
		//
        helper.apexAction(component, 'c.isCommunity', null, true)
        .then(result => {
            component.set('v.isCommunity', result);
            //Attachments Columns
            if(result != true) {
                component.set('v.aTableColumns', [
                    {label: 'File Name', fieldName: 'URL', sortable: 'true', searchable: 'true', type: 'url', typeAttributes: {
                        label: { fieldName: 'File_Name__c' }, tooltip : { fieldName: 'description' }, title : { fieldName: 'description' }
                    }},
                    {label: 'Version', fieldName: 'CH_FileType__c', sortable: 'true', searchable: 'true', type: 'text' },
                    {label: 'Status', fieldName: 'CH_Status__c', sortable: 'true', searchable: 'true', type: 'text' },
                    {label: 'Sensitive Data', fieldName: 'Sensitive_Data__c', sortable: 'true', searchable: 'true', type: 'boolean' },
                    {label: 'Source', fieldName: 'CH_Portal_or_Email_to_Case__c', sortable: 'true', searchable: 'true', type: 'text' },
                    {label: 'Mark For Delete', fieldName: 'CH_MarkForDelete__c', sortable: 'true', searchable: 'true', type: 'boolean' },
                    {label: 'Customer Visible', fieldName: 'Customer_Visible__c', sortable: 'true', searchable: 'true', type: 'boolean' },
                    {label: 'Problem Visible', fieldName: 'CH_ProblemVisible__c', sortable: 'true', searchable: 'true', type: 'boolean' },
                    {label: 'Size', fieldName: 'CH_Size__c', sortable: 'true', searchable: 'true', type: 'text' },
                    {label: 'Description', fieldName: 'CH_Description__c', searchable: 'true', type: 'hidden' },
                    {label: 'Uploaded', fieldName: 'CH_Uploaded__c', searchable: 'true', type: 'date', typeAttributes : dateType },
                    { type: 'action', typeAttributes: { rowActions: [
                        { label: 'Show Details', name: 'show_details' },
                        { label: 'Log Analysis', name: 'log_analysis' }
                    ]}},
                ]);
            } else {
                component.set('v.aTableColumns', [
                    {label: 'File Name', fieldName: 'URL', sortable: 'true', searchable: 'true', type: 'url', typeAttributes: {
                        label: { fieldName: 'File_Name__c' }, tooltip : { fieldName: 'description' }, title : { fieldName: 'description' }
                    }},
                    {label: 'Version', fieldName: 'CH_FileType__c', sortable: 'true', searchable: 'true', type: 'text' },
                    {label: 'Status', fieldName: 'CH_Status__c', sortable: 'true', searchable: 'true', type: 'text' },
                    {label: 'Sensitive Data', fieldName: 'Sensitive_Data__c', sortable: 'true', searchable: 'true', type: 'boolean' },
                    {label: 'Source', fieldName: 'CH_Portal_or_Email_to_Case__c', sortable: 'true', searchable: 'true', type: 'text' },
                    {label: 'Mark For Delete', fieldName: 'CH_MarkForDelete__c', sortable: 'true', searchable: 'true', type: 'boolean' },
                    {label: 'Customer Visible', fieldName: 'Customer_Visible__c', sortable: 'true', searchable: 'true', type: 'boolean' },
                    {label: 'Size', fieldName: 'CH_Size__c', sortable: 'true', searchable: 'true', type: 'text' },
                    {label: 'Description', fieldName: 'CH_Description__c', searchable: 'true', type: 'hidden' },
                    {label: 'Uploaded', fieldName: 'CH_Uploaded__c', searchable: 'true', type: 'date', typeAttributes : dateType },
                    { type: 'action', typeAttributes: { rowActions: [
                        { label: 'Show Details', name: 'show_details' },
                        { label: 'Log Analysis', name: 'log_analysis' }
                    ]}},
                ]);
            }
            //
            helper.getAttachments(component);
			helper.setTabIcon(component);
        });
	},
    handleGlobalAction : function(component, event, helper) {
        let selected = component.find("cAttachmentsTable").getSelectedRows();
        switch(event.getParam('action')) {
            case 'viewAll':
                if(! component.get('v.isCommunity')) {
                    var event = $A.get("e.force:navigateToComponent");
                    event.setParams({
                        componentDef: "c:CH_RelatedAttachments",
                        componentAttributes:{
                            recordId : component.get("v.recordId"),
                            type : component.get("v.type"),
                            logCollection : component.get("v.logCollection"),
                            viewAll: true
                        }
                    });
                    event.fire();
                }
                else component.set('v.viewAll', true);
                break;
            case 'refresh':
                helper.getAttachments(component);
                break;
            case 'toggle':
                component.set('v.type', component.get('v.type') === 'Attachments' ? 'Logs Collection' : 'Attachments');
                break;
            case 'download':
                if(selected.length == 0) { return helper.showToast(component, 'error', 'Error', 'Select at least one ' + (component.get('v.type') === 'Attachments' ? 'attachment.' :'log collection.')); }
        		if (selected.length > 10) { return helper.showToast(component, 'error', 'Error', 'You can only download a maximum of 10 files.'); }
                for(let i = 0, len = selected.length; i < len; i++) {
                    if(selected[i].CH_Status__c != 'Ready') {
                        return helper.showToast(component, 'error', 'Error', 'Status must be Ready to download any file.');
                    }
                }
                helper.apexAction(component, 'c.downloadAttachments', { oAttachmentList : selected }, true)
        		.then(res => helper.downloadHandler(component, res));
                break;
            case 'delete':
                if(selected.length == 0) { return helper.showToast(component, 'error', 'Error', 'Select at least one attachment.'); }
                for(let i = 0, len = selected.length; i < len; i++) {
                    if(selected[i].CH_MarkForDelete__c) {
                        return helper.showToast(component, 'error', 'Error', 'One of the selected attachments is already marked for deletion.');
                    }
    				if( selected[i].CH_ProblemVisible__c && (selected[i].Case__c != component.get('v.recordId'))) {
                        return helper.showToast(component, 'error', 'Error', $A.get("$Label.c.CH_DeleteAttachmentFromProblem"));
                    }//NOKIASC-38420
                }
                component.set("v.selectedForDelete", selected);
                component.set("v.popup", 'delete');
                break;
            case 'share':
                if(selected.length == 0) { return helper.showToast(component, 'error', 'Error', 'Select at least one attachment.'); }
                const baseLink = component.get('v.baseUrl') + '/' + component.get('v.capsInstance');
                component.set("v.shareRND", {
                    subject : "Update R&D Interaction - Attachment",
                    description : selected.reduce(
                        (acc, att) => 	acc + baseLink + '/downloadattachment?id=' + att.AttachmentID__c + '\n' +
                        				baseLink + '/external/downloadattachment?id=' + att.AttachmentID__c + '\n',
                        'Download links for internal and external users:\n'
                    ),
                    additionalDescription : "",
                    comments  : "",
                    attachments : selected,
                });
                component.set("v.popup", 'share');
                break;
            case 'link':
                if(selected.length == 0) { return helper.showToast(component, 'error', 'Error', 'Select at least one attachment.'); }
                for(let i = 0, len = selected.length; i < len; i++) {
                    if(selected[i].CH_ProblemVisible__c) {
                        return helper.showToast(component, 'error', 'Error', 'One of the selected attachments is already shared with a Problem.');
                    }
                }
                component.set("v.selectedForLinkage", selected);
                component.set("v.popup", 'link');
                break;
            case 'unlink':
                if(selected.length == 0) { return helper.showToast(component, 'error', 'Error', 'Select at least one attachment.'); }
                for(let i = 0, len = selected.length; i < len; i++) {
                    if(!selected[i].CH_ProblemVisible__c) {
                        return helper.showToast(component, 'error', 'Error', 'One of the selected attachments is not shared with a Problem.');
                    }
                }
                component.set("v.selectedForLinkage", selected);
                component.set("v.popup", 'unlink');
                break;
        }
	},
    handleRowAction: function (component, event, helper) {
        const row = event.getParam('row');
        switch(event.getParam('action')) {
            case 'show_details':
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                	"url": row.URL
               	});
               	urlEvent.fire();
                break;
            case 'log_analysis':
                if(row.CH_LogAnalysisURL__c == null || row.CH_LogAnalysisURL__c == '') {
                    return helper.showToast(component, 'error', 'Error', 'No Log Analysis was provided.');
                }
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                	"url": row.CH_LogAnalysisURL__c
               	});
               	urlEvent.fire();
                break;
        }
	},
    closePopup : function (component, event, helper) {
        component.set("v.popup", null);
        component.set("v.selectedForDelete", null);
        component.set("v.shareRND", null);
	},
    confirmPopUp : function (component, event, helper) {
        switch(component.get("v.popup")) {
            case 'share':
                var shareRND = component.get("v.shareRND");
                helper.apexAction(component, 'c.shareAttachmentWithRND', {
                    caseId: component.get('v.recordId'),
                    interfaceName : component.get('v.rndInterface'),
                    subject : shareRND.subject,
                    combinedDescription : shareRND.description + shareRND.additionalDescription,
                    comments : shareRND.comments,
                    oAttachmentList : shareRND.attachments
                }, true).then(res => {
                    helper.showToast(component, 'success', 'Success', 'Files/Attachments have been shared with R&D.');
                    var urlEvent = $A.get("e.force:navigateToSObject");
                    urlEvent.setParams({
                        "recordId": res
                    });
                    urlEvent.fire();
                    component.set("v.popup", null);
                    component.set("v.shareRND", null);
                });
                break;
            case 'delete':
                helper.apexAction(component, 'c.markAttachmentsForDelete', {
                    caseId: component.get('v.recordId'),
                    oAttachmentList : component.get("v.selectedForDelete")
                }, true).then(res => {
                    helper.showToast(component, 'success', 'Success', 'Files/Attachments have been queued for deletion.');
                    helper.getAttachments(component);
                    component.set("v.popup", null);
                });
                break;
            case 'link':
                helper.apexAction(component, 'c.updateAttachmentVisibility', {
                    oAttachmentList : component.get("v.selectedForLinkage"),
                    visibilityType: 'Problem', visibilityValue : true
                }, true).then(res => {
                    helper.showToast(component, 'success', 'Success', 'Files/Attachments have been link to the problem.');
                    helper.getAttachments(component);
                    component.set("v.popup", null);
                });
                break;
            case 'unlink':
                helper.apexAction(component, 'c.updateAttachmentVisibility', {
                    oAttachmentList : component.get("v.selectedForLinkage"),
                    visibilityType: 'Problem', visibilityValue : false
                }, true).then(res => {
                    helper.showToast(component, 'success', 'Success', 'Files/Attachments have been unlink from the problem.');
                    helper.getAttachments(component);
                    component.set("v.popup", null);
                });
                break;
        }
	},
    closePortalPopup : function (component, event, helper) {
        component.set("v.communityViewAll", false);
	},
    copyToClipboard : function (component, event, helper) {
        var copyText = document.createElement('textarea');        
        copyText.value = event.getSource().get("v.value");
  		copyText.style.opacity = 0;
        document.body.appendChild(copyText); 
        copyText.select();
        copyText.setSelectionRange(0, 99999)
        document.execCommand("copy");
        document.body.removeChild(copyText); 
        helper.showToast(component, 'info', 'Info', 'Password has been copied to the clipboard.');
	},
})