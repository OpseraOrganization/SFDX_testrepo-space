@isTest

public class AccountRevalidationBatchtest {
    public static list<Portal_Honeywell_ID__c  > lp=new list<Portal_Honeywell_ID__c  >();
    static testmethod void testmethod1()
    {
        Account acc = new Account();
        acc.Name = 'Honeywell Test';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';
        
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Singh';
        con.FirstName = 'Kapil';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'akash.kingare@tcs.com';
        con.Email='akash.kingare@tcs.com';
        con.contact_Is_Employee__c =false;
        insert con;
        
        //List<String> toAddresses=new List<String>();
        // toAddresses.add('me@email1.com');
        Portal_Honeywell_ID__c  obj1=new Portal_Honeywell_ID__c ();
        obj1.Name='Test';
        //obj1.Revalidating_Flag__c = true;
        obj1.Revalidated_Date__c = Date.Today()-337;
        obj1.Contact__c=con.id;
        obj1.Email_Sent_Counter__c=4;
        obj1.Portal_Status__c='Active';
        //obj1.CurrencyIsoCode='US';
        insert obj1;
        
        Portal_Honeywell_ID__c  obj2=new Portal_Honeywell_ID__c ();
        obj2.Name='Test3';
        //obj2.Revalidating_Flag__c = true;
        obj2.Revalidated_Date__c =Date.Today()-344;
        obj2.Contact__c=con.id;
        obj2.Email_Sent_Counter__c=4;
        obj2.Portal_Status__c='Active';
        //obj1.CurrencyIsoCode='US';
        insert obj2;
        
        Portal_Honeywell_ID__c  obj3=new Portal_Honeywell_ID__c ();
        obj3.Name='Test4';
        //obj3.Revalidating_Flag__c = true;
        obj3.Revalidated_Date__c =Date.Today()-365;
        obj3.Contact__c=con.id;
        obj3.Email_Sent_Counter__c=4;
        obj3.Portal_Status__c='Active';
        //obj1.CurrencyIsoCode='US';
        insert obj3;
        
        //obj2.Revalidated_Date__c = Date.Today()-330;
        //update obj2;
        
        
        //lp.add(obj1);
        Test.startTest();
        AccountRevalidationBatch obj=new AccountRevalidationBatch();
        Id batchjobid=Database.executeBatch(obj);
        /*
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(toAddresses); 
mail.settargetObjectId(obj1.Contact__c);
mail.setwhatid(obj1.id);
mail.setTemplateId(Label.AccountRevalidationTemplate);  
mail.setOrgWideEmailAddressId(Label.RegistrationAddress);   
mail.setSaveAsActivity(false);
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
*/
        // AccountRevalidationBatch tobj= new AccountRevalidationBatch ();
        // tobj.execute(null,lp);
        
        Test.stopTest();
        
        
        
        
    }
    
    
    
    
    
}