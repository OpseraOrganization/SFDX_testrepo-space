// Below class is used to forward emails to Conexiom whenever case has been created
// This class is being called from a class EmailAttachmentCopy
public class ConexiomAutoforwardEmailHandler {
    
    public static void autoForwardEmail(List<EmailMessage> emList){
        system.debug('entered sample method');
        String Potential_Connexion;
        String Casrectype;
        String baseurl = URL.getSalesforceBaseUrl().getHost();
        Boolean hostVal; // =  URL.getSalesforceBaseUrl().getHost().left(2).equalsignorecase('cs');
        Id caseRTID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Orders').getRecordTypeId();
        Id caseRTID2 = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ISS_Orders').getRecordTypeId();
        Map<ID,ID> caseEmsgMap = new Map<ID,ID>();
        Map<ID, Case> caseRec = new Map<ID, Case>();
        Map<ID,ID> AccCaseMap = new map<ID, ID>();
        Map<ID,ID> caseFinalMap = new map<ID,ID>();
        Map<ID, List<Messaging.Emailfileattachment>> mapID = new Map<ID, List<Messaging.Emailfileattachment>>(); //Map to hold caseID and List of Attachments
        Map<ID, List<Messaging.Emailfileattachment>> caseAttListMap = new Map<ID, List<Messaging.Emailfileattachment>>();
      	List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
       string EmailStrings;
        Map<Boolean, String> emaddr = new Map<Boolean, String>();
        System.debug('baseurl::'+baseurl);
        if(baseurl.contains('--qa') || baseurl.contains('--aerocs')){
            hostVal = true;
        }
        else{
            hostVal = false;
        }
        System.debug('hostVal::'+hostVal);
        if(!emList.isEMpty() && emList!=null){
            System.debug('emList::'+emlist);
            for(EmailMessage em : emList){
                System.debug('Hasattachment'+em.HasAttachment);
                caseEmsgMap.put(em.ID, em.ParentId);
            }
            
        }
        system.debug('caseEmsgMap==>' +caseEmsgMap);
        if(!caseEmsgMap.isEmpty()){
            system.debug('caseEmsgMap enterd');
            system.debug('caseRTID2'+caseRTID2);
            //Casrectype = 'Orders';
            for(case cs : [select id, CaseNumber, Case_Ref_ID__c, recordtypeid, Account.Potential_Conexiom__c, AccountID, Account.Name from case where ID IN :caseEmsgMap.values() AND (Account.Potential_Conexiom__c =:'MyEditor Auto Forward' OR Account.Potential_Conexiom__c =:'IDOC Auto Forward') AND ((RecordTypeID =:caseRTID AND Type = 'Place Order') OR (RecordTypeID =:caseRTID2 AND Type IN ('Other', 'Orders')))]) /*AND sub_class__c = 'conexiom'*/ 
            {
                Potential_Connexion = cs.Account.Potential_Conexiom__c;
                Casrectype = Schema.SObjectType.Case.getRecordTypeInfosById().get(cs.recordtypeid).getname();
                System.debug('Casrectype::'+Casrectype);
                caseRec.put(cs.Id, cs);
                AccCaseMap .put(cs.AccountID , cs.ID);
            }
        }
        ConexiomToAddressCM__mdt[] conemail = [Select Potential_Connexiom__c, Is_Test_Sandbox__c, Email_Address__c from ConexiomToAddressCM__mdt];
        for(ConexiomToAddressCM__mdt cmdt: conemail){
            if(cmdt.Potential_Connexiom__c == Potential_Connexion){
                emaddr.put(cmdt.Is_Test_Sandbox__c, cmdt.Email_Address__c);
            }
        }
        System.debug('emaddr::'+emaddr);
        List<EmailMessage> eList = new List<EmailMessage>();
        
        for(EmailMessage em : emList){
            if(!AccCaseMap.isEmpty())
            {
                if(em.HasAttachment == true || (Test.isRunningTest()== True)){
                eList.add(em);
                }
            }
        }
        system.debug('AccCaseMap==>' + AccCaseMap);
        List<Attachment> attList = new List<Attachment>();
        if(!eList.isEMpty() && eList!=null){
            attList = [SELECT id,Name,ParentID,body FROM Attachment where ParentID IN : eList AND (contenttype = 'application/pdf' OR contenttype = 'application/txt')];
        }
        system.debug('attList==>' +attList);
        if(!attList.isEmpty()){
            for (Attachment attachItr : attList)
            { 
                system.debug('entered Attachment for loop');
                if(caseAttListMap.containsKey(attachItr.ParentID)) {
                    system.debug('entered if');
                    Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                    efa.setFileName(attachItr.Name);
                    efa.setBody(attachItr.body);
                    caseAttListMap.get(attachItr.ParentID).add(efa);
                } else { 
                    system.debug('entered else');
                    Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                    efa.setFileName(attachItr.Name);
                    efa.setBody(attachItr.body);
                    fileAttachments.add(efa);
                    System.debug('fileAttachments'+fileAttachments);
                    mapID.put(attachItr.ParentID, fileAttachments);
                    caseAttListMap.put(caseEmsgMap.get(attachItr.ParentID),fileAttachments);
                    System.debug('caseAttListMap:'+caseAttListMap);
                }
               
            }
       system.debug('caseAttListMap==' + caseAttListMap.values());     
            
        }
       
        system.debug('caseAttListMap==>' +caseAttListMap);
        // Logic to send email with the template and the attachments from the mapID
            List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
            List<EmailMessage> emailList = new List<EmailMessage>();
            Map<ID,EmailMessage> eMessageMap = new Map<ID,EmailMessage>();
            List<case> caseupdate = new List<case>();
            if(!caseAttListMap.isEmpty()){
                EmailTemplate temp;
                system.debug('entered mapID IF');
                if(Casrectype == 'Orders'){
                temp = [select id,Body,Subject from EmailTemplate where DeveloperName='Conexiom_Standard_Order_Template' LIMIT 1];
                }
                else if(Casrectype == 'ISS Orders'){
                temp = [select id,Body,Subject from EmailTemplate where DeveloperName='Conexiom_ISSEXCHG' LIMIT 1]; 
                }
                OrgWideEmailAddress owa = [select id from OrgWideEmailAddress where Address = 'orders@honeywell.com' limit 1];
               Case c = new case();
                
                for(ID caseID :caseAttListMap.keySet()){
                    system.debug('entered map for loop');
                    if(caseAttListMap.containsKey(caseID)){
                        
                        system.debug('entered map if');
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        EmailMessage emailMsg = new EmailMessage();
                        String emailBody = temp.Body;
                        String emailSubject = temp.Subject;
                        
                        emailSubject = emailSubject.Replace('{!Case.CaseNumber}', caseRec.get(caseID).CaseNumber);
                        emailSubject = emailSubject.Replace('{!Case.Case_Ref_ID__c}', caseRec.get(caseID).Case_Ref_ID__c);
                        if(caseRec.get(caseID).Account.Name!=null)
                            emailBody = emailBody.Replace('{!Case.Account}', caseRec.get(caseID).Account.Name );
                        else
                            emailBody = emailBody.Replace('{!Case.Account}', 'NA' ); 
                        emailBody = emailBody.Replace('{!Case.CaseNumber}', caseRec.get(caseID).CaseNumber );
                        System.debug('caseAttListMap.get(caseID):::'+caseAttListMap.get(caseID));
                        system.debug('caseid==' +caseID);
                        mail.setFileAttachments(caseAttListMap.get(caseID));
                        //EmailStrings.add(system.label.ConexiomToAddress);
                        //EmailStrings.add('prapoornashwetha.penumalla@nttdata.com');
                        list<String> Emaddrlst = new list<String>();
                        System.debug('hostVal::'+hostVal);
                        system.debug('hostVal2:'+emaddr.get(hostVal));
                        Emaddrlst.add(emaddr.get(hostVal));
                        //Emaddrlst.add('divijadeepthi.salla@honeywell.com');
                        System.debug('Email address'+Emaddrlst);
                        System.debug('Emal adrress 2'+emaddr.get(hostVal));
                        mail.setToAddresses(Emaddrlst);               
                        mail.setSubject(emailSubject);
                        mail.setBccSender(false);
                        mail.setPlainTextBody(emailBody);                
                        mail.setOrgWideEmailAddressId(owa.id);
                        mail.setSaveAsActivity(false);
                        msgList.add(mail);
                        // Created an EmailMessage and copy all details from above.
                        emailMsg.ToAddress = emaddr.get(hostVal);
                        emailMsg.Subject= emailSubject;
                        emailMsg.TextBody = emailBody;
                        emailMsg.ParentId = caseID ; //Attach with the case
                        emailMsg.MessageDate = system.now();
                        emailMsg.Status = '0';
                        emailList.add(emailMsg);
                        eMessageMap.put(caseID,emailMsg);
                        
                    }
                }
            }
            Messaging.SendEmailResult[] results;
            try{
                if(!msgList.isEmpty() && msgList!=null){
                    results= Messaging.sendEmail(msgList);
                    
                }
            }
            catch (Exception e){
                system.debug('An unexpected error for conexiom autoforward email---' + e.getMessage());
            }
            
            Map<ID,Messaging.SendEmailResult> targetMap = new Map<ID,Messaging.SendEmailResult>();
            List<EmailMessage> emInsertList = new List<EmailMessage>();
            Map<ID,ID> eMapIDs = new Map<ID,ID>();
            try{
                
                for(Messaging.SendEmailResult rr:results){
                    System.debug('Email result ' + rr.IsSuccess());
                    integer i=0;
                    //if the records are not success need to remove the targetobjectIDs(error'd ids from map)
                    if(!rr.IsSuccess())
                    {
                        Messaging.SendEmailError[] errArr = rr.getErrors();                      
                        eMessageMap.remove(errArr[i].getTargetObjectId());                     
                        i++; 
                    }
                }
                //Prepare a List to insert emailMessage from the eMessageMap
                for(EmailMessage em: eMessageMap.values()){
                    if(eMessageMap.containsKey(em.ParentID)){
                        system.debug('eMessageMap==>' +eMessageMap);
                        emInsertList.add(em);
                    }
                    
                }
                
                insert emInsertList;
            }
            catch (exception e){
                system.debug('email not inserted' + e.getMessage());
            }
            // from the inserted emailMessage populate the map with emailmessage parentID and emailMessageID
            //this map will be used to create attachments for this emailMessage.
            for(EmailMessage eml : emInsertList){
                if(eml.id!=null){
                    eMapIDs.put(eml.ParentID,eml.ID);
                }
            }
            system.debug('eMapIDs==>' +eMapIDs);
        List<attachment> emailAttchList = new List<attachment>();
       // [SELECT id,Name,ParentID,body FROM Attachment where ParentID IN : eMapIDs.Keyset() AND contenttype = 'application/pdf'];
            //create attachments for the inserted emailMessages.
            List<Attachment> attchList = new List<Attachment>();
            Attachment attch;
        if(!eMapIDs.isEMpty()){
            for(Attachment att : [SELECT id,Name,ParentID,body FROM Attachment where ParentID IN : caseAttListMap.Keyset() AND contenttype = 'application/pdf']) 
            {
                if(eMessageMap.containsKey(att.ParentID))
                {
                    system.debug('entered attachment loop');
                    system.debug('att.ParentID==>' +att.ParentID);
                    attch= new Attachment();
                    attch.Name = att.Name;
                    attch.Body = att.body;
                    attch.ParentID = eMapIDs.get(att.ParentID);
                    attchList.add(attch);
                }
            }
        }
            
        system.debug('attchList==' +attchList);
        try{
            insert attchList;
        }
        catch(exception e){
            system.debug('atachment not inserted==>' + e.getMessage());
        }
        
        system.debug('after attachment insert');
        }
    
    
    // The below method is used to autforward emails to Conexiom for Repair OverHaul Record types - Added by Shwetha
    public static void autoForwardROemail(List<EmailMessage> emList){
        
       system.debug('entered sample RO method');
       boolean epass = false;
        Id caseRTID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Repair_Overhaul').getRecordTypeId(); 
        Map<ID,ID> caseEmsgMap = new Map<ID,ID>();
        Map<ID, Case> caseRec = new Map<ID, Case>();
        List<case> csList = new List<case>();
        Map<ID,ID> AccCaseMap = new map<ID, ID>();
        Map<ID,ID> caseFinalMap = new map<ID,ID>();
        Map<ID, List<Messaging.Emailfileattachment>> mapID = new Map<ID, List<Messaging.Emailfileattachment>>(); //Map to hold caseID and List of Attachments
        Map<ID, List<Messaging.Emailfileattachment>> caseAttListMap = new Map<ID, List<Messaging.Emailfileattachment>>();
        List<EmailMessage> eList = new List<EmailMessage>();
          List<EmailMessage> emInsertList = new List<EmailMessage>();
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        set<string>RowID = new set<string>(); // to store the rowIDs from the metdata
        set<ID>AccountID = new set<ID>(); //to store AccountIDs which should be excluded from conexiom autoforward logic.
        // Getting SFDC ROWID stored in Custom Metadata 
        //map<id,ROConexiom_Exclusion_Account__mdt> rcMap = new map<id,ROConexiom_Exclusion_Account__mdt>([select id,Account_SFDC_ROW_ID__c from ROConexiom_Exclusion_Account__mdt]);
        //system.debug('custom metadata==' +rcMap);   
        map<id,id> aMap = new map<id,id>();
        for(ROConexiom_Exclusion_Account__mdt rc : [select id,Account_SFDC_ROW_ID__c from ROConexiom_Exclusion_Account__mdt]){
            RowID.add(rc.Account_SFDC_ROW_ID__c);
        }
        system.debug('rowID==' +RowID);
        if(!RowID.isEmpty()){
            //aMap= new map<id,Account>([select id,SFDC_Row_Id__c from Account where SFDC_Row_Id__c IN :RowID]);
            for(Account acc :[select id,SFDC_Row_Id__c from Account where SFDC_Row_Id__c IN :RowID]){
                system.debug('row loop');
                AccountID.add(acc.id);
                aMap.put(acc.ID,acc.id);
            } 
        }
        system.debug('aMap' + aMap);
        if(!emList.isEMpty() && emList!=null && !aMap.isEmpty()){
            system.debug('emlist entered');
            for(EmailMessage em : emList){
                system.debug('em account=' +em.parent.AccountID);
                //system.debug('emaccountid==' + aMap.get(em.parent.AccountID).id);
                if(em.Toaddress.contains(label.Conexiom_RO_Email_Address) && em.parent.AccountID!=aMap.get(em.parent.AccountID)){
                    system.debug('auto forward');
                    system.debug('RO limit if');
                     caseEmsgMap.put(em.ID, em.ParentId);
                }
               
            }
            
        }
        system.debug('caseEmsgMap==>' +caseEmsgMap);
        if(!caseEmsgMap.isEmpty()){
            system.debug('caseEmsgMap enterd');
            for(case cs : [select id, CaseNumber,Case_Ref_ID__c, Type,AccountID, Account.Name,RecordType.Name,RecordTypeID from case where ID IN :caseEmsgMap.values() AND RecordTypeID =:caseRTID AND (Account.Potential_Conexiom__c IN('MyEditor Auto Forward','IDOC Auto Forward')) AND Type =:label.RO_Conexiom_Case_Type]) 
            {
                caseRec.put(cs.Id, cs);
                AccCaseMap .put(cs.AccountID , cs.ID);
                csList.add(cs);
            }
        }
         for(EmailMessage em : emList){
            if(caseRec.containsKey(em.ParentID))
            {
                eList.add(em);
            }
        }
        
        List<Attachment> attList = new List<Attachment>();
        if(!eList.isEMpty() && eList!=null){
           //Added content type octet-stream as per SCTASK2868401 
            attList = [SELECT id,Name,ParentID,body FROM Attachment where ParentID IN : eList AND (contenttype = 'application/pdf' OR ContentType = 'text/plain' OR ContentType = 'application/octet-stream')];
        }
        system.debug('attList==>' +attList);
        
         if(!attList.isEmpty()){
            for (Attachment attachItr : attList)
            { 
                system.debug('entered Attachment for loop');
                if(caseAttListMap.containsKey(attachItr.ParentID)) {
                    system.debug('entered if');
                    Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                    efa.setFileName(attachItr.Name);
                    efa.setBody(attachItr.body);
                    caseAttListMap.get(attachItr.ParentID).add(efa);
                } else { 
                    system.debug('entered else');
                    Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                    efa.setFileName(attachItr.Name);
                    efa.setBody(attachItr.body);
                    fileAttachments.add(efa);
                    mapID.put(attachItr.ParentID, fileAttachments);
                    caseAttListMap.put(caseEmsgMap.get(attachItr.ParentID),fileAttachments);
                }
               
            }
       system.debug('caseAttListMap==' + caseAttListMap.values());     
            
        }
            EmailTemplate temp = [select id,Body,Subject from EmailTemplate where DeveloperName='Conexiom_R_O_Template' LIMIT 1];
        OrgWideEmailAddress owa = [select id from OrgWideEmailAddress where Address = 'aerorepairs@honeywell.com' limit 1];
        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
        List<EmailMessage> emailList = new List<EmailMessage>();
        Map<ID,ID> eMapIDs = new Map<ID,ID>();
        Map<ID,EmailMessage> eMessageMap = new Map<ID,EmailMessage>();
        for(Case cs : csList){
            if(caseAttListMap.containsKey(cs.ID)){
                
                system.debug('entered map if');
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                EmailMessage emailMsg = new EmailMessage();
                String emailBody = temp.Body;
                String emailSubject = temp.Subject;
                
                emailSubject = emailSubject.Replace('{!Case.CaseNumber}', caseRec.get(cs.ID).CaseNumber);
                emailSubject = emailSubject.Replace('{!Case.Case_Ref_ID__c}', caseRec.get(cs.ID).Case_Ref_ID__c);
                if(caseRec.get(cs.ID).Account.Name!=null)
                    emailBody = emailBody.Replace('{!Case.Account}', caseRec.get(cs.ID).Account.Name );
                else
                    emailBody = emailBody.Replace('{!Case.Account}', 'NA' ); 
                emailBody = emailBody.Replace('{!Case.CaseNumber}', caseRec.get(cs.ID).CaseNumber );
                emailBody = emailBody.Replace('{!Case.RecordTypeId}', caseRec.get(cs.ID).RecordType.Name );
                
                system.debug('caseid==' +cs.ID);
                mail.setFileAttachments(caseAttListMap.get(cs.ID));
                list<string> EmailStrings = new list<string>();
                EmailStrings.add(system.label.ConexiomROEmail);
                //EmailStrings.add('prapoornashwetha.penumalla@nttdata.com'); // remove this later
                mail.setToAddresses(EmailStrings);               
                mail.setSubject(emailSubject);
                mail.setBccSender(false);
                mail.setPlainTextBody(emailBody);                
                mail.setOrgWideEmailAddressId(owa.id);
                mail.setSaveAsActivity(false);
                msgList.add(mail);
                // Created an EmailMessage and copy all details from above.
                emailMsg.ToAddress = system.label.ConexiomROEmail;
                emailMsg.Subject= emailSubject;
                emailMsg.TextBody = emailBody;
                emailMsg.ParentId = cs.ID ; //Attach with the case
                emailMsg.MessageDate = system.now();
                emailMsg.Status = '0';
                emailList.add(emailMsg);
                eMessageMap.put(cs.ID,emailMsg);
                
            }
            
        }
        try{
            if(!msgList.isEmpty() && msgList!=null){
                system.debug('msglist==>'+msgList);
                Messaging.sendEmail(msgList);
                epass = true;
            }
        }
        catch (Exception e){
            epass = false;
            String excError = String.valueOf(e);
            //errorMsgList.add('Interrupted with an error while updating the case ('+excError+')');
            system.debug('An unexpected error for conexiom autoforward email---' + e.getMessage());
        }
        if(epass == true)
        {
           
            for(EmailMessage em: eMessageMap.values()){
                if(eMessageMap.containsKey(em.ParentID)){
                    emInsertList.add(em);
                }
            }
            try{
                insert emInsertList;
            }
            catch (exception e){
                String excError = String.valueOf(e);
                // errorMsgList.add('Interrupted with an error while updating the case ('+excError+')');
                system.debug('Unable to insert email message on case related list' +e.getMessage());
            }
            
            for(EmailMessage eml : emInsertList){
                if(eml.id!=null){
                    eMapIDs.put(eml.ParentID, eml.ID);
                }
            } 
            List<Attachment> attchList = new List<Attachment>();
            Attachment attch;
             if(!eMapIDs.isEMpty()){
            for(Attachment att : [SELECT id,Name,ParentID,body FROM Attachment where ParentID IN : caseAttListMap.Keyset() AND (contenttype = 'application/pdf' OR ContentType = 'text/plain')]) 
            {
                if(eMessageMap.containsKey(att.ParentID))
                {
                    system.debug('entered attachment loop');
                    system.debug('att.ParentID==>' +att.ParentID);
                    attch= new Attachment();
                    attch.Name = att.Name;
                    attch.Body = att.body;
                    attch.ParentID = eMapIDs.get(att.ParentID);
                    attchList.add(attch);
                }
            }
            
        }
        system.debug('attchList==' +attchList);
        try{
            insert attchList;
        }
        catch(exception e){
            system.debug('atachment not inserted==>' + e.getMessage());
        }
        
        system.debug('after attachment insert');
        }
    }
    
