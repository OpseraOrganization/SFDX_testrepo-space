/*******************************************************************************
Name         : RONoteExchangefromAero
Company Name : NTT Data
Project      : <AeroExchangeRONote> 
Created Date : 31-July-2019
Usages       : Webserive Class for RONoteExchangefromAero
*******************************************************************************/
global class RONoteExchangefromAero{
    //Preparing the WSDL structure with list of wrappers as per the given sample structure
    global class AeroExchange{
        webservice  AEX_NotesExchangeWithDocAttach AEX_NotesExchangeWithDocAttach;
    }
    global class   AEX_NotesExchangeWithDocAttach 
    {
        webservice List<AEX_NotesExchangeWithDocAttachHeader> AEX_NotesExchangeWithDocAttachHeader = new List<AEX_NotesExchangeWithDocAttachHeader>();
        webservice list <AEX_NotesExchangeWithDocAttachDetails> AEX_NotesExchangeWithDocAttachDetails = new list <AEX_NotesExchangeWithDocAttachDetails>();
    }
    global class AEX_NotesExchangeWithDocAttachHeader
    {
        webservice List<CommunicationArea> CommunicationArea = new list<CommunicationArea>();
        webservice list <MessageSender> MessageSender;
        webservice list <MessageReceiver> msgRcvr;
        webservice string ProductType;
    }
    global class CommunicationArea 
    {
        webservice string CustomerCode;
        webservice string SupplierCageCode;
        webservice string MessageSeqID;
        webservice string CreationDateTime;
    }
    global class MessageSender
    {
        webservice string ID;
        webservice string Name;
        webservice string CompanyCode;
        webservice string Email;
        webservice string Telephone;
        webservice string Fax;
    }
    
    global class MessageReceiver
    {
        webservice string ID;
        webservice string Name;
        webservice string CompanyCode;
        webservice string Email;
        webservice string Telephone;
        webservice string Fax;
    }
    global class AEX_NotesExchangeWithDocAttachDetails
    {
        webservice List<RequestAttachments> attachment;
        webservice string ServiceOrderNumber;
        webservice string ReferenceIdentifier;
        webservice string NotesPurposeIndicator;
        webservice string NotesType;
        webservice string Remarks;
    }
    global class RequestAttachments{
        
        webservice string FileReference;
        webservice string FileName;
        webservice string FileType;
    }
    
    // Webservice method 
    webservice static string AexNoteResponse(AeroExchange aex){
        //MainWrapper aex1 = new MainWrapper();
        // return('success');
        
        String CustomerCode;
        String SupplierCageCode;
        String MessageSeqID;
        String CreationDateTime;
        string MSID;
        string MSName;
        string MSCompanyCode;
        string MSEmail;
        string MSTelephone;
        string MSFax;
        string FileReference;
        string FileName;
        string FileType;
        string ServiceOrderNumber;
        string ReferenceIdentifier;
        string NotesPurposeIndicator;
        string NotesType;
        string Remarks;
        string filecontent;
        string productType;
        RONoteExchangefromAero.AEX_NotesExchangeWithDocAttach noteExchangewAttachlist=new RONoteExchangefromAero.AEX_NotesExchangeWithDocAttach();
        List<RONoteExchangefromAero.AEX_NotesExchangeWithDocAttach> noteExchangewAttachlist1=new List<RONoteExchangefromAero.AEX_NotesExchangeWithDocAttach>();
        List<RONoteExchangefromAero.AEX_NotesExchangeWithDocAttachHeader> AEX_NotesExchangeWithDocAttachHeaderlist=new List<RONoteExchangefromAero.AEX_NotesExchangeWithDocAttachHeader>();
        List<RONoteExchangefromAero.AEX_NotesExchangeWithDocAttachDetails> AEXNotesExchangeWithDocAttachDetailslst=new  List<RONoteExchangefromAero.AEX_NotesExchangeWithDocAttachDetails>(); 
        List<RONoteExchangefromAero.CommunicationArea> CommArealist=new List<RONoteExchangefromAero.CommunicationArea>();
        List<RONoteExchangefromAero.MessageSender> MessageSenderList=new List<RONoteExchangefromAero.MessageSender>();
        List<RONoteExchangefromAero.MessageReceiver> MessageReceiverList=new List<RONoteExchangefromAero.MessageReceiver>();
        List<RONoteExchangefromAero.RequestAttachments> RequestAttachmentsList = new List<RONoteExchangefromAero.RequestAttachments>();
        if(aex.AEX_NotesExchangeWithDocAttach != null)
        {
            noteExchangewAttachlist=aex.AEX_NotesExchangeWithDocAttach;
            
        }
        if(noteExchangewAttachlist != null)
        {
            noteExchangewAttachlist1.add(noteExchangewAttachlist); 
        }
        for(RONoteExchangefromAero.AEX_NotesExchangeWithDocAttachHeader AEXNote:noteExchangewAttachlist.AEX_NotesExchangeWithDocAttachHeader)
        {
            AEX_NotesExchangeWithDocAttachHeaderlist.add(AEXNote);
        }
        for(RONoteExchangefromAero.AEX_NotesExchangeWithDocAttachDetails AEXNote1:noteExchangewAttachlist.AEX_NotesExchangeWithDocAttachDetails)
        {
            AEXNotesExchangeWithDocAttachDetailslst.add(AEXNote1);
        }
        
        /* if(noteExchangewAttachlist.size()>0)
{
for(SampleWebserviceClass.AEX_NotesExchangeWithDocAttachHeader aexnote1:noteExchangewAttachlist.AEX_NotesExchangeWithDocAttachHeader)
{
AEX_NotesExchangeWithDocAttachHeaderlist.add(aexnote1);
}
}*/     
        for(RONoteExchangefromAero.AEX_NotesExchangeWithDocAttachHeader ae : AEX_NotesExchangeWithDocAttachHeaderlist){
            productType = ae.ProductType;
        }
        for(integer i=0;i<AEX_NotesExchangeWithDocAttachHeaderlist.size();i++){
            for(RONoteExchangefromAero.CommunicationArea AEXNote2: AEX_NotesExchangeWithDocAttachHeaderlist[i].CommunicationArea)
            {
                CommArealist.add(AEXNote2);
            } 
            
            for(RONoteExchangefromAero.MessageSender AEXNote3: AEX_NotesExchangeWithDocAttachHeaderlist[i].MessageSender)
            {
                MessageSenderList.add(AEXNote3);
            }
        } 
        
        for(integer j=0; j<AEXNotesExchangeWithDocAttachDetailslst.size();j++)
        {
            if((AEXNotesExchangeWithDocAttachDetailslst[j].attachment).size()>0 && (!(AEXNotesExchangeWithDocAttachDetailslst[j].attachment).IsEmpty()))
            {
                system.debug('Entred J attachment loop');
                for(RONoteExchangefromAero.RequestAttachments attch : AEXNotesExchangeWithDocAttachDetailslst[j].attachment) {
                    if(attch.FileReference!=null && attch.FileReference!= '' && attch.FileName!=null && attch.FileName!= '' && attch.FileType!=null &&  attch.FileType!=''  )
                    {
                        system.debug('entered attchment line 144');
                        RequestAttachmentsList.add(attch); 
                    }
                    
                }
            }
        }
        
        for(RONoteExchangefromAero.AEX_NotesExchangeWithDocAttachDetails aexlst: AEXNotesExchangeWithDocAttachDetailslst)
        {
            ServiceOrderNumber = aexlst.ServiceOrderNumber ;
            ReferenceIdentifier = aexlst.ReferenceIdentifier ;
            NotesPurposeIndicator = aexlst.NotesPurposeIndicator ;
            NotesType = aexlst.NotesType ;
            Remarks= aexlst.Remarks;
        }
        
        if(!RequestAttachmentsList.isEmpty())
        {
            system.debug('Entred Remarks if ');
            Remarks= Remarks + '.Please find the customer shared attachment'; 
            
        }
        for(RONoteExchangefromAero.CommunicationArea cm: CommArealist)
        {
            CustomerCode = cm.CustomerCode ;
            SupplierCageCode = cm.SupplierCageCode;
            MessageSeqID = cm.MessageSeqID ;
            CreationDateTime = cm.CreationDateTime ;
        } 
        
        for(RONoteExchangefromAero.MessageSender msg : MessageSenderList)
        {
            MSID = msg.ID;
            MSName = msg.Name;
            MSCompanyCode = msg.CompanyCode;
            MSEmail = msg.Email;
            MSTelephone = msg.Telephone;
            MSFax = msg.Fax;
            
        }
        //blob eBody;
        if(!RequestAttachmentsList.isEmpty())
        {
            system.debug('entered if condition of Requestattach');
            for(RONoteExchangefromAero.RequestAttachments att : RequestAttachmentsList)
            {
                system.debug('entered Attached loop');
                //eBody = EncodingUtil.base64Decode(att.FileReference);
                filecontent= att.FileReference;
                FileName = att.FileName ;
                FileType = att.FileType ; 
            }
        } 
        // This list is to store errors found any
        List<String> errorMsgList = new List<String>();
        Map<String,String> aexMetaMap = new Map<String,String>(); // This map is to store customMetadata records.
        Map<string,string> aexsfdcRowMap = new Map<string,string>();
        Account_Cross_Ref__c acr;
        Account acc;
        // The below custom metadata is used to store Customer code and sold to number, based on the customer code get the sold to account number.
        // This sold to account number will be used to get the Account ID.
        for(AeroRoExchangeSoldTo__mdt aexm : [Select MasterLabel,SoldToNumber__c,SFDC_ROWID__c from AeroRoExchangeSoldTo__mdt])
        {
            aexMetaMap.put(aexm.MasterLabel,aexm.SoldToNumber__c);
            
            system.debug (aexMetaMap);
            aexsfdcRowMap.put(aexm.MasterLabel,aexm.SFDC_ROWID__c);
            system.debug (aexsfdcRowMap);
        }
        
        //Query the Account_Cross_Ref__c to get the AccountID
        
        /*if(aexMetaMap.containsKey(CustomerCode))
{

acr =[select Account_Name__c from Account_Cross_Ref__c where External_Account_ID__c = :aexMetaMap.get(CustomerCode)];
}*/
        List<ID> conList = new List<ID>();
        string msreceive;
        if(!Test.isRunningTest()){
            system.debug(aexsfdcRowMap.containsKey(CustomerCode));
            system.debug(CustomerCode);
            if(aexsfdcRowMap.containsKey(CustomerCode))
            {
                acc =[select ID from Account where SFDC_Row_Id__c = :aexsfdcRowMap.get(CustomerCode)];
                
            }
            if(CustomerCode != null)
            {
                for(AeroRoExchangeSoldTo__mdt aexr : [Select MasterLabel,SoldToNumber__c,SFDC_ROWID__c,Receiver_Name__c from AeroRoExchangeSoldTo__mdt where MasterLabel =:CustomerCode ])
                {
                    msreceive = aexr.Receiver_Name__c;
                }
            }       
                      system.debug(acc);
            
            if(acc.ID!=null)
            {
                for(contact c : [select id,name from contact where AccountID= :acc.ID])
                {
                    conList.add(c.ID);
                }
            }
        }
        //  AeroRoExchangeSoldTo__mdt aexData;
        
        /*if(CustomerCode!=null){
aexData = [Select MasterLabel,SoldToNumber__c from AeroRoExchangeSoldTo__mdt where MasterLabel = :CustomerCode];
}
if(aexData.SoldToNumber__c !=null)
{
acr =[select Account_Name__c from Account_Cross_Ref__c where External_Account_ID__c = :aexData.SoldToNumber__c];

}*/
        Group csQ =   [select Id, name from Group where  Type = 'Queue' AND NAME = 'CSO R&O Team'];
        set<ID> csID = new set<ID>();
        // Creating a Case
        List<Case> cslst = new list<case>(); 
         List<Case> cse = new list<case>();
        String shortText = 'EDI Outbound Notes_Req Shipping Info';
        List<case> updateCase = new List<case>();
         Map<String,Case> caseMapRecent = new Map<String,Case>();
        List<case> updCase = new List<case>();
        list<Z_Task__c> tsk = new list<Z_Task__c>();
        set<id> ids = new set<id>();
        Id caseRTID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Repair_Overhaul').getRecordTypeId();
	if(ServiceOrderNumber!=null){
            //  cse = [select id,Customer_PO_RO_WONumber__c,Status,casenumber from case where Customer_PO_RO_WONumber__c = :ServiceOrderNumber AND Sub_Class__c ='EDI Note' AND RecordtypeID =:caseRTID order BY createddate DESC LIMIT 1];
          
        
        cse = [select id,Customer_PO_RO_WONumber__c,Status,casenumber, (Select Id, Name, RelatedTo__c, Short_Text__c,Short_Text2__c,type__c,status__c From Z_Tasks__r) from case where Customer_PO_RO_WONumber__c = :ServiceOrderNumber AND RecordtypeID =:caseRTID order BY createddate DESC];
            
        
        system.debug('case cse== ' + cse);
        system.debug('case cse== ' + cse.size());
            
          if(cse.size() == 0){
                system.debug('id==' +caseRTID); 
                case csi = new case();
                csi.RecordtypeID = caseRTID;
                csi.subject = 'AeroXchange R&O Note #' + ServiceOrderNumber;
                csi.Type = 'Repair Inquiry';
                csi.Classification__c = 'R&O issue';
                csi.Sub_Class__c = 'EDI Note';
                csi.Origin = 'M2M';
                csi.Customer_PO_RO_WONumber__c = ServiceOrderNumber;
                if(!Test.isRunningTest())
                {
                    if(acc.ID!=null){
                        //cs.AccountID = acr.Account_Name__c;
                        // cs.contactID = Label.Case_Default_Contact;
                        csi.AccountID = acc.ID;
                        csi.contactID = conList[0];
                    }
                }
                csi.Export_Compliance_Content_ITAR_EAR__c = 'No';
                csi.Government_Compliance_SM_M_Content__c = 'No';
                //cs.Sub_Class__c = ''
                csi.status = 'open';
                //cs.OwnerID = Label.CSO_R_O_Team;
                csi.OwnerID = csQ.ID;
               
                    insert csi;
                    csID.add(csi.ID);
                    system.debug('try cs==' +csi);
              
                
                system.debug('inserted case ==>' + csi);
                system.debug('inserted case Account ==>' + csi.AccountID);  
            }
        
          if(cse.size()>0)
          {
            for(Case cs: cse) 
            {
                system.debug(cs.id);
              
                if(cs.Z_Tasks__r.size()>0)
                {
                    for(Z_Task__c ztask: cs.Z_Tasks__r)
                    {
                        if(ztask.type__c.contains('Z146') && ztask.Short_Text2__c == shortText && ztask.Status__c == 'Open')
                        {
                            if(!caseMapRecent.containskey(cs.Customer_PO_RO_WONumber__c))
                            { 
                                caseMapRecent.put(cs.Customer_PO_RO_WONumber__c,cs);
                                
                                    system.debug('status' + cs.status);
                                    Case c = new case();
                                    c.Status = 'Open-Comment-Attachment';
                                    //c.ParentID = cs.ID;
                                    c.Id = cs.id;
                                    updateCase.add(c);
                                    system.debug('updatecase'+updateCase);
             
                                if(updateCase.size()>0){
                                   
                                        update updateCase;
                                        system.debug('updatecase'+updateCase);
                                        for(case cd : updateCase){
                                            system.debug('entered loop update one');
                                            csID.add(cd.ID);
                                            system.debug(csID);
                                        }
                                  
                                    
                                    
                                }
                            }
                        }
                    }
                }
            }
              
              
              for(Case csf: cse) 
              {
                  system.debug(csf.id);
                  
                  if(csf.Z_Tasks__r.size()>0)
                  {
                      if(!caseMapRecent.containskey(csf.Customer_PO_RO_WONumber__c))
                      { 
                          caseMapRecent.put(csf.Customer_PO_RO_WONumber__c,csf);
                          if(csf.Status == 'Closed')
                          {
                              system.debug('status closed' + csf.status);
                              Case c = new case();
                              c.Status = 'Re-Open';
                              //c.ParentID = cs.ID;
                              c.Id = csf.id;
                              updateCase.add(c);
                              system.debug('updatecase'+updateCase);
                              
                          }
                          else
                          {
                              system.debug('else block for service order case');
                              csID.add(csf.ID);
                              system.debug(csID);
                          }
                          
                          
                          if(updateCase.size()>0){
                             
                                  update updateCase;
                                  system.debug('updatecase'+updateCase);
                                  for(case cd : updateCase){
                                      system.debug('entered loop update one');
                                      csID.add(cd.ID);
                                      system.debug(csID);
                                  }
                              
                              
                          }
                      }
                  }
              }
              
              
              
              for(Case css: cse) 
              {
                  system.debug(css.id);
                  if(css.Z_Tasks__r.size()==0)
                  {
                      if(!caseMapRecent.containskey(css.Customer_PO_RO_WONumber__c))
                      { 
                          caseMapRecent.put(css.Customer_PO_RO_WONumber__c,css);
                          if(css.Status == 'Closed')
                          {
                              system.debug('status closed' + css.status);
                              Case c = new case();
                              c.Status = 'Re-Open';
                              //c.ParentID = cs.ID;
                              c.Id = css.id;
                              updateCase.add(c);
                              system.debug('updatecase'+updateCase);
                              
                          }
                          else
                          {
                              system.debug('else block for service order case');
                              csID.add(css.ID);
                              system.debug(csID);
                          }
                          
                          
                          if(updateCase.size()>0){
                             
                                  update updateCase;
                                  system.debug('updatecase'+updateCase);
                                  for(case cd : updateCase){
                                      system.debug('entered loop update one');
                                      csID.add(cd.ID);
                                      system.debug(csID);
                                  }
                              
                              
                              
                          }
                      }
                  }
              }
          } 
    }
        
          
        string caseID;
        system.debug('csID==' + csID);
        for(ID i :csID){
            caseID = i;
        }
    
        // Creating a Case
        /*Id caseRTID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Repair_Overhaul').getRecordTypeId();
system.debug('id==' +caseRTID); 
case cs = new case();
cs.RecordtypeID = caseRTID;
cs.subject = 'AeroXchange R&O Note #' + ServiceOrderNumber;
cs.Type = 'Repair Inquiry';
cs.Classification__c = 'R&O issue';
if(!Test.isRunningTest())
{
if(acc.ID!=null){
//cs.AccountID = acr.Account_Name__c;
// cs.contactID = Label.Case_Default_Contact;
cs.AccountID = acc.ID;
cs.contactID = conList[0];
}
}
cs.Export_Compliance_Content_ITAR_EAR__c = 'No';
cs.Government_Compliance_SM_M_Content__c = 'No';
//cs.Sub_Class__c = ''
cs.status = 'open';
//cs.OwnerID = Label.CSO_R_O_Team;
cs.OwnerID = csQ.ID;
try{
insert cs;
system.debug('try cs==' +cs);
}
catch (exception e){
string excError = string.valueOf(e);
system.debug('Unable to create case-Exception occured===' + e.getMessage());
errorMsgList.add(excError);
}
system.debug('inserted case ==>' + cs);
system.debug('inserted case Account ==>' + cs.AccountID);*/
        
        // Forming XML for response in a string- This is string will be used for post response - Refer AeroROExchangeHelper Apex class
        string envelope;
        boolean attchenvelope;
        envelope = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:aer="http://www.aeroxchange.com">'+ '<soapenv:Header/>' +
            '<soapenv:Body>' +
            '<aer:AEX_NotesExchangeWithDocAttach>' + '\n' +
            '<aer:AEX_NotesExchangeWithDocAttachHeader>' + '\n' +
            '<aer:CommunicationArea>'+ '\n' +
            '<aer:CustomerCode>'+ CustomerCode + '</aer:CustomerCode>' + '\n' +
            '<aer:SupplierCageCode>' + SupplierCageCode + '</aer:SupplierCageCode>' + '\n' +
            '<aer:MessageSeqID>' + MessageSeqID + '</aer:MessageSeqID>' + '\n' +
            '<aer:CreationDateTime>'+ CreationDateTime + '</aer:CreationDateTime>' + '\n' +
            '</aer:CommunicationArea>' + '\n' +
            '<aer:MessageSender>'+ '\n' +
            '<aer:ID>' + 'HWSFDC' + '</aer:ID>'+ '\n' +
            '<aer:Name>' + 'Honeywell Aero' + '</aer:Name>' + '\n' +
            '<aer:CompanyCode>' + SupplierCageCode + '</aer:CompanyCode>' + '\n' +
            '<aer:Email>'+ 'noreply@honeywell.com' + '</aer:Email>' + '\n' +
            '</aer:MessageSender>'+ '\n' +
            '<aer:MessageReceiver>' + '\n' +
            '<aer:ID>' + MSID + '</aer:ID>'+ '\n' +
            '<aer:Name>' +msreceive+ '</aer:Name>' + '\n' +
            '<aer:CompanyCode>' + CustomerCode + '</aer:CompanyCode>' + '\n' +
            '<aer:Email>'+ MSEmail + '</aer:Email>' + '\n' +
            '</aer:MessageReceiver>'+ '\n' +
            '<aer:ProductType>' + productType + '</aer:ProductType>' + '\n' +
            '</aer:AEX_NotesExchangeWithDocAttachHeader>'+ '\n' +
            '<aer:AEX_NotesExchangeWithDocAttachDetails>'+ '\n' +
            '<aer:ServiceOrderNumber>' + ServiceOrderNumber + '</aer:ServiceOrderNumber>' + '\n' +
            '<aer:ReferenceIdentifier>' + ReferenceIdentifier + '</aer:ReferenceIdentifier>' + '\n' +
            '<aer:NotesPurposeIndicator>' + 'NSM' + '</aer:NotesPurposeIndicator>' + '\n' +
            '<aer:NotesType>' + 'Order' + '</aer:NotesType>';
        if(FileName!=null && FileName!= '' && filecontent!=null && filecontent!= '')
        {    
            attchenvelope = true;
        }
        else
        {  
            attchenvelope = false;
        }
        
        system.debug('envelope==>' +envelope);
        
        // Query Case_Extension__c object and update the field with XML response.
        if(!csID.isEmpty()){     
            List<Case_Extension__c>  ce = [Select ID,ROExchange_XML__c,Case_object__c  from Case_Extension__c where Case_object__c IN :csID];
            ce[0].ROExchange_XML__c = envelope;
            //ce[0].RoExchange_IsAttach__c = attchenvelope;   
            system.debug('ROExchange_XML__c==>' +ce[0].ROExchange_XML__c);
            // system.debug('ROExchange_Attch__c===>' +ce[0].ROExchange_Attch__c);
           
                update ce;
                system.debug('ce update==>' + ce);
           
           
               
            
        }    
        //sending Email with the given data which we received
        EmailTemplate temp = [select id,Body,HtmlValue,Subject from EmailTemplate where DeveloperName='RO_Note_Exchange' LIMIT 1];
        EmailMessage mail = new EmailMessage();
        string emailbody = temp.HtmlValue;
        string plainbody = temp.Body;
        //insert email message on case
        for(case c: [select ID,Subject,CaseNumber,Case_Ref_ID__c,owner.name,owner.email,Account.Name from case where ID IN :csID]){
            string emailSubject = temp.subject;            
            emailSubject = emailSubject.Replace('{!Case.Subject}', c.Subject);
            emailSubject = emailSubject.Replace('{!Case.CaseNumber}', c.CaseNumber);
            emailSubject = emailSubject.Replace('{!Case.Case_Ref_ID__c}', c.Case_Ref_ID__c);
            mail.Subject = emailSubject;
            mail.MessageDate = system.now();
            mail.ParentID = c.ID;
            mail.ToAddress = 'aerodonotreply@honeywell.com';
            mail.FromAddress = 'noreply@honeywell.com';
            mail.status = '3';
            emailbody =  emailbody.Replace('{!Case.OwnerFullName}', csQ.name );
            
            emailbody = emailbody.Replace('{!Case.CaseNumber}', c.CaseNumber);
            if(SupplierCageCode!=null)
            {
                emailbody =  emailbody.Replace('&lt;Enter SupplierCageCode #&gt;', SupplierCageCode);
            }
            else
            {
                emailbody =  emailbody.Replace('&lt;Enter SupplierCageCode #&gt;', 'Not Provided');
            }
            if(CustomerCode!=null)
            {
                emailbody = emailbody.Replace('&lt;Enter Customer Code #&gt;', CustomerCode);
            }
            else{
                emailbody = emailbody.Replace('&lt;Enter Customer Code #&gt;', 'Not provided'); 
            }
            if(ServiceOrderNumber!=null)
            {
                emailbody = emailbody.Replace('&lt;Enter Service Order Number#&gt;',ServiceOrderNumber);
            }
            else{
                emailbody = emailbody.Replace('&lt;Enter Service Order Number#&gt;','Not provided'); 
            }
            if(c.Account.Name!=null)
            {
                emailbody = emailbody.Replace('&lt;Enter Name here&gt;', c.Account.Name);
            }
            else if(MSName!=null){
                emailbody = emailbody.Replace('&lt;Enter Name here&gt;', MSName);
            }
            else{
                emailbody = emailbody.Replace('&lt;Enter Name here&gt;', 'Not provided');
            }
            
            if(ReferenceIdentifier!=null)
            {
                emailbody = emailbody.Replace('&lt;Enter Reference Identifier&gt;',ReferenceIdentifier);
            }
            else{
                emailbody = emailbody.Replace('&lt;Enter Reference Identifier&gt;','Not provided');
            }
            if(Remarks!=null)
            {
                emailbody = emailbody.Replace('&lt;Enter Remarks &gt;',Remarks);
            }
            else{
                emailbody = emailbody.Replace('&lt;Enter Remarks &gt;','Not provided');
            }
           // mail.HtmlBody = emailbody;
            system.debug('case owner=='+ c.owner.email);
            system.debug('case owner=='+ c.OwnerID);
            system.debug('case owner=='+ c);
            plainbody =  plainbody .Replace('{!Case.OwnerFullName}', csQ.name );
            
            plainbody = plainbody.Replace('{!Case.CaseNumber}', c.CaseNumber);
            if(SupplierCageCode!=null)
            {
                plainbody =  plainbody.Replace('<Enter SupplierCageCode #>', SupplierCageCode);
            }
            else
            {
                plainbody =  plainbody.Replace('<Enter SupplierCageCode #>', 'Not Provided');
            }
            if(CustomerCode!=null)
            {
                plainbody = plainbody.Replace('<Enter Customer Code #>', CustomerCode);
            }
            else{
                plainbody = plainbody.Replace('<Enter Customer Code #>', 'Not provided'); 
            }
            if(ServiceOrderNumber!=null)
            {
                plainbody = plainbody.Replace('<Enter Service Order Number#>',ServiceOrderNumber);
            }
            else{
                plainbody = plainbody.Replace('<Enter Service Order Number#>','Not provided'); 
            }
            if(c.Account.Name!=null)
            {
                plainbody = plainbody.Replace('<Enter Name here>', c.Account.Name);
            }
            else if(MSName!=null){
                plainbody = plainbody.Replace('<Enter Name here>', MSName);
            }
            else{
                plainbody = plainbody.Replace('<Enter Name here>', 'Not provided');
            }
            
            if(ReferenceIdentifier!=null)
            {
                plainbody = plainbody.Replace('<Enter Reference Identifier>',ReferenceIdentifier);
            }
            else{
                plainbody = plainbody.Replace('<Enter Reference Identifier>','Not provided');
            }
            if(Remarks!=null)
            {
                plainbody = plainbody.Replace('<Enter Remarks >',Remarks);
            }
            else{
                plainbody = plainbody.Replace('<Enter Remarks >','Not provided');
            }
            mail.TextBody = plainbody;
        }
        system.debug('SupplierCageCode==>' +SupplierCageCode);
        system.debug('emailbody ==>' +emailbody);
        
        try{
            insert mail;
        }
        catch (Exception e){
            system.debug('Unable to insert the mail==>'+ e.getMessage());
        }
        List<Attachment> attList = new List<Attachment>();
        //List<ContentVersion> attList = new List<ContentVersion>();
        if(!RequestAttachmentsList.isEMpty()){
            for(RONoteExchangefromAero.RequestAttachments attch : RequestAttachmentsList)
            {
                if(attch.FileName!=null && attch.FileName!= '' && attch.FileReference!=null && attch.FileReference!= ''){
                    system.debug('Before converting==>' + attch.FileReference);
                    string pdfcontent= attch.FileReference;
                    blob ROIbody = EncodingUtil.base64Decode(pdfcontent);
                    // string strpdf = ROIbody.toString();
                    //blob ebody = blob.toPdf(strpdf );
                    system.debug('string pdf==>'+pdfcontent);
                    //EncodingUtil.base64Decode(attch.FileReference);
                    // blob eBody = EncodingUtil.base64Decode(attch.FileReference);
                    // Blob body=Blob.toPDF(attch.FileReference);
                    // string afterblob = eBody.toString();
                    // blob eBody = Blob.toPdf(pdfcontent);
                    //system.debug('after converting==>' + ebody);
                    //system.debug('after converting to string ==>' + eBody.toString());
                     Attachment att = new Attachment();
//att.Body = ebody;
att.Body = ROIbody ;
att.ContentType = 'application/pdf';
att.Name = attch.FileName;
att.ParentId = mail.id;
system.debug('attbody===>' +att.Body);
attList.add(att);
                   /* ContentVersion objConVer = new ContentVersion();
                    objConVer.PathOnClient = attch.FileName;     
                    objConVer.Title = attch.FileName;
                    objConVer.VersionData = ROIbody;
                    attList.add(objConVer);*/
                }
            }
        }
        system.debug('attlist==>' + attList);
        /*if(FileReference!=null && FileReference!='' && FileName!=null && FileName!='' && FileType!=null && FileType!='' && mail.ID !=null )
{


}*/
        if(!attList.isEmpty())
        {
            try{
                insert attList;
                /*set<id> setConvID = new set<id>();
                for(ContentVersion objCon1 : attList){
                    if(objCon1 != null){
                        setConvID.add(objCon1.Id);
                    }
                }
                system.debug('setConvID: '+setConvID);
                List<ContentDocumentlink> lstConDoclink = new List<ContentDocumentLink>();
                if(setConvID != null && setConvID.size()>0){
                    for(ContentVersion objCon : [SELECT Id,Title,ContentDocumentId from ContentVersion where Id IN: setConvID AND IsLatest = true]){
                        ContentDocumentlink objCDL = new ContentDocumentlink();
                        objCDL.ContentDocumentId = objCon.ContentDocumentId;
                        objCDL.linkedentityId = mail.id;
                        objCDL.Sharetype = 'I';
                        lstConDoclink.add(objCDL);
                    }
                }
                if(lstConDoclink != null && lstConDoclink.size()>0){
                    Insert lstConDoclink;  
                    system.debug('check::::::'+lstConDoclink);
                }*/
            }
            catch (exception e){
                string excError = string.valueOf(e);
                system.debug('Unable to create case-Exception occured===' + e.getMessage());
                errorMsgList.add(excError);
            }
        }
        
        if(!errorMsgList.isEMpty()){
            string errmsg = 'An error has been occured unable to process the request' + 'Error: ' + errorMsgList;
            system.debug('Error has been occured' + errorMsgList);
            return errmsg;
        }
        else{
            return caseID;
            //return envelope;
        }
        //return('Overall Result ===>' + CommArealist + MessageSenderList + RequestAttachmentsList);
        
    }
    
}