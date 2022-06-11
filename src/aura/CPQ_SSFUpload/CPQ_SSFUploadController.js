({
    init: function (component, event, helper) {
        component.set("v.csvData", null);
    },
    
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
    
    doUpload: function(component, event, helper) {
        if (component.find("fileId").get("v.files") != null) {
            helper.uploadSSFHelper(component, event, helper);
        } else {
            helper.showMessage(component, 'warning', 'Please Select a Valid File!');
        }
    },
    
    closeModel: function(component, event, helper) {
        window.history.back();
    },
    
    goToCart: function(component, event, helper) {
        helper.addToCart(component, helper);
    }
})