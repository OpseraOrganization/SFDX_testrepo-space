/**************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : EmailAttachmentCopy
* Description           : Trigger to add incoming message to Case and service depending on the
*                         email content
* 
* Modification History  :
* Date              Version No.     Modified by             Brief Description of Modification
* Apr-26-2013       1.0             NTTDATA                 SR#387068 Code changes for Assigning Case Ownership based on an Incoming email
* Nov-13-2013       1.1             NTTDATA                 SR#432747 Code change for sending creation notification forfor Embraer contacts.
* Dec-12-2013       1.2             NTTDATA                 Code change for case 101 exceptions.  
* Nov-03-2014       1.3             NTTDATA                 INC000006656211--Commented Code where Email-GBS-AES-Repair,Email-CPSQuotesEMEA contains     
* Nov-18-2014       1.4             NTTDATA                 INC000007037567 -- Auto populate fields on Case for General RT and sending notification email
**************************************************************************************************/
trigger EmailAttachmentCopy on EmailMessage (after insert) 
{
    /*commenting inactive trigger code to improve code coverage
    Set<ID> emID = new Set<ID>();
    Set<Id> setRoCaseIds = new Set<Id>();
    Map<Id,String> mpRoCaseEmail = new Map<Id,String>();
    Map<Id,String> mpRoEmailSubject = new Map<Id,String>();
    Map<Id,String> mpRoFromAddress = new Map<Id,String>();
    List<Case> lstROCases = new List<Case>();
    List<Case> lstRnOCases = new List<Case>();
    List<Case> lstRnOCasess = new List<Case>();
    String CaseId; 
    Boolean Owneractive;
    String CaseIdSub; 
    String contid,csnumref,frmaddr;
    //SR#419758
    Boolean aeromech = false; Boolean aeroavionics = false;
    Boolean aeroapu = false; Boolean aeroengines = false;
    Boolean aeroshop = false; Boolean aerogbs = false; Boolean aeroescalation = false;
    List<string> listE2cEmailOrigin = new List<string>{'Email-AeroAirbus',
                                        'Email-AeroBoeing',
                                        'Email-AeroComponents',
                                        'Email-BGAOEMQuoteOrders',
                                        'Email-CPSQuotesApprovals',
                                        'Email-CSO BGA Spares',
                                        'Email-D&Sorders',
                                        'Email-D&Squotes',
                                        'Email-R&O D&S',
                                        'Email-Order Changes',
                                        'Email-Order Status',
                                        'Email-Orders',
                                        'Email-Quotes',
                                        'Email-R&O Avionics',
                                        'Email-R&O MechComponents',
                                        'Email-ROEMEAIAvionics',
                                        'Email-ROEMEAIMechanical',
                                        'Email-RepairquotesEscalation',
                                        'Email-R&O APU',
                                        'Email-R&O Engines',
                                        'Email-R&O FastShop'};
    List<Case_Matrix__c> listCaseMatrix = [select id,Name, OwnerId__c from Case_Matrix__c where Name in: listE2cEmailOrigin];
    Map<string,id> mapOwnerIds = new Map<string,id>();
    for(Case_Matrix__c cmItem:listCaseMatrix){
        mapOwnerIds.put(cmItem.Name,cmItem.OwnerId__c);
    }
    Set<id> setCaseIds = new Set<id>();
    set<id> setContIds = new set<id>();
    list<string> listProcess = new list<string>();
    // End for SR#419758
    for(EmailMessage em :Trigger.New)
    {
        //if(em.hasattachment){
            emID.add(em.ID);
        //}
        // Code added for SR # 387068 starts
        CaseId = em.ParentId;     
        if(CaseId != null)
        {
           CaseIdSub = caseId.substring(0,3);
        }
        // Added code for INC000007037567
        if(CaseIdSub != null && CaseIdSub == '500' && (em.FromAddress != null)){
            if(em.FromAddress.toUpperCase().contains('BOEING.COM')){
                setRoCaseIds.add(em.parentid);
                frmaddr = em.FromAddress;
            }
        }
        // End code for INC000007037567
        if(CaseIdSub == '500' && em.subject != null && em.subject != '' && (em.ToAddress != null || em.CcAddress != null))
        { 
            if(em.ToAddress!=null &&((em.ToAddress.toUpperCase().contains('AEROROMECHCOMPONENTSQA@HONEYWELL.COM')) || (em.ToAddress.toUpperCase().contains('AEROROMECHCOMPONENTS@HONEYWELL.COM')) || (em.ToAddress.toUpperCase().contains('AEROR&OMECHCOMPONENTS@HONEYWELL.COM'))) ||
               (em.CcAddress!=null && ((em.CcAddress.toUpperCase().contains('AEROROMECHCOMPONENTSQA@HONEYWELL.COM')) || (em.CcAddress.toUpperCase().contains('AEROROMECHCOMPONENTS@HONEYWELL.COM')) || (em.CcAddress.toUpperCase().contains('AEROR&OMECHCOMPONENTS@HONEYWELL.COM')))
            ))
            {
                setRoCaseIds.add(em.ParentId);
                mpRoCaseEmail.put(em.ParentId,'Email-R&O MechComponents');
                mpRoEmailSubject.put(em.ParentId,em.subject);
                mpRoFromAddress.put(em.ParentId,em.FromAddress);
                aeromech = true;
            }
            else if(em.ToAddress!=null &&((em.ToAddress.toUpperCase().contains('AEROROAPU@HONEYWELL.COM')) || (em.ToAddress.toUpperCase().contains('AEROR&OAPU@HONEYWELL.COM'))) ||
                   (em.CcAddress!=null && ((em.CcAddress.toUpperCase().contains('AEROROAPU@HONEYWELL.COM')) || (em.CcAddress.toUpperCase().contains('AEROR&OAPU@HONEYWELL.COM'))
            )))
            {
                setRoCaseIds.add(em.ParentId);
                mpRoCaseEmail.put(em.ParentId,'Email-R&O APU');
                mpRoEmailSubject.put(em.ParentId,em.subject);
                mpRoFromAddress.put(em.ParentId,em.FromAddress);
                aeroapu = true;
            }
            else if(em.ToAddress!=null &&((em.ToAddress.toUpperCase().contains('AEROROAVIONICSQA@HONEYWELL.COM')) || (em.ToAddress.toUpperCase().contains('AEROROAVIONICS@HONEYWELL.COM')) || (em.ToAddress.toUpperCase().contains('AEROR&OAVIONICS@HONEYWELL.COM'))) ||
                    (em.CcAddress!=null && ((em.CcAddress.toUpperCase().contains('AEROROAVIONICSQA@HONEYWELL.COM')) || (em.CcAddress.toUpperCase().contains('AEROROAVIONICS@HONEYWELL.COM')) || (em.CcAddress.toUpperCase().contains('AEROR&OAVIONICS@HONEYWELL.COM')))
            ))
            {
                setRoCaseIds.add(em.ParentId);
                mpRoCaseEmail.put(em.ParentId,'Email-R&O Avionics');
                mpRoEmailSubject.put(em.ParentId,em.subject);
                mpRoFromAddress.put(em.ParentId,em.FromAddress);
                aeroavionics = true;
            }
            else if(em.ToAddress!=null && ((em.ToAddress.toUpperCase().contains('AEROROENGINES@HONEYWELL.COM')) || (em.ToAddress.toUpperCase().contains('AEROR&OENGINES@HONEYWELL.COM'))) ||
                    (em.CcAddress!=null &&((em.CcAddress.toUpperCase().contains('AEROROENGINES@HONEYWELL.COM')) || (em.CcAddress.toUpperCase().contains('AEROR&OENGINES@HONEYWELL.COM')))
            ))
            {
                setRoCaseIds.add(em.ParentId);
                mpRoCaseEmail.put(em.ParentId,'Email-R&O Engines');
                mpRoEmailSubject.put(em.ParentId,em.subject);
                mpRoFromAddress.put(em.ParentId,em.FromAddress);
                aeroengines = true;
            }
            else if(em.ToAddress!=null && ((em.ToAddress.toUpperCase().contains('AEROROFASTSHOP@HONEYWELL.COM')) || (em.ToAddress.toUpperCase().contains('AEROR&OFASTSHOP@HONEYWELL.COM'))) ||
                    (em.CcAddress!=null && ((em.CcAddress.toUpperCase().contains('AEROROFASTSHOP@HONEYWELL.COM')) || (em.CcAddress.toUpperCase().contains('AEROR&OFASTSHOP@HONEYWELL.COM')))
            ))
            {
                setRoCaseIds.add(em.ParentId);
                mpRoCaseEmail.put(em.ParentId,'Email-R&O FastShop');
                mpRoEmailSubject.put(em.ParentId,em.subject);
                mpRoFromAddress.put(em.ParentId,em.FromAddress);
                aeroshop = true;
            }
            else if((em.ToAddress!=null && (em.ToAddress.toUpperCase().contains('GBS-AES-REPAIR@HONEYWELL.COM'))) ||(em.CcAddress!=null && (em.CcAddress.toUpperCase().contains('GBS-AES-REPAIR@HONEYWELL.COM'))))
            {
                setRoCaseIds.add(em.ParentId);
                mpRoCaseEmail.put(em.ParentId,'Email-GBS-AES-Repair');
                mpRoEmailSubject.put(em.ParentId,em.subject);
                mpRoFromAddress.put(em.ParentId,em.FromAddress);
                aerogbs = true;
            }
            else if((em.ToAddress!=null && (em.ToAddress.toUpperCase().contains('ROQUOTEESCALATION@HONEYWELL.COM'))) || (em.CcAddress!=null && (em.CcAddress.toUpperCase().contains('ROQUOTEESCALATION@HONEYWELL.COM'))))
            {
                setRoCaseIds.add(em.ParentId);
                mpRoCaseEmail.put(em.ParentId,'Email-RepairquotesEscalation');
                mpRoEmailSubject.put(em.ParentId,em.subject);
                mpRoFromAddress.put(em.ParentId,em.FromAddress);
                aeroescalation = true;
            }
        }
        // Code added for SR # 387068 ends
    }   
    if(emID.size()>0){
        EmailAttachmentCopy.attachcase(emID);
    }    
    List<Messaging.SingleEmailMessage> msglist = new List<Messaging.SingleEmailMessage>(); // Added for INC000007037567
    // Code added for SR # 387068 starts
    if(setRoCaseIds.size() > 0)
    {   
        try
        {
            String strEmailSubj;
            lstROCases = [Select id,OwnerId__r.IsActive,ownerid,R_O_Case_Origin__c,contactid,subject,RnOSAPCases__c,RecordTypeId,CreatedById,Customer_PO_RO_WONumber__c,Product_Serial_Number__c,IsClosed From
                          Case Where Id in :setRoCaseIds and Status != 'Cancelled'];
                          
            if(lstROCases != null && lstROCases.size() > 0)
            {
                listProcess.add(lstROCases[0].R_O_Case_Origin__c);
                setContIds.add(lstROCases[0].contactid);
                List<Agent_Contact_Mapping__c> listAgent =[select id,CSR__c,CSR__r.Signature1__c,CSR__r.IsActive,Contact__c,Process__c from Agent_Contact_Mapping__c where
                Agent_Contact_Mapping__c.Contact__c in: setContIds and Agent_Contact_Mapping__c.Process__c in: listProcess ];
                for(case objCase : lstROCases)
                {
                    // Added code for INC000007037567
                    if(objCase.RecordTypeId != null && objCase.Origin != null && objCase.Description != null && frmaddr != null){
                        if(objCase.RecordTypeId == label.General_RT_ID && objCase.Origin == 'E2CP Test' && objCase.OwnerId == label.aero_default_user_id && objCase.Description.toUpperCase().contains('THE BOEING COMMUNICATION SYSTEM')){
                            objCase.Origin = 'Email';
                            objCase.RecordTypeId = label.TechnicalIssueId;
                            objCase.ContactId = label.Boeing_Comm_Sys_Cont_ID;
                            objCase.OwnerId = label.TOC_Team_ID;
                            lstRnOCases.add(objCase);
                            String[] toadd = new String[]{frmaddr};
                            String body='<!DOCTYPE html><body><table border="0" cellpadding="0" cellspacing="0" width="950" style="position: absolute;right: 50px;"><tr><td align="center" height="45" valign="top"><img src="https://c.na19.content.force.com/servlet/servlet.ImageServer?id=015300000018fo4&amp;oid=00D30000000dWxY" alt="Logo" style="border:none;display:block;right: 20px;position: absolute;top: 10px;height: 30px;"/></td></tr><br/></table><table border="0" cellpadding="5" cellspacing="0" width="600" style="position: absolute;right: 50px;border-top-width: 4px;border-top-style: solid;border-top-color: #ED2028;border-bottom-width: 4px;border-bottom-style: solid;border-bottom-color: #ED2028;"><tr><td align="right" valign="top"><table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td align="left" height="60" style="font-family:Times New Roman;font-size:16px;padding-left: 24px;" valign="middle">Thank you for contacting Honeywell Aerospace Customer Support.  Your case tracking number for this inquiry is provided above.  If you wish to communicate with us further about this inquiry, you may reply to this e-mail -- please leave the Reference Case # within the subject line for quicker responses.<br/><br/>Visit the exciting new options on our improved, easier to navigate Web Portal at www.myaerospace.com.  You can now obtain real time price and availability, place orders and check order status online for avionics, mechanical, wheels and brakes products and exchange programs (SPEX), globally for all of our customers. Additionally, you can access Technical Publications, database updates, R&O capabilities, and other support tools.  BendixKing Dealers can obtain price and availability, place orders and check order status online and Wingman Services customers can utilize database services at www.bendixking.com.<br/><br/>Thank you, we appreciate your business!<br/>Honeywell Aerospace<br/>Customer & Product Support<br/>Web: <span  style="font-size:16px; text-decoration:underline; color:#679afa; ">http://www.MyAerospace.com</span><br/>1-800-601-3099 or internationally at 1-602-365-3099<br/>ORIGINAL CORRESPONDENCE:<br/>'+objCase.Subject+'<br/>'+objCase.Description+'<br/>'+objCase.Case_Ref_ID__c+'<br/><br/></td></tr></table></td></tr></table><br/><br/><table border="0" cellpadding="5" cellspacing="0" width="600" style="position: absolute;right: 50px;border-bottom-width: 4px;border-bottom-style: solid;border-bottom-color: #ED2028;"/></body></html>';
                            csnumref = objCase.CaseNumber+' '+objCase.Case_Ref_ID__c;
                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();            
                            message.setToAddresses(toadd);
                            message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                            message.setBccSender(false);             
                            message.setUseSignature(false);
                            message.setSaveAsActivity(false); 
                            message.setSubject(csnumref);
                            message.setHtmlBody(body);
                            msglist.add(message);
                        }
                    }
                    // End code for INC000007037567
                    Owneractive = objCase.OwnerId__r.IsActive;
                    if(objCase.recordtypeid == label.RnO_Automation_Record_Type &&
                      (objCase.Customer_PO_RO_WONumber__c != null || objCase.Product_Serial_Number__c != null) &&
                       objCase.createdbyid == label.Portal_API_User_RO_Automation && objCase.ownerid == label.RnO_Automation_Default_Owner)
                    {
                        strEmailSubj = mpRoEmailSubject.get(objCase.id);                       
                        Decimal intRnOSAPCases = objCase.RnOSAPCases__c;
                        Case objCaseToUpdt = new Case(id = objCase.id);
                        
                        if(intRnOSAPCases != null)
                        {
                            objCaseToUpdt.RnOSAPCases__c = intRnOSAPCases + 1;
                        }
                        else
                        {
                            objCaseToUpdt.RnOSAPCases__c = 1;
                        }
                        objCaseToUpdt.origin = mpRoCaseEmail.get(objCase.id);
                        
                        if(objCaseToUpdt.contactid == null || objCaseToUpdt.contactid == label.RnO_Automation_Default_Contact)
                        {
                            List<Contact> lstContact = [select id from Contact where email =: mpRoFromAddress.get(objCase.id)];
                            if(lstContact!=null && lstContact.size() > 0)
                            {
                              objCaseToUpdt.contactid = lstContact[0].id;
                            }  
                            objCaseToUpdt.SuppliedEmail = mpRoFromAddress.get(objCase.id);
                        }    
                        if(objCase.isclosed)
                        {
                            objCaseToUpdt.Reopen_Case__c = true;
                        }
                        lstRnOCases.add(objCaseToUpdt);
                    }
                    // Start SR#419758
                    if(objCase.recordtypeid == label.RnO_Automation_Record_Type &&
                      (objCase.Customer_PO_RO_WONumber__c != null || objCase.Product_Serial_Number__c != null) &&
                       objCase.createdbyid == label.Portal_API_User_RO_Automation)
                    {
                        Case objCaseToUpdte = new Case(id = objCase.id);
                        if(aeromech == true){ objCaseToUpdte.Emailbox_Origin__c = 'Email-R&O MechComponents';
                                              objCaseToUpdte.R_O_Case_Origin__c = 'R&O MechComponents';}
                        else if(aeroapu == true){ objCaseToUpdte.Emailbox_Origin__c = 'Email-R&O APU';
                                                  objCaseToUpdte.R_O_Case_Origin__c = 'R&O APU';}
                        else if(aeroavionics == true){ objCaseToUpdte.Emailbox_Origin__c = 'Email-R&O Avionics';
                                                       objCaseToUpdte.R_O_Case_Origin__c = 'R&O Avionics';}
                        else if(aeroengines  == true){ objCaseToUpdte.Emailbox_Origin__c = 'Email-R&O Engines';
                                                       objCaseToUpdte.R_O_Case_Origin__c = 'R&O Engines';}
                        else if(aeroshop == true){ objCaseToUpdte.Emailbox_Origin__c = 'Email-R&O FastShop';
                                                    objCaseToUpdte.R_O_Case_Origin__c = 'R&O FastShop';}
                        else if(aerogbs == true){ objCaseToUpdte.Emailbox_Origin__c = 'Email-GBS-AES-Repair';
                                                    objCaseToUpdte.R_O_Case_Origin__c = 'GBS-AES-Repair';}
                        else if(aeroescalation == true){ objCaseToUpdte.Emailbox_Origin__c = 'Email-RepairquotesEscalation';
                                                        objCaseToUpdte.R_O_Case_Origin__c = 'RepairquotesEscalation';}
                        if( mapOwnerIds.size()>0){
                            for(string emailBox : listE2cEmailOrigin){
                                
if(objCaseToUpdte.Emailbox_Origin__c == emailBox && Owneractive == false)
                                {
                                    objCaseToUpdte.ownerid = mapOwnerIds.get(objCaseToUpdte.Emailbox_Origin__c);
                                }
                            }
                        }
                        if(listAgent.size()>0){
                            if(listAgent[0].CSR__r.IsActive == true && Owneractive == false){
                                objCaseToUpdte.ownerid = listAgent[0].CSR__c;
                            }
                        }
                        lstRnOCasess.add(objCaseToUpdte);
                    }   //End SR#419758
                }                   
                if(lstRnOCases.size() > 0)
                {
                    update lstRnOCases;
                }
                if(lstRnOCasess.size() > 0)
                {
                    update lstRnOCasess;
                }
                // Added code for INC000007037567
                if(msglist.size()>0){
                    system.debug('messagelist----->'+msglist);
                    Messaging.sendEmail(msglist);
                }
                // End code for INC000007037567
            }
        } 
        catch(Exception e){
            System.debug('Exception occured while assigning values based on email subject '+e);
        }
    }    
    // Code added for SR # 387068 ends
    // code starts for SR 432747
    //code changes starts for case 101 exception
    set<id>eid= new set<id>();
    for(emailmessage em: trigger.new)
    eid.add(em.id);
    list<emailmessage> emlist= new list<emailmessage>();
    emlist=[select id,parent.Contactid,FromAddress from emailmessage where id in: eid];
    for(EmailMessage em: emlist)
    {
    //code changes ends for case 101 exception
    // Changes Added for INC000006226785 
    Case csConId = [select ContactId from Case where id=:CaseId];
    if(null!=csConId)
    contid = csConid.ContactId;
    // Changes End for INC000006226785 
    for(emailmessage em: trigger.new)
    {
        if(em.fromaddress!= null && em.fromaddress.contains('embraer'))
        {
            try
            {
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setTargetObjectId(contid);
                message.setWhatId(em.ParentId);
                // The email template ID used for the email
                message.setTemplateId(label.Orders_Acknowledgement_Template_ID);
                message.setBccSender(false);
                message.setUseSignature(false);
                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                message.setSaveAsActivity(false); 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
            }
            catch (Exception exc) 
            {
                System.debug('*******************'+exc);
            }
                    
        }
    }*/
    //Code ends-SR 432747
}