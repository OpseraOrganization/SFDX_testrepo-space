/*******************************************************************************
Name         : EffortlessOrders_RejectOrderCheckboxClas
Created By   : Harikishore V
Company Name : NTT Data
Project      : <Phase-I>, <EfforlessOrders> 
Created Date : 25 September 2014
Usages       : Used to reject the case with options selected and sending mail to Contact of the Case
*******************************************************************************/

public class EffortlessOrders_RejectOrderCheckboxClas{
    String casowid;
    Public Case cas{get;set;}
    public String MTAdd{get;set;}
    public String MShTAdd{get;set;}
    public String MPO{get;set;}
    public String MQuan{get;set;}
    public String MPart{get;set;}
    public String ShTPO{get;set;}
    public String res{get;set;}
    public string Casowidsub{get;set;}
    public string csid{get;set;}
    public string caseid{get;set;}
    String strbaseURL = URL.getSalesforceBaseUrl().toExternalForm(); 
    List<Attachment> attlistWOCon = new List<Attachment>();
    Contact con;
    public EffortlessOrders_RejectOrderCheckboxClas(ApexPages.StandardController controller) {
        caseid = apexpages.currentpage().getparameters().get('Id');
        if(caseid!=null){
            cas = [select id,OwnerId,casenumber,Subject,Case_Ref_ID__c,Description,Contact_Name__c,Reject_Order_Reasons__c,SuppliedEmail,Status,Primary_Email_Address__c,contactid from Case where id=:caseid];
            //attlistWOCon = [SELECT id, Name, body, ContentType FROM Attachment WHERE ParentId=:caseid OR ParentId=:label.Reject_Order_template_Id];
            id conid=cas.Contactid;
            system.debug('Contact Id:'+conid);
            attlistWOCon = [SELECT id, Name, body, ContentType FROM Attachment WHERE ParentId=:caseid];
            con=[select id,Email,Primary_Email_Address__c from contact where id=:conid];
            system.debug('Contact Id:'+con);
        }
        if(cas!=null){
            casowid = cas.OwnerId;    
            Casowidsub = casowid.substring(0,3); 
        }
    }
    public Pagereference getSelected(){
        if(MTAdd == 'true'){
            if(res !=null){
                res = res+','+ 'Missing Sold-To Address'; 
            }
            else{
                res = 'Missing Sold-To Address'; 
            }      
        }
        if(MShTAdd == 'true'){
            if(res !=null){
                res = res+','+'Missing Ship-To Address' ;
            }
            else{
                res = 'Missing Ship-To Address' ;  
            }     
        }
        if(MPO == 'true') {
            if(res !=null){
                res = res+','+'Missing PO Number' ;  
            }
            else{
                res = 'Missing PO Number' ;  
            }   
        }
        if(MQuan == 'true') {
            if(res !=null){
                res = res+','+'Missing Quantity' ;  
            }
            else{
                res = 'Missing Quantity' ;  
            }   
        }
        if(MPart == 'true') {
            if(res !=null){
                res = res+','+'Missing Part Number' ;  
            }
            else{
                res = 'Missing Part Number' ;  
            }   
        }
        if(ShTPO == 'true') {
            if(res !=null){
                res = res+','+'Ship-To is PO Box' ;  
            }
            else{
                res = 'Ship-To is PO Box' ;  
            }   
        }
        List<Messaging.EmailFileAttachment> efaListWOCon = new List<Messaging.EmailFileAttachment>();     
        List<Messaging.SingleEmailMessage> msglist = new List<Messaging.SingleEmailMessage>();     
        List<Messaging.SingleEmailMessage> BulkEmails = new List<Messaging.SingleEmailMessage>();        
        List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
        
        if(attlistWOCon.size()>0 && attlistWOCon!=null){
            for(Attachment attWOCon:attlistWOCon){
                Messaging.EmailFileAttachment efaWOCon = new Messaging.EmailFileAttachment();
                efaWOCon.setFileName(attWOCon.Name);
                efaWOCon.setBody(attWOCon.body);
                efaWOCon.setContentType(attWOCon.ContentType);
                efaWOCon.setInline(false);
                efaListWOCon.add(efaWOCon);
            }
        }
        if(Casowidsub == '005' && (MTAdd == 'true'||MShTAdd == 'true'||MPO == 'true'||MQuan == 'true'||MPart == 'true'||ShTPO == 'true')){  
            system.debug('inside Main if------------->');         
            
                system.debug('inside if------------->');            
                if(cas.Reject_Order_Reasons__c == null)
                    cas.Reject_Order_Reasons__c = res;
                else{
                    cas.Reject_Order_Reasons__c = null;
                    cas.Reject_Order_Reasons__c = res;
                }
                cas.Status = 'Reject';
                cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
                cas.Government_Compliance_SM_M_Content__c = 'No';
                system.debug('@@@primary email id:'+cas.Primary_Email_Address__c);

                update cas;    
                    
                EmailTemplate em = [Select id,Name,HTMLValue,Subject,Body from EmailTemplate where id=:label.EffortlessOrdersRejectTemplate];
                               
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage(); 
                    if(cas.ContactId!=null && cas.Primary_Email_Address__c!=null){ 
                    system.debug('is entering here@@@'+cas.ContactId);                 
                    message.setTargetObjectId(cas.ContactId);
                    system.debug('messag@@@'+cas.Primary_Email_Address__c);                 
                    String[] toadd = new String[]{con.Primary_Email_Address__c}; 
                    message.setToAddresses(toadd);
                    system.debug('To address If:@@'+toadd);
                   
                    }
                    else{
                    system.debug('!!!!!');
                    
                     string conid=Label.UFR_Cont_Id;
                     message.setTargetObjectId(conid); 
                    
                     String[] toadd = new String[]{cas.SuppliedEmail}; 
                     message.setToAddresses(toadd);
                     system.debug('To address Else:@@'+toadd); 
                             
                    }
                    

                    message.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);
                    message.setWhatId(cas.Id);             
                    message.setBccSender(false);             
                    message.setUseSignature(false);
                    message.setSaveAsActivity(true); 
                   
                    if(efaListWOCon.size()>0 ){
                    message.setFileAttachments(efaListWOCon);
                    }
                    message.setTemplateId(label.EffortlessOrdersRejectTemplate);
                    msglist.add(message);                 
                    Messaging.sendEmail(msglist);
           
                system.debug('Email ---------->');
  
        }       
        if(BulkEmails.size()>0)
        {
            System.debug('Is sending mail');
            
            Messaging.sendEmail(BulkEmails);
    
        }                
          
        
        if(MTAdd == 'true'||MShTAdd == 'true'||MPO == 'true'||MQuan == 'true'||MPart == 'true'||ShTPO == 'true'){
            Pagereference tocase = new Pagereference('/'+caseid);
            tocase.setRedirect(true);
            return tocase;
        }else{
            return null;
        }
    }
}