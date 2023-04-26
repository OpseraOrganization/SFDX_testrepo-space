({
    executeAllianceExport: function (component, event, helper) {
        var allianceExportAction = component.get("c.initiateOrderExportForAlliance");
        allianceExportAction.setParams({
            "proposalId": component.get("v.recordId"),
            "externalSystenName": "Alliance"
        });
        allianceExportAction.setCallback(this, function (response) {
            console.log('>>Output from apex class:::::' + response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                var messageResult = response.getReturnValue();
                if (messageResult.includes('SUCCESS')) {
                    // call x-author app
                    helper.generateAllianceFile(component, event, helper);
                    var toastTitle = 'Success';
                    var toastType = 'Success';
                    var toastMessage = 'Alliance File is exported successfully !';
                    //helper.toastMessage(component, event, helper, toastTitle, toastMessage, toastType);
                }
                else if (messageResult.includes('GoForFile')) {
                    // call x-author app
                    helper.generateAllianceFile(component, event, helper);
                }
                else {
                    // toast message
                    console.log('>>messageResult:::::' + messageResult);
                    var toastTitle = 'Error';
                    var toastType = 'Error';
                    helper.toastMessage(component, event, helper, toastTitle, messageResult, toastType);
                }
            }
        });
        $A.enqueueAction(allianceExportAction);
    },
    toastMessage: function (component, event, helper, title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            duration: ' 5000',
            key: 'info_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();

        $A.get('e.force:refreshView').fire();
    },
    generateAllianceFile: function (component, event, helper) {
        var recId = component.get("v.recordId");
        //var filePath = '/apex/ValidateCSPExport?Id='+recId+'&appName=AllianceExport';
        var filePath = '/apex/Apttus_XApps__EditInExcelLaunch?selectedRecordId=' + recId + '&appName=AllianceExport&mode=touchless&outputType=None';
        var url = location.href;  // entire url including querystring - also: window.location.href;
        var baseURL = url.substring(0, url.indexOf('/', 14));
        console.log('>>>' + baseURL + filePath);
        var link = baseURL + filePath;
        window.open(link, "_self");
    },
    executeQTCExport: function (component, event, helper) {
        console.log('component.get("v.proposal.NokiaCPQ_Proposal_Id__c")' + component.get("v.proposal.NokiaCPQ_Proposal_Id__c"));
        var QTCExportAction = component.get("c.initiateOrderExportForQTC");
        QTCExportAction.setParams({
            "proposalId": component.get("v.recordId"),
            "nokiaQuoteId": component.get("v.proposal.NokiaCPQ_Proposal_Id__c")
        });
        QTCExportAction.setCallback(this, function (response) {
            console.log('>>Output from apex class:::::' + response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                var messageResult = response.getReturnValue();
                if (messageResult.includes('SUCCESS')) {
                    var toastTitle = 'Success';
                    var toastType = 'Success';
                    var toastMessage = 'QTC(Surround) File is exported successfully !';
                    helper.toastMessage(component, event, helper, toastTitle, toastMessage, toastType);
                }
                else {
                    // toast message
                    console.log('>>messageResult:::::' + messageResult);
                    var toastTitle = 'Error';
                    var toastType = 'Error';
                    helper.toastMessage(component, event, helper, toastTitle, messageResult, toastType);
                }
            }
        });
        $A.enqueueAction(QTCExportAction);
    },
    // QTC Site Export
    executeQTCSiteExport: function (component, event, helper) {
        console.log('component.get("v.proposal.NokiaCPQ_Proposal_Id__c")' + component.get("v.proposal.NokiaCPQ_Proposal_Id__c"));
        var QTCSiteExportAction = component.get("c.initiateOrderExportForQTCSite");
        QTCSiteExportAction.setParams({
            "proposalId": component.get("v.recordId"),
            "nokiaQuoteId": component.get("v.proposal.NokiaCPQ_Proposal_Id__c")
        });
        QTCSiteExportAction.setCallback(this, function (response) {
            console.log('>>Output from apex class:::::' + response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                var messageResult = response.getReturnValue();
                if (messageResult.includes('SUCCESS')) {
                    var toastTitle = 'Success';
                    var toastType = 'Success';
                    var toastMessage = 'QTC(Site) File is exported successfully !';
                    helper.toastMessage(component, event, helper, toastTitle, toastMessage, toastType);
                }
                else {
                    // toast message
                    console.log('>>messageResult:::::' + messageResult);
                    var toastTitle = 'Error';
                    var toastType = 'Error';
                    helper.toastMessage(component, event, helper, toastTitle, messageResult, toastType);
                }
            }
        });
        $A.enqueueAction(QTCSiteExportAction);
    },
    // execute CSP Export
    cspExport: function (component, event, helper) {
        var action = component.get("c.cspExportMethod");
        action.setParams({ "recordIdVar": component.get("v.recordId") });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var recId = component.get("v.recordId");
                var filePath = response.getReturnValue(); //'/apex/Apttus_XApps__EditInExcelLaunch?selectedRecordId='+recId+'&appName=CSPExportp20&mode=touchless&outputType=None';
                var url = location.href;  // entire url including querystring - also: window.location.href;
                var baseURL = url.substring(0, url.indexOf('/', 14));
                console.log('>>>' + baseURL + filePath);
                var link = baseURL + filePath;
                //alert("response***"+link);
                window.open(link, "_self");
            }
        });

        $A.enqueueAction(action);
    },
    // application level event to check Product Status....
    fireEventCPQ_Evt_ToCallStatusCheck: function (component, event, helper, orderExportName) {
        var appEvent = $A.get("e.c:CPQ_Evt_ToCallStatusCheck");
        console.log('c:CPQ_Evt_ToCallStatusCheck>>>' + appEvent + 'Order Export Name>>>' + orderExportName);
        appEvent.setParams({
            "orderExportName": orderExportName,
            "recordId": component.get("v.recordId")
        });
        appEvent.fire();
    },

    // QTC Site Export
    sendAddQuoteMessageToEAI: function (component, event, helper) {
        console.log('component.get("v.proposal.NokiaCPQ_Proposal_Id__c")' + component.get("v.proposal.NokiaCPQ_Proposal_Id__c"));
        var quoteMessage = component.get("c.sendAddQuoteMessageToEAI");
        quoteMessage.setParams({
            "proposalId": component.get("v.recordId"),
            "nokiaQuoteId": component.get("v.proposal.NokiaCPQ_Proposal_Id__c")
        });
        quoteMessage.setCallback(this, function (response) {
            console.log('>>Output from apex class:::::' + response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                var messageResult = response.getReturnValue();
                if (messageResult.includes('SUCCESS')) {
                    var toastTitle = 'Success';
                    var toastType = 'Success';
                    var quoteType = component.get("v.proposal.Quote_Type__c");
                    console.log('quoteType-->' + quoteType);
                    var toastMessage = 'Your quote is being sent to SAP, please allow up to 20 minutes for the SAP Document number to be created.'//ITCCPQ-1949
                    if (quoteType != 'Indirect CPQ' && quoteType != 'Direct CPQ') {
                        toastMessage = 'Quote data has been successfully triggered for QTC !';
                    }
                    helper.toastMessage(component, event, helper, toastTitle, toastMessage, toastType);
                }
                //Imran --ITCEPP820
                else if (messageResult.includes('ERROR')) {
                    var toastTitle = 'ERROR';
                    var toastType = 'ERROR';
                    var toastMessage = 'This quote cannot be sent to QTC as this may have product which is not recognized';
                    helper.toastMessage(component, event, helper, toastTitle, toastMessage, toastType);
                    //alert(JSON.stringify('SendtoQTC --> Line 170 -->messageResult'+messageResult));
                }
                else {
                    // toast message
                    console.log('>>messageResult:::::' + messageResult);
                    var toastTitle = 'Error';
                    var toastType = 'Error';
                    helper.toastMessage(component, event, helper, toastTitle, messageResult, toastType);
                }
            }
        });
        $A.enqueueAction(quoteMessage);
    },
    ValidateCqorderButtonhelper: function (component, event, helper) {
        var Portfolio = component.get("v.proposal.NokiaCPQ_Portfolio__c");
        var Quotetype = component.get("v.proposal.Quote_Type__c");
        var QuoteStatus = component.get("v.proposal.Quote_Status__c");
        var Approvstage = component.get("v.proposal.Apttus_Proposal__Approval_Stage__c");
        var AllowedPortfolios = $A.get("$Label.c.Quote_Order_Doc_Portfolios");
        var AllowedPortfoliosList = AllowedPortfolios.split(';');
        //var ApprovalStage=["Approved","Accepted","Draft","In Review"];&&ApprovalStage.includes(Approvstage)
        var Quotestats = ["Configure", "Price"];

        if ((!$A.util.isEmpty(Portfolio)) && (AllowedPortfoliosList.includes(Portfolio)) && Quotetype == "Direct CPQ" && !Quotestats.includes(QuoteStatus))
            component.set("v.ShowQuoteDoc", true);
    },

    CQOrderDocExporthelper: function (component, event, helper, AppName) {
        var action = component.get("c.CQOrderDocExportMethod");
        action.setParams({
            "recordIdVar": component.get("v.recordId"),
            "appName": AppName,
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var link = response.getReturnValue();
                window.open(link, "_self");
            }
        });

        $A.enqueueAction(action);
    },
    generateReconciliationFile: function (component, event, helper) {
        var recId = component.get("v.recordId");
        //var filePath = '/apex/ValidateCSPExport?Id='+recId+'&appName=reconciliationExport';
        var filePath = '/apex/Apttus_XApps__EditInExcelLaunch?selectedRecordId=' + recId + '&appName=reconciliationExport&mode=touchless&outputType=None';
        var url = location.href;  // entire url including querystring - also: window.location.href;
        var baseURL = url.substring(0, url.indexOf('/', 14));
        console.log('>>>' + baseURL + filePath);
        var link = baseURL + filePath;
        window.open(link, "_self");
    },
})