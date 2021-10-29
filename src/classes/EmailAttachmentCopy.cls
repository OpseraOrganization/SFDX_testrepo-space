// Copy the email attachment message to Case level
// Implemented on 02/23/2012 by Wipro SFDC Support
// Changes done for XML Project to send case details to SAP

public class EmailAttachmentCopy {

    @future(callout=true)
    public static void attachcase(Set<ID> caseID){
        Map<String,String> emailmap = new Map<String,String>();
        String XMLbody, XMLSub, XMLEmailSendStatus,AttCasId;
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage XMLmsg = new Messaging.SingleEmailMessage();
        List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
        List<Case> caslist = new List<Case>();
        List<ID> autocaseID = new List<ID>();
        for(EmailMessage att : [select ID,ParentID,Status,TextBody,Toaddress,FromAddress,HasAttachment from EmailMessage where Id IN: caseID and status != '5']){
            System.debug(att);
            if(att.hasattachment == True){
                emailmap.put(att.ID,att.ParentID);
            }
            AttCasId = att.ParentId;
        }
        //Added below logic for Conexiom Autofoward Emails
        List<EmailMessage> emList = new List<EmailMessage>();
        List<EmailMessage> GEmailList = new List<EmailMessage>(); // This is for no attachment list
        for(EmailMessage att : [select ID,ParentID,Parent.AccountID,Status,MessageDate,subject,HasAttachment,Parent.createdDate,Toaddress,FromAddress,TextBody from EmailMessage where Id IN: caseID]){
            autocaseID.add(att.ParentID);
           		system.debug('eMessage==' +att);
                system.debug('entered aerorepairs/OEM if ==>' + att.Toaddress);
                system.debug('case created time==>' + att.Parent.createdDate);
                Time csTime = att.Parent.createdDate.Time();
                Time eTime = att.MessageDate.Time();
                decimal diffTime = ((att.MessageDate.getTime())/1000/60)- ((att.Parent.createdDate.getTime())/1000/60);
                system.debug('csTime==>' + csTime);
            system.debug('diffTime==>' +diffTime);
            system.debug('subject==' + att.subject);
            system.debug('hasAttachment==>' +att.HasAttachment);
                if(!att.subject.contains('ref:_00') && (diffTime<=2) && att.HasAttachment == TRUE){
                    system.debug('entered emailAttachSubject');
                    emList.add(att);
                    //GEmailList.add(att);
                }
          else if(!att.subject.contains('ref:_00') && (diffTime<=2) &&  att.HasAttachment == FALSE){
                    system.debug('entered emailAttachSubject111');
                    GEmailList.add(att);
                }
            
            
        }
        system.debug('eList==>' +emList);
        
        
        system.debug('GEmailList==>' +GEmailList);
        
        //Ended the Conexiom Logic  
        List<Attachment> caseatt = new List<Attachment>();
              
        // Starts XML Project Code
        if(AttCasId!=null && AttCasId.subString(0,3)=='500'){
            List<Case> cas = [SELECT id,CaseNumber,RecordTypeId,Origin,Ownerid,SuppliedEmail,Status,CreatedByID,IsClosed from Case where Id=:AttCasId and Origin = 'XML Order' and RecordtypeId =:Label.XML_Orders_RecordType_Id and Ownerid =:Label.aero_default_user_id and CreatedByID=:Label.aero_default_user_id and IsClosed = False and Status = 'Open'];
            system.debug('-----Cas'+cas);
            if(cas!=null && cas.size()>0){
                List<Attachment> a = [SELECT id,BodyLength, Name, ContentType,Body FROM Attachment where ParentId IN:emailmap.Keyset() and (ContentType='application/xml' or ContentType='text/xml' or Name Like'%.xml') limit 1];
                system.debug('------>attachment'+a);
                if(a.size()>0){
                    System.debug('XML********* '+a);
                    try{
                        //Preparing Soap envelope           
                        String envelope= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:n0="http://hnwl.com/INFOC00063/HONSparesOrder">'+
                        '<soapenv:Header/>'+
                        '<soapenv:Body>'+
                        '<n0:MT_HONSparesOrder>'+
                        '<CaseNumber>'+cas[0].CaseNumber+'</CaseNumber>'+
                        '<Attachment>'+
                        '<MimeType>'+a[0].contenttype+'</MimeType>'+
                        '<FileName>'+a[0].name+'</FileName>'+
                        '<FileContent>'+EncodingUtil.base64Encode(a[0].body)+'</FileContent>'+
                        '</Attachment>'+
                        '</n0:MT_HONSparesOrder></soapenv:Body></soapenv:Envelope>';
                        System.debug('----->envelope '+envelope);
                        if(a[0].BodyLength<=3200000){     
                            HttpRequest req = new HttpRequest();
                            //req.setEndpoint(label.XML_Ordering_Endpoint_URL); //Service URL
                            req.setEndpoint(label.XML_Ordering_EndpointURL); //Service URL
                            req.setMethod('POST');
                            Blob headerValue = Blob.valueOf(label.XML_UserName_and_Pass);
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
                            System.debug('$$$$ + res.getBody() = :'+res.getBody());
                        }
                    }Catch(Exception e){
                        system.debug('XML Ordering - exception occurs while sending data to SAP '+e.getMessage());
                    }
                }else{
                    system.debug('no att or no xml reject---->');
                    String[] toadd = new String[]{cas[0].SuppliedEmail};
                    Id Whatid = cas[0].id;
                    XMLmsg.setToAddresses(toadd);
                    XMLmsg.setOrgWideEmailAddressId(Label.AeroNo_Reply_email_ID);
                    XMLmsg.setWhatId(Whatid);
                     //changed for INC0003203375
                    XMLmsg.setSaveAsActivity(false);
                    //changed for INC0003203375 end
                    XMLbody = '<!DOCTYPE html><body><table border="0" cellpadding="5" cellspacing="0" width="600" height="400" style="position: absolute;border-top-width: 4px;border-top-style: solid;border-top-color: #ED2028;border-bottom-width: 4px;border-bottom-style: solid;border-bottom-color: #ED2028;"><tr><td><table height="400" width="600" cellpadding="5" border="0" cellspacing="5"><tr><td style=" color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;" tEditID="c1r1" locked="0" aEditID="c1r1" ><font face="Arial, sans-serif" size="2">Dear Customer,<br/><br/>While attempting to extract your XML order, we found that the XML file attachment is either missing or has an incorrect file extension. Please resubmit your order with the XML file attached in the correct ‘.xml’ file format. <br/><br/>If you have any questions, please contact Honeywell Customer Support at Orders@Honeywell.com or call the toll free number for your region listed below.<br/><br/>Best Regards,<br/><br/>Honeywell Customer Support Team<br/><br/><b>·</b>    Australia  1800238870<br/><b>·</b>    China  4008210284  Select Option 9,  Enter any extension: 8093 or 8103 or 8105<br/><b>·</b>    Hong Kong  30126695<br/><b>·</b>    India  0008004420088<br/><b>·</b>    Indonesia  0078030114580<br/><b>·</b>    Japan  0120922192<br/><b>·</b>    Korea  0809000883<br/><b>·</b>    Malaysia  1800885339<br/><b>·</b>    New Zealand  0508223283<br/><b>·</b>    Philippines  180089088327<br/><b>·</b>    Singapore  18006227225<br/><b>·</b>    Taiwan  0800666264<br/><b>·</b>    Thailand  0018004418027<br/><b>·</b>    United States  18006013099<br/></font></td></tr></table></td></tr></table><br/><br/></body></html>';
                    XMLSub = 'Oops! Your XML purchase is unable to be processed. Details Inside';
                    XMLmsg.setHtmlBody(XMLbody);
                    XMLmsg.setSubject(XMLSub);
                    bulkEmails.add(XMLmsg);
                    cas[0].Status = 'Rejected';
                    cas[0].Export_Compliance_Content_ITAR_EAR__c = 'No';
                    cas[0].Government_Compliance_SM_M_Content__c = 'No';
                    
                    if(cas[0].Resolution__c == null)
                        cas[0].Resolution__c = 'None';
                    caslist.add(cas[0]);
                }
            }
            if(bulkEmails.size()>0){
                Messaging.sendEmail(bulkEmails); 
                XMLEmailSendStatus = 'EmailSendSuccess!';  
                    system.debug('the XML EMmail Send Status id'+XMLEmailSendStatus);
            } 
            if(cas!=null && XMLEmailSendStatus == 'EmailSendSuccess!'){
                EmailMessage emailToCase = new EmailMessage();
                emailToCase.Incoming = false;
                system.debug('the value of incoming is'+emailToCase.Incoming);
                emailToCase.Subject = XMLSub;
                emailToCase.MessageDate = system.now();
                emailToCase.ParentId = cas[0].Id;
                emailToCase.ToAddress = cas[0].SuppliedEmail;
                system.debug('the value of ToAddress is'+emailToCase.ToAddress);
                emailToCase.FromAddress = 'aerodonotreply@honeywell.com';
                emailToCase.FromName = 'No Reply';
                if(XMLbody!=null && XMLbody.length()>0){
                    if(XMLbody.length()<32000)
                        emailToCase.HtmlBody =  XMLbody.substring(0,XMLbody.length());
                    else
                        emailToCase.HtmlBody =  XMLbody.substring(0,32000);
                }
                listInsertEmailMessage.add(emailToCase);
            }
            if(listInsertEmailMessage.size()>0){
                try{
                    insert listInsertEmailMessage;
                }Catch(DMLException emailex){
                    system.debug('XML Email Message Insert----->'+emailex.getMessage());
                }
            }
            if(caslist.size()>0){
                update caslist;
            }
        }
        // End for XML Project Code
        for(Attachment a : [select Id,Name,Body,ParentID,ContentType from Attachment where ParentID IN: emailmap.Keyset()]){
            Attachment aobj = new Attachment();
            aobj.name=a.name;
            aobj.body=a.body;
            aobj.ContentType = a.ContentType;
            aobj.parentid = emailmap.get(a.ParentID);
            caseatt.add(aobj);
        }
        if(caseatt.size()>0){
        try{
            Insert caseatt;
            system.debug('conexiom started');
            if(!emList.isEMpty()){
                ConexiomAutoforwardEmailHandler.autoForwardEmail(emList);
                ConexiomAutoforwardEmailHandler.autoForwardROemail(emList);
                ConexiomAutoforwardEmailHandler.GEQuoteAutoForwardEmail(emList);
            }
            
            //ConexiomAutoforwardEmailHandler.autoForwardSample(emList);
           // ConexiomAutoforwardEmailHandler.autoforwardROconexiom(autocaseID);
            }
          catch(exception e){
              system.debug('Exception occured for inserting attachments=='+ e.getMessage());
          }
        }
        else{
            if(!GEmailList.isEmpty()){
                system.debug('GEmailList==if' + GEmailList);
                ConexiomAutoforwardEmailHandler.GEQuoteAutoForwardEmail(GEmailList);
            }
            
        }
    }
    
