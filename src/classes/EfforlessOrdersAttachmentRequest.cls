/*******************************************************************************
Name         : EfforlessOrdersAttachmentRequest
Created By   : Siva Nannapaneni
Company Name : NTT Data
Project      : <Phase-I>, <EfforlessOrders> 
Created Date : 25 September 2014
Usages       : Sending case attachments to SAP PI. This apex class used in AfterUpdateHelperClass.           
*******************************************************************************/

public class EfforlessOrdersAttachmentRequest{
    @future(callout=true)
    public static void SendRequest(string SONum,string CaseNum, list<id> atts ){
        Case c = new Case();
        c = [select id,OwnerId__r.Email,Sales_Order_Number__c,OwnerId__r.Name,OwnerId from Case where CaseNumber=:CaseNum];
        system.debug('-------->'+c);        
        String ownername,Owneremail,sonumber,Attnames,OwId;
        Integer count=0;
        List<Messaging.SingleEmailMessage> msglist = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();     
        try{  
        //Prapeing Soap envelope//
            for(id ai:atts){
                //System.debug('$$$$' + EncodingUtil.base64Encode(a.body));
                string envelope= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="http://hnwl.com/INFOC00052/EO/SOAttchmntUpdate">'+
                '<soapenv:Header/>'+
                '<soapenv:Body>'+
                '<ns0:MT_SOAttchmntUpdate_Request>'
                +'<SONum>'+SONum+'</SONum>'+
                '<CaseNum>'+CaseNum+'</CaseNum>';
                attachment a=[SELECT id,BodyLength, name, contenttype,body FROM Attachment WHERE Id =:ai];
               
                if(a.BodyLength>=3200000){
                    if(Attnames!=null)
                        Attnames = Attnames+','+a.Name;
                    else
                        Attnames = a.Name;
                }
                System.debug('*********' + a.name);
                envelope += '<Attachmnt>'+
                '<MimeType>'+a.contenttype+'</MimeType>'+
                +'<FileName>'+a.name+'</FileName>'+
                +'<FileContent>'+EncodingUtil.base64Encode(a.body)+'</FileContent></Attachmnt>';
                 
                envelope +=  '</ns0:MT_SOAttchmntUpdate_Request></soapenv:Body></soapenv:Envelope>';
                if(a.BodyLength<=3200000){     
                    HttpRequest req = new HttpRequest();
                    req.setEndpoint(label.EffortlessOrders_Endpoint); //Service URL
                    req.setMethod('POST');
                    //Blob headerValue = Blob.valueOf(label.EffortlessOrders_Username_and);
                    Blob headerValue = Blob.valueOf(label.Denied_Party_UserNameAndPass);
                    String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
                    req.setHeader('Authorization', authorizationHeader);
                    // req.setHeader('Content-Type', 'application/xml');
                    req.setHeader('SOAPAction', 'http://sap.com/xi/WebService/soap1.1');
                    req.setTimeout(120000);
                    req.setCompressed(true);
                    req.setHeader('Content-Type','application/xml');
                    req.setHeader('Content-Length',String.valueof(envelope.length()));
                    req.setBody(envelope);
                  
                    Http http = new Http();
                    HTTPResponse res = http.send(req);   
                    System.debug('$$$$ + res.getBody() = :'+res.getBody());
                }
                else{
                    count++;
                }
            }
        }
            Catch(Exception e){
                System.debug(e);
                //Catch exception and store in RnO Automation Transaction Log object//
                RnO_Automation_Transaction_Log__c tlog = new RnO_Automation_Transaction_Log__c();
                tlog.Status__c = 'failed';
                tlog.Description__c = 'Effortless Orders:'+e;
                tlog.Case_Num__c = casenum;
                tlog.Sales_Order_Num__c = sonum;
                insert tlog;
                count++;
                system.debug('count-->'+count);
            }  
        //}
        if(count>=1){
            ownername = c.OwnerId__r.Name;
            Owneremail = c.OwnerId__r.Email;
            sonumber = c.Sales_Order_Number__c; 
            OwId = c.ownerid;         
            if(OwId !=null && String.valueof(OwId ).startswith('005')){
                String[] toadd = new String[]{Owneremail};  
                system.debug('toadd  '+toadd);
                string body='<!DOCTYPE html><body><table border="0" cellpadding="0" cellspacing="0" width="950" style="position: absolute;right: 50px;"><tr><td align="center" height="45" valign="top"><img src="https://c.na19.content.force.com/servlet/servlet.ImageServer?id=015300000018fo4&amp;oid=00D30000000dWxY" alt="Logo" style="border:none;display:block;right: 20px;position: absolute;top: 10px;height: 30px;"/></td></tr><br/></table><table border="0" cellpadding="5" cellspacing="0" width="600" style="position: absolute;right: 50px;border-top-width: 4px;border-top-style: solid;border-top-color: #ED2028;border-bottom-width: 4px;border-bottom-style: solid;border-bottom-color: #ED2028;"><tr><td align="right" valign="top"><table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td align="left" height="60" style="font-family:arial;font-size:16px;padding-left: 24px;" valign="middle">Hi '+ownername+',<br/><br/></td></tr><tr><td align="left" height="60" style="font-family:arial;font-size:16px;padding-left: 24px;" valign="middle">Attachments ['+Attnames+'] for SO Number '+sonumber+' were not moved from Salesforce to SAP because of 3MB size limit. Please upload them manually.<br/><br/>Thanks,<br/>Aero SFDC Team</td></tr></table></td></tr></table><br/><br/><table border="0" cellpadding="5" cellspacing="0" width="600" style="position: absolute;right: 50px;border-bottom-width: 4px;border-bottom-style: solid;border-bottom-color: #ED2028;"/></body></html>';
                            
                message.setToAddresses(toadd);
                message.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);
                message.setBccSender(false);             
                message.setUseSignature(false);
                message.setSaveAsActivity(false); 
                message.setSubject('Action Required – Please copy files manually from SFDC to SAP');
                message.setHtmlBody(body);
                msglist.add(message);
            }
            Messaging.sendEmail(msglist);
        }
    }
}