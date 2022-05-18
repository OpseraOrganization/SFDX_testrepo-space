({
    // Fetch the accounts from the Apex controller
    getCHAttachment: function(component) {
        var self = this;
        var action = component.get('c.getAttachment'); 
        // Set up the callback 
        action.setParams({caseId: component.get("v.recordId") });
        action.setCallback(this, function(actionResult) {
            
            var result = actionResult.getReturnValue();
            if(actionResult.getState() === "SUCCESS"){
                component.set('v.chAttachments', result);
                component.set('v.chAttachmentsObj',result);            
                
                if(component.get("v.isRefreshed")){
                    if(!component.get("v.isCommunity")){
                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Success Message',
                            mode: '3000',
                            message: 'Refresh Completed.',
                            type : 'success'
                        });
                        toastEvent.fire(); 
                        component.set("v.isRefreshed",false);
                    }
                    else{
                        self.showMessage(component,"Refresh Completed.",'success');
                        var delay = 2000;
                        setTimeout(function(){
                            self.hideMessageHelper(component);
                        }, delay);
                    }
                }
            }
            else if (actionResult.getState() === "ERROR"){
                console.error(actionResult.getError());
                component.set("v.errorMessage", actionResult.getError());
                component.set("v.isMessageModalOpen", true);
            }
        });
        component.set("v.isSpinner", false);
        $A.enqueueAction(action);
    },
    downloadHelper: function(component, event, recordsIds) {
        //call apex class method
        var self = this;
        component.set("v.isSpinner", true);
        var action = component.get('c.downloadAttachments');
        // pass the all selected record's Id's to apex method 
        action.setParams({
            attachmentIds: recordsIds,
            attachmentList: component.get("v.chAttachmentsObj")
        });
        action.setCallback(this, function(response) {
            //store state of response
            var result = response.getReturnValue();
            if(response.getState() === "SUCCESS"){
                var downloadMessage = '';
                var capsError = '';
                var cnt = 0
                if(result[0].exceptionMessage != null && result[0].exceptionMessage != undefined){
                    downloadMessage = 'Following exception has occurred. Please contact your System Administrator.\n ' + result[0].exceptionMessage;
                }else{
                    
                    for(var i = 0; i< result.length; i++){
                        if(result[i].capsError != undefined)
                        {
                            cnt++;
                            capsError += cnt+'. FileName: '+result[i].fileName +' - ' + result[i].capsError+'\n';
                        }else if(result[i].downLoadUrl != undefined){
                            window.open(result[i].downLoadUrl,"_blank");
                        }
                    }
                    downloadMessage = 'Password(s) to open downloaded file(s) is displayed at the bottom of the attachment list.\n';
                    //downloadMessage += 'If file(s) failing to download please check your security permissions or contact System Administrator \n to check if there is any error in the storage system.';
                    if(capsError != ''){
                    	downloadMessage += 'Error(s) related to file(s) is displayed below\n'+capsError;
                    }
                }
                component.set("v.wrappervalue",result);
                
                if(!component.get("v.isCommunity")){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Info Message',
                        mode: 'sticky',
                        message: downloadMessage,
                        type : 'info'
                    });
                    toastEvent.fire();
                }
                else{
                    self.showMessage(component,downloadMessage,'info');
                }
            }
            else if(response.getState() === "ERROR"){
                console.error(response.getError());
                component.set("v.errorMessage", response.getError());
                component.set("v.isMessageModalOpen", true);
            }
            component.set("v.isSpinner", false);
        });
        $A.enqueueAction(action);
    },
    isWorkgroupMember: function(component) {
        var action = component.get("c.getCaseTeamMembers");
        action.setParams({
            "caseId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            if(result == true){
                component.set("v.isCaseWorkgroupMember",true);
            } 
        });
        $A.enqueueAction(action);
    },
	isShareRandD: function(component){
	var action = component.get("c.getRDInteractions");
	action.setParams({
            "caseId": component.get("v.recordId")
        });
		  action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            if(result==false){
                component.set("v.isSelectedRandD",false);
            } 
        });
        $A.enqueueAction(action);
	},
    deleteSelectedAttachments : function(component, event, attachmentIds){
        var action = component.get('c.updateRetentionDays');//call server side
        var self = this;
        action.setParams({
            listRecords: attachmentIds,//pass attachment ids
            attachmentList: component.get("v.chAttachmentsObj"),
            caseRecordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();//add toast message for success
            if(state === "SUCCESS"){
                if(!component.get("v.isCommunity")){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success Message',
                        mode: 'sticky',
                        message: 'Files/Attachments have been queued for deletion.',
                        type : 'success'
                    });
                    toastEvent.fire();
                }
                else{
                    self.showMessage(component,"Files/Attachments have been queued for deletion.",'success');
                }
            }
            if (state === "ERROR"){
                console.error(response.getError());
                component.set("v.errorMessage", response.getError());
                component.set("v.isMessageModalOpen", true);
            }
        });
        $A.enqueueAction(action);
    },
    isCommunity: function(component) {
        var action = component.get("c.isCommunity");
        action.setCallback(this, function(response) {
            component.set("v.isCommunity", response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    getUserProfile: function(component) {
        console.log('hereq');
        var action = component.get("c.getUserProfileDetails");
        action.setCallback(this, function(response) {
            component.set("v.isAgentProfile", response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    getDeleteOption: function(component) {
        var action = component.get("c.getDeleteButton");
        action.setParams({caseid: component.get("v.recordId") });
        action.setCallback(this, function(response) {
            component.set("v.isDataBreachCase", response.getReturnValue());
        });
        
        $A.enqueueAction(action);
    },
    getCaseinfo: function(component) {
        var action = component.get("c.getRequiredCaseInformation");
        action.setParams({caseid: component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();//add toast message for success
            if(state === "SUCCESS"){
                component.set("v.innerWrapper", result);
                if(result.suspectedDataBreach){
                    component.set("v.isDataBreachCase", false);
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    // Show the toast message
    showMessage : function(component, text, messageType){
        component.set("v.message", text);
        if (messageType === 'success'){
            var toastMessage = component.find("toastMessageSuccess");
        }
        else if(messageType === 'error'){
            var toastMessage = component.find("toastMessageError");
        }
            else if(messageType === 'info'){
                var toastMessage = component.find("toastMessageInfo");
            }
        $A.util.removeClass(toastMessage, 'slds-hidden')
    },
    // Hide or display the toast message
    hideMessageHelper : function(component) {
        var toastMessage = component.find("toastMessageSuccess");
        $A.util.addClass(toastMessage, "slds-hidden");
        var toastMessage = component.find("toastMessageError");
        $A.util.addClass(toastMessage, "slds-hidden");
        var toastMessage = component.find("toastMessageInfo");
        $A.util.addClass(toastMessage, "slds-hidden");
    },
    sharewithRnDIntegration: function(component) {
        component.set("v.isRnDModalOpen", false);
        var subject = component.find("subjectRnD").get("v.value");
        var description = component.find("rNdDescription").get("v.value");
        var additionalDescription = component.find("rNdAdditionalDescription").get("v.value");
        var comment = component.find("rNdComment").get("v.value");
        var action = component.get("c.shareAttachmentsWithRnd");
        action.setParams({
            caseid: component.get("v.recordId"),
            interfaceName : component.get("v.innerWrapper").rNdInterfaceName,
            subject :subject,
            combinedDescription : description + additionalDescription,
            comments : comment,
            attachmentIdList : component.get("v.attachmentIdsForRnD")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.navigateToOutboundRndInteraction(response.getReturnValue());
            } else if (response.getState() === "ERROR") {
                var errors = response.getError();
                console.error(errors);
                if (errors.length === 1 && errors[0].message) {
                    component.set("v.errorMessage", errors[0].message);
                } else {
                    component.set("v.errorMessage", JSON.stringify(errors));
                }
                component.set("v.isMessageModalOpen", true);
            }
            component.set("v.isSpinner", false);
        });
        
        $A.enqueueAction(action);
    },
    
    navigateToOutboundRndInteraction : function(rndInteractionId) {
        $A.get("e.force:closeQuickAction").fire();
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": rndInteractionId
        });
        navEvt.fire();
    },
    sortBy: function(component, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.chAttachments");
        sortAsc = field == sortField? !sortAsc: true;
        if(field === "CH_Size__c"){
            records.sort(function(a,b){
                var x = a[field];
                var y = b[field];
                var t1 = x == y,
                    t2 = x > y;
                return t1? 0: (sortAsc?-1:1)*(t2?-1:1);
                
            });
        }else{
            records.sort(function(a,b){
                var x = a[field].toString();
                var y = b[field].toString();
                var t1 = x.toLowerCase() == y.toLowerCase(),
                    t2 = x.toLowerCase() > y.toLowerCase();
                return t1? 0: (sortAsc?-1:1)*(t2?-1:1);
                
            });
        }
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.chAttachments", records);
    }
})