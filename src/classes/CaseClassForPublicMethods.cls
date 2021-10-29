/*******************************************************************************
Name         : Constants
Created By   : Anusuya Murugiah
Company Name : NTT Data
Project      : Phase-II, HealthCheck
Created Date : 19 September 2013
Usages       : This Class a generic Constant/String declaration which is used in 
               ObjCaseHelper class.    
Modification History  :
Date          Version No.     Modified by     Brief Description of Modification
15 Oct 2010     1.0           NTTDATA         HAN-0263 Healtcheck Sprint 2 
11 Aug 2014     1.1           NTTDATA         INC000006427828 - Replaced with new Email Template to have Case Number - All_BGA_Template_CSO_BGA_Orders
10 Nov 2014     1.2           NTTDATA         INC000006329969 - to send mail on Case creation from Contact Us Form
13 Nov 2014     1.3           NTTDATA         INC000006844172 - Included code for Case creation notification for BFE Support
18 Nov 2014     1.4           NTTDATA         INC000007007934 - Auto close case if mail received from Unauthorized contact to any email-to-Case Email address
20 Nov 2014     1.5           NTTDATA         INC000007065649 - Please notify the CPS BGA Process team when a case is created
09 Dec 2o14     1.6           NTTDATA         INC000006598776 - Technical Support Engineers must send emails through Outlook.
09 Dec 2014     1.7           NTTDATA         INC000006227014 - Please put case notification email on every case record type.
09 Dec 2014     1.8           NTTDATA         INC000006991156 - to send mail on case creation for Email-DS OEM & Spares Internal, Email-DS Repairs Internal
18 Dec 2014     1.9           NTTDATA         Production Fix for Too Long Html content in the Email while attaching the Email Template in Email relatedlist
16 Jan 2015     2.0           NTTDATA         INC000008113942 - Modified ORG id from Aero No reply to Yourresponse
16 Jan 2015     2.1           NTTDATA         INC000008026261 - to send notification mail for Email-AerospaceWarranty
26 Jan 2015     2.2           NTTDATA         //Added for SR INC000008273229 -- Unauthorized contact auto close rule change
22 Apr 2015     2.3           NTTDATA         INC000008372626 - Modified template id for SBU D&S
09-May-2015     2.4           NTTDATA         INC000008382347 - Email notification to Nicole Kuhn
16-Jul-2015     2.5           NTTDATA         INC000008656265 - To send mail notification on Airbus Transformation 
01-Oct-2015     2.6           NTTDATA         Added code for Aircraft Connectivity project 
19-Jan-2016     2.7           NTTDATA         INC000009615486  - To send mail notification on Olathe Service Center cases 
11-May-2017     2.8           TCS             INC000011590241 - Avsat orders workflow
10-July-2017    2.9           NTTDATA         PRJ11585-- added email notification for JX Accounts FSS Activaiton recordtypes
*******************************************************************************/
global class CaseClassForPublicMethods
{  
    /*
    Map<String,R_O_Case_Reassignment_Queue__c> mapROQType = R_O_Case_Reassignment_Queue__c.getall();
    global Map<Id,String> mapGroupQName = new Map<ID, String>();//[select name from group where type='Queue']);
    //get the values from R&O Case Reassignment Queue in custom settings
    List<R_O_Case_Reassignment_Queue__c> qtype = R_O_Case_Reassignment_Queue__c.getall().values(); 
    Case exceptionCase = new Case();
    
    //INC000006598776 -Start, variables to hold EmailMessage details
    set<id> cid =new set<id>();
    map<id,string> mapCaseIdACTname = new map<id,string>();
    map<id,string> mapCasesupported = new map<id,string>();
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    List<Messaging.SingleEmailMessage> bulkEmailss = new List<Messaging.SingleEmailMessage>();
    List<Messaging.SingleEmailMessage> bulkEmailsNavDB = new List<Messaging.SingleEmailMessage>();
    List<Messaging.SingleEmailMessage> bulkEmailsAVSAT = new List<Messaging.SingleEmailMessage>();
    
    List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
    map<id,case> cse;
    list<string> MailToAddress=new list<string>();
    list<string> temp=new list<string>();
    list<case> CaseAT =new list<case>();
    list<case> Cases =new list<case>();
    list<Supported_Products__c> SupedPrud = new list<Supported_Products__c>();
    map<string,list<string>> MapAircraftTypeEmail = new map<string,list<string>>();
    map<string,list<case>> Mapgroupcase = new map<string,list<case>>();
    //INC000006598776 -Start, variables to hold EmailMessage details

    //INC000005569277 -Start, variables to hold EmailMessage details
    map<id,id> mapContactIds = new map<id,id>();
    map<id,string> mapEmailTemplateids = new map<id,id>();
    map<id,List<string>> mapCaseDetails = new map<id,List<string>>();
    list<Case> listCaseids = new list<Case>();
    //INC000005569277 -End, variables to hold EmailMessage details
    Public String GDCGroup;
    public integer ATRNextWaveCheckdays;
    Public list<String> mailToAddresses = new list<String>();
    public Map<String,GDC_Accounts_Groups__c> mapGDCGroup = new Map<String,GDC_Accounts_Groups__c>();
    
    global CaseClassForPublicMethods()
    {
        //inside constructor
        for(R_O_Case_Reassignment_Queue__c lstRoObj : qtype )
        {                    
            mapGroupQName.put(lstRoObj.QueueId__c,lstRoObj.name); 
            system.debug('@@#mapGroupQName'+mapGroupQName) ;        
        } 
    }
    
    This method is used for the replacement of CaseValUpdtBasOnOwner trigger code called Before Update
    
    global Case setCaseDetails(String queueID,Case objCase)
    {
        String queueName = mapGroupQName.get(queueID);
        system.debug('!!queueName'+queueName );
        if(null != mapROQType.get(queueName) && (mapROQType.get(queueName).QueueId__c).equals(queueID)){
        system.debug('Inside Loop'+mapROQType.get(queueName));
            if(null != mapROQType.get(queueName).RecordTypeid__c)
            objCase.RecordtypeId = mapROQType.get(queueName).RecordTypeid__c;
            objCase.Type = mapROQType.get(queueName).Type__c ;
            objCase.Classification__c = mapROQType.get(queueName).Classification__c;
            objCase.Detail_Class__c = mapROQType.get(queueName).Detail_Class__c;
            objCase.Repair_Location__c = mapROQType.get(queueName).Repair_Location__c;
            objCase.Sub_Class__c = mapROQType.get(queueName).Sub_Class__c;
            return objCase;
        }
        else
        {
            return objCase;
        }
    }
    //INC000005593534-Create planned meeting -Akila
   /* Commented for SR INC000009687923 as it is no longer used
    Global void plannedmeetingcreation(list<case>listObjCaseNew, Map<id,Case>oldmap)
    {
        system.debug('^^^^^^^^^^^^^^'+oldMap);
        set<id> caid= new set<id>();
        list<case> calist=new list<case>();
        list<Planned_Meeting__c>pllist=new list<Planned_Meeting__c>();
        for (case c:listObjCaseNew)
        {
            if((c.Dispatch_Approval_Date__c!=null && oldmap==null )|| (oldmap!=null &&
            oldmap.get(c.id).Dispatch_Approval_Date__c==Null && c.Dispatch_Approval_Date__c!=null))
            caid.add(c.id);
            system.debug('^^^^^^^^^^^^^^'+caid);
            calist.add(c);
            system.debug('^^^^^^^^^^^^^^'+calist);
        }
        if(caid.size()>0)
        {
            for (case casess :calist)
            {
                if(casess.recordtypeid ==label.TechnicalIssue_RecordTypeID)
                {
                    try {
                        Planned_Meeting__c pl =new Planned_Meeting__c();
                        pl.recordtypeid=label.Deployment_Planned_Meeting_rec_Type;
                        pl.Assigned_To__c=casess.OwnerId;
                        system.debug('****'+pl.Assigned_To__c);
                        pl.Contact_Name__c= casess.ContactId;
                        system.debug('****'+pl.Contact_Name__c);
                        pl.Account_Name__c=casess.AccountId;
                        system.debug('****'+pl.Account_Name__c);
                        pl.Reason_for_deployment__c=casess.Dispatch_Reason__c;
                        system.debug('****'+pl.Reason_for_deployment__c);
                        pl.Status__c='Deployed';
                        pl.Case__c=casess.id;
                        system.debug('****'+pl.Status__c);
                        pllist.add(pl);
                    }
                    catch (Exception exc) {
                        System.debug('*******************'+exc);
                    }
                }
            }
        }
        if(pllist.size()>0)
        {
            insert pllist;
        }
    }
    
       
   // This method is used for update the opportunity proposal last opend case called After Insert/Update
    
    
    public void UpdateOppProposalCase(List<Case> listObjCaseNew,Map<ID,Case> oldMap){
        set<id> propids= new set<id>();
        list<case> calist=new list<case>();
        list<Opportunity_Proposal__c> proplist=new list<Opportunity_Proposal__c>();
        list<Opportunity_Proposal__c> proplist1=new list<Opportunity_Proposal__c>();
        for (case c:listObjCaseNew)
        {
            if((c.Opportunity_Proposal__c!=null && oldmap==null )|| (oldmap!=null &&
            oldmap.get(c.id).Opportunity_Proposal__c!= c.Opportunity_Proposal__c)){
                propids.add(c.Opportunity_Proposal__c);
                if(oldmap!=null){
                    propids.add(oldmap.get(c.id).Opportunity_Proposal__c);
                }
            }
        }

        if(propids!=null &&(!propids.isempty()) ){
            proplist =[SELECT Id,(SELECT Id,casenumber FROM Cases__r ORDER BY CreatedDate DESC NULLS FIRST LIMIT 1) FROM Opportunity_Proposal__c where id=:propids];
            for(Opportunity_Proposal__c oppprop : proplist ){
                if(oppprop.Cases__r.size() > 0){
                    for(case cas :oppprop.Cases__r){
                        oppprop.Last_Opened_Case__c = cas.id;
                        proplist1.add(oppprop);
                    }
                }
                else{
                    oppprop.Last_Opened_Case__c = null;
                    proplist1.add(oppprop);
                }
            }
        }
        if(proplist1.size()>0)
        update proplist1;
    }
    // Code added for Aircraft Connectivity Project to reduce sendCaseEmailMethod lines of code and used in After Insert/Update Classes
    public void ACSMSendCaseEmailMethod(List<Case> listObjCaseNew,Map<ID,Case> oldMap,String strDMLMode){
        List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> ACSMbulkEmails = new List<Messaging.SingleEmailMessage>(); 
        List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
        String body,Sub;
        for(Case acsmcas:listObjCaseNew){
            if(TriggerCheck.ACSMMailsend){
                if(acsmcas.ContactId!=null){
                    system.debug('ACSM changes start');
                    Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                    msg.setTargetObjectId(acsmcas.ContactId);
                    msg.setWhatId(acsmcas.id);
                    msg.setOrgWideEmailAddressId(label.ACSM_FSS_Tech_Support_ORG_ID);
                    if(('Insert').equals(strDMLMode) && ((acsmcas.Emailbox_Origin__c=='Email-FSS Tech Support' && acsmcas.RecordTypeId == Label.FSS_Tech_Issue_RT_ID) || (acsmcas.RecordTypeId == Label.GDC_Accounts && acsmcas.Origin == 'Web' && acsmcas.CreatedById == Label.ACSM_API_User_Id))){
                        system.debug('inside if 1');
                        msg.setTemplateId(label.ACSM_Request_Received_Temp_ID);
                    }
                    if(('Update').equals(strDMLMode) && acsmcas.RecordTypeId == Label.FSS_Tech_Issue_RT_ID ){
                        system.debug('ACSM Inside Update');
                        if(acsmcas.OwnerId!=oldMap.get(acsmcas.id).Ownerid && acsmcas.Status == 'Open'){
                            msg.setTemplateId(label.ACSM_Case_Owner_Assigned_Temp_ID); 
                        }else if(acsmcas.Status == 'Closed' && acsmcas.IsClosed == TRUE && acsmcas.Status!=oldMap.get(acsmcas.id).Status){
                            msg.setTemplateId(label.ACSM_Case_Closed_Temp_ID);
                        }
                    }
                    msgList.add(msg);
                    system.debug(msgList);
                    Savepoint sp = Database.setSavepoint();
                    if(msg.getTemplateId()!=null)
                        Messaging.sendEmail(msgList);
                    Database.rollback(sp);
                    if(msgList.size()>0){
                        for(Messaging.SingleEmailMessage email : msgList){
                            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                            emailToSend.setTargetObjectId(email.getTargetObjectId());
                            emailToSend.setPlainTextBody(email.getPlainTextBody());
                            emailToSend.setHTMLBody(email.getHTMLBody());
                            emailToSend.setSubject(email.getSubject());
                            emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                            if(emailToSend.getHTMLBody()!=null)
                                ACSMbulkEmails.add(emailToSend);
                            body = email.getHTMLBody();
                            sub = email.getSubject();
                        }
                    }
                    if(ACSMbulkEmails.size()>0){
                        EmailMessage emailToCase = new EmailMessage();
                        emailToCase.Incoming = false;
                        emailToCase.Subject = sub;
                        emailToCase.MessageDate = system.now();
                        emailToCase.ParentId = acsmcas.Id;
                        emailToCase.FromAddress = Label.ACSM_FSS_Tech_Support_Email;
                        emailToCase.FromName = 'Aero FSS Tech Support';
                        emailToCase.ToAddress = acsmcas.Primary_Email_Address__c;
                        if(body!=null && body.length()>0 ){
                            if(body.length()<32000)
                                emailToCase.HtmlBody =  body.substring(0,body.length());
                            else
                                emailToCase.HtmlBody =  body.substring(0,32000);
                        }
                        listInsertEmailMessage.add(emailToCase);
                    }
                }
                TriggerCheck.ACSMMailsend = false;
            }
        }
        if(ACSMbulkEmails.size()>0){
            try{
                Messaging.sendEmail(ACSMbulkEmails);
            }catch(Exception emailexe){
                system.debug('ACSM Mail Sending Invalid------>'+emailexe.getMessage());
            }
        }
        if(listInsertEmailMessage.size()>0){
            try{
                insert listInsertEmailMessage;
            }Catch(DMLException emailex){
                system.debug('ACSM Email Message Insert----->'+emailex.getMessage());
            }
        }
           
        
    }
    // End code for Aircraft Connectivity Project
   
    This method is used for the replacement of sencaseemail trigger code called After Insert/Update
    
    public Boolean checkCond = false;// Added for INC000007065649
    public void sendCaseEmailMethod(List<Case> listObjCaseNew,Map<ID,Case> oldMap,String strDMLMode){
        set<id> recordtype = new set<id>();
        Map<id,Set<id>>recordmap = new map<id,set<id>>();
        //string recordtype1=label.Quotes_Id;
        string strSurveyTemplate = label.Web_Support_Survey_Template;
        //string quotestemplate=label.quotes_template;
        string MTOTemplate = label.MTO_Inquiry_Confirmation;
        String OtherHoldTemplate = label.Other_Hold_Types_Deferred_On_Line_Order_Template;
        String spexTemplate = label.SPEX_Exchange_Warranty_Deferred_On_Line_Order_Notification_Template;
        //gss integration
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> DSPCbulkmail = new List<Messaging.SingleEmailMessage>();
        Boolean blnSendMail = false; 
        
        try{
            // PortalCaseAtuoClose //
            set<id>caseid= new set<id>();
            map<Id,Case_Line_Item__c> caselinemap= new map<Id,Case_Line_Item__c>();
            list<Case_Line_Item__c> caslinelist=new list<Case_Line_Item__c>();
            list<Case_Line_Item__c> cliupdatelist=new list<Case_Line_Item__c>();
            list<case> caselist= new list<case>();
            // case creating line item
            list<String> nsn,PN,nsnPN =New list<string>();
            list<String> nsnall =New list<string>();
            list<String> pnall =New list<string>();
            list<String> lisnclt=New list<string>();
            list<String> nsn2=New list<string>();
            list<String> pn2=New list<string>();
            List<id>listToAddresses = new list<id>();
            Map<String,Id> Mapofcaseid=New Map<String,Id>();
            list<Case_Line_Item__c> insertlistNSN = New list<Case_Line_Item__c>();
            set<Id> casid=New set<Id>();
            Map<id,Case> lstCas = new Map<id,Case>([select  contactid,Contact.firstName,SuppliedEmail, Contact.LastName,Owner.Email, Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,account.Service_Level__c,SBU__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c,(select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r ) from case where id =: listObjCaseNew]);
            System.debug('CONTACTMAP:'+lstCas);
            if(trigger.isAfter){
                sendAOGAlertMethod(listObjCaseNew,oldMap,strDMLMode, lstCas);
            }
            for(case c: listObjCaseNew ){
                if(Trigger.isInsert && c.RecordTypeId==Label.CaseRecordTypeId_General && c.Type=='CPS BGA Process'){
                    checkCond = true;
                }
            }
            List<User> usrList = new List<User>();
            if(checkCond){
                usrList=[SELECT email, id from User where id in (SELECT UserOrGroupId FROM GroupMember WHERE GroupId=:Label.GroupAeroCpsBgaProcessITeamId)];
            }
            //INC000007065649*************20-Nov-2014**********Pre Required Code********END**
            // case creating line item      
            for(case c: listObjCaseNew )
            {
                if((trigger.isinsert && c.Status=='On Hold') || (trigger.isupdate && 
                (c.Status!=oldmap.get(c.id).Status || c.Sub_Status__c!=oldmap.get(c.id).Sub_Status__c ))){
                    caseid.add(c.id);
                    caselist.add(c);
                }
                //case creating item
                if(c.NSN__c!=null&&c.NSN__c!=''&& c.Recordtypeid==label.D_S_Clear_House_RecordTypeId_Case){
                    nsn=(c.NSN__c).split(';');
                }else{nsn=null;}
                if(nsn!=null){
                    for(string n:nsn){
                        n=n+'\\\\'+c.id;
                        nsn2.add(n);
                    }
                }
                if(c.Part_Number__c !=null&& c.Part_Number__c!=''&& c.Recordtypeid==label.D_S_Clear_House_RecordTypeId_Case){
                    PN=(c.Part_Number__c).split(';');
                }else{PN=null;}
                if(PN!=null){
                    for(string p:PN){
                        p=p+'\\\\'+c.id;
                        PN2.add(p);
                    }
                }
                if(nsn2 != null){
                    nsnall.addall(nsn2);
                    nsnPN.addall(nsn2);
                }
                if(PN2!=null){
                    Pnall.addall(PN2);
                    nsnPN.addall(PN2);
                }
                for(String nclt:nsnPN){
                    Mapofcaseid.put(nclt,c.id);
                }
                nsnPN.clear();
                nsn2.clear();
                PN2.clear();
                casid.add(c.id);
                // case creat item
                //INC000007065649*************20-Nov-2014******************START
                if(Trigger.isInsert && c.RecordTypeId==Label.CaseRecordTypeId_General && c.Type=='CPS BGA Process'){
                    String userMail='';
                    for(User u : usrList){
                        userMail =u.email;
                        
                        System.debug('Sumit >>>>>>>>> userMail: '+ userMail);
                        try{
                            System.debug('Sumit >>>>>>>>>>InsideTry');
                            String casMailSubject=c.Subject+' '+c.CaseNumber+' '+c.Case_Ref_ID__c;
                            String casMailBody='<!DOCTYPE html><body><table border="0" cellpadding="0" cellspacing="0" width="950" style="position: absolute;right: 50px;"><tr><td align="center" height="45" valign="top"><img src=https://c.cs69.content.force.com/servlet/servlet.ImageServer?id=015300000018fo4&oid=00D30000000dWxY" alt="Logo" style="border:none;display:block;right: 20px;position: absolute;top: 10px;height: 30px;"/></td></tr><br/></table><table border="0" cellpadding="5" cellspacing="0" width="600" style="position: absolute;right: 50px;border-top-width: 4px;border-top-style: solid;border-top-color: #ED2028;border-bottom-width: 4px;border-bottom-style: solid;border-bottom-color: #ED2028;"><tr><td align="right" valign="top"><table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td align="left" height="60" style="font-family:Times New Roman;font-size:16px;padding-left: 24px;" valign="middle">'+c.Contact_Name__c +' <br/> This notice is to inform you that your request for '+ c.Subject + ' has been logged with the Aero BGA CPS Process Team.<br/> '+c.Description  +' <br/>Thank you for submitting your request. We will contact you if we have any questions.<br/><br/>Aero C&PS BGA Team</td></tr></table></td></tr></table><br/><br/><table border="0" cellpadding="5" cellspacing="0" width="600" style="position: absolute;right: 50px;border-bottom-width: 4px;border-bottom-style: solid;border-bottom-color: #ED2028;"/></body></html>';
                            String[] toadd = new String[]{userMail};
                            //String[] toadd = new String[]{'sumit13.gupta@nttdata.com'};
                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();            
                            message.setBccSender(false);             
                            message.setUseSignature(false);
                            message.setSaveAsActivity(false);
                            message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                            message.setToAddresses(toadd);
                            message.setHtmlBody(casMailBody);
                            message.setSubject(casMailSubject);
                            bulkEmails.add(message);
                            TriggerInactive.avoidRecursion=False;
                        }catch(Exception e){
                            System.debug('Exception' + e);
                        }
                    }       
                }
                /*****INC000007065649*************20-Nov-2014******************END*******/
                
                //********************GTO Usability Starts*****************************************
                           /* if(c.Id !=null && c.RecordTypeId==Label.TechnicalIssue_RecordTypeID && ( ( lstCas.get(c.Id).Field_Events__r.size() >0 && lstCas.get(c.Id).Field_Events__r[0].Field_event_Report__c==true)))
                            {
                            
                            String strbaseURL = URL.getSalesforceBaseUrl().toExternalForm();
                            String casUrl = strbaseURL+'/'+c.id;
                            List<String> toAddressList = new List<String>();
                            toAddressList.add('DL-AEROC&PSTechOps-FieldEventReport@mail.Honeywell.com ');
                            toAddressList.add(lstCas.get(c.Id).Owner.Email);
                            Messaging.SingleEmailMessage message1 = new Messaging.SingleEmailMessage();
                            message1.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                            message1.setSaveAsActivity(false);
                            String sub='Field Event Report '+( lstCas.get(c.Id).Field_Events__r.size() >0 ? lstCas.get(c.Id).Field_Events__r[0].Field_Event_Report_Count__c : 0) +' '+lstCas.get(c.Id).Supported_Products__r.name+' '+c.Case_Ref_ID__c;
                            String body='Account Name : '+
                            lstCas.get(c.Id).Account.name+'<br></br>Case Number :<a href="'+casUrl+'"> '+
                            c.CaseNumber+'</a><br></br>Date of event :'+
                            ( lstCas.get(c.Id).Field_Events__r.size() >0 ? lstCas.get(c.Id).Field_Events__r[0].Event_Date__c : null)+'<br></br>Engine Model : '+
                            c.Engine_Model__c+'<br></br>Engine/APU Reported SN : '+
                            ( lstCas.get(c.Id).Field_Events__r.size() >0 ? lstCas.get(c.Id).Field_Events__r[0].Engine_APU_Reported_S_N__c : '')+'<br></br>Operational Symptom :  '+
                            ( lstCas.get(c.Id).Field_Events__r.size() >0 ? lstCas.get(c.Id).Field_Events__r[0].Operational_Symptom__c : '')+'<br></br>Case Owner :  '+
                            lstCas.get(c.Id).Owner.name+'<br></br>Region :  '+
                            c.Region__c;
                            body=body+'</table></body></html>';       
                            message1.setSubject(sub);
                            message1.setHtmlBody(body); 
                            message1.setToAddresses(toAddressList);
                            system.debug('To Address'+toAddressList);
                            bulkEmails.add(message1);
                            TriggerInactive.avoidRecursion1=False;
                            }
                            //GTO Usability Ends
            } 
            if(nsnall!=null)
            for(String nclt:nsnall){
                Case_Line_Item__c clt= new Case_Line_Item__c();
                if(nclt!=''){
                    lisnclt=nclt.split('\\\\',2);
                    clt.NSN__c=lisnclt[0];
                    clt.recordtypeid=label.D_S_Clear_House_RecordTypeId_CaseLineItem;
                    clt.Case_Number__c=Mapofcaseid.get(nclt);
                    insertlistNSN.add(clt);
                    lisnclt.clear();
                }
            }
            if(PNall!=null)
            for(String nclt:Pnall){
                Case_Line_Item__c clt= new Case_Line_Item__c();
                if(nclt!=''){
                    lisnclt=nclt.split('\\\\',2);
                    clt.Part_Number__c=lisnclt[0];
                    clt.recordtypeid=label.D_S_Clear_House_RecordTypeId_CaseLineItem;
                    clt.Case_Number__c=Mapofcaseid.get(nclt);
                    insertlistNSN.add(clt);
                    lisnclt.clear();
                }
            }
            if(booleanclass.creatingcaselineitem){
                booleanclass.creatingcaselineitem=false;
                if(insertlistNSN.size()>0)
                    insert insertlistNSN;
            }   
            ///
            /*commented for INC000009169188 
            if(caseid.size()>0){
                caslinelist=[select Case_Number__c,id,MTOCustomer_Endtime__c,MTOCustomer_Starttime__c ,
                BusinessHold_Starttime__c,BusinessHold_Endtime__c,Credithold_Starttime__c,
                Credithold_Endtime__c,Engineeringhold_Endtime__c,Engineeringhold_Starttime__c,
                Exporthold_Endtime__c,Exporthold_Starttime__c,Import_Hold_Endtime__c,
                Import_Hold_Starttime__c,MTO_Endtime__c,MTO_Starttime__c,Pricinghold_Endtime__c,Pricinghold_Starttime__c,
                Qualityhold_Endtime__c,Qualityhold_Starttime__c,Supplychainhold_Endtime__c,
                Supplychainhold_Starttime__c from Case_Line_Item__c where Case_Number__c IN: caseid
                and recordtypeID =:label.AverageTimeHold_RecID];     
            }
            for(Case_Line_Item__c cl: caslinelist)
                caselinemap.put(cl.Case_Number__c,cl);
            for(case cases: caselist){
                if(cases.recordtypeid==label.Orders_Rec_ID || cases.recordtypeid ==label.QuotesRecordID|| cases.recordtypeid ==label.Repair_Overhaul_RT_ID || cases.recordtypeid ==label.OEM_Quotes_Orders_ID || cases.recordtypeid ==label.D_S_Order )
                {
                    Case_Line_Item__c cli;
                    if(caselinemap.get(cases.id)!=null)
                    {
                        cli= new Case_Line_Item__c();
                        cli= caselinemap.get(cases.id);
                    }
                    if(cases.Status=='On Hold' && cases.Sub_Status__c=='Import Hold' &&
                    (trigger.isinsert || (trigger.isupdate && (oldmap.get(cases.Id).status != cases.status ||
                    (oldmap.get(cases.id).Sub_Status__c!=cases.Sub_Status__c)))))
                    {
                        if(caselinemap.get(cases.id)!=null)
                        {
                            cli.Import_Hold_Starttime__c=System.now();          
                        }
                        else
                        {
                            if(cli==null)
                            cli= new Case_Line_Item__c();
                            cli.recordtypeID=label.AverageTimeHold_RecID;
                            cli.Case_Number__c=cases.id;
                            cli.Import_Hold_Starttime__c= System.now();
                        }
                    }
                    else if(trigger.isupdate && ((cases.Sub_Status__c!='Import Hold' && oldmap.get(cases.id).Sub_Status__c=='Import Hold' && cases.Status=='On Hold') || 
                    (cases.Status!='On Hold' && oldmap.get(cases.id).Status=='On Hold' && (oldmap.get(cases.id).Sub_Status__c=='Import Hold'))))
                    {
                        if(caselinemap.get(cases.id)!=null && cli.Import_Hold_Starttime__c!=null)
                        {
                            cli.Import_Hold_Endtime__c=cli.Import_Hold_Endtime__c+ ((System.now().getTime() - cli.Import_Hold_Starttime__c.getTime())/ (1000.0*60.0*60.0));
                        }
                    }
                    if(cases.Status=='On Hold' && cases.Sub_Status__c=='MTO Customer' && (trigger.isinsert || (trigger.isupdate && (oldmap.get(cases.Id).status != cases.status ||oldmap.get(cases.id).Sub_Status__c!=cases.Sub_Status__c))))
                    {
                        if(caselinemap.get(cases.id)!=null)
                        {
                            cli.MTOCustomer_Starttime__c=System.now();          
                        }
                        else
                        {
                            if(cli==null)
                            cli= new Case_Line_Item__c();
                            cli.recordtypeID=label.AverageTimeHold_RecID;
                            cli.Case_Number__c=cases.id;
                            cli.MTOCustomer_Starttime__c= System.now();
                        }
                    }
                    else if(trigger.isupdate && ((cases.Sub_Status__c!='MTO Customer' && oldmap.get(cases.id).Sub_Status__c=='MTO Customer' && cases.Status=='On Hold') || 
                    (cases.Status!='On Hold' && oldmap.get(cases.id).Status=='On Hold' && (oldmap.get(cases.id).Sub_Status__c=='MTO Customer'))))
                    {
                        if(caselinemap.get(cases.id)!=null && cli.MTOCustomer_Starttime__c!=null)
                        {
                            cli.MTOCustomer_Endtime__c=cli.MTOCustomer_Endtime__c+ ((System.now().getTime() - cli.MTOCustomer_Starttime__c.getTime())/ (1000.0*60.0*60.0));
                        }
                    }
                    if(cases.Status=='On Hold' && cases.Sub_Status__c=='Business Hold' && (trigger.isinsert || (trigger.isupdate && (oldmap.get(cases.Id).status != cases.status ||oldmap.get(cases.id).Sub_Status__c!=cases.Sub_Status__c))))
                    {
                        if(caselinemap.get(cases.id)!=null)
                        {
                            //Case_Line_Item__c cli= caselinemap.get(cases.id);
                            cli.BusinessHold_Starttime__c=System.now();
                            //cliupdatelist.add(cli);
                        }
                        else
                        {
                            if(cli==null)
                            cli= new Case_Line_Item__c();
                            //Case_Line_Item__c cli= new Case_Line_Item__c();
                            cli.recordtypeID=label.AverageTimeHold_RecID;
                            cli.Case_Number__c=cases.id;
                            cli.BusinessHold_Starttime__c= System.now();
                            //cliupdatelist.add(cli);
                        }
                    }
                    else if(trigger.isupdate && ((cases.Sub_Status__c!='Business Hold' && oldmap.get(cases.id).Sub_Status__c=='Business Hold' && cases.Status=='On Hold') || 
                    (cases.Status!='On Hold' && oldmap.get(cases.id).Status=='On Hold' && (oldmap.get(cases.id).Sub_Status__c=='Business Hold'))))
                    {
                        if(caselinemap.get(cases.id)!=null && cli.BusinessHold_Starttime__c !=null)
                        {
                            //Case_Line_Item__c cli= caselinemap.get(cases.id);
                            System.debug('BusinessHold_Starttime'+cli.BusinessHold_Starttime__c);
                            //cli.BusinessHold_Endtime__c=cli.BusinessHold_Endtime__c+ ((System.now().getTime() - cli.BusinessHold_Starttime__c.getTime())/ (1000.0*60.0*60.0));
                            cli.BusinessHold_Endtime__c=cli.BusinessHold_Endtime__c+ (System.now().getTime() - cli.BusinessHold_Starttime__c.getTime());
                            System.debug('BusinessHold_Endtime'+cli.BusinessHold_Endtime__c);
                            
                            //cliupdatelist.add(cli);
                        }
                    }
                    if(cases.Status=='On Hold' && cases.Sub_Status__c=='Credit Hold' && (trigger.isinsert || (trigger.isupdate && (oldmap.get(cases.Id).status != cases.status ||oldmap.get(cases.id).Sub_Status__c!=cases.Sub_Status__c))))
                    {
                        if(caselinemap.get(cases.id)!=null)
                        {
                            //Case_Line_Item__c cli= caselinemap.get(cases.id);
                            cli.Credithold_Starttime__c=System.now();
                            //cliupdatelist.add(cli);
                        }
                        else
                        {
                            if(cli==null)
                            cli= new Case_Line_Item__c();
                            //Case_Line_Item__c cli= new Case_Line_Item__c();
                            cli.recordtypeID=label.AverageTimeHold_RecID;
                            cli.Case_Number__c=cases.id;
                            cli.Credithold_Starttime__c= System.now();
                            //cliupdatelist.add(cli);
                        }
                    }
                    else if(trigger.isupdate && ((cases.Sub_Status__c!='Credit Hold' && oldmap.get(cases.id).Sub_Status__c=='Credit Hold' && cases.Status=='On Hold') || 
                    (cases.Status!='On Hold' && oldmap.get(cases.id).Status=='On Hold' && (oldmap.get(cases.id).Sub_Status__c=='Credit Hold'))))
                    {
                        if(caselinemap.get(cases.id)!=null && cli.Credithold_Starttime__c !=null)
                        {
                            //Case_Line_Item__c cli= caselinemap.get(cases.id);
                            cli.Credithold_Endtime__c= cli.Credithold_Endtime__c+ ((System.now().getTime() - cli.Credithold_Starttime__c.getTime())/ (1000.0*60.0*60.0));
                            // cliupdatelist.add(cli);
                        }
                    }
                    if(cases.Status=='On Hold' && cases.Sub_Status__c=='Engineering Hold' && (trigger.isinsert || (trigger.isupdate && (oldmap.get(cases.Id).status != cases.status ||oldmap.get(cases.id).Sub_Status__c!=cases.Sub_Status__c))))
                    {
                        if(caselinemap.get(cases.id)!=null)
                        {
                            //Case_Line_Item__c cli= caselinemap.get(cases.id);
                            cli.Engineeringhold_Starttime__c=System.now();
                            //cliupdatelist.add(cli);
                        }
                        else
                        {
                            if(cli==null)
                            cli= new Case_Line_Item__c();
                            //Case_Line_Item__c cli= new Case_Line_Item__c();
                            cli.recordtypeID=label.AverageTimeHold_RecID;
                            cli.Case_Number__c=cases.id;
                            cli.Engineeringhold_Starttime__c= System.now();
                            //cliupdatelist.add(cli);
                        }
                    }
                    else if(trigger.isupdate && ((cases.Sub_Status__c!='Engineering Hold' && oldmap.get(cases.id).Sub_Status__c=='Engineering Hold' && cases.Status=='On Hold') || 
                    (cases.Status!='On Hold' && oldmap.get(cases.id).Status=='On Hold' && (oldmap.get(cases.id).Sub_Status__c=='Engineering Hold'))))
                    {
                        if(caselinemap.get(cases.id)!=null && cli.Engineeringhold_Starttime__c!=null)
                        {
                            //Case_Line_Item__c cli= caselinemap.get(cases.id);
                            cli.Engineeringhold_Endtime__c = cli.Engineeringhold_Endtime__c+((System.now().getTime() - cli.Engineeringhold_Starttime__c.getTime())/ (1000.0*60.0*60.0));
                            //cliupdatelist.add(cli);
                        }
                    }
                    if(cases.Status=='On Hold' && cases.Sub_Status__c=='Export Hold' && (trigger.isinsert || (trigger.isupdate && (oldmap.get(cases.Id).status != cases.status ||oldmap.get(cases.id).Sub_Status__c!=cases.Sub_Status__c))))
                    {
                        if(caselinemap.get(cases.id)!=null)
                        {
                            //Case_Line_Item__c cli= caselinemap.get(cases.id);
                            cli.Exporthold_Starttime__c=System.now();
                            //cliupdatelist.add(cli);
                        }
                        else
                        {
                            if(cli==null)
                            cli= new Case_Line_Item__c();
                            //Case_Line_Item__c cli= new Case_Line_Item__c();
                            cli.recordtypeID=label.AverageTimeHold_RecID;
                            cli.Case_Number__c=cases.id;
                            cli.Exporthold_Starttime__c= System.now();
                            //cliupdatelist.add(cli);
                        }
                    }
                    else if(trigger.isupdate && ((cases.Sub_Status__c!='Export Hold' && oldmap.get(cases.id).Sub_Status__c=='Export Hold' && cases.Status=='On Hold') || 
                    (cases.Status!='On Hold' && oldmap.get(cases.id).Status=='On Hold' && (oldmap.get(cases.id).Sub_Status__c=='Export Hold'))))
                    {
                        if(caselinemap.get(cases.id)!=null && cli.Exporthold_Starttime__c!=null)
                        {
                            //Case_Line_Item__c cli= caselinemap.get(cases.id);
                            cli.Exporthold_Endtime__c = cli.Exporthold_Endtime__c + ((System.now().getTime() - cli.Exporthold_Starttime__c.getTime())/ (1000.0*60.0*60.0));
                            //cliupdatelist.add(cli);
                        }
                    }
                    if(cases.Status=='On Hold' && cases.Sub_Status__c=='Integrated Supply Chain Hold' && (trigger.isinsert || (trigger.isupdate && (oldmap.get(cases.Id).status != cases.status ||oldmap.get(cases.id).Sub_Status__c!=cases.Sub_Status__c))))
                    {
                        if(caselinemap.get(cases.id)!=null)
                        {
                            //Case_Line_Item__c cli= caselinemap.get(cases.id);
                            cli.Supplychainhold_Starttime__c=System.now();
                            //cliupdatelist.add(cli);
                        }
                        else
                        {
                            if(cli==null)
                            cli= new Case_Line_Item__c();
                            // Case_Line_Item__c cli= new Case_Line_Item__c();
                            cli.recordtypeID=label.AverageTimeHold_RecID;
                            cli.Case_Number__c=cases.id;
                            cli.Supplychainhold_Starttime__c= System.now();
                            //cliupdatelist.add(cli);
                        }

                    }
                    else if(trigger.isupdate && ((cases.Sub_Status__c!='Integrated Supply Chain Hold' && oldmap.get(cases.id).Sub_Status__c=='Integrated Supply Chain Hold' && cases.Status=='On Hold') || 
                    (cases.Status!='On Hold' && oldmap.get(cases.id).Status=='On Hold' && (oldmap.get(cases.id).Sub_Status__c=='Integrated Supply Chain Hold'))))
                    {
                        if(caselinemap.get(cases.id)!=null && cli.Supplychainhold_Starttime__c!=null)
                        {
                             System.debug('Integrated_Starttime'+cli.Supplychainhold_Starttime__c);
                            //Case_Line_Item__c cli= caselinemap.get(cases.id);
                            //cli.Supplychainhold_Endtime__c = cli.Supplychainhold_Endtime__c + ((System.now().getTime() - cli.Supplychainhold_Starttime__c.getTime())/ (1000.0*60.0*60.0));
                            cli.Supplychainhold_Endtime__c = cli.Supplychainhold_Endtime__c + ((System.now().getTime() - cli.Supplychainhold_Starttime__c.getTime())/1000)/60; // Modified for INC000008750073
                             System.debug('Integrated_Starttime'+cli.Supplychainhold_Endtime__c);
                             System.debug('System_time'+System.now().getTime());
                            
                            //cliupdatelist.add(cli);
                        }
                    }
                    if(cases.Status=='On Hold' && cases.Sub_Status__c=='Pricing Hold' && (trigger.isinsert || 
                    (trigger.isupdate && (oldmap.get(cases.Id).status != cases.status ||
                    oldmap.get(cases.id).Sub_Status__c!=cases.Sub_Status__c))))
                    {
                        if(caselinemap.get(cases.id)!=null)
                        {
                            //Case_Line_Item__c cli= caselinemap.get(cases.id);
                            cli.Pricinghold_Starttime__c=System.now();
                            //cliupdatelist.add(cli);
                        }
                        else
                        {
                            if(cli==null)
                            cli= new Case_Line_Item__c();
                            //Case_Line_Item__c cli= new Case_Line_Item__c();
                            cli.recordtypeID=label.AverageTimeHold_RecID;
                            cli.Case_Number__c=cases.id;
                            cli.Pricinghold_Starttime__c= System.now();
                            //cliupdatelist.add(cli);
                        }
                    }
                    else if(trigger.isupdate && ((cases.Sub_Status__c!='Pricing Hold' && oldmap.get(cases.id).Sub_Status__c=='Pricing Hold' && cases.Status=='On Hold') || 
                    (cases.Status!='On Hold' && oldmap.get(cases.id).Status=='On Hold' && (oldmap.get(cases.id).Sub_Status__c=='Pricing Hold'))))
                    {
                        if(caselinemap.get(cases.id)!=null && cli.Pricinghold_Starttime__c!=null)
                        {
                            //Case_Line_Item__c cli= caselinemap.get(cases.id);
                            cli.Pricinghold_Endtime__c = cli.Pricinghold_Endtime__c + ((System.now().getTime() - cli.Pricinghold_Starttime__c.getTime())/ (1000.0*60.0*60.0));
                            // cliupdatelist.add(cli);
                        }
                    }
                    if(cases.Status=='On Hold' && cases.Sub_Status__c=='Quality Hold' && (trigger.isinsert || (trigger.isupdate && (oldmap.get(cases.Id).status != cases.status ||oldmap.get(cases.id).Sub_Status__c!=cases.Sub_Status__c))))
                    {
                        if(caselinemap.get(cases.id)!=null)
                        {
                            //Case_Line_Item__c cli= caselinemap.get(cases.id);
                            cli.Qualityhold_Starttime__c=System.now();
                            //cliupdatelist.add(cli);
                        }
                        else
                        {
                            if(cli==null)
                            cli= new Case_Line_Item__c();
                            //Case_Line_Item__c cli= new Case_Line_Item__c();
                            cli.recordtypeID=label.AverageTimeHold_RecID;
                            cli.Case_Number__c=cases.id;
                            cli.Qualityhold_Starttime__c= System.now();
                            //cliupdatelist.add(cli);
                        }
                    }
                    else if(trigger.isupdate && ((cases.Sub_Status__c!='Quality Hold' && oldmap.get(cases.id).Sub_Status__c=='Quality Hold' && cases.Status=='On Hold') || 
                    (cases.Status!='On Hold' && oldmap.get(cases.id).Status=='On Hold' && (oldmap.get(cases.id).Sub_Status__c=='Quality Hold'))))
                    {
                        if(caselinemap.get(cases.id)!=null && cli.Qualityhold_Starttime__c!=null)
                        {
                            //Case_Line_Item__c cli= caselinemap.get(cases.id);
                            cli.Qualityhold_Endtime__c = cli.Qualityhold_Endtime__c + ((System.now().getTime() - cli.Qualityhold_Starttime__c.getTime())/ (1000.0*60.0*60.0));
                            //cliupdatelist.add(cli);
                        }
                    }
                    if(cases.Status=='On Hold' && cases.Sub_Status__c=='MTO' && (trigger.isinsert || (trigger.isupdate && (oldmap.get(cases.Id).status != cases.status ||oldmap.get(cases.id).Sub_Status__c!=cases.Sub_Status__c))))
                    {
                        if(caselinemap.get(cases.id)!=null)
                        {
                            //Case_Line_Item__c cli= caselinemap.get(cases.id);
                            cli.MTO_Starttime__c=System.now();
                            //cliupdatelist.add(cli);
                        }
                        else
                        {
                            if(cli==null)
                            cli= new Case_Line_Item__c();
                            //Case_Line_Item__c cli= new Case_Line_Item__c();
                            cli.recordtypeID=label.AverageTimeHold_RecID;
                            cli.Case_Number__c=cases.id;
                            cli.MTO_Starttime__c= System.now();
                            //cliupdatelist.add(cli);
                        }
                    }
                    else if(trigger.isupdate && ((cases.Sub_Status__c!='MTO' && oldmap.get(cases.id).Sub_Status__c=='MTO' && cases.Status=='On Hold') || 
                    (cases.Status!='On Hold' && oldmap.get(cases.id).Status=='On Hold' && (oldmap.get(cases.id).Sub_Status__c=='MTO'))))
                    {
                        if(caselinemap.get(cases.id)!=null && cli.MTO_Starttime__c!=null)
                        {
                            //Case_Line_Item__c cli= caselinemap.get(cases.id);
                            cli.MTO_Endtime__c = cli.MTO_Endtime__c + ((System.now().getTime() - cli.MTO_Starttime__c.getTime())/ (1000.0*60.0*60.0));
                            //cliupdatelist.add(cli);
                        }
                    }
                    if(cli!=null)
                        cliupdatelist.add(cli);
                }
                System.debug('ANU-OWNER-513'+cases.ownerid);
            }
            if(cliupdatelist.size()>0)
                upsert cliupdatelist;
                
            // PortalCaseAutoClose //
            for(Case cas:listObjCaseNew)
            {
                listCaseids.add(cas);// INC000005569277
                 //Added the boolean var 'emailDomain' for BGA condition - SR INC000005580855
                 String[] emailAddressArr = (label.BGA_Case_Creation_Notification).split(','); 
                 boolean check=false; 
                 for(String s: emailAddressArr){
                         if(cas.SuppliedEmail!=null){
                         if(cas.SuppliedEmail.contains(s)){
                        check=true;
                           break;
                           }
                        }
                        }   
                boolean emailDomain = (cas.SuppliedEmail !=null) && (check)? false : true;  

               //INC000005888983---start
                 String[] emailAddressArr2 = (label.ATR_Customers_to_the_Send_to_Portal).split(','); 
                 boolean check1=false; 
                 for(String s: emailAddressArr2){
                         if(cas.SuppliedEmail!=null){
                         if(cas.SuppliedEmail.contains(s)){
                        check1=true;
                           break;
                           }
                        }
                        }   
                boolean emailDomain1 = (cas.SuppliedEmail !=null) && (check1)? true : false; 
            //INC000005888983---End          
        exceptionCase = cas;
        //code added for avsat autoresponse
        if(('Insert').equals(strDMLMode) && cas.ContactId != null && cas.Emailbox_Origin__c!=null && cas.Emailbox_Origin__c=='Email-AVSAT Orders'&& !AircraftNotificationsTriggerStopper.hasalreadyExecutedPPO())
        {
                    System.debug('inside Trupti');
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();  
                     message.setTargetObjectId(cas.ContactId);
                     message.setWhatId(cas.Id);             
                     message.setBccSender(false);             
                     message.setUseSignature(false);
                     message.setSaveAsActivity(false);
                     String[] toAddresses1 = new String[] {cas.SuppliedEmail}; 
                     message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                     message.setTemplateId(label.Case_Creation_Template_ID3); 
                     message.setToAddresses(toAddresses1); 
                     bulkEmailsAVSAT.add(message);
                     AircraftNotificationsTriggerStopper.setalreadyExecutedPPO();                             
        }
        //Code added for INC000011218366 
        
        
        if(('Update').equals(strDMLMode) && cas.Type!=null && cas.Type!= oldmap.get(cas.id).Type && cas.RecordtypeId == label.AerobizRecType && cas.IsClosed == False)
        {
            System.debug('inside AeroBiZ');
            System.debug('inside AeroBiZ case type:'+cas.Type);
                     Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();  
                     string conid=Label.UFR_Cont_Id;
                     message.setTargetObjectId(conid);
                     message.setWhatId(cas.Id);             
                     message.setBccSender(false);             
                     message.setUseSignature(false);
                     message.setSaveAsActivity(false);
                     
                     String[] typeWINGMAN = new String[] {'DL-CORP-BKWINGMAN@Honeywell.com'}; 
                     String[] typeNGAPM = new String[] {'DL-CORP-NGAPM@Honeywell.com'};
                     String[] typeBMS = new String[] {'DL-CORP-NGBSS@Honeywell.com'};
                     String[] typeADS = new String[] {'DL-CORP-ASDS@Honeywell.com'};
                     String[] typeSIMS = new String[] {'DL-CORP-SIMS@Honeywell.com'};
                     String[] typeDBMAN = new String[] {'DL-CORP-GODIRECTPORTAL@Honeywell.com'};
                     String[] typeSIGNS = new String[] {'DL-CORP-SIGNS@Honeywell.com'};
                     String[] typeINDS = new String[] {'DL-CORP-INDS@Honeywell.com'};
                     String[] typeBUSINESSOBJECTS = new String[] {'kiran.sibbala@Honeywell.com','Sunanda.Yellapragada@Honeywell.com','RadhaShyam.Singh@Honeywell.com'};
                     String[] typeGSS = new String[] {'DL-CORP-PILOTGATEWAY@Honeywell.com'};
                     message.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                     message.setTemplateId(label.AeroBiz_TypeChangeTemplate); 
                     mapEmailTemplateids.put(cas.id,label.AeroBiz_TypeChangeTemplate);
                     if(cas.Type== 'AEROEBIZSUPPORT-WINGMAN')
                     {
                      message.setToAddresses(typeWINGMAN); 
                     }
                     if(cas.Type== 'AEROEBIZSUPPORT- NGAPM')
                     {
                      message.setToAddresses(typeNGAPM); 
                     }
                     if(cas.Type== 'AEROEBIZSUPPORT-BMS/NGBMS')
                     {
                      message.setToAddresses(typeBMS); 
                     }
                     if(cas.Type== 'AEROEBIZSUPPORT-ADS/AMI/RCD')
                     {
                      message.setToAddresses(typeADS); 
                     }
                     if(cas.Type== 'AEROEBIZSUPPORT-SIMS')
                     {
                      message.setToAddresses(typeSIMS); 
                     }
                     if(cas.Type== 'AEROEBIZSUPPORT-DBMAN/GODIRECT/ACSM')
                     {
                      message.setToAddresses(typeDBMAN); 
                     }
                     if(cas.Type== 'AEROEBIZSUPPORT-SIGNS')
                     {
                      message.setToAddresses(typeSIGNS); 
                     }
                     if(cas.Type== 'AEROEBIZSUPPORT-INDS')
                     {
                      message.setToAddresses(typeINDS); 
                     }
                     if(cas.Type== 'AEROEBIZSUPPORT-BUSINESS OBJECTS')
                     {
                      message.setToAddresses(typeBUSINESSOBJECTS); 
                     }
                     if(cas.Type== 'AEROEBIZSUPPORT-GSS/PILOTGATEWAY')
                     {
                      message.setToAddresses(typeGSS); 
                     }
                     
                     
                    System.debug('CaseCloseNotification@@:'+typeWINGMAN);
                    msgList.add(message);
                    Savepoint sp = Database.setSavepoint();
                    Messaging.sendEmail(msgList);
                    Database.rollback(sp);
                    for(Messaging.SingleEmailMessage email : msgList){
                    System.debug('Is enterring:');
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(email.getToAddresses());
                    emailToSend.setPlainTextBody(email.getPlainTextBody());
                    emailToSend.setHTMLBody(email.getHTMLBody());
                    emailToSend.setSubject(email.getSubject());                    
                    emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                    bulkEmailsNavDB.add(emailToSend); 
                    }
                    
                                       
        }
        if( trigger.isupdate && Trigger.isAfter && TriggerCheck.firstIntEscRun && cas.RecordtypeId == label.AerobizRecType && cas.IsClosed == true && cas.IsClosed !=oldmap.get(cas.id).IsClosed )
                  {
                   try{
                     System.debug('CaseCloseNotification:'+lstCas.get(cas.Id).Owner.Email);      
                     Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();  
                     string conid=Label.UFR_Cont_Id;
                     message.setTargetObjectId(conid);
                     message.setWhatId(cas.Id);             
                     message.setBccSender(false);             
                     message.setUseSignature(false);
                     message.setSaveAsActivity(false);
                    
                     String[] typeWINGMAN = new String[] {'DL-CORP-BKWINGMAN@Honeywell.com',lstCas.get(cas.Id).Owner.Email,cas.SuppliedEmail}; 
                     String[] typeNGAPM = new String[] {'DL-CORP-NGAPM@Honeywell.com',lstCas.get(cas.Id).Owner.Email,cas.SuppliedEmail};
                     String[] typeBMS = new String[] {'DL-CORP-NGBSS@Honeywell.com',lstCas.get(cas.Id).Owner.Email,cas.SuppliedEmail};
                     String[] typeADS = new String[] {'DL-CORP-ASDS@Honeywell.com',lstCas.get(cas.Id).Owner.Email,cas.SuppliedEmail};
                     String[] typeSIMS = new String[] {'DL-CORP-SIMS@Honeywell.com',lstCas.get(cas.Id).Owner.Email,cas.SuppliedEmail};
                     String[] typeDBMAN = new String[] {'DL-CORP-GODIRECTPORTAL@Honeywell.com',lstCas.get(cas.Id).Owner.Email,cas.SuppliedEmail};
                     String[] typeSIGNS = new String[] {'DL-CORP-SIGNS@Honeywell.com',lstCas.get(cas.Id).Owner.Email,cas.SuppliedEmail};
                     String[] typeINDS = new String[] {'DL-CORP-INDS@Honeywell.com',lstCas.get(cas.Id).Owner.Email,cas.SuppliedEmail};
                     String[] typeBUSINESSOBJECTS = new String[] {'kiran.sibbala@Honeywell.com','Sunanda.Yellapragada@Honeywell.com','RadhaShyam.Singh@Honeywell.com',lstCas.get(cas.Id).Owner.Email,cas.SuppliedEmail};
                     String[] typeGSS = new String[] {'DL-CORP-PILOTGATEWAY@Honeywell.com',lstCas.get(cas.Id).Owner.Email,cas.SuppliedEmail};
                     message.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                     message.setTemplateId(label.AeroBizCaseClosureNotification); 
                     mapEmailTemplateids.put(cas.id,label.AeroBizCaseClosureNotification);
                     if(cas.Type== 'AEROEBIZSUPPORT-WINGMAN')
                     {
                      System.debug('CaseCloseNotification@:'+typeWINGMAN);
                      
                      message.setToAddresses(typeWINGMAN); 
                      System.debug('CaseCloseNotification@#:'+typeWINGMAN);
                     }
                     if(cas.Type== 'AEROEBIZSUPPORT- NGAPM')
                     {
                      message.setToAddresses(typeNGAPM); 
                     }
                     if(cas.Type== 'AEROEBIZSUPPORT-BMS/NGBMS')
                     {
                      message.setToAddresses(typeBMS); 
                     }
                     if(cas.Type== 'AEROEBIZSUPPORT-ADS/AMI/RCD')
                     {
                      message.setToAddresses(typeADS); 
                     }
                     if(cas.Type== 'AEROEBIZSUPPORT-SIMS')
                     {
                      message.setToAddresses(typeSIMS); 
                     }
                     if(cas.Type== 'AEROEBIZSUPPORT-DBMAN/GODIRECT/ACSM')
                     {
                      message.setToAddresses(typeDBMAN); 
                     }
                     if(cas.Type== 'AEROEBIZSUPPORT-SIGNS')
                     {
                      message.setToAddresses(typeSIGNS); 
                     }
                     if(cas.Type== 'AEROEBIZSUPPORT-INDS')
                     {
                      message.setToAddresses(typeINDS); 
                     }
                     if(cas.Type== 'AEROEBIZSUPPORT-BUSINESS OBJECTS')
                     {
                      message.setToAddresses(typeBUSINESSOBJECTS); 
                     }
                     if(cas.Type== 'AEROEBIZSUPPORT-GSS/PILOTGATEWAY')
                     {
                      message.setToAddresses(typeGSS); 
                     }
                    System.debug('CaseCloseNotification@@:'+typeWINGMAN);
                    msgList.add(message);
                    Savepoint sp = Database.setSavepoint();
                    Messaging.sendEmail(msgList);
                    Database.rollback(sp);
                    for(Messaging.SingleEmailMessage email : msgList){
                    System.debug('Is enterring:');
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(email.getToAddresses());
                    emailToSend.setPlainTextBody(email.getPlainTextBody());
                    emailToSend.setHTMLBody(email.getHTMLBody());
                    emailToSend.setSubject(email.getSubject());                    
                    emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                    bulkEmailsNavDB.add(emailToSend); 
                    
                    }
                                        
                        List<string> caseDet = new List<string>();
                        if(cas.CaseNumber != null)
                            caseDet.add(cas.CaseNumber);
                        else
                            caseDet.add(' ');
                        
                        if( cas.Subject != null)
                            caseDet.add(cas.Subject);
                        else
                            caseDet.add(' ');
                            
                        if(cas.Case_Ref_ID__c != null)
                            caseDet.add(cas.Case_Ref_ID__c);
                        else
                            caseDet.add(' ');
                            
                        if(cas.Description!= null)
                            caseDet.add(cas.Description);
                        else
                            caseDet.add(' ');
                        
                        if(cas.Resolution__c!= null)
                            caseDet.add(cas.Resolution__c);
                        else
                            caseDet.add(' '); 

                       /* if(cas.OwnerFullName!= null)
                            caseDet.add(cas.OwnerFullName);
                        else
                            caseDet.add(' '); 
                            
                        if(cas.SuppliedEmail!= null)
                            caseDet.add(cas.SuppliedEmail);
                        else
                            caseDet.add(' '); 
                            
                        mapCaseDetails.put(cas.id,caseDet);
                             
                         TriggerCheck.firstIntEscRun = false;   
                           }
                        catch(Exception exc) {
                            System.debug('*******************'+exc);
                        }
                   }
                   
                
                    
        //Code added for INC000011218366 
        
        if(cas.ContactId == null && cas.Origin!=null && (cas.Origin=='Email-AeroBizSupport' || cas.Origin=='Email-JXSupport' || cas.Origin=='Email-Raunheim' || cas.Origin=='Email-NavDB' || cas.Origin=='Email-Edinburgh' || cas.Origin=='Email-Garden Grove'|| cas.origin=='Email- AerospaceWarranty') && (cas.RecordtypeId == label.NavDB_Accts_Record_Type || cas.RecordtypeId == label.Orders_Rec_ID || cas.RecordtypeId == label.Repair_Overhaul_RT_ID || cas.RecordtypeId == label.AerobizRecType || cas.RecordtypeId == label.JXSupportRecType_ID|| cas.RecordtypeId==label.Warranty_RT_ID) && !AircraftNotificationsTriggerStopper.hasalreadyExecutedPPO())
                {
                     Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();  
                     string conid=Label.UFR_Cont_Id;
                     message.setTargetObjectId(conid);
                     message.setWhatId(cas.Id);             
                     message.setBccSender(false);             
                     message.setUseSignature(false);
                     message.setSaveAsActivity(false);
                    System.debug('Inside Non Contact else'); 
                    System.debug('Inside Non Contact else Supplied mail:'+cas.SuppliedEmail);
                    String[] toAddresses = new String[] {cas.SuppliedEmail};  
                      message.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                                //incident INC000008343112/INC000008392050 start
                                if(cas.Emailbox_Origin__c=='Email-NavDB' || cas.Emailbox_Origin__c=='Email-AeroBizSupport'|| (cas.Emailbox_Origin__c=='Email-Orders' ))
                                {
                                message.setTemplateId(label.Case_Creation_Template_ID3); 
                                mapEmailTemplateids.put(cas.id,label.Case_Creation_Template_ID3); 
                                
                                }
                                //code starts for JXSupport
                                if(null!=cas.Emailbox_Origin__c && cas.Emailbox_Origin__c == 'Email-JXSupport' )
                                {
                                System.debug('Inside JXSupport3'); 
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                                message.setTemplateId(label.JX_Customer_Support_ID1); 
                                mapEmailTemplateids.put(cas.id,label.JX_Customer_Support_ID1);                                                                              
                                
                                }                               
                                //code ends for JXSupport 
                                else if(cas.Emailbox_Origin__c=='Email-Raunheim')
                                {
                                message.setTemplateId(label.Order_Confirmation_For_Raunheim); 
                                mapEmailTemplateids.put(cas.id,label.Order_Confirmation_For_Raunheim); 
                                }
                                else if(cas.Emailbox_Origin__c=='Email-Edinburgh' )
                                {
                                message.setTemplateId(label.Order_Confirmation_Template_Edinburgh); 
                                mapEmailTemplateids.put(cas.id,label.Order_Confirmation_Template_Edinburgh);
                                }
                                else if(cas.Emailbox_Origin__c=='Email-Garden Grove')
                                {
                                 message.setTemplateId(label.Order_Confirmation_For_GardenGrove); 
                                 mapEmailTemplateids.put(cas.id,label.Order_Confirmation_For_GardenGrove);
                                }
                                else if(cas.Emailbox_Origin__c=='Email- AerospaceWarranty')
                                {
                                 message.setTemplateId(label.Case_Creation_Template_ID); 
                                 mapEmailTemplateids.put(cas.id,label.Case_Creation_Template_ID);
                                }
                                
                                message.setToAddresses(toAddresses);                                                                             
                                //incident INC000008343112/INC000008392050 End 
                                bulkEmailsNavDB.add(message);                   
                                //blnSendMail = true;
                                
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                                AircraftNotificationsTriggerStopper.setalreadyExecutedPPO();
                                System.debug('setalreadyExecuted'+AircraftNotificationsTriggerStopper.hasalreadyExecutedPPO());
                               
                }
                System.debug('Contact^^^:'+cas.ContactId);
                if(cas.ContactId != null && (cas.Origin == 'Email-Orders' || cas.Origin == 'Email-Order Status' || cas.Origin == 'Email-Quotes' || cas.Origin == 'Email-BGAOEMQuoteOrders' || cas.Origin == 'Email-CSO BGA Spares') && (cas.sbu__c == 'ATR' || cas.sbu__c == 'BGA' || cas.sbu__c == 'D&S' || cas.sbu__c == 'Intercompany') && (cas.PFECN__c=='Portal' || cas.PFECN__c=='Manual' || cas.PFECN__c=='Refer to Network' || cas.PFECN__c=='EDI' || cas.PFECN__c=='Winshuttle' || cas.PFECN__c=='Customer Funded Manual') && !AircraftNotificationsTriggerStopper.hasalreadyExecutedORdersRT())
                            {
                            System.debug('inside Email-Orders by PFECN Trig Stopper:'+AircraftNotificationsTriggerStopper.hasalreadyExecutedORdersRT());
                            AircraftNotificationsTriggerStopper.setalreadyExecutedORdersRT();
                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();  
                             string conid=Label.UFR_Cont_Id;
                             //message.setTargetObjectId(conid);
                             message.setTargetObjectId(cas.ContactId);
                             message.setWhatId(cas.Id);             
                             message.setBccSender(false);             
                             message.setUseSignature(false);
                             message.setSaveAsActivity(false);
                             String[] toAddresses = new String[] {cas.SuppliedEmail}; 
                                system.debug('inside Email-Orders by PFECN:'+cas.PFECN__c);
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                                   if((cas.Emailbox_Origin__c == 'Email-Orders' || cas.Origin == 'Email-BGAOEMQuoteOrders' || cas.Origin == 'Email-CSO BGA Spares') && cas.PFECN__c=='Portal')
                                {
                                    message.setTemplateId(label.Orders_PFECN);
                                    //blnSendMail = true;
                                    mapEmailTemplateids.put(cas.id,label.Orders_PFECN);
                                }
                                if(cas.Emailbox_Origin__c == 'Email-Order Status' && cas.PFECN__c=='Portal')
                                {
                                    message.setTemplateId(label.Order_Status_PFECN);
                                    //blnSendMail = true;
                                    mapEmailTemplateids.put(cas.id,label.Order_Status_PFECN);
                                }
                                if(cas.Emailbox_Origin__c == 'Email-Quotes' && cas.PFECN__c=='Portal')
                                {
                                    message.setTemplateId(label.Quotes_PFECN);
                                    //blnSendMail = true;
                                    mapEmailTemplateids.put(cas.id,label.Quotes_PFECN);
                                }
                                if(cas.Emailbox_Origin__c == 'Email-Orders' && (cas.PFECN__c=='Manual' || cas.PFECN__c=='Winshuttle' || cas.PFECN__c=='EDI' || cas.PFECN__c=='Customer Funded Manual' ))
                                {
                                    system.debug('inside Email-Orders by PFECN##:'+cas.PFECN__c);
                                    message.setTemplateId(label.Order_Confirmation); 
                                    mapEmailTemplateids.put(cas.id,label.Order_Confirmation); 
                                }
                                if((cas.Origin == 'Email-BGAOEMQuoteOrders' || cas.Origin == 'Email-CSO BGA Spares') && cas.PFECN__c=='Manual' || cas.PFECN__c=='Customer Funded Manual')
                                {
                                    system.debug('inside Email-BGAOEMQuoteOrders by PFECN##:'+cas.PFECN__c);
                                    message.setTemplateId(label.Order_Confirmation); 
                                    mapEmailTemplateids.put(cas.id,label.Order_Confirmation); 
                                }
                                if(cas.Emailbox_Origin__c == 'Email-Order Status' && (cas.PFECN__c=='Manual' || cas.PFECN__c=='Winshuttle' || cas.PFECN__c=='EDI' || cas.PFECN__c=='Customer Funded Manual'))
                                {
                                system.debug('inside Email-Order Status by PFECN##:'+cas.PFECN__c);
                                    message.setTemplateId(label.Order_Status_Inquiry); 
                                    mapEmailTemplateids.put(cas.id,label.Order_Status_Inquiry); 
                                }
                                if(cas.Emailbox_Origin__c == 'Email-Quotes' && (cas.PFECN__c=='Manual' || cas.PFECN__c=='Winshuttle' || cas.PFECN__c=='EDI' || cas.PFECN__c=='Customer Funded Manual'))
                                {
                                system.debug('inside Email-Quotes Status by PFECN##:'+cas.PFECN__c);
                                    message.setTemplateId(label.Quote_Request_Confirmation); 
                                    mapEmailTemplateids.put(cas.id,label.Quote_Request_Confirmation); 
                                }
                                if((cas.Emailbox_Origin__c == 'Email-Orders' || cas.Emailbox_Origin__c == 'Email-Order Status' || cas.Emailbox_Origin__c == 'Email-Quotes') && cas.PFECN__c=='Refer to Network')
                                {
                                    message.setTemplateId(label.D_S_Refer_to_Network);
                                    
                                    mapEmailTemplateids.put(cas.id,label.D_S_Refer_to_Network);
                                }
                                
                               // mapEmailTemplateids.put(cas.id,label.Order_Confirmation);
                                mapContactids.put(cas.id,cas.contactid);
                                //message.setToAddresses(toAddresses); 
                                 
                                 bulkEmailsNavDB.add(message);  
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet); 
                            }
    if(cas.ContactId != null)
    {  
    // Added for SR INC000007007934 starts
        if(('Insert').equals(strDMLMode) && (cas.Origin!=null && cas.Origin.contains('Email')) && cas.Service_Level__c=='Unauthorized Dist/Brkr'
        //Added for SR INC000008273229
        && (cas.Origin =='Email-AOG' 
             || cas.Origin =='Email- AerospaceWarranty' || cas.Origin =='Email-bga-orders' 
            || cas.Origin =='Email-Disputes'|| cas.Origin =='Email-Order Changes' 
             || cas.Origin =='Email-crc-spex' || cas.Origin =='Email-yeovil.spares' ))
             //END for SR INC000008273229
                {       
                    //Setting common variables
                    System.debug('Inside This to send email');
                    blnSendMail = true;
                    mapEmailTemplateids.put(cas.id,label.Unauthorizedtemplate);
                    mapContactids.put(cas.id,cas.contactid);         
                    List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                }

            //INC000007007934 ends 
            /*       
            INC000010647025 starts
                    else if(('Insert').equals(strDMLMode) &&
                    (cas.RecordtypeId == label.GSS_Quotes_Orders || cas.RecordtypeId == label.GSS_Technical_Support
                    || cas.RecordtypeId == label.Engine_Rentals_RT_ID || cas.RecordtypeId == label.Orders_Rec_ID
                    || cas.RecordtypeId == label.NavDB_Prod_RecordId || cas.RecordtypeId == label.Aero_Export_Holds_RT_ID
                    || cas.RecordtypeId == label.Repair_Overhaul_RT_ID || cas.RecordtypeId == label.OEM_Quotes_Orders_ID
                    || cas.RecordtypeId == label.EMS_Orders_RecordType_ID || cas.RecordtypeId == label.D_S_Quotes_Orders_RT_ID
                    || cas.RecordtypeId == label.Internal_Escalations || cas.RecordtypeId == label.Warranty_RT_ID || cas.RecordtypeId == label.AMDB_Production_Record_Type 
                    || cas.RecordTypeId == Label.FSS_Tech_Issue_RT_ID)) 
                    INC000010647025 ends
                    
                    
                    else if(('Insert').equals(strDMLMode) &&
                    (cas.RecordtypeId == label.GSS_Quotes_Orders || cas.RecordtypeId == label.GSS_Technical_Support
                    || cas.RecordtypeId == label.Engine_Rentals_RT_ID || cas.RecordtypeId == label.ISS_Invoicing_RecID || cas.RecordtypeId == label.Orders_Rec_ID ||  cas.RecordtypeId == label.JXSupportRecType_ID || cas.RecordtypeId == label.AerobizRecType
                    || cas.RecordtypeId == label.NavDB_Prod_RecordId || cas.RecordtypeId == label.NavDB_Accts_Record_Type || cas.RecordtypeId == label.SWTools_Record_Id || cas.RecordtypeId == label.Aero_Export_Holds_RT_ID 
                    || cas.RecordtypeId == label.Repair_Overhaul_RT_ID || cas.RecordtypeId == label.OEM_Quotes_Orders_ID
                    || cas.RecordtypeId == label.EMS_Orders_RecordType_ID || cas.RecordtypeId == label.D_S_Quotes_Orders_RT_ID
                    || cas.RecordtypeId == label.Internal_Escalations || cas.RecordtypeId == label.Warranty_RT_ID || cas.RecordTypeId == Label.FSS_Tech_Issue_RT_ID)) 
                    
                     {                    
                        try 
                        {
                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();            
                            //Setting common variables
                            message.setTargetObjectId(cas.ContactId);
                            message.setWhatId(cas.Id);             
                            message.setBccSender(false);             
                            message.setUseSignature(false);
                            message.setSaveAsActivity(false);
                            //Setting Template and From address based on email box
                            //Added by Dhivya for SR INC000007007934 - //commented for SR INC000008273229
                            //if(cas.Service_Level__c != 'Unauthorized Dist/Brkr'  
                            //{
                            if(cas.Emailbox_Origin__c == 'Email-Aero GSE Orders')
                            {
                            System.debug(' ********* Agent_Contact_Flag__c ' + cas.Agent_Contact_Flag__c);
                                message.setOrgWideEmailAddressId(label.Aerogssorders);   
                                if(cas.Agent_Contact_Flag__c == false)
                                {
                                    message.setTemplateId(label.Order_Response);
                                    blnSendMail = true;
                                    
                                    //mapEmailTemplateids.put(cas.id,label.Order_Status_Inquiry);
                                    mapEmailTemplateids.put(cas.id,label.Order_Response);
                                    mapContactids.put(cas.id,cas.contactid);
                                    List<string> caseDet = new List<string>();
                                    if(cas.CaseNumber != null)
                                        caseDet.add(cas.CaseNumber);
                                    else
                                        caseDet.add(' ');
                                    
                                    if( cas.Subject != null)
                                        caseDet.add(cas.Subject);
                                    else
                                        caseDet.add(' ');
                                        
                                    if(cas.Case_Ref_ID__c != null)
                                        caseDet.add(cas.Case_Ref_ID__c);
                                    else
                                        caseDet.add(' ');
                                    mapCaseDetails.put(cas.id,caseDet);
                                }
                                else
                                {
                                    message.setTemplateId(label.GSS_Response_Template);                            
                                    blnSendMail = true;
                                    
                                    mapEmailTemplateids.put(cas.id,label.GSS_Response_Template);
                                    mapContactids.put(cas.id,cas.contactid);
                                    List<string> caseDet = new List<string>();
                                    if(cas.CaseNumber != null)
                                        caseDet.add(cas.CaseNumber);
                                    else
                                        caseDet.add(' ');
                                    
                                    if( cas.Subject != null)
                                        caseDet.add(cas.Subject);
                                    else
                                        caseDet.add(' ');
                                        
                                    if(cas.Case_Ref_ID__c != null)
                                        caseDet.add(cas.Case_Ref_ID__c);
                                    else
                                        caseDet.add(' ');
                                    mapCaseDetails.put(cas.id,caseDet);
                                }
                            }  
                            else if(cas.Emailbox_Origin__c == 'Email-Aero GSE Quotes')
                            {
                                message.setOrgWideEmailAddressId(label.Aerogssquotes);
                                if (cas.Agent_Contact_Flag__c == false)
                                {
                                    message.setTemplateId(label.Order_Status);
                                    blnSendMail = true;
                                    
                                    mapEmailTemplateids.put(cas.id,label.Order_Status);
                                    mapContactids.put(cas.id,cas.contactid);
                                    List<string> caseDet = new List<string>();
                                    if(cas.CaseNumber != null)
                                        caseDet.add(cas.CaseNumber);
                                    else
                                        caseDet.add(' ');
                                    
                                    if( cas.Subject != null)
                                        caseDet.add(cas.Subject);
                                    else
                                        caseDet.add(' ');
                                        
                                    if(cas.Case_Ref_ID__c != null)
                                        caseDet.add(cas.Case_Ref_ID__c);
                                    else
                                        caseDet.add(' ');
                                    mapCaseDetails.put(cas.id,caseDet);
                                }
                                else
                                {
                                    message.setTemplateId(label.GSS_Response_Template);                            
                                    blnSendMail = true;
                                    
                                    mapEmailTemplateids.put(cas.id,label.GSS_Response_Template);
                                    mapContactids.put(cas.id,cas.contactid);
                                    List<string> caseDet = new List<string>();
                                    if(cas.CaseNumber != null)
                                        caseDet.add(cas.CaseNumber);
                                    else
                                        caseDet.add(' ');
                                    
                                    if( cas.Subject != null)
                                        caseDet.add(cas.Subject);
                                    else
                                        caseDet.add(' ');
                                        
                                    if(cas.Case_Ref_ID__c != null)
                                        caseDet.add(cas.Case_Ref_ID__c);
                                    else
                                        caseDet.add(' ');
                                    mapCaseDetails.put(cas.id,caseDet);
                                }
                            }  
                            else if(cas.Emailbox_Origin__c == 'Email-Aero GSE Support')
                            {
                                message.setOrgWideEmailAddressId(label.Aerogsssupport);                    
                                if(cas.Agent_Contact_Flag__c == false)
                                {
                                    message.setTemplateId(label.Order_Status);                                                                                      
                                    blnSendMail = true;                                    
                                    blnSendMail = true;
                                    mapEmailTemplateids.put(cas.id,label.Order_Status);
                                    mapContactids.put(cas.id,cas.contactid);
                                    List<string> caseDet = new List<string>();
                                    if(cas.CaseNumber != null)
                                        caseDet.add(cas.CaseNumber);
                                    else
                                        caseDet.add(' ');
                                    
                                    if( cas.Subject != null)
                                        caseDet.add(cas.Subject);
                                    else
                                        caseDet.add(' ');
                                        
                                    if(cas.Case_Ref_ID__c != null)
                                        caseDet.add(cas.Case_Ref_ID__c);
                                    else
                                        caseDet.add(' ');
                                    mapCaseDetails.put(cas.id,caseDet);
                                }
                                else
                                {
                                    message.setTemplateId(label.GSS_Response_Template);                            
                                    blnSendMail = true;
                                    
                                    mapEmailTemplateids.put(cas.id,label.GSS_Response_Template);
                                    mapContactids.put(cas.id,cas.contactid);
                                    List<string> caseDet = new List<string>();
                                    if(cas.CaseNumber != null)
                                        caseDet.add(cas.CaseNumber);
                                    else
                                        caseDet.add(' ');
                                    
                                    if( cas.Subject != null)
                                        caseDet.add(cas.Subject);
                                    else
                                        caseDet.add(' ');
                                        
                                    if(cas.Case_Ref_ID__c != null)
                                        caseDet.add(cas.Case_Ref_ID__c);
                                    else
                                        caseDet.add(' ');
                                    mapCaseDetails.put(cas.id,caseDet);
                                }                        
                            }
                            else if(cas.Emailbox_Origin__c == 'Email-Aero GSE Vendor Support')
                            {
                                message.setOrgWideEmailAddressId(label.aerogsevendorsupport);                    
                                if(cas.Agent_Contact_Flag__c == false)
                                {
                                    message.setTemplateId(label.Order_Status); 
                                    blnSendMail = true;
                                    mapEmailTemplateids.put(cas.id,label.Order_Status);
                                    mapContactids.put(cas.id,cas.contactid);
                                    List<string> caseDet = new List<string>();
                                    if(cas.CaseNumber != null)
                                        caseDet.add(cas.CaseNumber);
                                    else
                                        caseDet.add(' ');
                                    
                                    if( cas.Subject != null)
                                        caseDet.add(cas.Subject);
                                    else
                                        caseDet.add(' ');
                                        
                                    if(cas.Case_Ref_ID__c != null)
                                        caseDet.add(cas.Case_Ref_ID__c);
                                    else
                                        caseDet.add(' ');
                                    mapCaseDetails.put(cas.id,caseDet);
                                }
                                else
                                {
                                    message.setTemplateId(label.GSS_Response_Template);                            
                                    blnSendMail = true;
                                    
                                    mapEmailTemplateids.put(cas.id,label.GSS_Response_Template);
                                    mapContactids.put(cas.id,cas.contactid);
                                    List<string> caseDet = new List<string>();
                                    if(cas.CaseNumber != null)
                                        caseDet.add(cas.CaseNumber);
                                    else
                                        caseDet.add(' ');
                                    
                                    if( cas.Subject != null)
                                        caseDet.add(cas.Subject);
                                    else
                                        caseDet.add(' ');
                                        
                                    if(cas.Case_Ref_ID__c != null)
                                        caseDet.add(cas.Case_Ref_ID__c);
                                    else
                                        caseDet.add(' ');
                                    mapCaseDetails.put(cas.id,caseDet);
                                }                                                             
                            }
                            
                            if(cas.Emailbox_Origin__c == 'Email-Order Status' && cas.Service_Level__c != 'Unauthorized Dist/Brkr' 
                            && cas.sbu__c!=null && cas.sbu__c != 'ATR' && cas.sbu__c != 'D&S' && cas.sbu__c != 'BGA' && cas.Region__c != 'Asia/Pacific Rim')
                            {
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);                     
                                message.setTemplateId(label.Order_Status_Inquiry);                                                           
                                blnSendMail = true;
                                mapEmailTemplateids.put(cas.id,label.Order_Status_Inquiry);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                            }
                            else if(cas.Emailbox_Origin__c == 'Email-Order Status' && cas.Service_Level__c != 'Unauthorized Dist/Brkr'  && 
                            (cas.sbu__c == 'D&S' && cas.Service_Level__c != 'Refer to Network') && cas.Region__c != 'Asia/Pacific Rim' && cas.PFECN__c==null)                            
                            {                                             
                                try{ 
                                    message.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                                    message.setTemplateId(label.Order_Status_Inquiry); 
                                    message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);                     
                                    blnSendMail = true; 
                                    mapEmailTemplateids.put(cas.id,label.Order_Status_Inquiry);
                                    mapContactids.put(cas.id,cas.contactid);
                                    List<string> caseDet = new List<string>();
                                    if(cas.CaseNumber != null)
                                        caseDet.add(cas.CaseNumber);
                                    else
                                        caseDet.add(' ');
                                    
                                    if( cas.Subject != null)
                                        caseDet.add(cas.Subject);
                                    else
                                        caseDet.add(' ');
                                        
                                    if(cas.Case_Ref_ID__c != null)
                                        caseDet.add(cas.Case_Ref_ID__c);
                                    else
                                        caseDet.add(' ');
                                    mapCaseDetails.put(cas.id,caseDet);
                                } 
                                catch (Exception exc) {
                                    System.debug('*******************'+exc);
                                }
                            }
                            //Code added for BGA order Status - INC000005580855
                            else if (cas.Emailbox_Origin__c == 'Email-Order Status' && cas.Service_Level__c != 'Unauthorized Dist/Brkr'  
                            && cas.sbu__c == 'BGA' && cas.PFECN__c==null)
                            { 
                                if (cas.Account_Type__c == 'Owner/Operator' || cas.Account_Type__c == 'Fractional Ownership' 
                                || !emailDomain || cas.Region__c=='Asia/Pacific Rim')
                                {
                                    try{
                                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);                    
                                        message.setTemplateId(label.Order_Status_Inquiry); 
                                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);                     
                                        blnSendMail = true;
                                        mapEmailTemplateids.put(cas.id,label.Order_Status_Inquiry);
                                        mapContactids.put(cas.id,cas.contactid);
                                        List<string> caseDet = new List<string>();
                                        if(cas.CaseNumber != null)
                                            caseDet.add(cas.CaseNumber);
                                        else
                                            caseDet.add(' ');
                                        
                                        if( cas.Subject != null)
                                            caseDet.add(cas.Subject);
                                        else
                                            caseDet.add(' ');
                                            
                                        if(cas.Case_Ref_ID__c != null)
                                            caseDet.add(cas.Case_Ref_ID__c);
                                        else
                                            caseDet.add(' ');
                                        mapCaseDetails.put(cas.id,caseDet);
                                    }
                                    catch(Exception exc) {
                                        System.debug('*******************'+exc);
                                    }
                                }
                                else if(cas.Account_Type__c != 'Owner/Operator' && cas.Account_Type__c != 'Fractional Ownership' && emailDomain && cas.Region__c!='Asia/Pacific Rim')
                                {
                                    try{
                                        System.debug ('manish1');
                                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);                    
                                        message.setTemplateId(label.Order_Status_Request); 
                                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);                     
                                        blnSendMail = true;
                                        mapEmailTemplateids.put(cas.id,label.Order_Status_Request);
                                        mapContactids.put(cas.id,cas.contactid);
                                        List<string> caseDet = new List<string>();
                                        if(cas.CaseNumber != null)
                                            caseDet.add(cas.CaseNumber);
                                        else
                                            caseDet.add(' ');
                                        
                                        if( cas.Subject != null)
                                            caseDet.add(cas.Subject);
                                        else
                                            caseDet.add(' ');
                                            
                                        if(cas.Case_Ref_ID__c != null)
                                            caseDet.add(cas.Case_Ref_ID__c);
                                        else
                                            caseDet.add(' ');
                                        mapCaseDetails.put(cas.id,caseDet);
                                    }
                                    catch(Exception exc) {
                                        System.debug('*******************'+exc);
                                    }                           
                                }
                            }   
                           /* Commented the lines for SR INC000006181706
                           else if(!emailDomain1 &&((('Insert').equals(strDMLMode) && (cas.Emailbox_Origin__c=='Email-Order Status') 
                           && (cas.SBU__c == 'ATR') && cas.Primary_Email_Address__c != '' && cas.Region__c != 'Asia/Pacific Rim') || 
                            else if(cas.Emailbox_Origin__c == 'Email-Order Status' && cas.Region__c=='Asia/Pacific Rim' && cas.SBU__c == 'D&S')
                            {
                                try{
                                    // The email template ID used for the email
                                    message = setEmailMessage(cas.contactid,cas.id);
                                    message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                                    message.setTemplateId(label.Order_Status_Inquiry);
                                    blnSendMail = true;
                                    mapEmailTemplateids.put(cas.id,label.Order_Status_Inquiry);
                                    mapContactids.put(cas.id,cas.contactid);
                                    List<string> caseDet = new List<string>();
                                    if(cas.CaseNumber != null)
                                        caseDet.add(cas.CaseNumber);
                                    else
                                        caseDet.add(' ');
                                    
                                    if( cas.Subject != null)
                                        caseDet.add(cas.Subject);
                                    else
                                        caseDet.add(' ');
                                        
                                    if(cas.Case_Ref_ID__c != null)
                                        caseDet.add(cas.Case_Ref_ID__c);
                                    else
                                        caseDet.add(' ');
                                    mapCaseDetails.put(cas.id,caseDet);
                                }
                                catch (Exception exc) {
                                    System.debug('*******************'+exc);
                                }
                            } 
                            else if(cas.Emailbox_Origin__c == 'Email-EngineRentals')
                            {
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);                    
                                //message.setTemplateId(label.ERB_Case_Creation_Template); 
                                message.setTemplateId(label.Engine_Rental_Inquiry);                                                     
                                blnSendMail = true;
                                //mapEmailTemplateids.put(cas.id,label.ERB_Case_Creation_Template);
                                mapEmailTemplateids.put(cas.id,label.Engine_Rental_Inquiry);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                            }
                            // Added code for INC000006991156 
                            if(cas.Origin=='Email-DS OEM & Spares Internal'){
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                                message.setTemplateId(label.Internal_Escalations_Case);
                                bulkEmails.add(message);
                                
                                mapEmailTemplateids.put(cas.id,label.Internal_Escalations_Case);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                            }
                            if(cas.Origin=='Email-DS Repairs Internal'){
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                                message.setTemplateId(label.Internal_Escalations_Case);
                                bulkEmails.add(message);
                                
                                mapEmailTemplateids.put(cas.id,label.Internal_Escalations_Case);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                            }
                            // End code for INC000006991156
                            // Added code for INC000008026261
                            if(cas.Emailbox_Origin__c == 'Email- AerospaceWarranty' && cas.Service_Level__c != 'Unauthorized Dist/Brkr' ){
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                                message.setTemplateId(label.Case_Creation_Template_ID);
                                bulkEmails.add(message);
                                
                                mapEmailTemplateids.put(cas.id,label.Case_Creation_Template_ID);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                            }
                            // Code end for INC000008026261
                            // Added code for SR# 410393
                            else if(cas.RecordtypeId == label.NavDB_Prod_RecordId)
                            {                        
                                String[] ccAddresses = new String[] {'AviationServices@Honeywell.com'};
                                message.setOrgWideEmailAddressId(label.Aviation_Service_OrgID);   
                                message.setCcAddresses(ccAddresses);                 
                                message.setTemplateId(label.NavDB_Prod_TemplateID);
                                blnSendMail = true;
                                mapEmailTemplateids.put(cas.id,label.NavDB_Prod_TemplateID);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                            }
                            // End for SR# 410393

                            // Added Code for SR#436603 -- Hari
                            else if(cas.RecordtypeId == label.Aero_Export_Holds_RT_ID)
                            {                        
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);   
                                //message.setTemplateId(label.Aero_Export_Holds_Template);
                                message.setTemplateId(label.Export_Hold_Inquiry);
                                blnSendMail = true;
                                
                                //mapEmailTemplateids.put(cas.id,label.Aero_Export_Holds_Template);
                                mapEmailTemplateids.put(cas.id,label.Export_Hold_Inquiry);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                            }
                            // End for SR#436603 -- Hari
                            // Added code for INC000006329969 
                            if(cas.Origin=='Web' && (cas.CreatedById==label.API_User_My_Aerospace_Portal || cas.CreatedById==label.myaerospace_webform) && (cas.Subject!=Null && cas.Subject.contains('Webform'))){
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                                //message.setTemplateId(label.Contact_US_Temp_Id);
                                message.setTemplateId(label.Portal_Inquiry_Confirmation);
                                blnSendMail = true;
                                //mapEmailTemplateids.put(cas.id,label.Contact_US_Temp_Id);
                                message.setTemplateId(label.Portal_Inquiry_Confirmation);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                            }
                            // End code for INC000006329969 
                            
                            // Added code for INC000006074166 
                            else if(cas.RecordtypeId == label.OEM_Quotes_Orders_ID && cas.Emailbox_Origin__c == 'Email-AeroComponents')
                            {                        
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);   
                                //message.setTemplateId(label.Case_Creation_OEM_template_ID);
                                message.setTemplateId(label.Inquiry_Confirmation);
                                blnSendMail = true;
                                
                                //mapEmailTemplateids.put(cas.id,label.Case_Creation_OEM_template_ID);
                                mapEmailTemplateids.put(cas.id,label.Inquiry_Confirmation);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                            }

                            // Code End for INC000006074166 
                            //Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
                            //Added Code for INC000011112327
                            
                            if((cas.Emailbox_Origin__c == 'Email-Orders' || cas.Emailbox_Origin__c == 'Email-Order Status')&& cas.Service_Level__c != 'Unauthorized Dist/Brkr' && (cas.sbu__c == 'ATR' || cas.sbu__c == 'BGA' || cas.sbu__c == 'D&S') && !(lstcas.get(cas.id).account.Orders_Next_Wave__c) && cas.PFECN__c==null )
                            {
                                system.debug('inside Email-Orders by sof');
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                                message.setTemplateId(label.ATRNextWaveCustomerPortal);
                                blnSendMail = true;
                                 mapEmailTemplateids.put(cas.id,label.ATRNextWaveCustomerPortal);
                               // mapEmailTemplateids.put(cas.id,label.Order_Confirmation);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet); 
                            
                            }
                            //Added for INC000011185655  
                        if(cas.Emailbox_Origin__c!=null && (cas.Emailbox_Origin__c == 'Email-Edinburgh' || cas.Emailbox_Origin__c == 'Email-Garden Grove'|| cas.Emailbox_Origin__c=='Email-Raunheim' ))
                            {
                                system.debug('inside Email-Edinburg by sof');
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                                if(cas.Emailbox_Origin__c == 'Email-Edinburgh')
                                {                                
                                message.setTemplateId(label.Order_Confirmation_Template_Edinburgh);
                                blnSendMail = true;
                                 mapEmailTemplateids.put(cas.id,label.Order_Confirmation_Template_Edinburgh);
                                 }
                                 else if(cas.Emailbox_Origin__c=='Email-Raunheim')
                                 {
                                 message.setTemplateId(label.Order_Confirmation_For_Raunheim);
                                blnSendMail = true;
                                 mapEmailTemplateids.put(cas.id,label.Order_Confirmation_For_Raunheim);
                                 }
                                 else if(cas.Emailbox_Origin__c=='Email-Garden Grove')
                                 {
                                 message.setTemplateId(label.Order_Confirmation_For_GardenGrove);
                                blnSendMail = true;
                                 mapEmailTemplateids.put(cas.id,label.Order_Confirmation_For_GardenGrove);
                                 }
                               // mapEmailTemplateids.put(cas.id,label.Order_Confirmation);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet); 
                            
                            }
                               //Added for INC000011185655  
                            //End for INC000011112327
                            
                            
                            //Added Code for INC000005764900 -- Venu
                                                        
                            if(cas.Emailbox_Origin__c == 'Email-Orders' && cas.Service_Level__c != 'Unauthorized Dist/Brkr' && cas.sbu__c == 'ATR' && (cas.Do_Not_Send_to_Portal__c) && !(lstcas.get(cas.id).account.Orders_Next_Wave__c) && cas.PFECN__c==null)
                            {
                                system.debug('inside Email-Orders');
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                                message.setTemplateId(label.Order_Confirmation);
                                blnSendMail = true;
                                
                                 mapEmailTemplateids.put(cas.id,label.Order_Confirmation);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet); 
                            }

                            if((cas.Emailbox_Origin__c == 'Email-Orders' )&& cas.Service_Level__c != 'Unauthorized Dist/Brkr' && cas.sbu__c == 'ATR' 
                            && (!cas.Do_Not_Send_to_Portal__c) 
                            && (!lstcas.get(cas.id).account.Orders_Next_Wave__c) && cas.PFECN__c==null)
                            {
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                                message.setTemplateId(label.ATR_Redirect_to_Portal_Orders);
                                blnSendMail = true;
                                
                               // mapEmailTemplateids.put(cas.id,label.ATR_Redirect_to_Portal_Orders);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                            }
                             
                            if(cas.Emailbox_Origin__c == 'Email-Order Status' && cas.Service_Level__c != 'Unauthorized Dist/Brkr' && 
                            cas.sbu__c == 'ATR' && cas.Do_Not_Send_to_Portal__c && cas.PFECN__c==null)
                            {
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                                message.setTemplateId(label.Order_Status_Inquiry);
                                blnSendMail = true;
                                
                                //mapEmailTemplateids.put(cas.id,label.Order_Status_Inquiry);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                            }
                            
                            if(cas.Emailbox_Origin__c == 'Email-Order Status' && cas.Service_Level__c != 'Unauthorized Dist/Brkr' &&
                            cas.sbu__c == 'ATR'
                            &&  (!cas.Do_Not_Send_to_Portal__c)&& cas.PFECN__c==null)
                            {
                                System.debug('manish2');
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                                message.setTemplateId(label.Order_Status_Request);
                                blnSendMail = true;
                                
                                 //mapEmailTemplateids.put(cas.id,label.Order_Status_Request);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                            }
                            
                            
                            // End for INC000005764900 -- Venu
                            // Addition for INC000006844172 begins
                            if(cas.Emailbox_Origin__c == 'Email-BFESupport')
                            {
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                                message.setTemplateId(label.BFE_Case_Notification);
                                blnSendMail = true; //Sends Case Creation Notification Email
                                
                                //Adds the Case Creation Notification Email to the Related list of the Case
                                mapEmailTemplateids.put(cas.id,label.BFE_Case_Notification);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                            }
                            // Addition for INC000006844172 ends
                            // Changes Start for APAC Transition -- INC000005725524
                                System.debug('Sending email to DSA customer1');
                            if(((cas.Emailbox_Origin__c == 'Email-AeroRepairs'|| cas.Emailbox_Origin__c == 'Email-AeroBizSupport' || cas.Emailbox_Origin__c =='Email-ISSInvoicing' || cas.Emailbox_Origin__c == 'Email-SWT' ||cas.Emailbox_Origin__c == 'Email-NavDB'|| cas.Emailbox_Origin__c == 'Email-Bournemouth Repairs' || cas.Emailbox_Origin__c == 'Email-Yeovil Repairs' || cas.Emailbox_Origin__c == 'Email-AeroIDO') && (Null!=cas.SuppliedEmail && (!(cas.SuppliedEmail.contains('@usairways.com'))) && (!(cas.SuppliedEmail.contains('@aa.com'))) ))
                            || (null!=cas.Emailbox_Origin__c && cas.Emailbox_Origin__c == 'Email-olatheservicecenter')){
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                                //incident INC000008343112/INC000008392050 start
                                message.setTemplateId(label.Case_Creation_Template_ID3); 
                                mapEmailTemplateids.put(cas.id,label.Case_Creation_Template_ID3);                                                                              
                                //incident INC000008343112/INC000008392050 End                    
                                blnSendMail = true;
                                //mapEmailTemplateids.put(cas.id,label.Case_Creation_Template_ID3);
                            
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                            }
                            // Changes end for APAC Transition -- INC000005725524
                            //code starts for JXSupport
                            if(null!=cas.Emailbox_Origin__c && cas.Emailbox_Origin__c == 'Email-JXSupport' )
                            {
                                System.debug('Inside JXSupport3'); 
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                                message.setTemplateId(label.JX_Customer_Support_ID1); 
                                mapEmailTemplateids.put(cas.id,label.JX_Customer_Support_ID1);                                                                              
                                blnSendMail = true;
                            
                            }                               
                            //code ends for JXSupport   
                            // Changes made for INC000006490217 starts
                            if(cas.Emailbox_Origin__c == 'Email-EMS-Norcross'){
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                                message.setTemplateId(label.Case_Creation_Template_ID_1);
                                blnSendMail = true;
                                mapEmailTemplateids.put(cas.id,label.Case_Creation_Template_ID_1);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                            }               
                            // Changes made for INC000006490217 ends
                            
                            
                            if(cas.Emailbox_Origin__c == 'Email-AMDB Production'){
                            
                                list<String> toadd  = (label.AMDB_Case_Creation_Notification).split(',');                                                   
                                List<Messaging.SingleEmailMessage> AMDBbulkEmails = new List<Messaging.SingleEmailMessage>();
                                Messaging.SingleEmailMessage message1 = new Messaging.SingleEmailMessage();              
                                message1.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                                message1.setSaveAsActivity(false);
                                if(cas.contactid != null){
                                    message1.setTargetObjectId(cas.ContactId);
                                }
                                message1.setTemplateId(label.AMDB_Case_Creation_Template);
                                message1.setWhatId(cas.Id); 
                                AMDBbulkEmails.add(message1);
                                Savepoint sp = Database.setSavepoint();
                                Messaging.sendEmail(AMDBbulkEmails);
                                Database.rollback(sp); 
                                for(Messaging.SingleEmailMessage email : AMDBbulkEmails){
                                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                                    emailToSend.setCcAddresses(toadd);
                                    emailToSend.setPlainTextBody(email.getPlainTextBody());
                                    emailToSend.setHTMLBody(email.getHTMLBody());
                                    emailToSend.setSubject(email.getSubject());
                                    emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                                    emailToSend.setTargetObjectId(cas.ContactId);
                                    emailToSend.setWhatId(cas.Id);
                                    bulkEmails.add(emailToSend);
                                }
                            }
                            
                            if(blnSendMail == true){
                                bulkEmails.add(message);
                            }

                       // }
                        }
                        catch (Exception e) 
                        {
                            System.debug('Exception occured while sending mail');
                        }
                    } 
                    
                    /*
                    // Deb Code Begins (DSPC Send mail to MDT for Account Request)
                    if(('Insert').equals(strDMLMode) && cas.RecordtypeId == label.DSPC_CMDT_RecordTypeId) {
                        list<user> u = new list<User>();
                        if (cas.contactid != null) {
                            u = [select id,name from user where contactid =:cas.contactid limit 1];
                            Group MDT = [select (select userOrGroupId from groupMembers) from group where DeveloperName='CustomerMasterData'];
                            for(GroupMember gm: MDT.GroupMembers)
                            listToAddresses.add(gm.userOrGroupid);
                            if(listToAddresses.size() > 0) {
                                for(Id uid : listToAddresses){
                                    string LHead = '<img src="'+Label.DSPC_ServerName+'/servlet/servlet.ImageServer?id=015c0000000AUL6&oid=00Dc0000003s6iA&lastMod=1389005713000"/>';
                                    string body1 = '<font size="2" style="font-family:arial"><br/>Dear MDT User,<br/><br/> A New Account Request has been created by ' + 
                                    u[0].name + '. Please find the following case number and do the needful.<br/>';
                                    string body2 = '<font size="2" style="font-weight:bold">Case Number: ' + cas.Casenumber;
                                    string body3 = '<br/> <br/>Thank You!';
                                    string body = LHead+body1+body2+body3;
                                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();            
                                    message.setTargetObjectId(uid);
                                    message.setSubject('New Account Request Created');
                                    message.setHtmlBody(body);
                                    message.setBccSender(false);             
                                    message.setUseSignature(false);
                                    message.setSaveAsActivity(false);
                                    message.setOrgWideEmailAddressId(label.Aviation_Service_OrgID);  
                                    // String[] ccAddresses = new String[] {Label.DSPC_MDT_Mail_ID}; 
                                    // message.setCcAddresses(ccAddresses);
                                    DSPCbulkmail.add(message);
                                    // Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});   
                                }
                            } 
                        } 
                    }
                    
                     */
                    // Deb Code Ends (DSPC Send mail to MDT for Account Request)
                    ////////////////////////////////////////
                    
                    /*************** Code added by dhivya for SR INC000008696104  starts 
                system.debug('outsideeee dhivya code case sbu'+cas.SBU__c);
                if(('Insert').equals(strDMLMode) && (cas.Origin!=null && cas.Origin.contains('Email')) && cas.Service_Level__c=='Refer to Network' && cas.sbu__c=='D&S'
                && cas.Origin =='Email-Order Changes' )
                {      
                    system.debug('insideee dhivya code');
                    //Setting common variables
                    //blnSendMail = true;
                    mapEmailTemplateids.put(cas.id,label.D_S_Refer_to_Network);
                    mapContactids.put(cas.id,cas.contactid);         
                    List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                }

            /*************** Code added by dhivya for SR INC000008696104 ends 
            
            
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    

                    //////////////////////////////////////
                    //Code added for SR #375781 starts 
                    /*system.debug('venkat test'+!((cas.Emailbox_Origin__c=='Email-Orders' && cas.SBU__c =='ATR' && (null!=lstcas.get(cas.id) && null!=lstcas.get(cas.id).account && null!= lstcas.get(cas.id).account.Orders_Next_Wave__c && lstcas.get(cas.id).account.Orders_Next_Wave__c==true) && (cas.Do_Not_Send_to_Portal__c))));         
                    system.debug('survey sent old value---->'+oldMap.get(cas.id).Survey_Sent__c);
                    system.debug('survey sent new value---->'+cas.Survey_Sent__c);
                    system.debug('survey type---->'+cas.Survey_Type__c );
                    if(('Update').equals(strDMLMode) 
                      && cas.Survey_Sent__c == 1 
                      && oldMap.get(cas.id).Survey_Sent__c != 1
                      && cas.Survey_Type__c == 'Web_Support'
                      && !((cas.Emailbox_Origin__c=='Email-Orders' && cas.SBU__c =='ATR'   
                      //&& (cas.PreventCloseonupdate__c <7 ) 
                      && (null!=lstcas.get(cas.id) && null!=lstcas.get(cas.id).account && null!= lstcas.get(cas.id).account.Orders_Next_Wave__c && lstcas.get(cas.id).account.Orders_Next_Wave__c==true)      
                      && (cas.Do_Not_Send_to_Portal__c)))
                    )
                    
                    {
                        system.debug('inside web support to send survey email');
                        try 
                        {
                            message = setEmailMessage(cas.contactid,cas.id);
                            message.setTemplateId(strSurveyTemplate);                     
                            message.setOrgWideEmailAddressId(label.Myaerospace_Org_Id);
                            bulkEmails.add(message);
                        }
                        catch (Exception e) 
                        {
                            System.debug('Exception while sending mail for ebiz web survey '+e);
                        }
                    }
                    // Coded added for INC000008656265
                    if(('Update').equals(strDMLMode) && cas.RecordTypeId == Label.WIS_RecordType_Id && cas.Ownerid!= oldMap.get(cas.id).Ownerid && cas.Ownerid == Label.Airbus_Queue_Id){
                        system.debug('WIS Cases email sending');
                        message = setEmailMessage(cas.contactid,cas.id);
                        message.setTemplateId(label.WIS_Email_Temp_Id);                     
                        message.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);
                        bulkEmails.add(message);
                        mapEmailTemplateids.put(cas.id,label.WIS_Email_Temp_Id);
                        mapContactids.put(cas.id,cas.contactid);
                        List<string> caseDet = new List<string>();
                        if(cas.CaseNumber != null)
                            caseDet.add(cas.CaseNumber);
                        else
                            caseDet.add(' ');
                        
                        if( cas.Subject != null)
                            caseDet.add(cas.Subject);
                        else
                            caseDet.add(' ');
                            
                        if(cas.Case_Ref_ID__c != null)
                            caseDet.add(cas.Case_Ref_ID__c);
                        else
                            caseDet.add(' ');
                        mapCaseDetails.put(cas.id,caseDet); 
                    }
                    // End for INC000008656265
                    boolean validEmail = (cas.Primary_Email_Address__c !=null) && (cas.Primary_Email_Address__c.contains('@honeywell.com') || cas.Primary_Email_Address__c.contains('@HONEYWELL.COM')) ? false : true;
                    //Commented the below Line to exclude the BGA condition  - INC000005580855 
                    //if(('Update').equals(strDMLMode) &&(cas.Emailbox_Origin__c=='Email-Quotes') && cas.Account_Concierge__c == 'True' && (cas.SBU__c == 'BGA' || cas.SBU__c == 'D&S' || cas.SBU__c == 'ATR') && cas.Origin!= oldMap.get(cas.id).Origin && cas.Region__c != 'Asia/Pacific Rim')
                    system.debug('outside check');
                    if(('Update').equals(strDMLMode) &&(cas.Emailbox_Origin__c=='Email-Quotes') && cas.SBU__c == 'D&S' && (cas.Service_Level__c != 'Refer to Network')  && cas.Origin!= oldMap.get(cas.id).Origin && cas.PFECN__c==null)
                    //&& (cas.Region__c == 'Asia/Pacific Rim' || (cas.Account_Concierge__c == 'True' && cas.Region__c != 'Asia/Pacific Rim')))
                    {
                        system.debug('outside check');
                        if(cas.Origin=='Email')
                        {
                            system.debug('inside check');
                            try{
                                // The email template ID used for the email
                                message = setEmailMessage(cas.contactid,cas.id);
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                                message.setTemplateId(label.All_Concierge_and_D_S_Owner_Operator_Quotes_Notification_Template_Id); // Modified Template Id for INC000008372626 
                                bulkEmails.add(message);   

                                mapEmailTemplateids.put(cas.id,label.All_Concierge_and_D_S_Owner_Operator_Quotes_Notification_Template_Id); // Modified Template Id for INC000008372626 
                                        mapContactids.put(cas.id,cas.contactid);
                                        List<string> caseDet = new List<string>();
                                        if(cas.CaseNumber != null)
                                            caseDet.add(cas.CaseNumber);
                                        else
                                            caseDet.add(' ');
                                        
                                        if( cas.Subject != null)
                                            caseDet.add(cas.Subject);
                                        else
                                            caseDet.add(' ');
                                            
                                        if(cas.Case_Ref_ID__c != null)
                                            caseDet.add(cas.Case_Ref_ID__c);
                                        else
                                            caseDet.add(' ');
                                        mapCaseDetails.put(cas.id,caseDet);     
                                        
                            }
                            catch (Exception ep) {
                                System.debug('RRRRRRRRRRRRR'+ep);
                            }
                        }
                    }
                    //commented the below lines for INC000005580855 
                    /*else if(('Update').equals(strDMLMode) &&(cas.Emailbox_Origin__c=='Email-Quotes') && cas.SBU__c == 'BGA' && cas.Account_Type__c == 'Owner/Operator' && cas.Origin!= oldMap.get(cas.id).Origin && cas.Region__c != 'Asia/Pacific Rim')
                    {
                        if(cas.Origin=='Email')
                        {
                            try{
                                // The email template ID used for the email
                                message = setEmailMessage(cas.contactid,cas.id);
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                                message.setTemplateId(label.All_Concierge_and_BGA_Owner_Operator_Quotes_Notification);
                                bulkEmails.add(message);
                            }
                            catch (Exception ep) {
                                System.debug('RRRRRRRRRRRRR'+ep);
                            }
                        }
                    }
                    //SR 446063
                    //Code added for BGA Qoutes for SR INC000005580855
                    else if(('Insert').equals(strDMLMode) && cas.Emailbox_Origin__c=='Email-Quotes' && cas.sbu__c == 'BGA' && cas.PFECN__c==null)
                     { 
                        //Added by Dhivya for SR INC000007007934 
                        if(cas.Service_Level__c != 'Unauthorized Dist/Brkr')
                        {
                          if ((cas.Account_Type__c == 'Owner/Operator' || cas.Account_Type__c == 'Fractional Ownership' 
                          || !emailDomain || cas.Region__c =='Asia/Pacific Rim') && validEmail && (Null!=cas.SuppliedEmail && !(cas.SuppliedEmail.contains('@linmarr.com'))))
                             {
                                try{
                                    message = setEmailMessage(cas.contactid,cas.id);
                                    message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                                    //message.setTemplateId(label.ATRNextWaveCustomerPortal);//Changes added for INC000011112327  
                                    System.debug('Quote Request Confirmation');                  
                                    message.setTemplateId(label.Quote_Request_Confirmation); 
                                    bulkEmails.add(message);
                                    //Start INC000005569277
                                    
                                    mapEmailTemplateids.put(cas.id,label.ATRNextWaveCustomerPortal);
                                    //mapEmailTemplateids.put(cas.id,label.Quote_Request_Confirmation);
                                    mapContactids.put(cas.id,cas.contactid);
                                    List<string> caseDet = new List<string>();
                                    if(cas.CaseNumber != null)
                                        caseDet.add(cas.CaseNumber);
                                    else
                                        caseDet.add(' ');
                                    
                                    if( cas.Subject != null)
                                        caseDet.add(cas.Subject);
                                    else
                                        caseDet.add(' ');
                                        
                                    if(cas.Case_Ref_ID__c != null)
                                        caseDet.add(cas.Case_Ref_ID__c);
                                    else
                                        caseDet.add(' ');
                                    mapCaseDetails.put(cas.id,caseDet);
                                    
                                    
                                   }
                                catch(Exception exc) {
                                    System.debug('*******************'+exc);
                                }
                             }
                           else if((Null!=cas.SuppliedEmail && cas.SuppliedEmail.contains('@linmarr.com'))|| (cas.Account_Type__c != 'Owner/Operator' && cas.Account_Type__c != 'Fractional Ownership' 
                           && emailDomain && cas.Region__c!='Asia/Pacific Rim' && validEmail))
                             {
                                system.debug('Quotes----------->');
                                try{
                                    message = setEmailMessage(cas.contactid,cas.id); 
                                    //message.setTemplateId(label.ATRNextWaveCustomerPortal);//Changes added for INC000011112327                   
                                    message.setTemplateId(label.Quote_Request); 
                                    message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);                     
                                    bulkEmails.add(message);
                                    //Start INC000005569277
                                        mapEmailTemplateids.put(cas.id,label.ATRNextWaveCustomerPortal);
                                        //mapEmailTemplateids.put(cas.id,label.Quote_Request);
                                        mapContactids.put(cas.id,cas.contactid);
                                        List<string> caseDet = new List<string>();
                                        if(cas.CaseNumber != null)
                                            caseDet.add(cas.CaseNumber);
                                        else
                                            caseDet.add(' ');
                                        
                                        if( cas.Subject != null)
                                            caseDet.add(cas.Subject);
                                        else
                                            caseDet.add(' ');
                                            
                                        if(cas.Case_Ref_ID__c != null)
                                            caseDet.add(cas.Case_Ref_ID__c);
                                        else
                                            caseDet.add(' ');
                                        mapCaseDetails.put(cas.id,caseDet);
                                        
                                        //End INC000005569277
                                    
                                   }
                                catch(Exception exc) {
                                    System.debug('*******************'+exc);
                                }                           
                             }

                     }    

                    }
                    
                    else if(('Insert').equals(strDMLMode) && cas.Emailbox_Origin__c=='Email-Quotes' && cas.sbu__c == 'BGA' && cas.PFECN__c==null )
                    {
                    System.debug('ATR Next Wave BGA');
                      try{
                                    message = setEmailMessage(cas.contactid,cas.id);
                                    message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                                    message.setTemplateId(label.ATRNextWaveCustomerPortal);//Changes added for INC000011112327                    
                                    //message.setTemplateId(label.Quote_Request_Confirmation); 
                                    bulkEmails.add(message);
                                    //Start INC000005569277
                                    
                                    mapEmailTemplateids.put(cas.id,label.ATRNextWaveCustomerPortal);
                                    //mapEmailTemplateids.put(cas.id,label.Quote_Request_Confirmation);
                                    mapContactids.put(cas.id,cas.contactid);
                                    List<string> caseDet = new List<string>();
                                    if(cas.CaseNumber != null)
                                        caseDet.add(cas.CaseNumber);
                                    else
                                        caseDet.add(' ');
                                    
                                    if( cas.Subject != null)
                                        caseDet.add(cas.Subject);
                                    else
                                        caseDet.add(' ');
                                        
                                    if(cas.Case_Ref_ID__c != null)
                                        caseDet.add(cas.Case_Ref_ID__c);
                                    else
                                        caseDet.add(' ');
                                    mapCaseDetails.put(cas.id,caseDet);
                                    
                                    
                                   }
                                catch(Exception exc) {
                                    System.debug('*******************'+exc);
                                }
                    
                    
                    }
                    /*else if(('Update').equals(strDMLMode) &&(cas.Emailbox_Origin__c=='Email-Quotes') && cas.Origin!= oldMap.get(cas.id).Origin && cas.Region__c!='Asia/Pacific Rim' && validEmail && cas.SBU__c != 'ATR' && cas.SBU__c != 'BGA' )
                    {
                        if(cas.Origin=='Email')
                        {
                            try{
                                message = setEmailMessage(cas.contactid,cas.id);
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                                message.setTemplateId(label.All_Customers_Email_Quote_Customer_Notification);
                                bulkEmails.add(message);
                                //INC000006188796 

                                mapEmailTemplateids.put(cas.id,label.All_Customers_Email_Quote_Customer_Notification);
                                        mapContactids.put(cas.id,cas.contactid);
                                        List<string> caseDet = new List<string>();
                                        if(cas.CaseNumber != null)
                                            caseDet.add(cas.CaseNumber);
                                        else
                                            caseDet.add(' ');
                                        
                                        if( cas.Subject != null)
                                            caseDet.add(cas.Subject);
                                        else
                                            caseDet.add(' ');
                                            
                                        if(cas.Case_Ref_ID__c != null)
                                            caseDet.add(cas.Case_Ref_ID__c);
                                        else
                                            caseDet.add(' ');
                                        mapCaseDetails.put(cas.id,caseDet);
                            }
                            catch (Exception ep) {
                                System.debug('RRRRRRRRRRRRR'+ep);
                            }
                        }
                    }*/
                    
                    //446063 ends
                    //Commented the lines for SR INC000005580855
                    /*else if(('Update').equals(strDMLMode) &&(cas.Emailbox_Origin__c=='Email-Quotes') && cas.Origin!= oldMap.get(cas.id).Origin && cas.Region__c!='Asia/Pacific Rim')
                    {                        
                        if(cas.Origin=='Email')
                        {                            
                            try{
                                message = setEmailMessage(cas.contactid,cas.id);
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                                message.setTemplateId(label.All_Customers_Email_Quote_Customer_Notification);
                                bulkEmails.add(message);
                            }
                            catch (Exception ep) {
                                System.debug('RRRRRRRRRRRRR'+ep);
                            }
                        }
                    } 
                    // Code added for INC000008372626 to remove Email-Quotes from rule "Case Creation Acknowledgement Template 1"
                    system.debug('----SBU Out-----'+cas.SBU__c);
                    if(('Insert').equals(strDMLMode) && null!=cas.SBU__c && null!=cas.Primary_Email_Address__c &&
                    cas.Emailbox_Origin__c == 'Email-Quotes' && cas.Agent_Contact_Flag__c!=True 
                    && !(cas.Primary_Email_Address__c.contains('boeing.com') || cas.Primary_Email_Address__c.contains('@lmco.com')) 
                    && (null!=cas.Subject && !(cas.Subject.contains('Fax:{'))) && !(cas.Primary_Email_Address__c.contains('@usairways.com') 
                    || cas.Primary_Email_Address__c.contains('@aa.com')) && (cas.OwnerId!=Label.General_Compliance_Queue_Id 
                    || cas.OwnerId!=Label.Compliance_Queue_CSO_ID || cas.OwnerId!=Label.Compliance_Queue_GTO_ID) 
                    && cas.LastModifiedById!=Label.SFDC_Admin && (cas.SBU__c!='D&S' && cas.SBU__c!='BGA')){
                        system.debug('----SBU-----'+cas.SBU__c);
                        System.debug('Quotes Notification mail---->');
                        try{
                            message = setEmailMessage(cas.contactid,cas.id);
                            message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                            message.setTemplateId(label.All_Concierge_and_BGA_Owner_Operator_Quotes_Notification);
                            bulkEmails.add(message);
                         
                            mapEmailTemplateids.put(cas.id,label.All_Concierge_and_BGA_Owner_Operator_Quotes_Notification);
                            mapContactids.put(cas.id,cas.contactid);
                            List<string> caseDet = new List<string>();
                            if(cas.CaseNumber != null)
                                caseDet.add(cas.CaseNumber);
                            else
                                caseDet.add(' ');
                            
                            if( cas.Subject != null)
                                caseDet.add(cas.Subject);
                            else
                                caseDet.add(' ');
                                
                            if(cas.Case_Ref_ID__c != null)
                                caseDet.add(cas.Case_Ref_ID__c);
                            else
                                caseDet.add(' ');
                            mapCaseDetails.put(cas.id,caseDet);
                        }catch (Exception quotexc) {
                            System.debug('Quotes Notification Failed---->'+quotexc);
                        }
                    }
                    if(('Insert').equals(strDMLMode) && null!=cas.Primary_Email_Address__c && cas.Emailbox_Origin__c == 'Email-Order Changes' 
                    && (null!=cas.SBU__c && (cas.SBU__c=='D&S' && cas.Service_Level__c != 'Refer to Network') ) && cas.Service_Level__c!='Unauthorized Dist/Brkr' ){
                        System.debug('Order Changes Notification mail---->');
                        try{
                            message = setEmailMessage(cas.contactid,cas.id);
                            message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                            message.setTemplateId(label.Case_Creation_Acknowledgement_D_S_Order_Changes_Temp_Id);
                            bulkEmails.add(message);
                         
                            mapEmailTemplateids.put(cas.id,label.Case_Creation_Acknowledgement_D_S_Order_Changes_Temp_Id);
                            mapContactids.put(cas.id,cas.contactid);
                            List<string> caseDet = new List<string>();
                            if(cas.CaseNumber != null)
                                caseDet.add(cas.CaseNumber);
                            else
                                caseDet.add(' ');
                            
                            if( cas.Subject != null)
                                caseDet.add(cas.Subject);
                            else
                                caseDet.add(' ');
                                
                            if(cas.Case_Ref_ID__c != null)
                                caseDet.add(cas.Case_Ref_ID__c);
                            else
                                caseDet.add(' ');
                            mapCaseDetails.put(cas.id,caseDet);
                        }catch (Exception quotexc) {
                            System.debug('order changes Notification Failed---->'+quotexc);
                        }
                    }
                    // Code ends for INC000008372626 to remove Email-Quotes from rule "Case Creation Acknowledgement Template 1"
                    
                    // Added code for SR INC000006226761- Srarts
                    //Added by Dhivya for SR INC000007007934
                if(cas.Service_Level__c != 'Unauthorized Dist/Brkr')
                {
                    if(('Insert').equals(strDMLMode) && cas.Emailbox_Origin__c == 'Email-Quotes'&& cas.sbu__c == 'ATR' && cas.PFECN__c==null)
                   // && (!cas.Quotes_Do_Not_Send_to_Portal__c) && validEmail // commented for -INC000009261558
                    {
                       try{
                            message = setEmailMessage(cas.contactid,cas.id);
                            message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                            message.setTemplateId(label.ATRNextWaveCustomerPortal);//Changes added for INC000011112327
                           // message.setTemplateId(label.Quote_Request);
                            bulkEmails.add(message);
                         
                            mapEmailTemplateids.put(cas.id,label.ATRNextWaveCustomerPortal);
                            mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                                
                        }
                        catch (Exception exc) {
                            System.debug('*******************'+exc);
                        }
                    }
                    
                    if(('Insert').equals(strDMLMode) && cas.Emailbox_Origin__c == 'Email-Quotes'&& cas.sbu__c == 'ATR' && cas.Quotes_Do_Not_Send_to_Portal__c && validEmail && cas.PFECN__c==null)
                    {
                       try{
                            message = setEmailMessage(cas.contactid,cas.id);
                            message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                            message.setTemplateId(label.Quote_Request_Confirmation);
                            bulkEmails.add(message);
                         
                            mapEmailTemplateids.put(cas.id,label.Quote_Request_Confirmation);
                            mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                                
                        }
                        catch (Exception exc) {
                            System.debug('*******************'+exc);
                        }
                    }
                    // Added code for SR INC000006226761- Ends
                   /*
                   // Code added for INC000006397344 -Starts
                       if(('Insert').equals(strDMLMode) && cas.Emailbox_Origin__c == 'Email-Quotes'&& cas.sbu__c == 'ATR' && validEmail)
                    {
                     date atrcheckdate = cas.ATR_Next_Wave_Check_Time__c.date();
                      ATRNextWaveCheckdays = atrcheckdate.daysBetween(system.Now().date());                       
                      //integer days = now()-ATRNextWaveCheckdays;                      
                       try{
                            message = setEmailMessage(cas.contactid,cas.id);
                            message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                           if(ATRNextWaveCheckdays!=null && ATRNextWaveCheckdays<8){
                           message.setTemplateId(label.ATR_Quotes_First_Notification1);
                           mapEmailTemplateids.put(cas.id,label.ATR_Quotes_First_Notification1);
                           }
                           if(ATRNextWaveCheckdays!=null && ATRNextWaveCheckdays>7 && ATRNextWaveCheckdays<15)
                           {
                           message.setTemplateId(label.ATR_Quotes_Second_Notification);
                            mapEmailTemplateids.put(cas.id,label.ATR_Quotes_Second_Notification);
                           }
                           if(ATRNextWaveCheckdays!=null && ATRNextWaveCheckdays>14)
                           {
                           message.setTemplateId(label.ATR_Quotes_First_Notification);
                           mapEmailTemplateids.put(cas.id,label.ATR_Quotes_First_Notification);
                           }
                            bulkEmails.add(message);
                  
                           mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                                
                        }
                        catch (Exception exc) {
                            System.debug('*******************'+exc);
                        }
                    }*/

                    
                    // Code added for INC000006397344 - Ends
                    
                    //Code added for SR INC000008086115 -Starts
/*if(('Insert').equals(strDMLMode) && cas.Emailbox_Origin__c=='Email-Orders'                       
                      && cas.SBU__c =='ATR'                       
                      && (null!=lstcas.get(cas.id) && null!=lstcas.get(cas.id).account && null!= lstcas.get(cas.id).account.Orders_Next_Wave__c && lstcas.get(cas.id).account.Orders_Next_Wave__c==true && lstcas.get(cas.id).account.Service_Level__c!='Unauthorized Dist/Brkr' )
                      //&& (TriggerInactive.sendmailnotif)
                      && (lstcas.get(cas.id).account.Do_Not_Send_to_Portal__c==true))                                    
                       {
                       date orderscheckdate = lstcas.get(cas.id).account.Orders_Next_Wave_Check_Time__c.date();
                      integer  OrdersNextWaveCheckdays = orderscheckdate.daysBetween(system.Now().date());
                       
                      //integer days = now()-ATRNextWaveCheckdays;
                            try{
                            message = setEmailMessage(cas.contactid,cas.id);
                            message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                           if(OrdersNextWaveCheckdays!=null && OrdersNextWaveCheckdays<8){
                           message.setTemplateId(label.ATR_Orders_First_Notification1);
                            mapEmailTemplateids.put(cas.id,label.ATR_Orders_First_Notification1);
                           }
                           if(OrdersNextWaveCheckdays!=null && OrdersNextWaveCheckdays>7 && OrdersNextWaveCheckdays<15){
                           message.setTemplateId(label.ATR_Orders_Second_Notification);
                           mapEmailTemplateids.put(cas.id,label.ATR_Orders_Second_Notification);
                           }
                           if(OrdersNextWaveCheckdays!=null && OrdersNextWaveCheckdays>15){
                           message.setTemplateId(label.ATR_Orders_Third_Notification);
                            mapEmailTemplateids.put(cas.id,label.ATR_Orders_Third_Notification);
                           }
                           
                            bulkEmails.add(message);
                         
                           
                           mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                                
                        }
                        catch (Exception exc) {
                            System.debug('*******************'+exc);
                        }
                    }

       //Code for SR INC000008086115 -Ends
                    
                    if(('Insert').equals(strDMLMode)  && (cas.Subject == Null || (cas.Subject!=Null && !(cas.Subject.contains('MTO')))) 
                    && (cas.Origin=='Web') && cas.recordtypeid == label.recordtype_case_quotes )
                    {
                        try{
                            // The email template ID used for the email
                            message = setEmailMessage(cas.contactid,cas.id);
                            message.setTemplateId(label.Quote_Portal);
                            bulkEmails.add(message);
                            
                            mapEmailTemplateids.put(cas.id,label.Quote_Portal);
                           
                           mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');                                   
                                mapCaseDetails.put(cas.id,caseDet);
                        }
                        catch (Exception ep) {
                            System.debug('RRRRRRRRRRRRR'+ep);
                        }
                    }           
                    //code ends 427733
                    //Code for Igloo ends
                    //Added by Dhivya for SR INC000007007934
                //if(cas.Service_Level__c != 'Unauthorized Dist/Brkr')
                 //{
                    if(('Insert').equals(strDMLMode) && (cas.Emailbox_Origin__c=='Email-RO EMEAI Internal' ||
                    cas.Emailbox_Origin__c=='Email-RO Americas Internal' ||
                    cas.Emailbox_Origin__c=='Email-R&O APAC Internal' ||
                    cas.Emailbox_Origin__c=='Email-OEM Internal'  ||
                    cas.Emailbox_Origin__c=='Email-ACTinternal' ||
                    cas.Emailbox_Origin__c=='Email-APACACTinternal' ||
                    cas.Emailbox_Origin__c=='Email-EMEAACTInternal' ))
                    {
                        try{
                            // The email template ID used for the email
                            message = setEmailMessage(cas.contactid,cas.id);
                            message.setTemplateId(label.Internal_Escalations_Case);
                            bulkEmails.add(message);
                            
                            mapEmailTemplateids.put(cas.id,label.Internal_Escalations_Case);
                                        mapContactids.put(cas.id,cas.contactid);
                                        List<string> caseDet = new List<string>();
                                        if(cas.CaseNumber != null)
                                            caseDet.add(cas.CaseNumber);
                                        else
                                            caseDet.add(' ');
                                        
                                        if( cas.Subject != null)
                                            caseDet.add(cas.Subject);
                                        else
                                            caseDet.add(' ');
                                            
                                        if(cas.Case_Ref_ID__c != null)
                                            caseDet.add(cas.Case_Ref_ID__c);
                                        else
                                            caseDet.add(' ');
                                        mapCaseDetails.put(cas.id,caseDet);
                        }
                        catch (Exception exc) {
                            System.debug('*******************'+exc);
                        }
                    }

                    //}
                    if(cas.Subject!=Null)
                    {
                        if(cas.Subject.contains('MTO') && cas.Origin=='Web' )
                        {
                            if(('Insert').equals(strDMLMode) || (('Update').equals(strDMLMode) && cas.Subject!=oldMap.get(cas.id).Subject))
                            {
                                try{
                                    // The email template ID used for the email
                                    message = setEmailMessage(cas.contactid,cas.id);
                                    message.setTemplateId(MTOTemplate);
                                    bulkEmails.add(message);
                                    mapEmailTemplateids.put(cas.id,MTOTemplate);
                                        mapContactids.put(cas.id,cas.contactid);
                                        List<string> caseDet = new List<string>();
                                        if(cas.CaseNumber != null)
                                            caseDet.add(cas.CaseNumber);
                                        else
                                            caseDet.add(' ');
                                        
                                        if( cas.Subject != null)
                                            caseDet.add(cas.Subject);
                                        else
                                            caseDet.add(' ');
                                            
                                        if(cas.Case_Ref_ID__c != null)
                                            caseDet.add(cas.Case_Ref_ID__c);
                                        else
                                            caseDet.add(' ');
                                        mapCaseDetails.put(cas.id,caseDet);
                                }
                                catch (Exception e) {}
                            }
                        }
                    }
                    if(cas.Sub_Class__c == 'Deferred Online Order' && (cas.Subject == null || (cas.Subject!=Null && !(cas.Subject.contains('SPEX Warranty'))
                    && !(cas.Subject.contains('MTO'))&& !(cas.Subject.contains('WebOrder; SPEX; Warranty verification'))))
                    && !(cas.Emailbox_Origin__c=='Email-Orders' && cas.SBU__c =='ATR'   
              //&& (cas.PreventCloseonupdate__c <7 ) 
              && (null!=lstcas.get(cas.id) && null!=lstcas.get(cas.id).account && null!= lstcas.get(cas.id).account.Orders_Next_Wave__c && lstcas.get(cas.id).account.Orders_Next_Wave__c==true)
              && (cas.Do_Not_Send_to_Portal__c)))
                     
                    {
                        if(('Insert').equals(strDMLMode) || (('Update').equals(strDMLMode) && cas.Sub_Class__c != oldMap.get(cas.id).Sub_Class__c))
                        {
                            try{
                                // The email template ID used for the email
                                message = setEmailMessage(cas.contactid,cas.id);
                                message.setTemplateId(OtherHoldTemplate);
                                bulkEmails.add(message);
                                
                                mapEmailTemplateids.put(cas.id,OtherHoldTemplate);
                                        mapContactids.put(cas.id,cas.contactid);
                                        List<string> caseDet = new List<string>();
                                        if(cas.CaseNumber != null)
                                            caseDet.add(cas.CaseNumber);
                                        else
                                            caseDet.add(' ');
                                        
                                        if( cas.Subject != null)
                                            caseDet.add(cas.Subject);
                                        else
                                            caseDet.add(' ');
                                            
                                        if(cas.Case_Ref_ID__c != null)
                                            caseDet.add(cas.Case_Ref_ID__c);
                                        else
                                            caseDet.add(' ');
                                        mapCaseDetails.put(cas.id,caseDet);
                            }
                            catch (Exception e) {}
                        }
                    }
                    if(cas.Subject!=Null)
                    {
                        if(cas.Subject.contains('WebOrder; SPEX; Warranty verification'))
                        {
                            if(('Insert').equals(strDMLMode) || (('Update').equals(strDMLMode) && cas.Subject!=oldMap.get(cas.id).Subject))
                            {
                                try{
                                    // The email template ID used for the email
                                    message = setEmailMessage(cas.contactid,cas.id);
                                    message.setTemplateId(spexTemplate);
                                    bulkEmails.add(message);
                                    
                                    mapEmailTemplateids.put(cas.id,spexTemplate);
                                        mapContactids.put(cas.id,cas.contactid);
                                        List<string> caseDet = new List<string>();
                                        if(cas.CaseNumber != null)
                                            caseDet.add(cas.CaseNumber);
                                        else
                                            caseDet.add(' ');
                                        
                                        if( cas.Subject != null)
                                            caseDet.add(cas.Subject);
                                        else
                                            caseDet.add(' ');
                                            
                                        if(cas.Case_Ref_ID__c != null)
                                            caseDet.add(cas.Case_Ref_ID__c);
                                        else
                                            caseDet.add(' ');
                                        mapCaseDetails.put(cas.id,caseDet);
                                }
                                catch (Exception e) {}
                            }
                        }
                    }
                    //Added by Dhivya for SR INC000007007934
                if(cas.Service_Level__c != 'Unauthorized Dist/Brkr')
                {
                    system.debug('BGA Orders22--------->');
                    system.debug('cas.sbu__c'+cas.sbu__c);
                    system.debug('cas.Region__c'+cas.Region__c);
                    if(('Insert').equals(strDMLMode) && (cas.Emailbox_Origin__c == 'Email-Orders' ) && cas.sbu__c != 'ATR' && cas.sbu__c != 'D&S' && cas.sbu__c != 'BGA' && cas.service_level__c != 'Unauthorized Dist/Brkr' && cas.Region__c !='Asia/Pacific Rim' && cas.PFECN__c==null)
                    {  
                            try{
                            message = setEmailMessage(cas.contactid,cas.id);   
                            message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);                     
                            message.setTemplateId(label.Order_Confirmation);                                                           
                            bulkEmails.add(message);
                            //INC000005569277
                            
                                mapEmailTemplateids.put(cas.id,label.Order_Confirmation);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                                //INC000005569277
                            
                        }
                        catch (Exception exc) {
                            System.debug('*******************'+exc);
                        }
                    }
                                        //Commented the lines for SR INC000005580855
                    /*else if(('Insert').equals(strDMLMode) && (cas.Emailbox_Origin__c=='Email-Orders')&&(cas.SBU__c=='BGA')&&
                    (cas.Account_Concierge__c=='False' && cas.Account_Type__c!='Owner/Operator') && cas.Region__c !='Asia/Pacific Rim')
                    {
                        try{
                            // The email template ID used for the email
                            message = setEmailMessage(cas.contactid,cas.id);
                            message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                            message.setTemplateId(label.All_BGA_Template);
                            bulkEmails.add(message);
                              
                              mapEmailTemplateids.put(cas.id,label.All_BGA_Template);
                              mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                        }
                        catch (Exception exc) {
                            System.debug('*******************'+exc);
                        }
                    }
                    //Added the code for BGA Orders  - SR - INC000005580855
                    
                    else if(('Insert').equals(strDMLMode) && (cas.Emailbox_Origin__c=='Email-Orders') && cas.sbu__c == 'BGA' && cas.PFECN__c==null)                   
                     { 
                         system.debug('BGA Orders11--------->');
                          if ((cas.Account_Type__c == 'Owner/Operator' || cas.Account_Type__c == 'Fractional Ownership' 
                          || !emailDomain) || cas.Region__c=='Asia/Pacific Rim' )
                             {
                                system.debug('BGA Orders--------->');
                                try{
                                    message = setEmailMessage(cas.contactid,cas.id);
                                    message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);                    
                                    message.setTemplateId(label.Order_Confirmation); 
                                    bulkEmails.add(message);
                                    //INC000005569277
                                    
                                        mapEmailTemplateids.put(cas.id,label.Order_Confirmation);
                                        mapContactids.put(cas.id,cas.contactid);
                                        List<string> caseDet = new List<string>();
                                        if(cas.CaseNumber != null)
                                            caseDet.add(cas.CaseNumber);
                                        else
                                            caseDet.add(' ');
                                        
                                        if( cas.Subject != null)
                                            caseDet.add(cas.Subject);
                                        else
                                            caseDet.add(' ');
                                            
                                        if(cas.Case_Ref_ID__c != null)
                                            caseDet.add(cas.Case_Ref_ID__c);
                                        else
                                            caseDet.add(' ');
                                        mapCaseDetails.put(cas.id,caseDet);
                                        //INC000005569277
                                    
                                   }
                                catch(Exception exc) {
                                    System.debug('*******************'+exc);
                                }
                             }
                           else if(cas.Account_Type__c != 'Owner/Operator' && cas.Account_Type__c != 'Fractional Ownership' 
                           && emailDomain && cas.Region__c!='Asia/Pacific Rim')
                             {
                                try{
                                    message = setEmailMessage(cas.contactid,cas.id);                   
                                    message.setTemplateId(label.Order_Request); 
                                    message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);                     
                                   bulkEmails.add(message);
                                   //INC000005569277
                                   
                                        mapEmailTemplateids.put(cas.id,label.Order_Request);
                                        mapContactids.put(cas.id,cas.contactid);
                                        List<string> caseDet = new List<string>();
                                        if(cas.CaseNumber != null)
                                            caseDet.add(cas.CaseNumber);
                                        else
                                            caseDet.add(' ');
                                        
                                        if( cas.Subject != null)
                                            caseDet.add(cas.Subject);
                                        else
                                            caseDet.add(' ');
                                            
                                        if(cas.Case_Ref_ID__c != null)
                                            caseDet.add(cas.Case_Ref_ID__c);
                                        else
                                            caseDet.add(' ');
                                        mapCaseDetails.put(cas.id,caseDet);
                                        //INC000005569277
                                    
                                   }
                                catch(Exception exc) {
                                    System.debug('*******************'+exc);
                                }                           
                             }
                     }  
                       
                    /* commented the below lines for SR INC000006181706 
                    else if(('Insert').equals(strDMLMode) && (cas.Emailbox_Origin__c=='Email-Orders') && (cas.SBU__c == 'ATR') 
                         && (cas.Account_Type__c != 'broker/dealer' && cas.Account_Type__c != 'dealer' 
                         && cas.Account_Type__c != 'dealer-avionics' && cas.Account_Type__c != 'product/service provider' && cas.Account_Type__c != 'distributor') 
                         && cas.Primary_Email_Address__c != '' && cas.Region__c != 'Asia/Pacific Rim' && (cas.SuppliedEmail != null && (!cas.SuppliedEmail.contains('@equipaero.com' )) && 
                         (!cas.SuppliedEmail.contains('@aarcorp.com')) && (!cas.SuppliedEmail.contains('@triumphgroup.com')) && !emailDomain1) && (cas.service_level__c != 'Unauthorized Dist/Brkr' ||
                       cas.Recordtypeid == label.Repair_Overhaul_Rec_Id))
                    {
                        try{
                            // The email template ID used for the email
                            message = setEmailMessage(cas.contactid,cas.id);
                            message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                            message.setTemplateId(label.Order_Confirmation);
                            bulkEmails.add(message);
                            //INC000005569277
                            
                                mapEmailTemplateids.put(cas.id,label.Order_Confirmation);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                                //INC000005569277
                            
                        }
                        catch (Exception exc) {
                            System.debug('*******************'+exc);
                        }
                    } 
                    else if((('Insert').equals(strDMLMode) && (cas.Emailbox_Origin__c=='Email-Orders') 
                    && (cas.SBU__c == 'D&S') && (cas.Service_Level__c != 'Refer to Network') && cas.Primary_Email_Address__c != '' && cas.Region__c != 'Asia/Pacific Rim') 
                    || (('Insert').equals(strDMLMode)&& (cas.Emailbox_Origin__c=='Email-Orders') && cas.Region__c=='Asia/Pacific Rim' && cas.SBU__c != 'ATR') && cas.PFECN__c==null)
                    {
                          try{
                            // The email template ID used for the email
                            message = setEmailMessage(cas.contactid,cas.id);
                            message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                            message.setTemplateId(label.Order_Confirmation); // Modified Template Id for INC000008372626
                            bulkEmails.add(message);
                            //INC000005569277
                            
                                mapEmailTemplateids.put(cas.id,label.Order_Confirmation); // Modified Template Id for INC000008372626
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                                //INC000005569277
                            
                        }
                        catch (Exception exc) {
                            System.debug('*******************'+exc);
                        }
                    }
                    /* commented the below lines for SR INC000005580855 
                    else if(('Insert').equals(strDMLMode) && (cas.Emailbox_Origin__c=='Email-Orders') 
                    && (cas.SBU__c == 'BGA') && cas.Primary_Email_Address__c != '' 
                    && (cas.Account_Concierge__c == 'true' || cas.Account_Type__c == 'Owner/Operator')
                    && cas.Region__c != 'Asia/Pacific Rim')
                    {
                        try{
                            // The email template ID used for the email
                            message = setEmailMessage(cas.contactid,cas.id);
                            message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                            message.setTemplateId(label.BGA_orders_conci_true_owner_operator);
                            bulkEmails.add(message);                
                        }
                        catch (Exception exc) {
                            System.debug('*******************'+exc);
                        }
                    }*/
                    //Added the below lines for BGA email box CSO BGA Spares - SR INC000005580855
                    //Commented the code for Incident INC000012241833
                    /*if(('Insert').equals(strDMLMode) && cas.Emailbox_Origin__c=='Email-CSO BGA Spares' && cas.sbu__c == 'BGA' 
                    && ( Null!=cas.SuppliedEmail && (!cas.SuppliedEmail.contains('@dallasairmotive.com')) && 
                    (!cas.SuppliedEmail.contains('@standardaero.com')) && (!cas.SuppliedEmail.contains('@duncanaviation.com')) 
                    && (!cas.SuppliedEmail.contains('@tesservice.com'))))
                     {  
                          if (cas.Account_Type__c == 'Owner/Operator' || cas.Account_Type__c == 'Fractional Ownership' 
                          || !emailDomain || cas.Region__c=='Asia/Pacific Rim')
                             {
                                try{
                                    message = setEmailMessage(cas.contactid,cas.id);
                                    message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);                    
                                    message.setTemplateId(label.BGA_orders_conci_true_owner_operator); 
                                    bulkEmails.add(message);
                                    
                                    //INC000005860605-start
                                     mapEmailTemplateids.put(cas.id,label.BGA_orders_conci_true_owner_operator);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                                     //INC000005860605-end 
                                    
                                   }
                                catch(Exception exc) {
                                    System.debug('*******************'+exc);
                                }
                             }
                           else if(cas.Account_Type__c != 'Owner/Operator' && cas.Account_Type__c != 'Fractional Ownership' 
                           && emailDomain && cas.Region__c !='Asia/Pacific Rim')
                             {
                                try{
                                    message = setEmailMessage(cas.contactid,cas.id);                   
                                    //message.setTemplateId(label.All_BGA_Template); //INC000006427828 - Replaced with new Email Template to have Case Number - Order_Confirmation
                                    message.setTemplateId(label.Order_Confirmation);
                                    message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);                     
                                   bulkEmails.add(message);
                                   
                                    //INC000005860605-start
                                    //mapEmailTemplateids.put(cas.id,label.All_BGA_Template);
                                    mapEmailTemplateids.put(cas.id,label.Order_Confirmation); //INC000006427828 - Replaced with new Email Template to have Case Number - Order_Confirmation
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                                  //INC000005860605-end 
                                   
                                   }
                                catch(Exception exc) {
                                    System.debug('*******************'+exc);
                                }                           
                             }
                     } 
                     if(('Insert').equals(strDMLMode) && cas.Emailbox_Origin__c=='Email-CSO BGA Spares' && (null!=cas.SuppliedEmail && (cas.SuppliedEmail.contains('@dallasairmotive.com') || cas.SuppliedEmail.contains('@standardaero.com') || cas.SuppliedEmail.contains('@duncanaviation.com') || cas.SuppliedEmail.contains('@tesservice.com'))))
                      {
                       try{
                                System.debug('Inside this for Email-CSO BGA Spares');
                                    message = setEmailMessage(cas.contactid,cas.id);
                                    message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);                    
                                    message.setTemplateId(label.Order_Confirmation); 
                                    bulkEmails.add(message);
                                    
                                    
                                     mapEmailTemplateids.put(cas.id,label.Order_Confirmation);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);                                    
                                   }
                                catch(Exception exc) {
                                    System.debug('*******************'+exc);
                                }
                       } 
                     //Commented the code for Incident INC000012241833
                       } 
        system.debug('cas.Emailbox_Origin__c'+cas.Emailbox_Origin__c);
        system.debug('cas.SuppliedEmail'+cas.SuppliedEmail);
                       if(('Insert').equals(strDMLMode) && cas.Emailbox_Origin__c=='Email-R&O MechComponents' && cas.SuppliedEmail!=null )
                       {
                           system.debug('Tenth Test');
                       try{
                                   
                                message = setEmailMessage(cas.contactid,cas.id);
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);                    
                                message.setTemplateId(label.Case_Creation_Template_ID); 
                                bulkEmails.add(message);
                                    
                                    
                                mapEmailTemplateids.put(cas.id,label.Case_Creation_Template_ID);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = new List<string>();
                                if(cas.CaseNumber != null)
                                    caseDet.add(cas.CaseNumber);
                                else
                                    caseDet.add(' ');
                                
                                if( cas.Subject != null)
                                    caseDet.add(cas.Subject);
                                else
                                    caseDet.add(' ');
                                    
                                if(cas.Case_Ref_ID__c != null)
                                    caseDet.add(cas.Case_Ref_ID__c);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);
                                
                                if(cas.Description!= null)
                                    caseDet.add(cas.Description);
                                else
                                    caseDet.add(' ');
                                
                                mapCaseDetails.put(cas.id,caseDet);  
                                    
                                   }
                                catch(Exception exc) {
                                    System.debug('*******************'+exc);
                                }                       
                       }                       
                       //}                                             
                  if( trigger.isupdate && Trigger.isAfter && TriggerCheck.firstIntEscRun && cas.recordtypeid == label.Internal_Escalations_RecordId && cas.IsClosed == true && cas.IsClosed !=oldmap.get(cas.id).IsClosed )
                  {
                   try{
                        message = setEmailMessage(cas.contactid,cas.id);
                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);// Modified for INC000008113942                    
                        message.setTemplateId(label.EscalationCaseClosed_Template); 
                        bulkEmails.add(message);
                                  
                        mapEmailTemplateids.put(cas.id,label.EscalationCaseClosed_Template);
                        mapContactids.put(cas.id,cas.contactid);
                        List<string> caseDet = new List<string>();
                        if(cas.CaseNumber != null)
                            caseDet.add(cas.CaseNumber);
                        else
                            caseDet.add(' ');
                        
                        if( cas.Subject != null)
                            caseDet.add(cas.Subject);
                        else
                            caseDet.add(' ');
                            
                        if(cas.Case_Ref_ID__c != null)
                            caseDet.add(cas.Case_Ref_ID__c);
                        else
                            caseDet.add(' ');
                            
                        if(cas.Description!= null)
                            caseDet.add(cas.Description);
                        else
                            caseDet.add(' ');
                        
                        if(cas.Resolution__c!= null)
                            caseDet.add(cas.Resolution__c);
                        else
                            caseDet.add(' '); 

                        if(cas.Customer_Name__c!= null)
                            caseDet.add(cas.Customer_Name__c);
                        else
                            caseDet.add(' '); 
                            
                        if(cas.Sales_Order_Number__c!= null)
                            caseDet.add(cas.Sales_Order_Number__c);
                        else
                            caseDet.add(' '); 
                            
                        if(cas.Customer_PO_RO_WONumber__c!= null)
                            caseDet.add(cas.Customer_PO_RO_WONumber__c);
                        else
                            caseDet.add(' '); 
                            
                        if(cas.Hon_Plant_Code_del__c!= null)
                            caseDet.add(cas.Hon_Plant_Code_del__c);
                        else
                            caseDet.add(' '); 

                        mapCaseDetails.put(cas.id,caseDet);
                             
                         TriggerCheck.firstIntEscRun = false;   
                           }
                        catch(Exception exc) {
                            System.debug('*******************'+exc);
                        }
                   }
                   
                }         
            //Code added for the SR 435799 starts  
            // If any new user is Added/Removed to the GDC Accounts * group, the custom setting GDC_Accounts_Groups__c has to be edited with email ids of the user in group.
            if (cas.Recordtypeid==Label.GDC_Accounts){
                GDCGroup ='';
                if ((trigger.isinsert && cas.classification__c =='Activation') || (trigger.isupdate &&  cas.classification__c!=oldmap.get(cas.id).classification__c && cas.classification__c =='Activation'))
                 {
                  GDCGroup = 'GDC Accounts Activation';
                 }
                 else if ((trigger.isinsert && cas.classification__c =='Cancellation') || (trigger.isupdate &&  cas.classification__c!=oldmap.get(cas.id).classification__c && cas.classification__c =='Cancellation'))
                 {
                 GDCGroup = 'GDC Accounts Cancellation';
                 }
                 else if ((trigger.isinsert && cas.classification__c =='MyGDC Training') || (trigger.isupdate &&  cas.classification__c!=oldmap.get(cas.id).classification__c && cas.classification__c =='MyGDC Training'))
                 {
                 GDCGroup = 'GDC Accounts MyGDC Training';
                 }
                 else if ((trigger.isinsert && cas.classification__c =='Renewal') || (trigger.isupdate &&  cas.classification__c!=oldmap.get(cas.id).classification__c && cas.classification__c =='Renewal'))
                 {
                 GDCGroup = 'GDC Accounts Renewal';
                 }
                 else if((trigger.isinsert && cas.classification__c =='Technical Support') || (trigger.isupdate &&  cas.classification__c!=oldmap.get(cas.id).classification__c && cas.classification__c =='Technical Support'))
                 {
                 GDCGroup = 'GDC Accounts Technical Support';
                 }
                mapGDCGroup = new Map<String,GDC_Accounts_Groups__c>(GDC_Accounts_Groups__c.getALL());
                if (GDCGroup != null && GDCGroup!='' ){
                      if (null != mapGDCGroup && mapGDCGroup.containskey(GDCGroup)==true){
                      String[] emailAddressArr1 = (mapGDCGroup.get(GDCGroup).EmailID__c).split(',');        
                      if(emailAddressArr1.size() > 0){            
                      for(String i : emailAddressArr1){
                            mailToAddresses.add(i);
                        }
                      }   
                   }
                }                
                 If (mailToAddresses.size()>0)
                 {
                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();             
                 mail.setToAddresses(mailToAddresses);
                 String subclass;
                 if (Cas.Sub_Class__c==Null)
                    subclass='';
                 else
                    subclass=Cas.Sub_Class__c; 
                 mail.setSubject(Cas.CaseNumber +'  '+ Cas.Status + ' ' + Cas.Subject);
                 String bodyText = '<html><head>** New GDC Tech Issue **<br/><br/> </head>' + ' <body> Class : ' + Cas.Classification__c + ' ' +  subclass + '<br/><br/> ' + ' Priority: ' + Cas.Priority + ' <br/><br/>' + ' ---' + '<br/><br/>' + Cas.Description+'</body></Html>';
                 mail.setHtmlBody(bodyText);  
                 bulkEmails.add(mail);    
                 }
            }   
                //Code for SR 435799 Ends
                System.debug('ANU-OWNER-2875'+cas.ownerid);

                // Changes start for INC000008382347
                String strbaseURL = URL.getSalesforceBaseUrl().toExternalForm();
                String casUrl = strbaseURL+'/'+cas.id;
                if(cas.RecordTypeId == Label.ITEC_Quotes_Orders_RecordTypeId && (null!=cas.Classification__c && cas.Classification__c == 'ITEC') && ((trigger.isInsert && cas.Ownerid == Label.ITEC_Orders_Team_Id) || (trigger.isUpdate && oldMap.get(cas.id).OwnerId!=cas.OwnerId && cas.OwnerId == Label.ITEC_Orders_Team_Id))){
                    system.debug('----------New Mail');
                    String itecbody = '<!DOCTYPE html><body><table border="0" cellpadding="5" cellspacing="0" width="550" height="400" style="position: absolute;border-top-width: 4px;border-top-style: solid;border-top-color: #ED2028;border-bottom-width: 4px;border-bottom-style: solid;border-bottom-color: #ED2028;"><tr><td><table height="400" width="500" cellpadding="5" border="0" cellspacing="5"><tr><td style=" color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;" tEditID="c1r1" locked="0" aEditID="c1r1" ><font face="Arial, sans-serif" size="2">Case '+cas.CaseNumber+' has been assigned to ITEC Orders Team. Please click on the below link to view the record.<br/><br/>'+casUrl+'</font></td></tr></table></td></tr></table><br/><br/></body></html>';
                    String[] toadd = new String[]{'nicole.kuhn@honeywell.com'};
                    mail.setBccSender(false);             
                    mail.setUseSignature(false);
                    mail.setOrgWideEmailAddressId(label.DSRepairs_Org_Id);
                    mail.setWhatId(cas.Id);
                    mail.setSubject('Case transferred to ITEC Orders Team');
                    mail.setHtmlBody(itecbody);
                    mail.setToAddresses(toadd);
                    bulkEmails.add(mail); 
                }
                // Changes End for INC000008382347
            }
            ////////////////////////////////////////
            
            if(!(Test.isRunningTest()) )
            {              
            //Modified for SR INC000007007934 starts     
                if( bulkEmails.size() >0){
                Messaging.reserveSingleEmailCapacity(trigger.size);
                Messaging.sendEmail(bulkEmails); 
                }
             if(bulkEmailsNavDB.size()>0 )
           {
               System.debug('Test Autoresp NavDB non contact:');
               System.debug('setalreadyExecutedPPObulk'+AircraftNotificationsTriggerStopper.hasalreadyExecutedPPO());
               Messaging.sendEmail(bulkEmailsNavDB); 
           } 
           if(bulkEmailsAVSAT.size()>0 )
           {
               System.debug('Test Autoresp NavDB non contact:');
               System.debug('setalreadyExecutedPPObulk'+AircraftNotificationsTriggerStopper.hasalreadyExecutedPPO());
               Messaging.sendEmail(bulkEmailsAVSAT); 
           } 
                 //SR INC000007007934 ends
                //INC000005569277 start                                               
                
             if(!AircraftNotificationsTriggerStopper.hasalreadyExecutedNavdb())
            {
                system.debug('Enter here CASEClassFORPub:'+!AircraftNotificationsTriggerStopper.hasalreadyExecutedNavdb());
                AircraftNotificationsTriggerStopper.setalreadyExecutedNavdb();
                if(listCaseids.size() > 0){
                    map<id,EmailTemplate> mapEmailTemp = new map<id,EmailTemplate>([SELECT Body,HtmlValue,Id,Subject FROM EmailTemplate WHERE Id =: mapemailtemplateids.values()]);
                    //map<id,Contact> mapCons = new map<id,Contact>([SELECT Id,firstName, LastName, Primary_Email_Address__c FROM Contact WHERE Id =: mapcontactids.values()]);
                    List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
                    for(Case c: listCaseids){
                            EmailMessage emailToCase = new EmailMessage();
                            emailToCase.Incoming = false;
                            if(mapEmailTemplateIds.get(c.Id) != null){
                                EmailTemplate emailTemp = mapEmailTemp.get(id.valueOf(mapEmailTemplateIds.get(c.Id)));
                                if(emailTemp != null){
                                    
                                    emailToCase.Subject = emailTemp.subject.replace('{!Case.CaseNumber}',mapCaseDetails.get(c.Id)[0]).replace('{!Case.Subject}',mapCaseDetails.get(c.Id)[1]).replace('{!Case.Case_Ref_ID__c}',mapCaseDetails.get(c.Id)[2]);
                                    emailToCase.FromName = label.Yourresponse_Email;
                                    emailToCase.FromAddress = label.Yourresponse_Email;
                                    emailToCase.MessageDate = system.now();
                                    emailToCase.ParentId = c.Id;
                                    String strtemp,strTextBody; 
                                    if(null!= mapContactids && mapContactids.size()>0  && mapContactids.get(c.Id) != null){
                                       // Contact con = mapCons.get(mapContactids.get(c.Id));
                                        if(null!=lstcas && lstcas.size()>0 && null!=lstcas.get(c.id) && lstcas.get(c.id).contact!= null){
                                            //string contactName = con.FirstName + ' ' + con.LastName;                                             
                                            string contactName = lstcas.get(c.id).contact.FirstName + ' ' + lstcas.get(c.id).contact.LastName; 
                                            emailToCase.ToAddress = lstcas.get(c.id).contact.Primary_Email_Address__c;
                                            if(mapCaseDetails.get(c.Id).size()>4){
                                                strTextBody = emailTemp.body.replace('{!Case.Contact_Name__c}',ContactName).replace('{!Case.CaseNumber}',mapCaseDetails.get(c.Id)[0]).replace('{!Case.Subject}',mapCaseDetails.get(c.Id)[1]).replace('{!Case.Case_Ref_ID__c}',mapCaseDetails.get(c.Id)[2]).replace('{!Case.Description}',mapCaseDetails.get(c.Id)[3]).replace('{!Case.Resolution__c}',mapCaseDetails.get(c.Id)[4]).replace('{!Case.Customer_Name__c}',mapCaseDetails.get(c.Id)[5]).replace('{!Case.Sales_Order_Number__c}',mapCaseDetails.get(c.Id)[6]).replace('{!Case.Customer_PO_RO_WONumber__c}',mapCaseDetails.get(c.Id)[7]).replace('{!Case.Hon_Plant_Code_del__c}',mapCaseDetails.get(c.Id)[8]);
                                                strtemp = emailTemp.HtmlValue.replace('{!Case.Contact_Name__c}',ContactName).replace('{!Case.CaseNumber}',mapCaseDetails.get(c.Id)[0]).replace('{!Case.Subject}',mapCaseDetails.get(c.Id)[1]).replace('{!Case.Case_Ref_ID__c}',mapCaseDetails.get(c.Id)[2]).replace('{!Case.Description}',mapCaseDetails.get(c.Id)[3]).replace('{!Case.Resolution__c}',mapCaseDetails.get(c.Id)[4]).replace('{!Case.Customer_Name__c}',mapCaseDetails.get(c.Id)[5]).replace('{!Case.Sales_Order_Number__c}',mapCaseDetails.get(c.Id)[6]).replace('{!Case.Customer_PO_RO_WONumber__c}',mapCaseDetails.get(c.Id)[7]).replace('{!Case.Hon_Plant_Code_del__c}',mapCaseDetails.get(c.Id)[8]);                                             
                                            }
                                            else if(mapCaseDetails.get(c.Id).size()==4){
                                                strTextBody = emailTemp.body.replace('{!Case.Contact_Name__c}',ContactName).replace('{!Case.CaseNumber}',mapCaseDetails.get(c.Id)[0]).replace('{!Case.Subject}',mapCaseDetails.get(c.Id)[1]).replace('{!Case.Case_Ref_ID__c}',mapCaseDetails.get(c.Id)[2]).replace('{!Case.Description}',mapCaseDetails.get(c.Id)[3]);
                                                strtemp = emailTemp.HtmlValue.replace('{!Case.Contact_Name__c}',ContactName).replace('{!Case.CaseNumber}',mapCaseDetails.get(c.Id)[0]).replace('{!Case.Subject}',mapCaseDetails.get(c.Id)[1]).replace('{!Case.Case_Ref_ID__c}',mapCaseDetails.get(c.Id)[2]).replace('{!Case.Description}',mapCaseDetails.get(c.Id)[3]);                                                
                                            }
                                            else{
                                                system.debug('Case.Contact_Name__c'+ContactName);
                                                system.debug('mapCaseDetails.get(c.Id)[0]'+mapCaseDetails.get(c.Id)[0]);
                                                system.debug('mapCaseDetails.get(c.Id)[1]'+mapCaseDetails.get(c.Id)[1]);
                                                system.debug('mapCaseDetails.get(c.Id)[2]'+mapCaseDetails.get(c.Id)[2]);
                                                system.debug('emailTemp.body'+emailTemp.body);
                                                 strTextBody = emailTemp.body.replace('{!Case.Contact_Name__c}',ContactName).replace('{!Case.CaseNumber}',mapCaseDetails.get(c.Id)[0]).replace('{!Case.Subject}',mapCaseDetails.get(c.Id)[1]).replace('{!Case.Case_Ref_ID__c}',mapCaseDetails.get(c.Id)[2]);
                                                 strtemp = emailTemp.HtmlValue.replace('{!Case.Contact_Name__c}',ContactName).replace('{!Case.CaseNumber}',mapCaseDetails.get(c.Id)[0]).replace('{!Case.Subject}',mapCaseDetails.get(c.Id)[1]).replace('{!Case.Case_Ref_ID__c}',mapCaseDetails.get(c.Id)[2]);                                                
                                            }
                                           
                                        }
                                    }
                                    else{
                                    system.debug('Case Email List @@');
                                          emailToCase.ToAddress = lstcas.get(c.id).SuppliedEmail;
                                          strTextBody = emailTemp.body.replace('{!Case.CaseNumber}',mapCaseDetails.get(c.Id)[0]).replace('{!Case.Subject}',mapCaseDetails.get(c.Id)[1]).replace('{!Case.Case_Ref_ID__c}',mapCaseDetails.get(c.Id)[2]);
                                          strtemp = emailTemp.HtmlValue.replace('{!Case.CaseNumber}',mapCaseDetails.get(c.Id)[0]).replace('{!Case.Subject}',mapCaseDetails.get(c.Id)[1]).replace('{!Case.Case_Ref_ID__c}',mapCaseDetails.get(c.Id)[2]);                                                

                                    }
                                            if(strtemp!=null && strtemp.length()>0 ){
                                                if(strtemp.length()<32000){
                                                    emailToCase.HtmlBody =  strtemp.substring(0,strtemp.length());
                                                }
                                                else
                                                {
                                                    emailToCase.HtmlBody =  strtemp.substring(0,32000);
                                                }
                                            }
                                            if(strTextBody !=null && strTextBody.length()>0 ){
                                                if(strTextBody.length()<32000){
                                                    emailToCase.TextBody =  strTextBody.substring(0,strTextBody.length());
                                                }
                                                else
                                                {
                                                    emailToCase.TextBody =  strTextBody.substring(0,32000);
                                                }
                                            }                                            
                                    listInsertEmailMessage.add(emailToCase);
                                }
                                
                            }                        
                    }
                    
                    if(listInsertEmailMessage.size() > 0 )
                        insert listInsertEmailMessage;
                }                
                }                
                //INC000005569277 end
            }
        }catch(Exception e){        
            MainCaseTriggerUtility.handleCaseException(e,exceptionCase);
        }           
    }
    
    This method to reduce the mulitple occurence for creating Mail object
    
    public Messaging.SingleEmailMessage setEmailMessage(Id contactId,Id caseID)
    {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setTargetObjectId(contactId);
        message.setWhatId(caseID);                        
        message.setBccSender(false);
        message.setUseSignature(false);
        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
        message.setSaveAsActivity(false); 
        return message;
    }
    
    This method is used for the replacement of ROCaseCreation trigger code called Before Insert/Update
    
    public void RnOCaseOwnerAssignOnCreationMethod(List<Case> listObjCaseNew,Map<ID,Case> oldMap,String strDMLMode) 
    {
        if(TriggerInactive.AvoidRecursionCase==true){
        Boolean bolChangesPresent = false;
        Boolean bolChangesPresent1 = false;
        List<Case_Matrix__c> listCaseMatrix = [select id,Name, OwnerId__c from Case_Matrix__c where Email_Public_Group__c =null];   
        Map<string,id> mapOwnerIds = new Map<string,id>();  
        string origin;
        integer strSize;        
        List<Id> lstConID = new List<Id>();
        List<string> lstProd = new List<String>();
        List<string> lstProd1 = new List<String>();
        List<string> lstProd2 = new List<String>();
        String DSRO = 'D&S R&O';
        for(Case_Matrix__c cmItem:listCaseMatrix){
            mapOwnerIds.put(cmItem.Name,cmItem.OwnerId__c) ;            
        }
        List<id> listAircraft = new List<id>();
        Map<id,Fleet_Asset_Detail__c> mapAircraftName = new Map<id,Fleet_Asset_Detail__c>();
        List<id> listCaseOppDealer = new List<id>();
        Map<id,Opportunity> mapCaseOppDealer = new Map<id,Opportunity>();
        List<id> listCaseContact = new List<id>();
        Map<String,OriginCheckChange__c> mapOriginChange = OriginCheckChange__c.getall();    
        try{
            for(Case objCase:listObjCaseNew)
            {
                System.debug('Line@970'+objCase.origin);           
                System.debug('Line@970'+objCase.Emailbox_Origin__c);
                System.debug('ANU-OWNER-3017'+objCase.ownerid);
                if(null!=objCase.Aircraft_Name__c)
                listAircraft.add(objCase.Aircraft_Name__c );            
                if(null!=objCase.opportunity__c)
                listCaseOppDealer.add(objCase.opportunity__c);
                if(null!=objCase.contactid)
                listCaseContact.add(objCase.contactid);
                if(null!=objCase.Requested_By_HON_Internal__c )
                listCaseContact.add(objCase.Requested_By_HON_Internal__c);
                if(('Insert').equals(strDMLMode)||(('Update').equals(strDMLMode) && oldMap.get(objCase.id).RnOSAPCases__c != objCase.RnOSAPCases__c))            
                {
                    String neworigin;
                    bolChangesPresent = true;
                    lstConID.add(objCase.contactid);                
                    if(objCase.origin.length()!= null){
                        if(('Insert').equals(strDMLMode))
                        {
                            strSize=objCase.origin.length();
                        }
                        else
                        {
                            strSize = objCase.Mail_Box_Name__c.length(); 
                        }
                        if(strSize>6)
                        {
                            if(('Insert').equals(strDMLMode))
                            {
                                neworigin=objCase.origin.substring(6,strSize);
                            }
                            else
                            {
                                neworigin = objCase.Mail_Box_Name__c.substring(6,strSize);
                            }
                            if(null!=mapOriginChange.get(neworigin))
                                lstProd.add(mapOriginChange.get(neworigin).CaseOriginName__c);
                            else
                                lstProd.add(neworigin);
                        }
                        lstProd1.add(objCase.origin); 
                    }
                }
                if(null!=objCase.R_O_Case_Origin__c)
                lstProd2.add(objCase.R_O_Case_Origin__c);
                if(('Insert').equals(strDMLMode)||(('Update').equals(strDMLMode) && oldMap.get(objCase.id).RnOSAPCases__c != objCase.RnOSAPCases__c && String.valueof(objCase.ownerid).startswith('00G')))
                {
                    bolChangesPresent1 = true;    
                }
                System.debug('Line@1018'+objCase.origin);           
                System.debug('Line@1018'+objCase.Emailbox_Origin__c);
                System.debug('ANU-OWNER-3066'+objcase.ownerid);
            }
            //Map<Id,Contact> mapCaseOrigin = new Map<Id,Contact>([select id,(select id,CSR__c,CSR__r.IsActive,CSR__r.Signature1__c,Contact__c,Process__c from Agent_Contact_Mappings__r 
            //where Agent_Contact_Mapping__c.Contact__c in:lstConID and (Agent_Contact_Mapping__c.Process__c in:lstProd OR Agent_Contact_Mapping__c.Process__c in:lstProd1)) from contact where id in :lstConID]);
            Map<Id,Contact> mapCaseOrigin = new Map<Id,Contact>([select accountid, Contact_Function__c,id,contact_status__c,(select id,CSR__c,CSR__r.IsActive,CSR__r.Signature1__c,Contact__c,Process__c from Agent_Contact_Mappings__r 
            where Agent_Contact_Mapping__c.Contact__c in:lstConID and (Agent_Contact_Mapping__c.Process__c in:lstProd OR Agent_Contact_Mapping__c.Process__c in:lstProd1)) from contact where id in :listCaseContact]);
            if(listAircraft.size()>0)
                mapAircraftName = new Map<id,Fleet_Asset_Detail__c>([Select id, Make__c,Model__c,Tail_Number__c,Serial_Number__c,Base_ICAO__c from Fleet_Asset_Detail__c where id in:listAircraft]);
            if(listCaseOppDealer.size()>0)
                mapCaseOppDealer = new Map<id,Opportunity>([select id,dealer_account__r.name,ownerid,Opportunity_Number__c from opportunity where id in:listCaseOppDealer]);
            //Map<id,case> mapCAses = new Map<id,Case>([select id,Requested_By_HON_Internal__r.Contact_Status__c  from case where id in: listObjCaseNew]);
            //System.debug('Checking ID value'+mapCAses );
            for(case objCase :listObjCaseNew)
            {            
                ///////////////////// Case_Prevent_Creation  /////////////////////////
                //if(null != mapCAses) {
                   System.debug('Line@1035'+objCase.origin);           
                System.debug('Line@1035'+objCase.Emailbox_Origin__c);
                System.debug('ANU-OWNER-3084'+objcase.ownerid);
                    if((Trigger.isinsert || (Trigger.isupdate && (OldMap.get(objCase.Id).Aircraft_Name__c != objCase.Aircraft_Name__c))) && null!=objCase.Aircraft_Name__c  )
                    {
                        system.debug('check aricraft name11111---->'+objCase.Aircraft_Name__c);
                        if( null!=mapAircraftName.get(objCase.Aircraft_Name__c))
                        { 
                            system.debug('check aricraft name2222---->'+objCase.Aircraft_Name__c);
                            objCase.Make__c = mapAircraftName.get(objCase.Aircraft_Name__c).Make__c;
                            objCase.Model__c = mapAircraftName.get(objCase.Aircraft_Name__c).Model__c;
                            objCase.Tail__c = mapAircraftName.get(objCase.Aircraft_Name__c).Tail_Number__c;
                            objCase.Serial_Number__c = mapAircraftName.get(objCase.Aircraft_Name__c).Serial_Number__c;
                            objCase.Aircraft_Base_ICAO__c = mapAircraftName.get(objCase.Aircraft_Name__c).Base_ICAO__c;
                        }
                    }
                    if(Trigger.isinsert || (Trigger.isupdate && (OldMap.get(objCase.Id).Opportunity__c != objCase.Opportunity__c)))
                    {                       
                        if(null!=mapCaseOppDealer.get(objCase.Opportunity__c) && null!=mapCaseOppDealer.get(objCase.Opportunity__c).dealer_account__c)
                        {                            
                            objCase.BGA_Dealer_Name__c = mapCaseOppDealer.get(objCase.Opportunity__c).dealer_account__r.name;
                        }
                        // case_creatingcaselineitem  //
                        if(objCase.Opportunity__c != null){                
                            objCase.Opportunity_Owner__c=mapCaseOppDealer.get(objCase.opportunity__c).ownerid;
                            objCase.Opportunity_Number__c=mapCaseOppDealer.get(objCase.opportunity__c).Opportunity_Number__c;               
                        }
                        if(objCase.Opportunity__c == null){                
                            objCase.Opportunity_Owner__c= null;
                            objCase.Opportunity_Number__c=null;               
                        }
                        // case_creatingcaselineitem //
                    }
                    if(null!=mapCaseOrigin && null !=mapCaseOrigin.get(objCase.Requested_By_HON_Internal__c ))
                        objCase.On_Behalf_of_End_User_Status__c=mapCaseOrigin.get(objCase.Requested_By_HON_Internal__c).contact_status__c;
                //}
                if((objCase.type==null)||(objCase.Time_of_first_Type_Change__c==null))
                {
                    objCase.Time_of_first_Type_Change__c = System.Now();
                }
                else
                {
                    if(objCase.id!=null)
                    {
                        if(oldmap.get(objCase.Id).Time_of_first_Type_Change__c!=null && objCase.Time_of_first_Type_Change__c!=oldmap.get(objCase.Id).Time_of_first_Type_Change__c)
                        {
                            objCase.Time_of_first_Type_Change__c = oldmap.get(objCase.Id).Time_of_first_Type_Change__c;
                        }
                    }
                    else
                    if((objCase.type==null)||(objCase.Time_of_first_Type_Change__c==null))
                    {
                        objCase.Time_of_first_Type_Change__c = System.Now();
                    }
                }               
                if((Trigger.isinsert ||( Trigger.isupdate && OldMap.get(objCase.id).Sub_Status__c != objCase.Sub_Status__c))   && objCase.Case_Record_Type__c=='Engine Rentals')
                {
                    DateTime currDate = System.Now();
                    if (objCase.Status== 'On Hold')
                    {
                        if(objCase.Sub_Status__c=='Shipment')
                        {
                            objCase.Shipment_Sub_Status_Selected__c = currDate;
                            objCase.Shipment_Sub_Status_Ended__c = Null;
                        }
                        if(objCase.Sub_Status__c=='Removal')
                        {
                            objCase.Removal_Sub_Status_Selected__c = currDate;
                            objCase.Removal_Sub_Status_Ended__c = Null;
                        }
                        if( objCase.Sub_Status__c=='Other')
                        {
                            objCase.Others_Sub_Status_Selected__c = currDate;
                            objCase.Others_Sub_Status_Ended__c = Null;
                        }
                        if (objCase.Sub_Status__c=='DSO')
                        {
                            objCase.DSO_Sub_Status_Selected__c = currDate;
                            objCase.DSO_Sub_Status_Ended__c = Null;
                        }
                    }
                }
                // PortalCaseAutoClose //
                /* commented for INC000009169188                 
                if(objCase.status == 'On Hold' && (Trigger.isinsert || (Trigger.isupdate && (oldmap.get(objCase.Id).status != objCase.status))))
                {
                    objCase.On_Hold_start_time__c= System.now();
                }
                else if(Trigger.isupdate && objCase.status != 'On Hold' && oldmap.get(objCase.Id).status != objCase.status && oldmap.get(objCase.Id).status == 'On Hold')
                {
                    if(objCase.On_Hold_time_temp__c!=null && objCase.On_Hold_start_time__c !=null)
                    {
                        objCase.On_Hold_time_temp__c = objCase.On_Hold_time_temp__c +((System.now().getTime()  - objCase.On_Hold_start_time__c.getTime())/ (1000.0*60.0*60.0));
                    }             
                    else if(objCase.On_Hold_start_time__c!=null)
                    {
                        objCase.On_Hold_time_temp__c =(System.now().getTime()  - objCase.On_Hold_start_time__c.getTime())/ (1000.0*60.0*60.0);
                    }          
                    objCase.On_Hold_start_time__c= null;
                }    
                If (objCase.RecordTypeId==label.Orders_Rec_ID || objCase.RecordTypeId==label.QuotesRecordID|| objCase.RecordTypeId ==label.Repair_Overhaul_RT_ID || objCase.RecordTypeId ==label.OEM_Quotes_Orders_ID || objCase.RecordTypeId ==label.D_S_Order )
                {
                    if((objCase.status == 'On Hold'  && objCase.Sub_Status__c=='Customer Hold')&& (Trigger.isinsert || (Trigger.isupdate && (oldmap.get(objCase.Id).status != objCase.status || oldmap.get(objCase.Id).Sub_Status__c !='Customer Hold'))))
                    {
                        objCase.Customer_Hold_Sub_Status_Started__c = System.now();
                    }
                    else if(Trigger.isupdate && ((objCase.Status=='On Hold'&& (objCase.Sub_Status__c!='Customer Hold' && oldmap.get(objCase.Id).Sub_Status__c =='Customer Hold'))|| 
                    ((objCase.Status!='On Hold' && oldmap.get(objCase.Id).Status =='On Hold') && oldmap.get(objCase.Id).Sub_Status__c =='Customer Hold')))
                    {
                        if(objCase.Customer_Hold_Sub_Status_Temp__c!=null && objCase.Customer_Hold_Sub_Status_Started__c !=null)
                        {
                            objCase.Customer_Hold_Sub_Status_Temp__c =objCase.Customer_Hold_Sub_Status_Temp__c +((System.now().getTime()  - objCase.Customer_Hold_Sub_Status_Started__c.getTime())/ (1000.0*60.0*60.0));
                        }             
                        else if(objCase.Customer_Hold_Sub_Status_Started__c !=null)
                        {
                            objCase.Customer_Hold_Sub_Status_Temp__c =(System.now().getTime()  - objCase.Customer_Hold_Sub_Status_Started__c.getTime())/ (1000.0*60.0*60.0);
                        }          
                        objCase.Customer_Hold_Sub_Status_Started__c= null;
                    }  
                } commented for INC000009169188              
                if((objCase.status=='Open' || objCase.status=='Re-open') && (Trigger.isinsert || (Trigger.isupdate && (oldmap.get(objCase.Id).status != objCase.status)))) 
                {
                    objCase.SLA_Flag_Case_age__c = system.now();      
                }
                // PortalCaseAutoClose //
                ///////////////////   Sprint 5&6 Common methods -end   ///////////////////////////
                if(('Insert').equals(strDMLMode)||(('Update').equals(strDMLMode) && oldMap.get(objCase.id).RnOSAPCases__c != objCase.RnOSAPCases__c))
                {
                    if(('Insert').equals(strDMLMode))
                    {
                        strSize=objCase.origin.length();
                    }
                    else
                    {
                        strSize = objCase.Mail_Box_Name__c.length(); 
                    }
                    if(strSize > 6)
                    if(('Insert').equals(strDMLMode))
                    {
                        origin=objCase.origin.substring(6,strSize);
                    }
                    else
                    {
                        origin = objCase.Mail_Box_Name__c.substring(6,strSize);
                    }
                    if(null!=mapOriginChange.get(origin))
                    origin=mapOriginChange.get(origin).CaseOriginName__c;
                    //End Sr#370483
                    //For GSS Integration
                    else if(origin == 'Aero GSE Orders'){
                        origin = 'Aero GSE Orders';                                                            
                    }//End GSS
                    if(strSize > 6)
                    {
                        Contact objCont = mapCaseOrigin.get(objCase.ContactId);
                        if(null!=objcont)
                        {                   
                            List<Agent_contact_mapping__C> listACM = objCont.Agent_Contact_Mappings__r;
                            for(Agent_contact_mapping__C objACM : listACM)
                            {
                                if(objCase.ContactId==objACM.Contact__c && origin==objACM.Process__c && 
                                (objCase.RecordTypeId == label.Repair_Overhaul_RT_ID || objCase.RecordTypeId == label.Orders_Rec_ID || objCase.RecordTypeId == label.D_S_Order || objCase.RecordTypeId == label.OEM_Quotes_Orders_ID  || objCase.RecordTypeId == label.GSS_Quotes_Orders || objCase.RecordTypeId == label.GSS_Technical_Support))
                                { 
                                    objCase.R_O_Case_Origin__c = origin;
                                    lstProd2.add(objCase.R_O_Case_Origin__c);
                                    System.debug('Line@1197'+objCase.origin);
                                    if(('Insert').equals(strDMLMode))
                                    {
                                        objCase.Government_Compliance_SM_M_Content__c = 'Undetermined';
                                        objCase.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';
                                    }
                                    System.debug('Line@1203'+objCase.origin);
                                    if(origin == DSRO){
                                        origin = 'R&O D&S';
                                    }
                                    //Moved the value of origin to Email box origin before it is hardcoed as "Email" for the SR448416
                                    else if(origin=='D&S R&O Internal')
                                    {                                        
                                        objCase.Emailbox_Origin__c = objCase.Origin;
                                        objCase.Origin='Email';
                                        objCase.Classification__c='D&S R&O Internal';
                                    }
                                    else if(origin=='R&O Canada')
                                    {
                                        objCase.Emailbox_Origin__c = objCase.Origin;
                                        objCase.Origin='Email';
                                        objCase.Classification__c='CSO Repair/Overhaul';
                                        objCase.Sub_Class__c='Toronto/PEI';
                                        objCase.Type='Repair Inquiry';
                                    }
                                    else if(origin=='BGA R&O Internal')
                                    {
                                        objCase.Emailbox_Origin__c = objCase.Origin;
                                        objCase.Origin='Email';
                                        objCase.Classification__c='BGA R&O Internal';
                                    }
                                    else if(origin=='ATR R&O Internal')
                                    {
                                        objCase.Emailbox_Origin__c = objCase.Origin;
                                        objCase.Origin='Email';
                                        objCase.Classification__c='ATR R&O Internal';
                                    }         
                                    //GSS INtergation
                                    else if(origin == 'Aero GSE Orders'){                                                                                                            
                                        objCase.Emailbox_Origin__c = objCase.Origin;
                                        objCase.Origin='Email';
                                        objCase.Classification__c='GSE Orders';
                                        if(objACM.CSR__r.IsActive == true)                             
                                            objCase.OwnerId = objACM.CSR__c;
                                        else{
                                            objCase.OwnerId = mapOwnerIds.get(objCase.Emailbox_Origin__c);
                                            }
                                    }
                                    else if(origin == 'Aero GSE Quotes'){                             
                                        objCase.Emailbox_Origin__c = objCase.Origin;
                                        objCase.Origin='Email';
                                        objCase.Classification__c='GSE Quotes';                             
                                        if(objACM.CSR__r.IsActive == true)                             
                                            objCase.OwnerId = objACM.CSR__c;
                                        else
                                            objCase.OwnerId = mapOwnerIds.get(objCase.Emailbox_Origin__c);
                                    }
                                    else if(origin == 'Aero GSE Support'){                             
                                        objCase.Emailbox_Origin__c = objCase.Origin;
                                        objCase.Origin='Email';
                                        objCase.Classification__c='GSE Technical Support';                              
                                        if(objACM.CSR__r.IsActive == true)                             
                                            objCase.OwnerId = objACM.CSR__c;
                                        else
                                            objCase.OwnerId = mapOwnerIds.get(objCase.Emailbox_Origin__c);
                                    }
                                    else if(origin == 'Aero GSE Vendor Support'){                             
                                        objCase.Emailbox_Origin__c = objCase.Origin;
                                        objCase.Origin='Email';
                                        objCase.Classification__c='GSE Vendor Support';                             
                                        if(objACM.CSR__r.IsActive == true)                             
                                            objCase.OwnerId = objACM.CSR__c;
                                        else
                                            objCase.OwnerId = mapOwnerIds.get(objCase.Emailbox_Origin__c);
                                    }
                                    System.debug('*********** ORIGIN 1'+ origin + 'Agent Contact ' + objCase.Agent_Contact_Flag__c);
                                    if(origin=='D&Sorders' || origin=='D&Squotes' || origin=='R&O D&S' || origin=='ATR R&O Internal' 
                                    || origin=='BGA R&O Internal' || origin=='D&S R&O Internal' || origin=='R&O Canada' || origin=='R&O Engines' 
                                    || origin=='R&O FastShop' || origin=='R&O MechComponents' || origin=='R&O W&B/Greer' || origin=='R&O APU' 
                                    || origin=='R&O Avionics' || origin=='R&O Bournemouth' || origin=='R&O Toulouse' || origin=='R&O Raunheim' 
                                    || origin=='R&O Basingstoke' || origin == 'ATR OEM Airbus' || origin =='ATR OEM Boeing' || origin == 'ATR OEM Components' || origin == 'Aero GSE Orders' || origin == 'Aero GSE Quotes' || origin == 'Aero GSE Support' || origin == 'Aero GSE Vendor Support')
                                    {
                                    System.debug('*********** ORIGIN 2'+ origin + 'Agent Contact ' + objCase.Agent_Contact_Flag__c);
                                        objCase.Agent_Contact_Flag__c = True;
                                        objCase.User_Signature__c = objACM.CSR__r.Signature1__c;
                                    }                            
                                }
                            }
                        }   
                    }                    
                }
                if((objCase.Case_Record_Type__c == 'AOG' || objCase.Case_Record_Type__c == 'Orders')
                && (objCase.Sub_Class__c == 'SPEX/Exchange' || objCase.Detail_Class__c == 'SPEX/Exchange')
                && (objCase.Sales_Order_Number__c != null) && (objCase.SPEX_Exchange__c != true)){                  
                    objCase.SPEX_Exchange__c = true;
                }
                System.debug('Line@1281'+objCase.origin);           
                System.debug('Line@1281'+objCase.Emailbox_Origin__c);
                System.debug('ANU-OWNER-3343'+objcase.ownerid);
            }
        }
        catch(exception e) 
        {
            SYSTEM.DEBUG('Exception '+e);
        }
        if(bolChangesPresent1)
        {   
            Map<Id,Contact> mapROCaseOrigin = new Map<Id,Contact>([select id,(select id,CSR__c,CSR__r.Signature1__c,CSR__r.IsActive,Contact__c,Process__c from Agent_Contact_Mappings__r where
            Agent_Contact_Mapping__c.Contact__c in:lstConID and Agent_Contact_Mapping__c.Process__c in:lstProd) from contact where id in :lstConID] ) ;    
            for(Case objCase:listObjCaseNew) 
            {
                System.debug('Line@1295'+objCase.origin);           
                System.debug('Line@1295'+objCase.Emailbox_Origin__c);
                System.debug('ANU-OWNER-3357'+objcase.ownerid);
                Contact objcont = mapROCaseOrigin.get(objCase.ContactId);
                if(null!=objcont)
                { 
                    List<Agent_contact_mapping__C> newACM = mapROCaseOrigin.get(objCase.ContactId).Agent_Contact_Mappings__r;
                    for(Agent_contact_mapping__C newObject:newACM){
                        if( objCase.R_O_Case_Origin__c == newObject.Process__c && 
                        (objCase.recordtypeid == label.Repair_Overhaul_RT_ID || objCase.recordtypeid == label.Orders_Rec_ID ||
                        objCase.recordtypeid == label.D_S_Order || objCase.recordtypeid == label.OEM_Quotes_Orders_ID ||
                        objCase.recordtypeid == label.GSS_Quotes_Orders || objCase.recordtypeid == label.GSS_Technical_Support ||
                        objCase.recordtypeid == label.Rotable_Core_RecordType_Id))       {  
                            if(newObject.CSR__r.IsActive == true){                                
                                objCase.OwnerId = newObject.CSR__c;   
                            }else{                                
                                if(mapOwnerIds.size() > 0){
                                    objCase.OwnerId = mapOwnerIds.get(objCase.Emailbox_Origin__c);
                                }
                            }
                        }
                    }
                }
                System.debug('Line@1317'+objCase.origin);           
                System.debug('Line@1317'+objCase.Emailbox_Origin__c);
                System.debug('ANU-OWNER-513'+objcase.ownerid);
            }            
        }       
            TriggerInactive.AvoidRecursionCase=false;
            }
    } // End of the RnOCaseOwnerAssignOnCreationMethod
    
    //code added by krishna for SR#INC000006598776-Technical Support Engineers currently must send individual emails to alert various constituents that there has been a technical AOG. trigger code called After Insert/Update - End
 public void sendAOGAlertMethod(List<Case> listObjCaseNew,Map<ID,Case> oldMap,String strDMLMode, Map<id,Case> lstCas){
 System.debug(' *************** IN  IN sendAOGAlertMethod ' );
 for(case c: listObjCaseNew ){
                
               //code added by krishna for SR#INC000006598776-Technical Support Engineers currently must send individual emails to alert various constituents that there has been a technical AOG. trigger code called After Insert/Update - Start
                if(c.RecordTypeid!=null && (c.RecordTypeid==label.TechnicalIssue_RecordTypeID) && c.aog__c==true)    {
                    system.debug('CCPM Aog Alert'+c.aog__c);
                 String Uid =userinfo.getuserid();
                if( Uid !='005300000042rPL' &&( c.Sub_Class__c ==null || c.Resolution__c ==null || c.aircraft_location__c ==null 
                || c.Supported_Products__c == null|| c.aircraft_type__c==null || c.subject ==null 
                || c.Aircraft_Serial_Number__c==null || c.Aircraft_tail_Number__c==null || c.Expected_Update__c==null)){
                c.addError('If AOG check box is checked Sub Class, Expected Update, Resolution, Supported Products,Subject, Aircraft Type, Aircraft Location, Aircraft Tail Number, Aircraft Serial Number are mandatory. Please check and fill necessary details');
                }else if(Trigger.isinsert || (c.Sub_Class__c !=oldmap.get(c.id).sub_class__c || c.Resolution__c !=oldmap.get(c.id).Resolution__c 
                || c.aircraft_location__c !=oldmap.get(c.id).aircraft_location__c || c.Supported_Products__c!=oldmap.get(c.id).Supported_Products__c
                || c.aircraft_type__c !=oldmap.get(c.id).aircraft_type__c || c.subject !=oldmap.get(c.id).subject 
                || c.Aircraft_Serial_Number__c!=oldmap.get(c.id).Aircraft_Serial_Number__c ||
                c.Aircraft_tail_Number__c!=oldmap.get(c.id).Aircraft_tail_Number__c || c.Expected_Update__c!=oldmap.get(c.id).Expected_Update__c || c.aog__c!=oldmap.get(c.id).aog__c)){
                    if(c.Aircraft_Type__c!=null)
                        mapCaseIdACTname.put(c.id,lstCas.get(c.id).Aircraft_Type__r.name);
                    if(c.Supported_Products__c!=null)
                        mapCasesupported.put(c.id,lstCas.get(c.id).Supported_Products__r.name);
                }
                }
                if(mapCaseIdACTname!=null && mapCaseIdACTname.size()>0 && null!=mapCaseIdACTname.get(c.id))
                {
                
                System.debug(' *************** IN  IN START ' );
                if(mapCaseIdACTname.get(c.id).contains('Airbus'))
                {
                  
                    Cases=new list<case>();
                    if(Mapgroupcase.keySet().contains('Airbus'))
                    {
                        Mapgroupcase.get('Airbus').add(c);
                    }
                    else
                    {
                        Cases.add(c);
                        Mapgroupcase.put('Airbus',Cases);
                    }
                }
                if( mapCaseIdACTname.get(c.id).contains('Boeing'))
                {
                    
    
                    Cases=new list<case>();
                    if(Mapgroupcase.keySet().contains('Boeing'))
                    {
                    Mapgroupcase.get('Boeing').add(c);
                    }
                    else
                    {
                    Cases.add(c);
                    Mapgroupcase.put('Boeing',cases);
                    }
                }
                if( mapCaseIdACTname.get(c.id).contains('Bombardier') && c.SBU_w2c__c=='ATR')
                {
                    Cases=new list<case>();
                    if(Mapgroupcase.keySet().contains('Bombardier ATR'))
                    {
                        Mapgroupcase.get('Bombardier ATR').add(c);
                    }
                    else{
                        Cases.add(c);
                        Mapgroupcase.put('Bombardier ATR',Cases);
                    }
                }            
                if( mapCaseIdACTname.get(c.id).contains('Airlines'))
                {            
                    Cases=new list<case>();
                    if(Mapgroupcase.keySet().contains('Airlines'))
                    {
                    Mapgroupcase.get('Airlines').add(c);
                    }else{
                    Cases.add(c);
                    Mapgroupcase.put('Airlines',Cases);}
                }

                if( mapCaseIdACTname.get(c.id).contains('Helicopter'))
                {
                    Cases=new list<case>();
                    if(Mapgroupcase.keySet().contains('Helicopter'))
                    {
                    Mapgroupcase.get('Helicopter').add(c);
                    }
                    else{
                    Cases.add(c);
                    Mapgroupcase.put('Helicopter',Cases);}
                }
                if(mapCaseIdACTname.get(c.id).contains('Gulfstream'))
                {
                                
                    Cases=new list<case>();
                    if(Mapgroupcase.keySet().contains('Gulfstream'))
                    {
                    Mapgroupcase.get('Gulfstream').add(c);
                    }
                    else{
                    Cases.add(c);
                    Mapgroupcase.put('Gulfstream',Cases);}
                }
            
                if( mapCaseIdACTname.get(c.id).contains('Dassault'))
                {
                     
                     
                        Cases=new list<case>();
                        if(Mapgroupcase.keySet().contains('Dassault'))
                        {
                        Mapgroupcase.get('Dassault').add(c);
                        }
                        else{
                        Cases.add(c);
                        Mapgroupcase.put('Dassault',Cases);}
                    }
                 if(mapCaseIdACTname.get(c.id).contains('Pilatus'))
                    {
                        Cases=new list<case>();
                        if(Mapgroupcase.keySet().contains('Pilatus'))
                        {
                        Mapgroupcase.get('Pilatus').add(c);
                        }
                        else{
                        Cases.add(c);
                        Mapgroupcase.put('Pilatus',Cases);}                
                    }
                /*if(mapCaseIdACTname.get(c.id).contains('Learjet'))
                { 
                    Cases=new list<case>();
                    if(Mapgroupcase.keySet().contains('Learjet'))
                    {
                    Mapgroupcase.get('Learjet').add(c);
                    }
                    else{
                    Cases.add(c);
                    Mapgroupcase.put('Learjet',Cases);}
                }
                if(mapCaseIdACTname.get(c.id).contains('Bombardier') && c.SBU_w2c__c=='BGA')
                { 
                    Cases=new list<case>();
                    if(Mapgroupcase.keySet().contains('BombardierBGA'))
                    {
                    Mapgroupcase.get('BombardierBGA').add(c);
                    }
                    else{
                    Cases.add(c);
                    Mapgroupcase.put('BombardierBGA',Cases);}
                }
                if( mapCaseIdACTname.get(c.id).contains('Hawker'))
                {
                    if(mapCaseIdACTname.get(c.id).contains('Hawker'))
                    {
                    Cases=new list<case>();
                    if(Mapgroupcase.keySet().contains('Hawker'))
                    {
                    Mapgroupcase.get('Hawker').add(c);
                    }
                    else{
                    Cases.add(c);
                    Mapgroupcase.put('Hawker',Cases);}
                    }
                  }
                  if (mapCaseIdACTname.get(c.id).contains('Cessna'))
                  {
                    Cases=new list<case>();
                    if(Mapgroupcase.keySet().contains('Cessna'))
                    {
                    Mapgroupcase.get('Cessna').add(c);
                    }
                    else{
                    Cases.add(c);
                    Mapgroupcase.put('Cessna',Cases);}
                    }
                
            
                if(mapCaseIdACTname.get(c.id).contains('Embraer') && c.SBU_w2c__c=='BGA')
                {
                    if(Mapgroupcase.keySet().contains('Embraer BGA'))
                    {
                    Cases=new list<case>();
                    Mapgroupcase.get('Embraer BGA').add(c);
                    }
                    else{
                    Cases.add(c);
                    Mapgroupcase.put('Embraer BGA',Cases);}
                }

                if(mapCaseIdACTname.get(c.id).contains('Embraer') && c.SBU_w2c__c=='ATR')
                {  
                    Cases=new list<case>();
                    if(Mapgroupcase.keySet().contains('Embraer ATR'))
                    {
                    Mapgroupcase.get('Embraer ATR').add(c);
                    }
                    else{
                    Cases.add(c);
                    Mapgroupcase.put('Embraer ATR',Cases);}
                }                   
            
            }
            system.Debug('************ Before Supported Product Code ' + mapCasesupported + ' ******* ' + mapCaseIdACTname + ' Mapgroupcase ' + Mapgroupcase);
             if((mapCasesupported!=null && mapCasesupported.size()>0) && (mapCasesupported.get(c.id).contains('TPE331 - Controls')||mapCasesupported.get(c.id).contains('ATF3 - Controls')||mapCasesupported.get(c.id).contains('CFE738 - Controls')||mapCasesupported.get(c.id).contains('DEEC')||mapCasesupported.get(c.id).contains('DEEC 731 Digital Electronic Engine Control')||mapCasesupported.get(c.id).contains('Electronic Fuel Controls')
            ||mapCasesupported.get(c.id).contains('HTF7000 - Controls')||mapCasesupported.get(c.id).contains('TFE731 - Controls')||mapCasesupported.get(c.id).contains('Air Turbine Starter')||mapCasesupported.get(c.id).contains('Anti-Ice Valves - ATR')||mapCasesupported.get(c.id).contains('Anti-Ice Valves - BGA')||mapCasesupported.get(c.id).contains('APU Fuel Controls')
            ||mapCasesupported.get(c.id).contains('CF6-80C2 / 80E1 Fuel Controls')||mapCasesupported.get(c.id).contains('EEC')||mapCasesupported.get(c.id).contains('ESA')||mapCasesupported.get(c.id).contains('Flap Actuator')||mapCasesupported.get(c.id).contains('Fuel Contols - RR250')||mapCasesupported.get(c.id).contains('Fuel Controls LTS-101')
            ||mapCasesupported.get(c.id).contains('Fuel Controls PW')||mapCasesupported.get(c.id).contains('Fuel Controls - PWC PT6 & P108')||mapCasesupported.get(c.id).contains('Mechanical Fuel Controls')|mapCasesupported.get(c.id).contains('Oil Cooler')||mapCasesupported.get(c.id).contains('Starter Control Valves')||mapCasesupported.get(c.id).contains('Thrust Reverser Actuation')||mapCasesupported.get(c.id).contains('Electric Power Generation')
            ||mapCasesupported.get(c.id).contains('Power Distribution/Conversion')||mapCasesupported.get(c.id).contains('Electronic Fuel Controls')||mapCasesupported.get(c.id).contains('Air Turbine Starters')||mapCasesupported.get(c.id).contains('ATA 79 Heat Exchanger')||mapCasesupported.get(c.id).contains('ECS Controllers')||mapCasesupported.get(c.id).contains('Engine Bleed Air - ATA 75')))
            {                         
                Cases=new list<case>();
                if(Mapgroupcase.keySet().contains('Components'))
                {
                Mapgroupcase.get('Components').add(c);
                }
                else{
                Cases.add(c);
                Mapgroupcase.put('Components',Cases);}
            }
            
            system.Debug('************ Before Miscellaneous Code ' + mapCasesupported + ' ******* ' + mapCaseIdACTname + ' Mapgroupcase ' + Mapgroupcase);
            Boolean b1 = mapCaseIdACTname!=null;
            Boolean b2 = mapCaseIdACTname.size()>0;
            Boolean b3 = mapCasesupported!=null;
            Boolean b4 = mapCasesupported.size()>0;
            Boolean b5 = Mapgroupcase==null;
            Boolean b6 = Mapgroupcase.size()== 0;
            Boolean b7 = Mapgroupcase.keySet()==null;
            
            if(((mapCaseIdACTname!=null && mapCaseIdACTname.size()>0)||(mapCasesupported!=null && mapCasesupported.size()>0)) && 
            Mapgroupcase.size()==0) {

            System.debug(' *************** IN Mapgroupcase ' + mapCaseIdACTname + '********' + Mapgroupcase );
                Cases=new list<case>();
                if(Mapgroupcase.keySet().contains('Miscellaneous'))
                {
                Mapgroupcase.get('Miscellaneous').add(c);
                }
                else{
                Cases.add(c);
                Mapgroupcase.put('Miscellaneous',Cases);}
                
                System.debug(' *************** IN Mapgroupcase 2' + mapCaseIdACTname + '********' + Mapgroupcase );
            }
            
            system.Debug('************ Before AOGAlert ' + Mapgroupcase);
            if(Mapgroupcase!=null && Mapgroupcase.size()>0)
            {
                AOGAlert(Mapgroupcase);            
            } 
            }
     
     adding code for Fss activation Email to case response---start

   List<Messaging.SingleEmailMessage> FssEmailsList_new = new List<Messaging.SingleEmailMessage>();
   List<Messaging.SingleEmailMessage> FssEmailsList_closed = new List<Messaging.SingleEmailMessage>();
   List<Messaging.SingleEmailMessage> JXAccounts_Msg_List = new List<Messaging.SingleEmailMessage>();//Added for JX Accounts
   
   String FssRecordType = label.FssActivationCaseRecordTypeId;
   string conid=Label.UFR_Cont_Id;//Need to change this id for contact
   string emaiTempId = label.FssNewCaseTemplate;
   string emaiTempId_fssclose = label.FssActivation_Case_Close_Email;
   string emaiTempId_Jxacc  = label.JXAccountsEmailTemplateID;
for(case caseobj :listobjCaseNew){
system.debug('yes executed');
 

  if(('Insert').equals(strDMLMode)  && caseobj.status=='New' &&(caseobj.Emailbox_Origin__c == 'Email-FSSActivations'&&null!=caseobj.Emailbox_Origin__c || caseobj.Origin  == 'Email'&&null!=caseobj.Origin) && caseobj.SuppliedEmail!=null && caseobj.RecordTypeId==FssRecordType && label.FSSActivationNotificationswitch=='on'){
                     Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();  
                      
                     String[] toAddresses = new String[] {caseobj.SuppliedEmail};
                 message.setToAddresses(toAddresses);
                 message.setTargetObjectId(conid);
                     message.setWhatId(caseobj.Id); 
                     message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);           
                     message.setBccSender(false);             
                     message.setUseSignature(false);
                     message.setSaveAsActivity(false);
                     message.setTemplateId(emaiTempId); 
                 FssEmailsList_new.add(message);
               
 }
 ////////JX Accounts need to Email Notifications///start///
 
   if(('Insert').equals(strDMLMode)  && caseobj.status=='New' &&(caseobj.Emailbox_Origin__c == 'Email-JXAccounts' &&null!=caseobj.Emailbox_Origin__c || caseobj.Origin  == 'Email' &&null!=caseobj.Origin) && caseobj.SuppliedEmail!=null && caseobj.RecordTypeId==label.JXAccounts_RecordType_Id && label.JXAccountsEmailnotificationswitch=='on'){
                     Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();  
                      
                     String[] toAddresses = new String[] {caseobj.SuppliedEmail};
                 message.setToAddresses(toAddresses);
                 message.setTargetObjectId(conid);
                     message.setWhatId(caseobj.Id); 
                     message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);           
                     message.setBccSender(false);             
                     message.setUseSignature(false);
                     message.setSaveAsActivity(false);
                     message.setTemplateId(emaiTempId_Jxacc); 
                 JXAccounts_Msg_List.add(message);
               
 }
 ////////JX Accounts need to Email Notifications///End///
 
 
      if(trigger.isupdate && Trigger.isAfter && TriggerCheck.firstIntEscRun && caseobj.IsClosed !=oldmap.get(caseobj.id).IsClosed && caseobj.IsClosed == TRUE && caseobj.status=='done' && caseobj.Origin=='email' && caseobj.SuppliedEmail!=null && caseobj.RecordTypeId==FssRecordType && label.FSSActivationNotificationswitch=='on'){
      system.debug('updateing the case');
      system.debug('case closed mail called');
      Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();  
                      
                     String[] toAddresses = new String[] {caseobj.SuppliedEmail};
                 message.setToAddresses(toAddresses);
                 message.setTargetObjectId(conid);
                     message.setWhatId(caseobj.Id); 
                     message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);           
                     message.setBccSender(false);             
                     message.setUseSignature(false);
                     message.setSaveAsActivity(false);
                     message.setTemplateId(emaiTempId_fssclose); 
                 FssEmailsList_closed.add(message);
                    
          
                
 }
}    

if(FssEmailsList_new.size()>0){

    Messaging.sendEmail(FssEmailsList_new);
  system.debug('message sent');
}

       if(FssEmailsList_closed.size()>0){
           
      system.debug('FssEmailsList_closed size'+FssEmailsList_closed.size());
      Messaging.sendEmail(FssEmailsList_closed);
      system.debug('message sent');


}
     if(JXAccounts_Msg_List.size()>0){
           
      system.debug('JXAccounts_Msg_List size'+JXAccounts_Msg_List.size());
      Messaging.sendEmail(JXAccounts_Msg_List);
      system.debug('message sent');


}

adding code for Fss activation Email to case response---End
     
        }
    //code added by krishna for SR#INC000006598776-Technical Support Engineers currently must send individual emails to alert various constituents that there has been a technical AOG. trigger code called After Insert/Update - Start
    public void AOGAlert(map<string,list<case>> Mapgroupcase){
        for(string grpname:Mapgroupcase.keyset()){            
            if(grpname=='Airbus')
            {
                List<airbus__C> airbus = airbus__c.getall().values();
                if(airbus !=null && airbus.size()>0)
                {
                    MailToAddress=new list<string>();
                    for(airbus__C a:airbus)
                    {
                        if(a.name__c!=null)
                        {
                            MailToAddress.add(a.name__c);
                        }
                    }
                }
            }
            else if(grpname=='Boeing')
            {
                List<Boeing__C> Boeing = Boeing__c.getall().values();
                if(Boeing !=null && Boeing.size()>0){
                    MailToAddress=new list<string>();
                    for(Boeing__C a:Boeing)
                    {
                        if(a.name__c!=null)
                        {
                        MailToAddress.add(a.name__c);
                        }            
                    }
                }
            }
            else if(grpname=='Bombardier ATR')
            {
                List<Bombardier_ATR__C> Bombardier_ATR = Bombardier_ATR__c.getall().values();
                if(Bombardier_ATR !=null && Bombardier_ATR.size()>0)
                {
                    MailToAddress=new list<string>();
                    for(Bombardier_ATR__C a:Bombardier_ATR)
                    {
                        if(a.name__c!=null)
                        {
                        MailToAddress.add(a.name__c);
                        }            
                    }
            
                }
            }
            else if(grpname=='Airlines')
            {
                List<Airlines__C> Airlines = Airlines__c.getall().values();
                if(Airlines !=null && Airlines.size()>0){
                    MailToAddress=new list<string>();
                    for(Airlines__C a:Airlines)
                    {
                        if(a.name__c!=null)
                        {
                        MailToAddress.add(a.name__c);
                        }            
                    }
            
                }
            }
            else if(grpname=='Helicopter')
            {
                List<Helicopters__c> Helicopter = Helicopters__c.getall().values();
                if(Helicopter !=null && Helicopter.size()>0){
                    MailToAddress=new list<string>();
                    for(Helicopters__c a:Helicopter)
                    {
                        if(a.name__c!=null)
                        {
                        MailToAddress.add(a.name__c);
                        }            
                    }
            
                }    
            }
            else if(grpname=='Gulfstream')
            {
                List<Gulfstream__C> Gulfstream = Gulfstream__c.getall().values();
                if(Gulfstream !=null && Gulfstream.size()>0){
                    MailToAddress=new list<string>();
                    for(Gulfstream__C a:Gulfstream)
                    {
                        if(a.name__c!=null)
                        {
                        MailToAddress.add(a.name__c);
                        }            
                    }
            
                }
            }
            else if(grpname=='Dassault')
            {
                List<Dassault__C> Dassault = Dassault__c.getall().values();
                if(Dassault !=null && Dassault.size()>0){
                    MailToAddress=new list<string>();
                    for(Dassault__C a:Dassault)
                    {
                        if(a.name__c!=null)
                        {
                        MailToAddress.add(a.name__c);
                        }            
                    }
            
                }
            }
            
            else if(grpname=='Pilatus')
            {
                List<Pilatus__C> Pilatus = Pilatus__c.getall().values();
                if(Pilatus !=null && Pilatus.size()>0){
                    MailToAddress=new list<string>();
                    for(Pilatus__C a:Pilatus)
                    {
                        if(a.name__c!=null)
                        {
                        MailToAddress.add(a.name__c);
                        }            
                    }
            
                }
            }
            
            /*else if(grpname=='Learjet')
            {
                List<Learjet__C> Learjet = Learjet__c.getall().values();
                if(Learjet !=null && Learjet.size()>0){
                    MailToAddress=new list<string>();
                    for(Learjet__C a:Learjet)
                    {
                        if(a.name__c!=null)
                        {
                        MailToAddress.add(a.name__c);
                        }            
                    }
            
                }
            }
            
            else if(grpname=='BombardierBGA')
            {
                List<BombardierBGA__C> BombardierBGA = BombardierBGA__c.getall().values();
                if(BombardierBGA !=null && BombardierBGA.size()>0){
                    MailToAddress=new list<string>();
                    for(BombardierBGA__C a:BombardierBGA)
                    {
                        if(a.name__c!=null)
                        {
                        MailToAddress.add(a.name__c);
                        }            
                    }
            
                }
            }
            
            else if(grpname=='Hawker')
            {
                List<Hawker__C> Hawker = Hawker__c.getall().values();
                if(Hawker !=null && Hawker.size()>0){
                    MailToAddress=new list<string>();
                    for(Hawker__C a:Hawker)
                    {
                        if(a.name__c!=null)
                        {
                        MailToAddress.add(a.name__c);
                        }            
                    }
            
                }
            }
            else if(grpname=='Cessna')
            {
                List<Cessna__C> Cessna = Cessna__c.getall().values();
                if(Cessna !=null && Cessna.size()>0){
                    MailToAddress=new list<string>();
                    for(Cessna__C a:Cessna)
                    {
                        if(a.name__c!=null)
                        {
                        MailToAddress.add(a.name__c);
                        }            
                    }
            
                }
            }                                         
            else if(grpname=='Embraer BGA')
            {
                List<Embraer_BGA__C> Embraer_BGA = Embraer_BGA__c.getall().values();
                if(Embraer_BGA !=null && Embraer_BGA.size()>0){
                    MailToAddress=new list<string>();
                    for(Embraer_BGA__C a:Embraer_BGA)
                    {
                        if(a.name__c!=null)
                        {
                        MailToAddress.add(a.name__c);
                        }            
                    }
            
                }
            }
            else if(grpname=='Embraer ATR')
            {
                List<Embraer_ATR__C> Embraer_ATR = Embraer_ATR__c.getall().values();
                if(Embraer_ATR !=null && Embraer_ATR.size()>0){
                    MailToAddress=new list<string>();
                    for(Embraer_ATR__C a:Embraer_ATR)
                    {
                        if(a.name__c!=null)
                        {
                        MailToAddress.add(a.name__c);
                        }            
                    }
            
                }
            }
            else if(grpname=='Components')
            {
                List<Components__C> Components = Components__c.getall().values();
                if(Components !=null && Components.size()>0){
                    MailToAddress=new list<string>();
                    for(Components__C a:Components)
                    {
                        if(a.name__c!=null)
                        {
                        MailToAddress.add(a.name__c);
                        }            
                    }
            
                }
            }
            else if(grpname=='Miscellaneous')
            {
            System.debug('*********** In Miscellaneous ' + miscellaneous__c.getall().values());
                List<miscellaneous__C> miscellaneous = miscellaneous__c.getall().values();
                if(miscellaneous !=null && miscellaneous.size()>0){
                    MailToAddress=new list<string>();
                    for(miscellaneous__C a:miscellaneous)
                    {
                        if(a.name__c!=null)
                        {
                        MailToAddress.add(a.name__c);
                        }            
                    }
            
                }
                System.debug(' ************** In Miscellaneous 2 ' + MailToAddress);
            }
           for(case cs:Mapgroupcase.get(grpname))
            {             
            string SubjectLine='';
                string body='  <!DOCTYPE html> <body><table border="0" cellpadding="0" cellspacing="0" width="100%" style="right: 50px;"><tr><td align="center" height="45" valign="top"><img src="https://c.cs23.content.force.com/servlet/servlet.ImageServer?id=015300000018fo4&oid=00D180000000cAr" alt="Logo" style="border:none;display:block;right: 20px;top: 10px;height: 30px;"/> </td> </tr><br/> </table> <table border="0" cellpadding="5" cellspacing="0" width="100%" style="right: 50px;border-top-width: 4px;border-top-style: solid;border-top-color: #ED2028;border-bottom-width: 4px;border-bottom-style: solid;border-bottom-color: #ED2028;"> <tr> <td align="right" valign="top"> <table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td align="left" height="60" style="font-family:Verdana;font-size:14px;padding-left: 24px;" valign="middle"><br/><br/>'
                +'- GTO Owner Name: ';
    
                String field1 = (cs.OwnerName__c!=null)?cs.OwnerName__c:' ';
    
                body=body+'<b>'+field1+'</b>'+'<br/><br/>'+
                '- Mechanical/Electrical: ';
                String field2 = (cs.Sub_Class__c !=null)?cs.Sub_Class__c :' ';                
                
                body=body+'<b>'+field2 +'</b>'+'<br/><br/>'+
                '- Case Origin: ';
                String field13 = (cs.Origin !=null)?cs.Origin :' ';
                body=body+'<b>'+field13+'</b>'+'<br/><br/>'+
                '- Nature of Discrepancy: ';
                String field3 = (cs.Subject !=null)?cs.Subject :' ';
                
                body=body+'<b>'+field3 +'</b>'+'<br/><br/>'+
                '<font color="red">- Current Actions Provided to Operator: </font>';
                String field4 = (cs.Resolution__c !=null)?cs.Resolution__c.replaceall('\r\n', '<br/>'):' ';
                String field41 = (cs.Expected_Update__c!=null)?String.valueOf(cs.Expected_Update__c):' ';
                // Change done as per INC000008773526
                String fieldCreatedDateInString = (cs.created_date__c != null) ? String.valueOf(cs.created_date__c) : '';
                
                
                body=body+'<b>'+field4+'</b>'+'<br/><br/>'+
                // Changes done as per INC000008773526
                //'- Date and Time of AOG: ' +'<b>'+cs.created_date__c +'</b>'+'<br/><br/>'+
                '- Date and Time of AOG: ' +'<b>'+ fieldCreatedDateInString  +'</b>'+'<br/><br/>'+
                '<font color="red">- Next Update Due: </font>'+'<b>'+field41+'</b>'+'<br/><br/>'+
                '- Supported Products: ';
                system.debug('suported pro'+mailtoaddress);
                String field5 = (mapCasesupported.get(cs.id)!=null)?mapCasesupported.get(cs.id):' ';
                
                body=body+'<b>'+field5+'</b>'+'<br/><br/>'+
                '- Operator: '+'<b>'+cs.Account_Name__c+'</b>'+'<br/><br/>'+
                '- Location of Airplane: ';
                String field6 = (cs.Aircraft_Location__c !=null)?cs.Aircraft_Location__c:' ';
                
                body=body+'<b>'+field6+'</b>'+'<br/><br/>'+
                '- Aircraft Type: ';
                String field7 = (mapCaseIdACTname.get(cs.id)!=null)?mapCaseIdACTname.get(cs.id):' ';
                
                body=body+'<b>'+field7+'</b>'+'<br/><br/>'+
                '- Aircraft Tail Number: ';
                String field8 = (cs.Aircraft_Tail_Number__c !=null)?cs.Aircraft_Tail_Number__c :' ';
                
                body=body+'<b>'+field8+'</b>'+'<br/><br/>'+
    
                '- Aircraft Serial Number: ' ;
                String field9 = (cs.Aircraft_Serial_Number__c !=null)?cs.Aircraft_Serial_Number__c :' ';
                
                body=body+'<b>'+field9+'</b>'+'<br/><br/>'+
                '- Customer Contact Name: ' ;
                String field10 = (cs.Contact_Name__c !=null)?cs.Contact_Name__c :' ';
                
                body=body+'<b>'+field10+'</b>'+'<br/><br/>'+
    
                '- Customer Contact #: ';
                String field11 = (cs.Primary_Work_Number__c !=null)?cs.Primary_Work_Number__c :' ';
                
                body=body+'<b>'+field11;
                String field12 = (cs.Primary_Cell_Number__c !=null)?cs.Primary_Cell_Number__c :' '; 
                
                 body=body+field12+'</b>'+'<br/><br/>'+
                '- Engine/APU Reported Serial Number: ';
                String field14 = (cs.Engine_APU_Reported_Serial_Number__c !=null)?cs.Engine_APU_Reported_Serial_Number__c :' ';
                
                body=body+'<b>'+field14+               
                '</b>'+'<br/><br/>'+'If you wish to be removed from this distribution'+
                ' or to have another person added to the distribution, ';
                String encodeddlname = EncodingUtil.urlEncode(MailToAddress.get(0), 'UTF-8');
                body=body+'<a href="'+system.label.AOGDLRemoval_URL+encodeddlname+'">click here.</a>'+
                ' <br/><br/></td></tr></table></td></tr></table><br/><br/></body></html>'; 
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(MailToAddress);
                mail.sethtmlbody(body);
    
                SubjectLine='AOG Alert - '+' '+field7+' '+cs.Region__c+' '+cs.CaseNumber+'  '+cs.Case_Ref_ID__c+'';
                if(cs.Detail_Class__c==null|| ( cs.Detail_Class__c!='AOG - IFSD Commanded' && cs.Detail_Class__c!='AOG - IFSD Uncommanded'))
                    SubjectLine=SubjectLine+'  ';
    
                if(cs.Detail_Class__c!=null && cs.Detail_Class__c=='AOG - IFSD Commanded')
                    SubjectLine=SubjectLine+' '+'AOG - IFSD Commanded';
    
                if(cs.Detail_Class__c!=null && cs.Detail_Class__c=='AOG - IFSD Uncommanded')
                    SubjectLine=SubjectLine+' '+'AOG - IFSD Uncommanded';
    
                mail.setsubject(SubjectLine);
                mail.setOrgWideEmailAddressId(label.Aero_tech_support);
    
                bulkEmailss.add(mail);
                system.debug('suported pro'+bulkemailss);
            }
        } 
        if(bulkEmailss!= null && bulkEmailss.size()>0)
            Messaging.sendEmail(bulkEmailss);
    }*/
 }