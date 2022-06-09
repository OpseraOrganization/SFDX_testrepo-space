({
    doInit: function(component, event, helper) {
        helper.fetchPickListValforclassification(component, 'CH_Classification__c', 'classification');
        helper.isCommunity(component);
    },
    doSave: function(component, event, helper) { 
        var description 			= component.find("descriptionfield");
        var descriptionValue 	    = description.get("v.value");
        var classification			= component.find("classification");
        var classificationValue 	= classification.get("v.value");
        
        if(descriptionValue == '' || classificationValue == ''){
            component.set("v.fieldserror", 'Description, Classification fields can’t be blank');
        }
        
        if(descriptionValue != '' && classificationValue != ''){
            
            if (component.find("fileId").get("v.files") !=null  && component.find("fileId").get("v.files").length > 0) {
                
                // event.preventDefault();
                component.set("v.isDisabled", true);
                helper.uploadHelper(component, event);
            } else {
                //    alert('Please Select a Valid File');
                //   event.preventDefault();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Warning',
                    message: 'Please Select a Valid File',
                    messageTemplate: 'Mode is sticky ,duration is 5sec and Message is overrriden because messageTemplateData is {1}',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'warning',
                    mode: 'sticky'
                });
                toastEvent.fire();
                return false;
            }
        }
    },
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
            component.set("v.isDisabled", false);  
        }
        component.set("v.fileName", fileName);
    }
})