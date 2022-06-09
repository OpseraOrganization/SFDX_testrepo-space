({
    doInit: function(component, event, helper) {
        helper.doInit(component, event, helper);
    },
    
    closeModel: function(component, event, helper) {
        component.set('v.openPopup',false);
		helper.closeFocusedTab(component, event, helper);
    },
    
    tzHandler: function(component) {
        component.set('v.openPopup',false);
        component.set('v.previewDoc',true);
    },
    downloadHandler: function(component){
        var docPrevComponent = component.find("prevCmp");
        docPrevComponent.downloadDoc();
    },
	downloadasPDF: function(component){
        var recordId = component.get("v.recordId");
        var tzString = component.get("v.selectedTimezone");
        if(component.get("v.docType")==="SDR"){var url = '/apex/CH_GeneratePdf?id=' + recordId+'&timeZone='+tzString;}
        else if (component.get("v.docType")==="CAR"){ var url = '/apex/CH_GenerateCAR?id=' + recordId+'&timeZone='+tzString; }
        window.open(url);
    },
})