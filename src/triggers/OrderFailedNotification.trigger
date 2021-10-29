trigger OrderFailedNotification on Apttus_Config2__Order__c (After Update)
{
  Set<id> OrderCaseset = New Set<id>();
  For(Apttus_Config2__Order__c Ord:Trigger.new)
  {  
    If(Ord.Case_Number__c != Null )
    {
      OrderCaseset.Add(Ord.id);
    }
  
  }

  If(OrderCaseset.Size()>0)
  {
     map<id,set<string>> ordemails=new map<id,set<string>>();//order with emails
     List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
      Id orderid;
      set<string> Addresses; 
      
        // Create Contact
        Contact cnt = new Contact();
        cnt.FirstName = 'Test';
        cnt.LastName = 'Con '+orderid;
        cnt.Accountid = Trigger.new[0].Apttus_Config2__SoldToAccountId__c;
        cnt.Email = 'no-reply@gmail.com';
        insert cnt;
        
        //get templete id
        EmailTemplate et=[Select id from EmailTemplate where name = 'APU Order failed email template' limit 1];     
        list<OrgWideEmailAddress> listOrgwide= new list<OrgWideEmailAddress>();
        listOrgwide = [select Id from OrgWideEmailAddress where Address =: system.label.AspireLicenseEmailAddress];
        
      for(CPQ_Email__c emails: [select id,name,Order__c from CPQ_Email__c where Order__c IN:OrderCaseset])
      {
      system.debug('email'+emails);
      orderid = emails.Order__c;
      if(!ordemails.containsKey(emails.Order__c)) {
      ordemails.put(emails.Order__c, new set<string>()); 
      }
      ordemails.get(emails.Order__c).add(emails.name);
      }
          
        for(id ord:OrderCaseset){
                Addresses= new set<string>();
                for(id ordid:OrderCaseset)
               {
                set<string> emails= (set<string>)ordemails.get(ordid);
                Addresses.addall(emails);
               }
        }
                
      
        list<string> toAddresses= new list<string>(Addresses);
        list<string> BccAddresses= new list<string>(Addresses);
        BccAddresses.add('ngbss-apts@HoneywellProd.onmicrosoft.com');
            system.debug('toAddresses'+toAddresses);
            for(id ord:OrderCaseset)
            {
            
            if(toAddresses.size()>0){
                                
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                msg.setTemplateId(et.id);
                msg.setWhatId(ord);
                msg.setTargetObjectId(cnt.id);
                msg.setTreatTargetObjectAsRecipient(false);//to avoid sending email to dummy Contact email
                msg.setToAddresses(toAddresses);
                msg.setBccAddresses(BccAddresses);
                msg.setReplyTo('no-reply@honeywell.com');
                if(listOrgwide!=null && !listOrgwide.isEmpty())
                msg.setOrgWideEmailAddressId(listOrgwide.get(0).Id);
                msg.SaveAsActivity = false;
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