({
    doInit: function(component, event, helper) {
        helper.fetchPickListValforclassification(component, 'CH_Classification__c', 'classification');
        helper.isCommunity(component);
        helper.getCaseInfo(component);
        helper.isWorkgroupMember(component);
        //var caseinformation = component.get("v.caseDetails");
        
    },
    doUpload: function(component, event, helper) {
        
        var originSystemArray = ['tmobile-tim', 'tcom-dtag', 'orange-irma', 'vodafone', 'Schweizer-Armee', 'megafon', 'telefonica', 'pnms'];
        var isMoreThan5MB = false;
        var caseinformation = component.get("v.caseDetails");
        var filesSelectedForUpload = component.get("v.filesSelectedForUpload");
        var isOnPortal = component.get("v.isCommunity");
        for(var counterItr in filesSelectedForUpload){
            var fileSelectedForUpload = filesSelectedForUpload[counterItr];
            if(!isMoreThan5MB && fileSelectedForUpload.CustomerVisible && caseinformation.Origin === 'S2S' && caseinformation.CH_CaseOriginSystem__c === 'tmobile-tim' && fileSelectedForUpload.File.size > 5120000 && !isOnPortal){
                //component.set("v.errorMessagePopup", "Description and Classification can’t be blank");
                isMoreThan5MB = true;
            }
            if(fileSelectedForUpload.Description == '' || fileSelectedForUpload.Classification == ''){
                component.set("v.errorMessagePopup", "Description and Classification can’t be blank");
                component.set("v.isMessageModalOpened", true);
                return;
            }
            //changes for DEM0054001  
             if(fileSelectedForUpload.File.name.length > 80 ){
                component.set("v.errorMessagePopup", "The file name you are trying to upload should not exceed 80 characters!");
                component.set("v.isErrorModalOpened", true);
                return;
            }
        }
        if(!isMoreThan5MB){
            var counter = 0;
            component.set("v.uploadButtonIsDisabled", true);
            component.set("v.uploadStarted", true);
            helper.uploadHelper(component,counter);
        }else{
            component.set("v.morethan5MBWarning", true);
        }
    },
    confirmUpload : function(component, event, helper){
        var filesSelectedForUpload = component.get("v.filesSelectedForUpload");
        component.set("v.morethan5MBWarning", false);
        var counter = 0;
        component.set("v.uploadButtonIsDisabled", true);
        component.set("v.uploadStarted", true);
        helper.uploadHelper(component,counter);
    },
    ModifyUpload: function(component, event, helper) { 
        component.set("v.morethan5MBWarning", false);
    },
    handleFilesChange: function(component, event, helper) {
        component.set("v.uploadCancelled", false);
        component.set("v.status",'');
        var MAX_FILE_SIZE = 20971520000;
        var filesSelectedForUpload = component.get("v.filesSelectedForUpload");
        var filesFromInput = component.find("fileId").get("v.files");
        if (filesFromInput.length == 0) {
            return;
        }
        var iterateOnCount;
        var innerCount;
        var overallSize = 0;
        for(iterateOnCount in filesFromInput){
            if(iterateOnCount != 'item' && iterateOnCount != 'length'){
                var contenatedString = filesFromInput[iterateOnCount].name+filesFromInput[iterateOnCount].type+filesFromInput[iterateOnCount].size;
                if(filesSelectedForUpload !=null && filesSelectedForUpload != undefined && filesSelectedForUpload != ''){
                    for(innerCount in filesSelectedForUpload){
                        var comparisonToString = filesSelectedForUpload[innerCount].File.name+filesSelectedForUpload[innerCount].File.type+filesSelectedForUpload[innerCount].File.size;
                        if(contenatedString == comparisonToString){
                            component.set("v.errorMessagePopup", "Same File cannot be selected");
                            component.set("v.isMessageModalOpened", true);
                            return;
                        }
                    }
                }
                overallSize +=  filesFromInput[iterateOnCount].size;
            }
        }
        var lastPosition;
        var lastClassification = '';
        var lastCustomerVisible = false;
        if(component.get("v.isCommunity")){
            lastCustomerVisible = true;
        }
        var lastDescription = '';
        if(filesSelectedForUpload !=null && filesSelectedForUpload != undefined && filesSelectedForUpload != ''){
            lastPosition = filesSelectedForUpload.length - 1;
            lastClassification = filesSelectedForUpload[lastPosition].Classification;
            lastCustomerVisible = filesSelectedForUpload[lastPosition].CustomerVisible;
            lastDescription = filesSelectedForUpload[lastPosition].Description;
            var iterateOver;
            for(iterateOver in filesSelectedForUpload){
                overallSize += filesSelectedForUpload[iterateOver].File.size;
            }
        }
        if(overallSize > MAX_FILE_SIZE){
            var sizeExceeded = 'Overall FileSize cannot exceed '+ MAX_FILE_SIZE + ' bytes.\n' +
                'Selected files\' size: ' + overallSize +' bytes.';
            component.set("v.errorMessagePopup", sizeExceeded);
            component.set("v.isMessageModalOpened", true);
            return;
        }
        var numberOfFiles = filesSelectedForUpload.length + filesFromInput.length;
        if(numberOfFiles > 10){
            component.set("v.errorMessagePopup", "You can select maximum 10 files");
            component.set("v.isMessageModalOpened", true);
            return;
        }
        var counter;
        for(counter in filesFromInput){
            if (filesFromInput[counter].name != null && filesFromInput[counter].name != 'item') {
                filesSelectedForUpload.push({
                    'Description': lastDescription,
                    'ClassificationId': '',
                    'Classification': lastClassification,
                    'CustomerVisible': lastCustomerVisible,
                    'File': filesFromInput[counter],
                    'CancelcurrentFileUpload':false
                });
            }
        }
        component.set("v.filesSelectedForUpload", filesSelectedForUpload);
        if (filesSelectedForUpload.length > 0){
            component.set("v.uploadButtonIsDisabled", false);
        }
    },   
    handleRemoveItem : function(component, event, helper) {
        var self = this;
        var index = event.target.dataset.index;
        helper.removeItem(component, index);
    },
    closeModal: function(component, event, helper) { 
        component.set("v.isMessageModalOpened", false);
        component.set("v.isErrorModalOpened", false);
    },
    
    cancelUpload: function(component, event, helper) { 
        component.set("v.status",'Upload Cancelled');   
        component.set("v.uploadStarted", false);
        component.set("v.filesSelectedForUpload", []);
        component.set("v.uploadCancelled", true);
    },
})