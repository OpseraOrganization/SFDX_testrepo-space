/*******************************************************************************

AERO

Name         : APTS_sendInvoiceToCustomer
Created By   : Shiva Shankar Nalluri
Company Name : HTS
Project      : NGBSS-FE 
Created Date : 09-Feb-2018
Description  : This class is used to send invoice email to customer.
   
*******************************************************************************/
global class APTS_sendInvoiceToCustomer implements Database.Batchable<SObject> {
    
    global List<Id> invoiceMailList = new List<Id>();
    global APTS_sendInvoiceToCustomer(List<Id> invoiceMailList)
    {
        this.invoiceMailList=invoiceMailList;
    }
    
  public Database.QueryLocator start(Database.BatchableContext context) {
    return Database.getQueryLocator([select Id, Apttus_Billing__Status__c,Apttus_Billing__DeliveryStatus__c,Apttus_Billing__BillToAccountId__c, Apttus_Billing__BillToAccountId__r.Apttus_Config2__InvoiceEmailTemplate__c, APTS_LatestAttachmentId__c from Apttus_Billing__Invoice__c where id In:invoiceMailList]);
  }

  public void execute(Database.BatchableContext context, List<Apttus_Billing__Invoice__c> scope) {    

    
    set<id> setAccId= new Set<Id>();
    set<string> templateName= new set<string>();
    map<string,id> templateNametoId= new map<string,id>();
    map<Id,id> mapAccIdtoContact = new map<Id,id>();
    map<Id,list<contact>> mapAccIdtoContactList = new map<Id,list<contact>>();
    list<OrgWideEmailAddress> listOrgwide= new list<OrgWideEmailAddress>();
    Map<String, Apttus_Billing__BillingSystemProperties__c> orgwideEmail = Apttus_Billing__BillingSystemProperties__c.getAll();  
    if(orgwideEmail!=null && !orgwideEmail.isEmpty() && orgwideEmail.get('System Properties').Apttus_Billing__BillingOrgWideEmailAddress__c!=null)  
        listOrgwide=[select id, Address, DisplayName from OrgWideEmailAddress where DisplayName =:orgwideEmail.get('System Properties').Apttus_Billing__BillingOrgWideEmailAddress__c];
    for(Apttus_Billing__Invoice__c objInv:scope)
    {
        setAccId.add(objInv.Apttus_Billing__BillToAccountId__c);
        templateName.add(objInv.Apttus_Billing__BillToAccountId__r.Apttus_Config2__InvoiceEmailTemplate__c);
    }

    if(templateName!=null && !templateName.isEmpty())
    {
        list<EmailTemplate> lstET=[Select id,Name from EmailTemplate where Name In:templateName];
        for(EmailTemplate objET:lstET)
        {
            templateNametoId.put(objET.name,objET.id);
        }
    }
    
    if(setAccId!=null && !setAccId.isempty())
    {
        list<contact> lstCon=[select id,email,accountid,APTS_Subscription_Management_Billing__c from contact where accountid In:setAccId];
        for(contact objcon:lstCon)
        {
            if(objcon.APTS_Subscription_Management_Billing__c=='Yes')
            {
                if (mapAccIdtoContactList.containsKey(objcon.accountid))
                    mapAccIdtoContactList.get(objcon.accountid).add(objcon);
                else
                    mapAccIdtoContactList.put(objcon.accountid, new  List <contact> { objcon });
                    mapAccIdtoContact.put(objcon.accountid,objcon.id);
            }
                
            
        }
    }
    system.debug('>>>>>>>'+mapAccIdtoContact+'>>>>');
    list<Messaging.SingleEmailMessage> listEmailtosend= new list<Messaging.SingleEmailMessage>();
    list<Apttus_Billing__Invoice__c> updateToDelivered= new list<Apttus_Billing__Invoice__c>();
    map<Id,Apttus_Billing__Invoice__c> mapInvIdtoInvoice = new map<Id,Apttus_Billing__Invoice__c>();
    for(Apttus_Billing__Invoice__c objInv:scope)
    {
        if(isBlankorIsNull(objInv.Apttus_Billing__BillToAccountId__c) &&  isBlankorIsNull(objInv.Apttus_Billing__BillToAccountId__r.Apttus_Config2__InvoiceEmailTemplate__c) && isBlankorIsNull(objInv.APTS_LatestAttachmentId__c) && mapAccIdtoContactList!=null && !mapAccIdtoContactList.isEmpty() && mapAccIdtoContact.get(objInv.Apttus_Billing__BillToAccountId__c)!=null &&
        templateNametoId!=null && !templateNametoId.isEmpty()&& templateNametoId.get(objInv.Apttus_Billing__BillToAccountId__r.Apttus_Config2__InvoiceEmailTemplate__c)!=null)
        {
            if(mapAccIdtoContactList.get(objInv.Apttus_Billing__BillToAccountId__c)!=null)
            {
                for(contact objc:mapAccIdtoContactList.get(objInv.Apttus_Billing__BillToAccountId__c))
                {
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();        
                    email.setTargetObjectId(objc.id);
                    email.setTemplateId(templateNametoId.get(objInv.Apttus_Billing__BillToAccountId__r.Apttus_Config2__InvoiceEmailTemplate__c));
                    email.setSaveAsActivity(true);
                    email.setWhatId(objInv.Id);
                    email.setEntityAttachments(new List<Id>{objInv.APTS_LatestAttachmentId__c});
                    if(listOrgwide!=null && !listOrgwide.isEmpty())
                        email.setOrgWideEmailAddressId(listOrgwide[0].Id);
                    listEmailtosend.add(email);
                    //updating billing staus to Delivered
                    objInv.Apttus_Billing__DeliveryStatus__c='Delivered';
                }
                mapInvIdtoInvoice.put(objInv.Id,objInv);
            }
        }
        
    }
    if(listEmailtosend!=null && !listEmailtosend.isEmpty())
        List<Messaging.SendEmailResult> results =Messaging.sendEmail(listEmailtosend);
    if(mapInvIdtoInvoice!=null && !mapInvIdtoInvoice.isEmpty())  
        update mapInvIdtoInvoice.values();
    }
    
  public void finish(Database.BatchableContext context) {
  }
  
  public boolean isBlankorIsNull(string str)
  {
        if(str!=null && str!='')
            return true;
        else
            return false;
  }
}