({
    doInit: function(component, event, helper) {
        var reportHeading = component.get("v.docType") == 'CAR'?'Cause Analysis Report':'Service Disruption Report';
        component.set('v.reportHeading',reportHeading);
        helper.doInit(component, event, helper);
		helper.setFocusedTabLabel(component, event, helper);
    },
	
    downloadDoc: function(component, event, helper){
        component.set('v.showSpinner',true);
        component.set("v.toDownload", true);
		var docType = component.get("v.docType");
		var divId='document'+docType+'-'+component.get("v.recordId");
        let content = document.getElementById(divId).innerHTML;		
        var s = JSON.stringify(content);
        s = helper.unEscapeHTML(s);
        content = JSON.parse(s);
		var today= new Date();        
        var yearfooter=today.getFullYear();
        let res = component.find('nokiaUtils').buildWordDocument(content,{ pagination: true,                                                                         
					footer : {
                    style : "letter-spacing: 1.4in;",
					text : "<span style=\"letter-spacing:normal;\">@ Nokia "+yearfooter+"</span> <span style=\"letter-spacing:normal;\">Customer Confidential</span> <span style=\"letter-spacing:normal;\">Page {pagination}</span>"
                    }
                    });
        res.download();
        component.set("v.toDownload", false);
        component.set('v.showSpinner',false);
    }
})