    public static void GEQuoteAutoForwardEmail(List<EmailMessage> emList){
        system.debug('entered GE method');
        system.debug('emList==' +emList);
        String baseurl = URL.getSalesforceBaseUrl().getHost();
        Boolean hostVal;
        String Potential_Connexion;
        Id caseRTID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Orders').getRecordTypeId(); 
        Map<ID,ID> caseEmsgMap = new Map<ID,ID>();
        Map<ID, Case> caseRec = new Map<ID, Case>();
        List<case> csList = new List<case>();
         List<EmailMessage> emInsertList = new List<EmailMessage>();
        Map<ID, List<Messaging.Emailfileattachment>> caseAttListMap = new Map<ID, List<Messaging.Emailfileattachment>>();
        List<Attachment> attList = new List<Attachment>();
        boolean epass = false;
        string emBody;
        string splitbody;
        Map<Boolean, String> emaddr = new Map<Boolean, String>();
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        //string address = label.GE_From_Address;
        //string address1 = label.Conexiom_GE_Email_Address;
        set<string> LabelString = new set<string>();
        //set<string> LabelString1 = new set<string>();
        /*if(address.contains(',')){
            for(string str : address.split(',')){
                LabelString.add(str.trim());
            }
        }
        else{
            LabelString.add(address.trim());
        }
        system.debug('LabelString---> '+LabelString);*/
        /*if(address1.contains(',')){
            for(string str : address1.split(',')){
                LabelString1.add(str.trim());
            }
        }
        else{
            LabelString1.add(address.trim());
        }*/
      	System.debug('baseurl::'+baseurl);
        if(baseurl.contains('--qa') || baseurl.contains('--aerocs')){
            hostVal = true;
        }
        else{
            hostVal = false;
        }
        System.debug('hostVal::'+hostVal);
         if(!emList.isEMpty() && emList!=null){
             for(EmailMessage em : emList){
                 //if(LabelString1.contains(em.ToAddress) && LabelString.contains(em.FromAddress)){
                 system.debug('em.ToAddress-->'+em.ToAddress);
                 system.debug('em.FromAddress-->'+em.FromAddress);
                 if((em.ToAddress.contains(system.label.Conexiom_GE_Email_Address_add) || em.ToAddress.contains(system.label.Conexiom_GE_Email_Address)) && (em.FromAddress == system.label.GE_From_Address_add || em.FromAddress == system.label.GE_From_Address)){
                     system.debug('entered if');
                     caseEmsgMap.put(em.ID, em.ParentId);
                     emBody = em.TextBody;
                     
                 }
             }
         }
       
      system.debug('emBody==' +emBody);
        if(string.isNOTBlank(emBody) || string.isNotEmpty(emBody)){
              splitbody = emBody.substringBefore('\n');
        
        splitbody = splitbody.substringBefore('\n');
        }
     
        system.debug('splitbody=' +splitbody);
         system.debug('GEQuotecaseEmsgMap==>' +caseEmsgMap);
        if(!caseEmsgMap.isEmpty()){
            system.debug('caseEmsgMap enterd');
            for(case cs : [select id, CaseNumber, Account.Potential_Conexiom__c,Case_Ref_ID__c,AccountID, Account.Name from case where ID IN :caseEmsgMap.values() AND RecordTypeID =:caseRTID AND Account.Potential_Conexiom__c IN('MyEditor Auto Forward','IDOC Auto Forward') AND sub_class__c = 'conexiom']){
                Potential_Connexion = cs.Account.Potential_Conexiom__c;
                caseRec.put(cs.Id, cs);
                csList.add(cs);
            } 
        }
        ConexiomToAddressCM__mdt[] conemail = [Select Potential_Connexiom__c, Is_Test_Sandbox__c, Email_Address__c from ConexiomToAddressCM__mdt];
        for(ConexiomToAddressCM__mdt cmdt: conemail){
            if(cmdt.Potential_Connexiom__c == Potential_Connexion){
                emaddr.put(cmdt.Is_Test_Sandbox__c, cmdt.Email_Address__c);
            }
        }
        System.debug('emaddr::'+emaddr);
        List<EmailMessage> eList = new List<EmailMessage>();
        // Create Attachment Map
         for(EmailMessage em : emList){
            if(caseRec.containsKey(em.ParentID) && em.HasAttachment == true)
            {
                eList.add(em);
                System.debug('eList::'+eList);
            }
        }
        if(!eList.isEMpty() && eList!=null){
           System.debug('Entered here==');
            attList = [SELECT id,Name,ParentID,body FROM Attachment where ParentID IN : eList AND (contenttype = 'application/pdf' OR ContentType = 'text/plain' OR ContentType = 'text/csv' OR ContentType = 'application/octet-stream')];
        }
        system.debug('attList==>' +attList);
        
         if(!attList.isEmpty()){
            for (Attachment attachItr : attList)
            { 
                system.debug('entered Attachment for loop');
                if(caseAttListMap.containsKey(attachItr.ParentID)) {
                    system.debug('entered if');
                    Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                    efa.setFileName(attachItr.Name);
                    efa.setBody(attachItr.body);
                    caseAttListMap.get(attachItr.ParentID).add(efa);
                } else { 
                    system.debug('entered else');
                    Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                    efa.setFileName(attachItr.Name);
                    efa.setBody(attachItr.body);
                    fileAttachments.add(efa);
                    //mapID.put(attachItr.ParentID, fileAttachments);
                    caseAttListMap.put(caseEmsgMap.get(attachItr.ParentID),fileAttachments);
                }
               
            }
       system.debug('caseAttListMap==' + caseAttListMap.values());     
            
        }
        EmailTemplate temp = [select id,Body,Subject from EmailTemplate where DeveloperName='Conexiom_GE_Template' LIMIT 1];
        OrgWideEmailAddress owa = [select id from OrgWideEmailAddress where Address = 'orders@honeywell.com' limit 1];
        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
        List<EmailMessage> emailList = new List<EmailMessage>();
        List<Case> cssnlst = new List<Case>();
        Map<ID,ID> eMapIDs = new Map<ID,ID>();
        Map<ID,EmailMessage> eMessageMap = new Map<ID,EmailMessage>();
        for(Case cs : csList){
            system.debug('entered map if');
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                EmailMessage emailMsg = new EmailMessage();
                String emailBody = temp.Body;
                String emailSubject = temp.Subject;
                
                emailSubject = emailSubject.Replace('{!Case.CaseNumber}', caseRec.get(cs.ID).CaseNumber);
                emailSubject = emailSubject.Replace('{!Case.Case_Ref_ID__c}', caseRec.get(cs.ID).Case_Ref_ID__c);
                if(caseRec.get(cs.ID).Account.Name!=null)
                    emailBody = emailBody.Replace('{!Case.Account}', caseRec.get(cs.ID).Account.Name );
                else
                    emailBody = emailBody.Replace('{!Case.Account}', 'NA' ); 
                emailBody = emailBody.Replace('{!Case.CaseNumber}', caseRec.get(cs.ID).CaseNumber );
               // emailBody = emailBody.Replace('{!Case.RecordTypeId}', caseRec.get(cs.ID).RecordType.Name );
               emailBody = emailBody.Replace('<Dynamic>', splitbody);
            //list<string> EmailStrings = new list<string>();
                //EmailStrings.add('prapoornashwetha.penumalla@nttdata.com');
                //EmailStrings.add(system.label.ConexiomToAddress);
            //mail.setToAddresses(EmailStrings);
            	list<String> Emaddrlst = new list<String>();
                System.debug('hostVal::'+hostVal);
                system.debug('hostVal2:'+emaddr.get(hostVal));
                Emaddrlst.add(emaddr.get(hostVal));
                //Emaddrlst.add('divijadeepthi.salla@Honeywell.com');
                System.debug('Email address'+Emaddrlst);
                System.debug('Emal adrress 2'+emaddr.get(hostVal));
                mail.setToAddresses(Emaddrlst);
            	mail.setSubject(emailSubject);
                mail.setBccSender(false);
                mail.setPlainTextBody(emailBody);                
                mail.setOrgWideEmailAddressId(owa.id);
                mail.setSaveAsActivity(false);
            if(caseAttListMap!=null && caseAttListMap.containsKey(cs.ID)){
                mail.setFileAttachments(caseAttListMap.get(cs.ID));
            }
                msgList.add(mail);
                // Created an EmailMessage and copy all details from above.
                Case cssn = new Case(Id=cs.ID);
                cssnlst.add(cssn);
                emailMsg.ToAddress = emaddr.get(hostVal);
                emailMsg.FromAddress = 'noreply@honeywell.com';
                emailMsg.Subject= emailSubject;
                emailMsg.TextBody = emailBody;
                emailMsg.ParentId = cssn.ID ; //Attach with the case
                emailMsg.MessageDate = system.now();
                emailMsg.Status = '0';
            emailList.add(emailMsg);
                eMessageMap.put(cs.ID,emailMsg);
        }
        Messaging.SendEmailResult[] results;
        try{
            if(!msgList.isEmpty() && msgList!=null){
                system.debug('msglist==>'+msgList);
                results= Messaging.sendEmail(msgList);
                epass = true;
            }
        }
        catch (Exception e){
            epass = false;
            String excError = String.valueOf(e);
            //errorMsgList.add('Interrupted with an error while updating the case ('+excError+')');
            system.debug('An unexpected error for conexiom autoforward email---' + e.getMessage());
        }
        try{
              for(Messaging.SendEmailResult rr:results){
                    System.debug('Email result ' + rr.IsSuccess());
                    integer i=0;
                    //if the records are not success need to remove the targetobjectIDs(error'd ids from map)
                    if(!rr.IsSuccess())
                    {
                        Messaging.SendEmailError[] errArr = rr.getErrors();                      
                        eMessageMap.remove(errArr[i].getTargetObjectId());                     
                        i++; 
                    }
                }
                 
            }
            catch (exception e){
                system.debug('email not inserted' + e.getMessage());
            }
        if(epass == true)
        {
			System.debug('eMessageMap::'+eMessageMap);           
            for(EmailMessage em: eMessageMap.values()){
                if(eMessageMap.containsKey(em.ParentID)){
                    emInsertList.add(em);
                    System.debug('emInsertList::'+emInsertList);
                }
            }
            try{
                if(emInsertList.size()>0)
                	insert emInsertList;
            }
            catch (exception e){
                String excError = String.valueOf(e);
                // errorMsgList.add('Interrupted with an error while updating the case ('+excError+')');
                system.debug('Unable to insert email message on case related list' +e.getMessage());
            }
                
            //added by kayal
            
            for(EmailMessage eml : emInsertList){
                if(eml.id!=null && caseAttListMap!=null && !attList.isEmpty()){
                    eMapIDs.put(eml.ParentID,eml.ID);
                }
            }
            List<Attachment> attchList = new List<Attachment>();
            Attachment attch;
            if(!eMapIDs.isEMpty()){
            for(Attachment att : [SELECT id,Name,ParentID,body FROM Attachment where ParentID IN : caseAttListMap.Keyset() AND (contenttype = 'application/pdf' OR ContentType = 'text/plain' OR ContentType = 'text/csv' OR ContentType = 'application/octet-stream')]) 
            {
                if(eMessageMap.containsKey(att.ParentID))
                {
                    system.debug('entered attachment loop');
                    system.debug('att.ParentID==>' +att.ParentID);
                    attch= new Attachment();
                    attch.Name = att.Name;
                    attch.Body = att.body;
                    attch.ParentID = eMapIDs.get(att.ParentID);
                    attchList.add(attch);
                }
            }
             system.debug('attchList==' +attchList);
             try{
             insert attchList;
             }
             catch(exception e){
             system.debug('atachment not inserted==>' + e.getMessage());
             }
             system.debug('after attachment insert');
        
            } //ended by kayal   
        }
    }  
  
}