public class Apttus_Config2_Order_Helper {
    @InvocableMethod
    public static void sendLicenseemail(list<id> ApttusConfig2Orders){
       
        map<id,set<string>> ordemails=new map<id,set<string>>();//order with emails
        Set<id> oidset = New Set<id>();
        For(id OId :ApttusConfig2Orders)
        {
          oidset.Add(OId);
        }
        List<Apttus_Config2__OrderLineItem__c> lstACOL = [Select id,Apttus_Config2__OrderId__c,Apttus_Config2__OptionId__c,Apttus_Config2__OptionId__r.License_Type__c from Apttus_Config2__OrderLineItem__c where Apttus_Config2__OrderId__c =: oidset AND Apttus_Config2__OptionId__c != Null];
        
        List<Apttus_Config2__OrderLineItem__c> APUProducts = New List<Apttus_Config2__OrderLineItem__c>();
        List<Apttus_Config2__OrderLineItem__c> AsipProducts = New List<Apttus_Config2__OrderLineItem__c>();
        
        For(Apttus_Config2__OrderLineItem__c ACO : lstACOL)
        {
          IF(ACO.Apttus_Config2__OptionId__r.License_Type__c == 'APU')
          {
            APUProducts.Add(ACO);
          }
          Else
          {
            AsipProducts.Add(ACO);
          }
        }
        System.debug('Asipr'+AsipProducts.Size());        
        for(CPQ_Email__c emails: [select id,name,Order__c from CPQ_Email__c where Order__c in:ApttusConfig2Orders]){
            
            if(!ordemails.containsKey(emails.Order__c)) {
                ordemails.put(emails.Order__c, new set<string>()); 
            }
            ordemails.get(emails.Order__c).add(emails.name);
        }
       
        List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
         Account Acc = [Select id from Account limit 1];
        // Create Contact
        Contact cnt = new Contact();
        cnt.FirstName = ApttusConfig2Orders[0];
        cnt.LastName = 'Contact';
        cnt.AccountId = Acc.id;
        cnt.Email = 'no-reply@gmail.com';
        insert cnt;
        
        //get templete id
        
        list<OrgWideEmailAddress> listOrgwide= new list<OrgWideEmailAddress>();
        listOrgwide = [select Id from OrgWideEmailAddress where Address =: system.label.AspireLicenseEmailAddress];
        set<string> Addresses;
        for(id ord:ApttusConfig2Orders){
                Addresses= new set<string>();
                for(id ordid:ApttusConfig2Orders)
               {
                set<string> emails= (set<string>)ordemails.get(ordid);
                Addresses.addall(emails);
               }
        }
        System.debug('Addresses'+Addresses.Size());
        If(APUProducts.Size()>0)
        {
          EmailTemplate et =[Select id from EmailTemplate where name = 'APULicenseEmail' Limit 1];
          System.debug('et '+et);
        
            list<string> toAddresses= new list<string>(Addresses);
            system.debug('toAddresses'+toAddresses);
            for(id ord:ApttusConfig2Orders)
            {
            
            if(toAddresses.size()>0){
                                
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                msg.setTemplateId(et.id);
                msg.setWhatId(ord);
                msg.setTargetObjectId(cnt.id);
                msg.setTreatTargetObjectAsRecipient(false);//to avoid sending email to dummy Contact email
                msg.setToAddresses(toAddresses);
                msg.setReplyTo('no-reply@honeywell.com');
                if(listOrgwide!=null && !listOrgwide.isEmpty())
                msg.setOrgWideEmailAddressId(listOrgwide.get(0).Id);
                msg.SaveAsActivity = false;
                msgList.add(msg);
               }
            
           }
        
        }
        System.debug('Addresses1'+Addresses.Size());
        System.debug(AsipProducts.Size());
        If(AsipProducts.Size()>0 )
        {
           EmailTemplate et =[Select id from EmailTemplate where name = 'AspireLicenseEmail' Limit 1];
        
        for(id ord:ApttusConfig2Orders){
           
            list<string> toAddresses= new list<string>(Addresses);
            system.debug('toAddresses'+toAddresses);
            
            if(toAddresses.size()>0){
                                
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                msg.setTemplateId(et.id);
                msg.setWhatId(ord);
                msg.setTargetObjectId(cnt.id);
                msg.setTreatTargetObjectAsRecipient(false);//to avoid sending email to dummy Contact email
                msg.setToAddresses(toAddresses);
                msg.setReplyTo('no-reply@honeywell.com');
                if(listOrgwide!=null && !listOrgwide.isEmpty())
                msg.setOrgWideEmailAddressId(listOrgwide.get(0).Id);
                msg.SaveAsActivity = false;
                msgList.add(msg);
            }
            
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