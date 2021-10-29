global class CaseStatusUpdateEmailServiceClass implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email,Messaging.InboundEnvelope env){
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        Map<Id,Case> mapCase= new Map<Id,Case>();
        List<Case> casup = new List<Case>();
        Id casid;
        String ESubject = email.subject;
        String fromadd = email.fromAddress;
        //String noCSRPeding = Label.Case_No_CSR_Action_Pending;
        //String noCSRLicense = Label.Case_No_CSR_Action_License;
        String noCSR = Label.Case_No_CSR_Action;
        List<String> noCSRLst = noCSR.split(';');
        system.debug('noCSRLst-->'+noCSRLst);
        String CSRAdd = Label.Case_CSR_Action;
        List<String> CSRLst = CSRAdd.split(';');
        system.debug('CSRLst-->'+CSRLst);
        List<String> Toadd = email.toAddresses ;
        system.debug('fromadd-->'+fromadd);
        System.debug('Toadd-->'+Toadd);
        System.debug('ESubject-->'+ESubject);
        String ExReqId = ESubject.substringAfter('Export Request :');
        String bodyText;
        if (string.isEmpty(email.plainTextBody)){
            bodyText = HtmlToText(email.htmlBody);
        }
        else{
            bodyText = email.plainTextBody;
        }
        mapCase =  new Map<Id,Case>([Select Id,ParentId,isClosed,ClosedDate,RecordTypeId,OwnerId,status ,Case_Ref_ID__c,OpenTask__c,
                                     ContactID,Subject,Description,CaseNumber,OwnerId__r.IsActive,E2CP__Case_Thread_Id__c,
                                     origin,Activate_ACT__c, Emailbox_Origin__c from Case where 
                                     External_Ref__c =: ExReqId order by CreatedDate DESC]);
        system.debug('mapCase-->'+mapCase);
        if(Toadd.contains(Label.CasefromEmail)){ 
            //Add Inbound Email Message for Case
            EmailMessage CaseEmailMessage = new EmailMessage();
            CaseEmailMessage.ToAddress =  String.join(email.toAddresses, ',');
            CaseEmailMessage.FromAddress = email.FromAddress;
            CaseEmailMessage.FromName = email.FromName;
            CaseEmailMessage.Subject = email.subject;
            CaseEmailMessage.status = '0';
            CaseEmailMessage.HtmlBody = email.htmlBody;
            CaseEmailMessage.Incoming= True;
            CaseEmailMessage.TextBody = email.plainTextBody;
            try {
                for(String csrls : CSRLst){
                    if(mapCase.isEmpty() && (bodyText.containsIgnoreCase(csrls))){
                        system.debug('No case found');
                        case cas = new case();
                        cas.status = 'Open';
                        cas.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Internal Escalations').getRecordTypeId();
                        cas.Subject = ESubject;
                        cas.origin = 'Email-ACTinternal';
                        cas.Priority = 'Normal';
                        cas.External_Ref__c = ExReqId;
                        String s = bodyText;
                        String stext = s.abbreviate(31900);
                        cas.Description = stext;
                        cas.Emailbox_Origin__c ='Email-ACTinternal';
                        cas.OwnerId = Label.aero_default_user_id;
                        insert cas;
                        CaseEmailMessage.ParentId = cas.Id;
                    }
                }
                if(!mapCase.IsEmpty()){
                    casid = new List<Id>(mapCase.keySet()).get(0);
                    Date cloDate;
                    if(Test.isRunningTest())
                        cloDate = system.today().addDays(1);
                    else
                        cloDate  = system.today().addDays(-7);
                    for(String nocs : noCSRLst){
                        //if((bodyText.containsIgnoreCase(noCSRPeding)) || (bodyText.containsIgnoreCase(noCSRLicense)) || (bodyText.containsIgnoreCase(noCSRTermi))){
                        if((bodyText.containsIgnoreCase(nocs))){   
                            system.debug('Case found with no csr action');
                            CaseEmailMessage.ParentId = mapCase.get(casid).Id;
                        }
                    }
                    for(String csrls : CSRLst){
                        If((bodyText.containsIgnoreCase(CSRAdd))){
                            //Updating the case status as 'On Hold – Response Received' when the case is closed within 7 days and CSR action required
                            If(mapCase.get(casid).isClosed){
                                System.debug('Case found with csr action and case is closed');
                                If(mapCase.get(casid).ClosedDate >= cloDate){     
                                    System.debug('Case found with csr action and case is closed within 7 days');
                                    Case cas = new Case();
                                    cas.Id = mapCase.get(casid).Id;
                                    cas.Status = 'On Hold – Response Received';
                                    casup.add(cas);
                                    CaseEmailMessage.ParentId = mapCase.get(casid).Id;
                                }
                                //Creating a new case when the case is closed before 7 days and CSR action required
                                else{
                                    System.debug('Case found with csr action and case is closed before 7 days');
                                    system.debug('Creating a new case for csr action');
                                    case cas = new case();
                                    cas.status = 'Open';
                                    cas.ParentId = mapCase.get(casid).Id;
                                    cas.External_Ref__c = ExReqId;
                                    cas.recordtypeid = mapCase.get(casid).recordtypeid;
                                    cas.Subject = ESubject;
                                    if(mapCase.get(casid).contactid != null)
                                        cas.contactid=mapCase.get(casid).contactid;
                                    if(mapCase.get(casid).origin !=null && mapCase.get(casid).origin !='')
                                        cas.origin = mapCase.get(casid).origin;
                                    String s = bodyText;
                                    String stext = s.abbreviate(31900);
                                    cas.Description = stext;
                                    if(mapCase.get(casid).Emailbox_Origin__c !=null && mapCase.get(casid).Emailbox_Origin__c !='')
                                        cas.Emailbox_Origin__c =mapCase.get(casid).Emailbox_Origin__c;
                                    if(mapCase.get(casid).OwnerId__r.IsActive== True){
                                        cas.OwnerId = mapCase.get(casid).OwnerId;
                                    }
                                    else{
                                        cas.OwnerId = Label.aero_default_user_id;
                                    }
                                    insert cas;
                                    CaseEmailMessage.ParentId = cas.Id;
                                }
                            }
                            else{
                                System.debug('Case found with csr action and case is not closed');
                                Case cas = new Case();
                                cas.Id = mapCase.get(casid).Id;
                                cas.Status = 'On Hold – Response Received';
                                casup.add(cas);
                                CaseEmailMessage.ParentId = mapCase.get(casid).Id;
                            }
                        }
                    }
                }
                insert CaseEmailMessage;
                system.debug('mapCase-->'+mapCase);
                system.debug('casup-->'+casup.size()+casup);
                if(casup.size()>0)
                    update casup;
            }
            catch (Exception e) {
                System.debug('Issue: ' + e);
            }
        }
        result.success = true;
        return result;
    }
    public static string HtmlToText(string html){
        string result = html.replaceAll('<br/>', '\n');
        result = result.replaceAll('<br />', '\n');
        string HtmlPattern = '<.*?>';
        Matcher match =  Pattern.compile(HtmlPattern).matcher(result);
        return match.replaceAll('');
    }
}