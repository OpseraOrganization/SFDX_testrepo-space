({
    doInit : function(component, event, helper) {
        var caseId=component.get("v.recordId");
        component.set("v.isSpinner", true); 
        
        helper.isCommunity(component);        
        helper.getCHAttachment(component);
        helper.getUserProfile(component);  
        // console.log('helloo1'+component.get("v.isDataBreachCase"));
        //helper.getDeleteOption(component); 
        helper.getCaseinfo(component);
        helper.isWorkgroupMember(component);
		helper.isShareRandD(component);//defect 27302
        //console.log('helloo2'+component.get("v.isDataBreachCase"));
    },
    // to send the selected records id's to apex class.
    downloadAttachment : function(component, event, helper) {
        var isNotReadyStatus = false;
        // create var for store record id's for selected checkboxes  
        var attachIds = [];
        // get all checkboxes 
        var getAllId = component.find("checkboxId");
        // If the local ID is unique[in single record case], find() returns the component. not array
        if(!Array.isArray(getAllId)){
            if (getAllId.get("v.value") == true) {
                attachIds.push(getAllId.get("v.text"));
                if(component.get("v.chAttachmentsObj")[0].CH_Status__c != 'Ready'){
                    isNotReadyStatus = true; 
                }
            }
        }else{
            // play a for loop and check every checkbox values 
            // if value is checked(true) then add those Id (store in Text attribute on checkbox) in attachId var.
            for (var i = 0; i < getAllId.length; i++) {
                if (getAllId[i].get("v.value") == true) {
                    attachIds.push(getAllId[i].get("v.text"));
                    if(component.get("v.chAttachmentsObj")[i].CH_Status__c != 'Ready'){
                        isNotReadyStatus = true; 
                    }
                }
            }
        }
        if(attachIds.length > 10){
            component.set("v.errorMessage", "Maximum 10 files can be selected for download at one go.");
            component.set("v.isMessageModalOpen", true);
        }else if(isNotReadyStatus){
            component.set("v.errorMessage", "Status must be Ready to download any file");
            component.set("v.isMessageModalOpen", true);
        }
            else{
                // call the helper function and pass all selected record id's.  
                helper.downloadHelper(component, event, attachIds);
            }
    },
    deleteAttachments : function(component, event, helper){
        component.set("v.isDeleteModalOpen", false);
        component.set("v.isAlreadyMarkedForDeletion",false);
        component.set("v.isSelected", true);
        var attachmentIds = [];
        var getAllId = component.find("checkboxId");
        if(! Array.isArray(getAllId)){
            if (getAllId.get("v.value") == true) {
                attachmentIds.push(getAllId.get("v.text"));
            }
        }else{
            for (var i = 0; i < getAllId.length; i++) {
                if (getAllId[i].get("v.value") == true) {
                    attachmentIds.push(getAllId[i].get("v.text"));
                }
            }
        }  
        component.set("v.isSpinner", true);
        helper.deleteSelectedAttachments(component, event, attachmentIds);
        helper.getCHAttachment(component);// call doInt
        component.set("v.isSpinner", false);
    },
    shareLinkWithRandD : function(component, event, helper){
        component.set("v.isRnDModalOpen", true);
        //component.set("v.isAlreadyMarkedForDeletion",false);
        component.set("v.isSelected", true);
        var attachmentLinks = 'Download links for internal and external users:\n';
        var attachmentIds = [];
        var getAllId = component.find("checkboxId");
        var j = 1;
        if(! Array.isArray(getAllId)){
            if (getAllId.get("v.value") == true) {
                attachmentIds.push(getAllId.get("v.text"));
                 attachmentLinks = attachmentLinks +component.get("v.innerWrapper").baseUrl+'/'+component.get("v.innerWrapper").capsInstance+'/downloadattachment?id='+component.get("v.chAttachments")[0].AttachmentID__c+'\n';
                 attachmentLinks = attachmentLinks +component.get("v.innerWrapper").baseUrl+'/'+component.get("v.innerWrapper").capsInstance+'/external/downloadattachment?id='+component.get("v.chAttachments")[0].AttachmentID__c+'\n';
            }
        }else{
            for (var i = 0; i < getAllId.length; i++) {
                if (getAllId[i].get("v.value") == true) {
                    attachmentIds.push(getAllId[i].get("v.text"));
                    attachmentLinks = attachmentLinks +'Attachment '+j+':'+'\n'+component.get("v.innerWrapper").baseUrl+'/'+component.get("v.innerWrapper").capsInstance+'/downloadattachment?id='+component.get("v.chAttachments")[i].AttachmentID__c+'\n';
                    attachmentLinks = attachmentLinks +component.get("v.innerWrapper").baseUrl+'/'+component.get("v.innerWrapper").capsInstance+'/external/downloadattachment?id='+component.get("v.chAttachments")[i].AttachmentID__c+'\n';
                    j++;
                }
            }
        }
        component.find("rNdDescription").set("v.value",attachmentLinks);
        component.set("v.attachmentIdsForRnD",attachmentIds);
    },
    canceltoSharewithRnD: function(component, event, helper) { 
        component.set("v.isRnDModalOpen", false);
    },
    sendToRnD: function(component, event, helper) {
        component.set("v.isSpinner", true);
        
        helper.sharewithRnDIntegration(component);
        
    },
    isSelected : function(component, event, helper){
        var attachmentIds = [];
        var getAllId = component.find("checkboxId");
        component.set("v.isAlreadyMarkedForDeletion",false);
        if(! Array.isArray(getAllId)){
            if (getAllId.get("v.value") == true) {
                attachmentIds.push(getAllId.get("v.text"));
                if(component.get("v.chAttachmentsObj")[0].CH_MarkForDelete__c){
                    component.set("v.isAlreadyMarkedForDeletion",true);
                }
            }
        }else{
            for (var i = 0; i < getAllId.length; i++) {
                if (getAllId[i].get("v.value") == true) {
                    attachmentIds.push(getAllId[i].get("v.text"));
                    if(component.get("v.chAttachmentsObj")[i].CH_MarkForDelete__c){
                        component.set("v.isAlreadyMarkedForDeletion",true);
                    }
                }
            }
        }
        if(attachmentIds.length > 0){
            component.set("v.isSelected", false);
        }
        else{
            component.set("v.isSelected", true);
        }
    },
    confirmaDeletionModal: function(component, event, helper) {
        if(component.get("v.isAlreadyMarkedForDeletion")){
            component.set("v.errorMessage", "File(s) already marked for deletion, can not be deleted again.");
            component.set("v.isMessageModalOpen", true);
        }
        else{
            component.set("v.isDeleteModalOpen", true);  
        }
    },
    cancelDelete: function(component, event, helper) { 
        component.set("v.isDeleteModalOpen", false);
    },
    closeErrorModal: function(component, event, helper) { 
        component.set("v.isMessageModalOpen", false);
    },
    navigateToDetails : function(component, event, helper){
        var id = event.target.getAttribute("data-recId");
        if(component.get("v.isCommunity")){
            var url = window.location.href;
			//PRB0018443
			var endingPartURL = $A.get("$Label.c.CH_SupportPortal_AttachmentURL") ;
            var urlToNavigate = url.substr(0,url.lastIndexOf('/customers/'))+endingPartURL+id;
            //var urlToNavigate = url.substr(0,url.lastIndexOf('/customers/'))+'/customers/s/detail/'+id;
            window.open(urlToNavigate);
        }else{
            var status = event.target.getAttribute("data-status");
            var evt = $A.get("e.force:navigateToSObject");
            evt.setParams({
                "recordId": event.target.getAttribute("data-recId")
            });
            evt.fire();
        }
    },
    refreshView: function(component, event, helper) {
        component.set("v.isRefreshed",true);
        component.set("v.isSelected",true);
        helper.getCHAttachment(component);
    },
    // Hide or display the toast message
    hideMessage : function(component,event,helper) {
        helper.hideMessageHelper(component);
    },
    
    scriptsLoaded: function(component,event,helper) {
        var tableId = '#attachment-' + component.get("v.recordId");
        $(tableId).DataTable({                         
            "ordering": false,
            "stripeClasses": [],                                                                                       
            "paging": false,  
            "stateSave": true,                                        
            "bFilter":false,
            "bInfo": false,
            "scrollY":"250px",                   
            "fixedHeader": true,
            "language": {
                "emptyTable": "No data available in table"
            }
        });
        
    },
    copy:function(component,event,helper) {
        var copyText = event.getSource().get("v.value");
        var el = document.createElement('textarea');        
        el.value = copyText;       
        el.setAttribute('readonly', '');
        el.style = {position: 'absolute', left: '-9999px'};
        document.body.appendChild(el);        
        el.select();        
        document.execCommand('copy');        
        document.body.removeChild(el);
    },
    search: function(component, event, helper) {
        
        component.find("filterId").set("v.isLoading",true);
        var filterName = component.find("selectedFilter").get("v.value");
        console.log('testttt'+filterName);
        component.set("v.filterName",filterName);
        var chAttachments = component.get("v.chAttachmentsObj"),
            term = component.get("v.searchText"),
            results = chAttachments, regex;
        regex = new RegExp(term, "i");
        if(filterName === "All Filters"){
            results = chAttachments.filter(row=>regex.test(row.Name) || regex.test(row.CH_Status__c) || 
                                           regex.test(row.CH_Portal_or_Email_to_Case__c) || 
                                           regex.test(row.CH_FileType__c) || 
                                           regex.test(row.CH_Description__c));
        }else if(filterName === "File Name"){
            results = chAttachments.filter(row=>regex.test(row.Name));
        }else if(filterName === "Description"){
            results = chAttachments.filter(row=>regex.test(row.CH_Description__c));
        }else if(filterName === "Status"){
            results = chAttachments.filter(row=>regex.test(row.CH_Status__c));
        }else if(filterName === "Source"){
            results = chAttachments.filter(row=>regex.test(row.CH_Portal_or_Email_to_Case__c));
        }else if(filterName === "File Type"){
            results = chAttachments.filter(row=>regex.test(row.CH_FileType__c));
        }else{
            results = chAttachments;
        }
        component.set("v.chAttachments", results);
        
        component.find("filterId").set("v.isLoading",false);
    },
    sortByName: function(component, event, helper) {
        helper.sortBy(component, "Name");
    },
    sortByVersion : function(component, event, helper) {
        helper.sortBy(component, "CH_FileType__c");
    },
    sortByStatus : function(component, event, helper) {
        helper.sortBy(component, "CH_Status__c");
    },
    sortBySensitiveData : function(component, event, helper) {
        helper.sortBy(component, "Sensitive_Data__c");
    },
    sortByEmailToCase : function(component, event, helper) {
        helper.sortBy(component, "CH_Portal_or_Email_to_Case__c");
    },
    sortByDescription : function(component, event, helper) {
        helper.sortBy(component, "CH_Description__c");
    },
    sortByMarkDel : function(component, event, helper) {
        helper.sortBy(component, "CH_MarkForDelete__c");
    }, 
    sortByCustVisible :  function(component, event, helper) {
        helper.sortBy(component, "Customer_Visible__c");
    }, 
    sortBySize : function(component, event, helper) {
        helper.sortBy(component, "CH_Size__c");
    }, 
    sortByUploaded : function(component, event, helper) {
        helper.sortBy(component, "CH_Uploaded__c");
    }, 
})