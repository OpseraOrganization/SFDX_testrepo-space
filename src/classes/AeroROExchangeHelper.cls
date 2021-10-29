/*******************************************************************************
Name         : AeroROExchangeHelper
Company Name : NTT Data
Project      : <AeroROExchangeHelper> 
Created Date : 20-Aug-2019
Usages       : Future call out for posting XML response to AeroExchange. This class will be called from EMafterInsertHelperClass
*******************************************************************************/
public class AeroROExchangeHelper
{
  @future(callout = true)
    public static void XMLResponseToAero(set<ID> emsgID)
    {
        system.debug('Entered Method Aero');
        Id RTID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Repair & Overhaul').getRecordTypeId();
        system.debug('id===>' +RTID);
        set<ID> caseID = new set<ID>();
        set<ID> csID = new set<ID>();
        Map<ID,EmailMessage> caseEMIDMap = new Map<ID,EmailMessage>();
        Map<ID,string> caseEMSubject = new Map<ID,string>();
        set<ID> emID = new set<ID>();
        List<emailMessage> eList = new List<emailMessage>();
        string envelope;
        string envAttch ;
        string remarks;
        string CSRremarks;
        string supplierRemarks;
        string soapEnding;
        
        if(!emsgID.isEmpty()){
            for(EmailMessage em : [Select id, parentID,ToAddress,Subject,TextBody,HasAttachment from EmailMessage where ID In : emsgID])
            {
                caseEMIDMap.put(em.parentID,em);
                caseEMSubject.put(em.parentID ,em.Subject);
                
                if(em.ToAddress!=null && em.ToAddress.Contains(label.XML_Response_Toaddress))
                {
                system.debug('Email Message contains Debug Line 17');
                caseID.add(em.parentID);
               
                    emID.add(em.ID);
                    if(em.TextBody!=null){
                        system.debug('textbody');
                        remarks = em.TextBody;
                        //string remarks = em.textbody;
                        string[] str = remarks.split('Original Message');
                        string[] rm = str[0].split('--');
                         supplierRemarks = rm[0];
                        system.debug('split===' + supplierRemarks); 
                        
                    }
                }
            }
        }
        system.debug('remarks==>' +remarks);
        CSRremarks = '<aer:Remarks>' + supplierRemarks + '</aer:Remarks>';
      // Attachment att = new Attachment();
       List<attachment> attList = new List<attachment>();
        String content;
        String CType;
        String Name;
        ID emailID;
        EmailMessage emsg;
        boolean attach = false;
        if(!caseEMIDMap.isEmpty())
        {
            system.debug('entered if condition');
            for(EmailMessage e : [select id,parentID, subject,HasAttachment,Toaddress,MessageDate from EmailMessage where parentID IN :caseEMIDMap.Keyset() ORDER BY MessageDate DESC])
            {
                eList.add(e);                
                emsg = eList[0];
            }
        }
        system.debug('emsg==>' +emsg);
        if(emsg!=null && emsg.HasAttachment == true ){
            
        attList = [select id, Name, body, ContentType from Attachment where parentID =: emsg.ID ];
            system.debug('attList' +attList.size());
           
                if(attList.size()<=1){
                    system.debug('attlist size is one or zero');
                    for(Attachment att :attList){
                        content = EncodingUtil.base64Encode(att.body);
                        CType = att.ContentType;
                        Name = att.Name;
                    }
                }
            else{
                system.debug('More than one attachment is not supported as per Aero Structure');
            }
            
            
        }
       system.debug('att==>' +attList);
       system.debug('Name==' +Name);
        List<case> csList = new List<case>();
        if(!caseID.isEmpty())
        {
            for(Case cs: [select ID,casenumber,subject,Status,(select id,Case_object__c,ROExchange_XML__c,RoExchange_IsAttach__c from Case_Extensions__r) from case where RecordtypeId  =:RTID AND ID in :caseID])
            {
               //cs.subject = 'Updated to Future Handler';
               csList.add(cs);
               for(Case_Extension__c ce :cs.Case_Extensions__r)
               {
                   if(caseEMIDMap.containsKey(ce.Case_object__c)&& ce.ROExchange_XML__c!=null && attList.isEmpty())//att.id==null
                   {
                       system.debug('no attachment');
                       soapEnding =  '</aer:AEX_NotesExchangeWithDocAttachDetails>' + '\n' +
                           '<aer:UserArea>' +
                           '<aer:Identifier>' + 'test' + '</aer:Identifier>' 
                           + '<aer:Data>' + 'Test Data' + '</aer:Data>' + '</aer:UserArea>' +
                           '</aer:AEX_NotesExchangeWithDocAttach>'+ '</soapenv:Body>' + '</soapenv:Envelope>';
                       envelope = ce.ROExchange_XML__c + CSRremarks +soapEnding;
                   }
                   if(caseEMIDMap.containsKey(ce.Case_object__c)&& ce.ROExchange_XML__c!=null && !attList.isEmpty()) // attList.size()>0
                   {
                       system.debug('attachment if entered');
                       if(content!=null){
                       envAttch = '<aer:Attachments>' + '<aer:FileReference>' + Name+ ':'+'pdf;'+ content + '</aer:FileReference>'
                                    + '<aer:FileName>' +'FileName '  + '</aer:FileName>'+
                                        '<aer:FileType>' + 'application/pdf' + '</aer:FileType>' +
                                        '</aer:Attachments>'+ '</aer:AEX_NotesExchangeWithDocAttachDetails>' + '\n' +
                '<aer:UserArea>' +'<aer:Identifier>' + 'test' + '</aer:Identifier>' 
                + '<aer:Data>' + 'Test Data' + '</aer:Data>' + '</aer:UserArea>' +
                '</aer:AEX_NotesExchangeWithDocAttach>'+ '</soapenv:Body>' + '</soapenv:Envelope>';
                       }
                       system.debug('ROExchange_XML__c==' + ce.ROExchange_XML__c);
                       system.debug('envAttch==' + envAttch);
                       envelope = ce.ROExchange_XML__c + CSRremarks +envAttch;
                   }
               
               }
                
            }
            system.debug('string=====>'+envelope);
          // update csList; 
        }
        
        if(!emID.isEmpty()){
        // Sending XML Response to AeroExchange Server
         system.debug('xml response');
        try{
        HttpRequest req = new HttpRequest();
          system.debug('entered try block before end point');  
        req.setEndpoint(label.RO_Exhange_End_Point);  //1011F000004ecCX - Label ID
            system.debug('entered try block');
        req.setMethod('POST');
             system.debug('After post method'); 
        //string str = '7X000:Welcome10';
        //Blob headerValue = Blob.valueOf(label.ROExchange_Uname_Pwd);  //1011F000004ecCc - Label ID
            system.debug('After username');
           Blob headerValue = Blob.valueOf(Label.UFR_UserName_and_Pass); 
           String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
          req.setHeader('Authorization', authorizationHeader);
          req.setHeader('SOAPAction', 'http://sap.com/xi/WebService/soap1.1');
          req.setTimeout(120000);
          req.setCompressed(true);
          req.setHeader('Content-Type','application/xml');
          req.setHeader('Content-Length',String.valueof(envelope.length()));
          req.setBody(envelope);
          Http http = new Http();
          HTTPResponse res = http.send(req);   
          system.debug('HttpsRes'+res );
          System.debug('$$$$ + res.getBody() = :'+req.getBody());
        }
        catch (exception e)
        {
             system.debug('AeroROnoteExchange - exception occurs while sending data to AeroExchange '+e.getMessage());
        }
        }
    }
    


}