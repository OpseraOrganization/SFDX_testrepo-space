({
	doInit : function(component, event, helper) {
        helper.apexAction(component, 'c.isCommunity', null, true).then(result => component.set('v.isCommunity', result));
        helper.apexAction(component, 'c.getPicklistValues', {
            sfObject : {sobjectType : 'CH_Attachment__c'},
            field : 'CH_Classification__c'
        }, true).then(result => component.set('v.classifications', result));
        helper.apexAction(component, 'c.getUserAttachmentActionsAuthorization', { caseId : component.get('v.recordId'), forUpload : true }, true)
        .then(result => (component.set('v.authorized', result.upload), component.set('v.sizeWarning', result.sizeWarning), component.set('v.link', result.link)));
	},
	startUpload : function(component, event, helper) {
        const MAX_FILE_SIZE = 20971520000;
        let inputFiles = component.find("filesInput").get("v.files"), files = [], totalSize = 0;
        if (inputFiles.length == 0) { return helper.showToast(component, 'error', 'Error', 'No files selected.'); }
        if (inputFiles.length > 10) { return helper.showToast(component, 'error', 'Error', 'You can only select a maximum of 10 files.'); }
        const customerVisible = component.get("v.isCommunity");
        for(let i = 0, len = inputFiles.length; i < len; i++) {
            const file = inputFiles[i];
            if(file.name.length > 80) {
                return helper.showToast(component, 'error', 'Error', 'The file name you are trying to upload should not exceed 80 characters.');
            }
            totalSize += file.size;
            files = [...files, {
                Filename : file.name,
                Description : '',
                Classification : '',
                CustomerVisible : customerVisible,
                ProblemVisible : false,
                Progress : 0,
                Status : 'Pending Information',
                Size : file.size,
                File : file,
            }];
        }
        if(totalSize > MAX_FILE_SIZE){
            return helper.showToast(component, 'error', 'Error', 'Overall FileSize cannot exceed '+ MAX_FILE_SIZE + ' bytes. ' +
                'Selected files\' size: ' + totalSize +' bytes.');
        }
		component.set('v.uploadStatus', 'Pedding Confirmation');
        component.set('v.inputFiles', files);
	},
    toggleItemVisibility : function(component, event, helper) {
        const index = event.srcElement.dataset.index,
              target = event.srcElement.dataset.target + 'Visible';
        let inputFiles = component.get('v.inputFiles');
        inputFiles[index][target] = !inputFiles[index][target];
        component.set('v.inputFiles', inputFiles);
	},
    removeItem : function(component, event, helper) {
        const index = event.srcElement.dataset.index;
        let inputFiles = component.get('v.inputFiles');
        if(component.get('v.uploadStatus') !== 'In Progress') {
            inputFiles.splice(index, 1);
            if(inputFiles.length == 0) { component.set('v.uploadStatus', ''); }
        }
        else { inputFiles[index].Status = 'Cancelled'; }
        component.set('v.inputFiles', inputFiles);
	},
    cancelUpload : function(component, event, helper) {
        helper.cancelUpload(component);
	},
    uploadFiles : function(component, event, helper) {
        let inputFiles = component.get('v.inputFiles');
        let isMoreThan5MB = false;
        const sizeWarning = component.get('v.sizeWarning');
        for(let i = 0, len = inputFiles.length; i < len; i++) {
            if(!isMoreThan5MB && sizeWarning && inputFiles[i].CustomerVisible && inputFiles[i].Size > 5120000) {
                isMoreThan5MB = true;
            }
            if(inputFiles[i].Classification.length == 0 || inputFiles[i].Description.length == 0) {
                return helper.showToast(component, 'error', 'Error', 'Description and Classification can’t be blank.');
            }
            inputFiles[i].Status = 'In Queue';
        }
        component.set('v.inputFiles', inputFiles);
        if(isMoreThan5MB) {
            return component.set('v.isMoreThan5MB', true);
        }
        component.set('v.uploadStatus', 'In Progress');
        helper.initiateUpload(component, inputFiles, 0);
	},
    cancelConfirm : function(component, event, helper) {
		component.set('v.isMoreThan5MB', false);
	},
    confirmUploadFiles : function(component, event, helper) {
		component.set('v.isMoreThan5MB', false);
        let inputFiles = component.get('v.inputFiles');
        component.set('v.uploadStatus', 'In Progress');
        helper.initiateUpload(component, inputFiles, 0);
	},
})