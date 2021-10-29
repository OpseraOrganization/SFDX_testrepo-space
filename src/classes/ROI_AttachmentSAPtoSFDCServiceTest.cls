@isTest
global class ROI_AttachmentSAPtoSFDCServiceTest{
    testMethod static void SAP_ROI_ATTACH_REPORTTest() {
    	list<Case> sfdcCase = new list<Case>();
        Case cas = new Case();
        cas.RecordtypeId = Label.OEM_Spares;
        cas.Origin = 'web';
        cas.Status = 'Open';
        cas.Sales_Order_Number__c = '0000012347';
        cas.Repair_Notification_Number__c = '123';
        sfdcCase.add(cas);
        insert sfdcCase;
        ROI_AttachmentSAPtoSFDCService.attachreport atdata = new ROI_AttachmentSAPtoSFDCService.attachreport();
        atdata.NotificationNumber =  cas.Repair_Notification_Number__c;
        atdata.atturl = '';
        
        ROI_AttachmentSAPtoSFDCService.CaseDataSFDCtoSAP returndata = ROI_AttachmentSAPtoSFDCService.SAP_ROI_ATTACH_REPORT(atdata);
    }

}