    public static testmethod void attachmenttest()
    {
        Case cse = new Case();
        cse.Origin = 'XML Order';
        cse.Status = 'Open';
        cse.RecordTypeId = Label.XML_Orders_RecordType_Id;
        cse.Classification__c = 'Customer Master Team / eBusiness';
        //cse.ContactId = lstContacts[i].Id;
        cse.Type_of_Change__c = 'New Account';
        cse.Type = 'Other';
        cse.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cse.Government_Compliance_SM_M_Content__c = 'NO';
        cse.Ownerid = Label.aero_default_user_id;
        cse.CreatedByID = label.aero_default_user_id;
        cse.SuppliedEmail = 'XMLtest@test.com';
        insert cse;
        Emailmessage e1 = new Emailmessage(parentid=cse.id);
        e1.ToAddress='test@test.com';
        e1.Incoming=False;
        insert e1;
        Emailmessage e2 = new Emailmessage(parentid=cse.id);
        e2.ToAddress='test@test.com';
        e2.Incoming=False;
        insert e2;
        Attachment a1 = new Attachment(name='sample',body=blob.valueof('samplebody'),parentid=e1.id, ContentType='text/xml');
        insert a1;
        Set<ID> temp = new Set<ID>();
        temp.add(cse.id);
        EmailAttachmentCopy ea =new EmailAttachmentCopy();
        EmailAttachmentCopy.attachcase(temp);
    }
}