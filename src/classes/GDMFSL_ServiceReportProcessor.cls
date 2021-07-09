public inherited sharing class GDMFSL_ServiceReportProcessor {

    @TestVisible
    private static final String NO_REPLY_EMAIL = 'No-Reply-GCCC';

    private static OrgWideEmailAddress theOrgWideNoReplyAddress;

    @TestVisible
    private static final String COMMUNCONTACTEMAILTEMPLATE = 'GDMFSL_WOCompleted_SiteCon_Notification';


    @TestVisible
    private static OrgWideEmailAddress getOrgWideNoReplyAddress() {

        if (theOrgWideNoReplyAddress == null) {
            try {
                theOrgWideNoReplyAddress = [SELECT Id,DisplayName FROM OrgWideEmailAddress WHERE DisplayName = :NO_REPLY_EMAIL LIMIT 1];
            } catch (Exception e) {
                System.debug('Unable to find OrgWide No Reply Email Address named: ' + NO_REPLY_EMAIL);
            }
        }

        return theOrgWideNoReplyAddress;
    }


    public static void sendSiteContactEmailCompletedWOs(List<WorkOrder> newWorkOrders, Map<Id, WorkOrder> oldWorkOrdersMap) {

        System.debug('sendSiteContactEmailCompletedWOs()');

        if (newWorkOrders != null && !newWorkOrders.isEmpty() && oldWorkOrdersMap != null && !oldWorkOrdersMap.isEmpty()) {

            OrgWideEmailAddress theOrgWideAddressToUse = getOrgWideNoReplyAddress();

            System.debug('theOrgWideAddressToUse: ' + theOrgWideAddressToUse);

            if (theOrgWideAddressToUse == null) {
                System.debug('Unable to find orgWide Reply Address, no work to do.');
                return;
            }

            Map<Id, WorkOrder> wosToProcess = new Map<Id, WorkOrder>();

            for (WorkOrder wrkord : newWorkOrders) {
                if (wrkord.ContactId != null &&
                        wrkord.GDMFSL_Contact_Email__c != null
                        && wrkord.Status == GDMFSL_WorkOrderProcessor.COMPLETEDSTATUS
                        && !wrkord.GDMFSL_Executed_by_Sub_Contractor__c
                        && oldWorkOrdersMap.containsKey(wrkord.Id)
                        && (oldWorkOrdersMap.get(wrkord.Id).Status != wrkord.Status)) {

                    System.debug('WO is completed -- need to notify: ' + wrkord.Id);
                    wosToProcess.put(wrkord.Id, wrkord);
                }
            }

            if (!wosToProcess.isEmpty()) {

                System.debug('Have WOs to Process');

                EmailTemplate emailTemplate;

                try {
                    emailTemplate = [SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body FROM EmailTemplate WHERE Name = :COMMUNCONTACTEMAILTEMPLATE AND IsActive = TRUE LIMIT 1];
                } catch (Exception e) {
                    System.debug('Unable to find Email template, no work to do: ' + COMMUNCONTACTEMAILTEMPLATE);
                    return;
                }

                System.debug('Found Email template to use: ' + COMMUNCONTACTEMAILTEMPLATE);

                System.debug('Get all Service Appointment related to WO');
                Map<Id, Id> servApptIdWrkOrdId = new Map<Id, Id>();

                for (ServiceAppointment thisSA : [SELECT Id, ParentRecordId, Status FROM ServiceAppointment WHERE ParentRecordId IN :wosToProcess.keySet() AND Status = :GDMFSL_WorkOrderProcessor.COMPLETEDSTATUS]) {
                    servApptIdWrkOrdId.put(thisSA.Id, thisSA.ParentRecordId);
                }

                System.debug('Get all WOLI related to WO');
                Map<Id, Id> wOLIIdToWOId = new Map<Id, Id>();

                for (WorkOrderLineItem wLineItem : [SELECT Id, WorkOrderId FROM WorkOrderLineItem WHERE WorkOrderId IN :wosToProcess.keySet()]) {
                    wOLIIdToWOId.put(wLineItem.Id, wLineItem.WorkOrderId);
                }

                Set<Id> serRptParentIds = new Set<Id>();
                serRptParentIds.addAll(servApptIdWrkOrdId.keySet());
                serRptParentIds.addAll(wOLIIdToWOId.keySet());

                System.debug('This many ServReport Parents to use: ' + serRptParentIds.size());

                if (!serRptParentIds.isEmpty()) {

                    System.debug('Get all Service Report related to SA and WOLI of the WO');

                    Set<Id> conDocIds = new Set<Id>();

                    for (ServiceReport sRep : [
                            SELECT ContentVersionDocumentId, DocumentBody, DocumentContentType,
                                    DocumentLength, DocumentName, ParentId, Template 
                            FROM ServiceReport
                            WHERE ParentId IN :serRptParentIds
                            ORDER BY CreatedDate DESC
                    ]) {

                        System.debug('Service Report ContentVersionDocumentId to Process: ' + sRep.ContentVersionDocumentId);
                        conDocIds.add(sRep.ContentVersionDocumentId);
                    }

                    if (!conDocIds.isEmpty()) {

                        System.debug('Have ContentDoc Ids to Process');

                        Map<Id, ContentVersion> contentDocIdConVerMap = new Map<Id, ContentVersion>();

                        for (ContentVersion conVer : [SELECT Title,PathOnClient, FileType, VersionData, ContentDocumentId FROM ContentVersion WHERE Id IN:conDocIds AND IsLatest = TRUE]) {
                            contentDocIdConVerMap.put(conVer.ContentDocumentId, conVer);
                        }

                        System.debug('Have this many ContentDoc Link IDs to process: ' + contentDocIdConVerMap.size());

                        if (!contentDocIdConVerMap.isEmpty()) {

                            System.debug('Get ContactDocumentLinks');

                            List<Id> conDocIdsToGet = new List<Id>();
                            conDocIdsToGet.addAll(conDocIds);
                            Map<Id, List<ContentVersion>> woIdToConVersionLstMap = new Map<Id, List<ContentVersion>>();
                            Set<Id> recIdsWeveSeen = new Set<Id>();

                            for (ContentDocumentLink thisCDLink : [SELECT LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE ContentDocumentId IN :contentDocIdConVerMap.keySet() ORDER BY ContentDocument.CreatedDate DESC]) {

                                Id theWOId;

                                if (thisCDLink.LinkedEntityId.getSobjectType() == ServiceAppointment.getSObjectType()) {

                                    System.debug('CDLink is related to a ServAppt' + thisCDLink.Id);

                                    if (servApptIdWrkOrdId.containsKey(thisCDLink.LinkedEntityId)
                                            && !recIdsWeveSeen.contains(servApptIdWrkOrdId.get(thisCDLink.LinkedEntityId))) {

                                        theWOId = servApptIdWrkOrdId.get(thisCDLink.LinkedEntityId);
                                        recIdsWeveSeen.add(theWOId);

                                        System.debug('Checking for WO: ' + theWOId);
                                    }

                                } else if (thisCDLink.LinkedEntityId.getSobjectType() == WorkOrderLineItem.getSObjectType()) {

                                    System.debug('CDLink is related to a WOLI' + thisCDLink.Id);

                                    if (wOLIIdToWOId.containsKey(thisCDLink.LinkedEntityId)
                                            && !recIdsWeveSeen.contains(thisCDLink.LinkedEntityId)) {

                                        theWOId = wOLIIdToWOId.get(thisCDLink.LinkedEntityId);
                                        recIdsWeveSeen.add(thisCDLink.LinkedEntityId);

                                        System.debug('Checking for WO: ' + theWOId);
                                    }
                                }

                                if (theWOId != null) {

                                    if (!woIdToConVersionLstMap.containsKey(theWOId)) {

                                        System.debug('Adding Entry for WO: ' + theWOId);
                                        woIdToConVersionLstMap.put(theWOId, new List<ContentVersion>());
                                    }

                                    woIdToConVersionLstMap.get(theWOId).add(contentDocIdConVerMap.get(thisCDLink.ContentDocumentId));
                                }
                            }


                            System.debug('WO to send emails for: ' + woIdToConVersionLstMap.size());

                            if (!woIdToConVersionLstMap.isEmpty()) {

                                System.debug('Have ContentDocs to Email');

                                Messaging.SingleEmailMessage[] emailsLst = new List<Messaging.SingleEmailMessage>();

                                for (WorkOrder wrkord : wosToProcess.values()) {

                                    String[] toAddresses = new String[]{
                                            wrkord.GDMFSL_Contact_Email__c
                                    };

                                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                                    mail.setTemplateId(emailTemplate.Id);
                                    mail.setWhatId(wrkord.Id); //This is important for the merge fields in template to work
                                    mail.setToAddresses(toAddresses);
                                    mail.setOrgWideEmailAddressId(theOrgWideAddressToUse.Id);
                                    mail.setBccSender(false);
                                    mail.setUseSignature(false);
                                    mail.setTargetObjectId(wrkord.ContactId);
                                    mail.saveAsActivity = false;

                                    if (woIdToConVersionLstMap.containsKey(wrkord.Id)) {

                                        List<Messaging.EmailFileAttachment> fileAttachments = new List<Messaging.EmailFileAttachment>();

                                        for (ContentVersion theReport : woIdToConVersionLstMap.get(wrkord.Id)) {

                                            Blob serviceReportBody = theReport.VersionData;
                                            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                                            efa.setFileName(wrkord.WorkOrderNumber + '-' + theReport.Title + '.' + theReport.FileType);
                                            efa.setBody(serviceReportBody);
                                            fileAttachments.add(efa);
                                        }

                                        if (!fileAttachments.isEmpty()) {
                                            mail.setFileAttachments(fileAttachments);
                                        }
                                    }

                                    emailsLst.add(mail);
                                }

                                System.debug('Have this many emails to send: ' + emailsLst.size());

                                if (!emailsLst.isEmpty()) {

                                    try {

                                        System.debug('Reserve Email send capacity for : ' + emailsLst.size());
                                        Messaging.reserveSingleEmailCapacity(emailsLst.size());

                                        System.debug('Send the emails');

                                        Messaging.sendEmail(emailsLst);

                                        System.debug('Email submitted');

                                    } catch (Exception e) {
                                        System.debug('Email could not be sent: ' + e.getMessage());
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }


}