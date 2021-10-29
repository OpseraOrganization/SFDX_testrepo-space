public class APTS_PDF_Attachment_Status_Helper {
    public static void sendInvoiceemail(map<id,APTS_PDF_Attachment_Status__c> newatt,map<id,APTS_PDF_Attachment_Status__c> oldatt){
        try{
            system.debug('sendinvoiceapproveemail');
            //system.debug('newatt=='+newatt);
            list<ID> invoceids = new list<ID>();
            list<Apttus_Billing__Invoice__c> invocies = new list<Apttus_Billing__Invoice__c>();
            for(APTS_PDF_Attachment_Status__c APTSPDF:newatt.values()){
                if(APTSPDF.APTS_Invoice_Status__c=='Approved' && ( Trigger.isInsert || (oldatt.get(APTSPDF.id).APTS_Invoice_Status__c != APTSPDF.APTS_Invoice_Status__c))){
                    invoceids.add(APTSPDF.APTS_Invoice__c);
                }
                
            }
            system.debug('invoceids=='+invoceids);
            list<id> invids=new list<id>();
            for(Apttus_Billing__Invoice__c inv:[select id,Apttus_Billing__Status__c,Price_List__c,Apttus_Billing__DeliveryStatus__c from Apttus_Billing__Invoice__c where id in: invoceids]){
                if(Inv.Apttus_Billing__DeliveryStatus__c == 'Pending' && inv.Apttus_Billing__Status__c=='Approved' && inv.Price_List__c != Null && (inv.Price_List__c == 'Aspire PriceList'||inv.Price_List__c == 'Aspire PriceList_SAPOrders')){
                    invids.add(inv.id);
                }
            }
            system.debug('invids'+invids); 
            if(invids.size()>0){
                list<id> orderids=new list<id>();
                list<Apttus_Billing__Invoice__c> invs=new list<Apttus_Billing__Invoice__c>();
                map<id,list<id>> mapordinvoice= new map<ID,list<ID>>();//lnvoice with orders
                
                for(Apttus_Billing__InvoiceLineItem__c invlineitem:[select id,Apttus_Billing__InvoiceId__c,Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__c  from Apttus_Billing__InvoiceLineItem__c where Apttus_Billing__InvoiceId__c in:invids and Apttus_Billing__InvoiceId__r.Apttus_Billing__Status__c='Approved']){
                    system.debug('invlineitem'+invlineitem);
                    system.debug('invlineitem order'+invlineitem.Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__c);
                    
                    if(invlineitem.Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__c!=null ){
                        orderids.add(invlineitem.Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__c); 
                        if(!mapordinvoice.containsKey(invlineitem.Apttus_Billing__InvoiceId__c)) {
                            mapordinvoice.put(invlineitem.Apttus_Billing__InvoiceId__c, new List<id>()); 
                        }
                        mapordinvoice.get(invlineitem.Apttus_Billing__InvoiceId__c).add(invlineitem.Apttus_Billing__BillingScheduleId__r.Apttus_Billing__OrderLineItemId__r.Apttus_Config2__OrderId__c);
                    }
                    // }
                }
                if(mapordinvoice.keyset()!=null && mapordinvoice.keyset().size()>0){
                    system.debug('mapordinvoice'+mapordinvoice);
                    map<id,list<id>> mapaptsatt=new map<id,list<id>>();//order with emails
                    for(APTS_PDF_Attachment_Status__c aptsatt:[select id,APTS_Attachment_Id__c,APTS_Invoice__c from APTS_PDF_Attachment_Status__c where APTS_Invoice__c in:mapordinvoice.keyset() and APTS_Invoice_Status__c='Approved' AND Price_List_Name__c != Null Order By CreatedDate Asc Limit 1]){
                        if(!mapaptsatt.containsKey(aptsatt.APTS_Invoice__c)) {
                            mapaptsatt.put(aptsatt.APTS_Invoice__c, new list<id>()); 
                        }
                        mapaptsatt.get(aptsatt.APTS_Invoice__c).add(aptsatt.APTS_Attachment_Id__c);
                    }
                    system.debug('mapaptsatt'+mapaptsatt);
                    map<id,set<string>> ordemails=new map<id,set<string>>();//order with emails
                    for(CPQ_Email__c emails: [select id,name,Order__c from CPQ_Email__c where Order__c in:orderids]){
                        system.debug('email'+emails);
                        if(!ordemails.containsKey(emails.Order__c)) {
                            ordemails.put(emails.Order__c, new set<string>()); 
                        }
                        ordemails.get(emails.Order__c).add(emails.name);
                    }
                    system.debug('ordemails'+ordemails);
                    List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
                    Account Acc = [Select id from Account limit 1];
                    Contact cnt = new Contact();
                    cnt.FirstName = invoceids[0];
                    cnt.LastName = 'Contact';
                    cnt.AccountId = Acc.id;
                    cnt.Email = 'no-reply@gmail.com';
                    insert cnt;
                    
                    //get templete id
                    EmailTemplate et=[Select id from EmailTemplate where name = 'InvoiceEmailTemplate' limit 1];
                   
                    system.debug('mapordinvoice.keyset()'+mapordinvoice.keyset());
                    list<OrgWideEmailAddress> listOrgwide= new list<OrgWideEmailAddress>();
                    Map<String, Apttus_Billing__BillingSystemProperties__c> orgwideEmail = Apttus_Billing__BillingSystemProperties__c.getAll();
                    system.debug('orgwideEmail'+orgwideEmail);
                    
                   listOrgwide = [select Id from OrgWideEmailAddress where Address =: system.label.AspireLicenseEmailAddress];
                    system.debug('listOrgwide'+listOrgwide);
                    for(id inv:mapordinvoice.keyset()){
                        List<Id> attachmentIds = new List<Id>();
                        attachmentIds=mapaptsatt.get(inv);
                        system.debug('attachmentIds'+attachmentIds);
                        set<string> Addresses= new set<string>();
                        system.debug('inv.id)=='+inv);
                        system.debug('mapordinvoice.get(inv)'+mapordinvoice.get(inv));
                        for(id ordid:mapordinvoice.get(inv)){
                            system.debug('ordemails.get(ordid)'+ordemails.get(ordid));
                            set<string> emails= (set<string>)ordemails.get(ordid);
                            Addresses.addall(emails);
                        }
                        list<string> toAddresses= new list<string>(Addresses);
                        system.debug('toAddresses'+toAddresses);
                        if(toAddresses.size()>0){
                           
                            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                            msg.setTemplateId(et.id);
                            msg.setWhatId(inv);
                            msg.setTargetObjectId(cnt.id);
                            msg.setTreatTargetObjectAsRecipient(false);//to avoid sending email to dummy Contact email
                            msg.setToAddresses(toAddresses);
                            msg.setReplyTo('no-reply@honeywell.com');
                            if(listOrgwide!=null && !listOrgwide.isEmpty())
                                msg.setOrgWideEmailAddressId(listOrgwide.get(0).Id);
                            msg.SaveAsActivity = false;
                            if(attachmentIds!=null && !attachmentIds.isempty())
                                msg.setEntityAttachments(attachmentIds);
                            msgList.add(msg);
                        }
                        
                    }
                    system.debug('msgList'+msgList);
                    if(msgList!=null && msgList.size()>0){
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(msgList); 
                        system.debug('results'+results);
                    }
                    // Don't Forget!  Clean up!
                    delete cnt;
                }
            }
            
        }catch(Exception e){
            system.debug('e.getMessage()'+e.getMessage());
            system.debug('e.getLineNumber()'+e.getLineNumber());
            system.debug('e.getCause()'+e.getCause());
            system.debug('e.getTypeName()'+e.getTypeName());
        }
    }
    
}