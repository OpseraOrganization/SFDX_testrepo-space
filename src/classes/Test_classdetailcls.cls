@isTest(SeeAllData=true)
private class Test_classdetailcls
{
   static testMethod void classdetailcls()
   {                      
        boolean showContent=true;
        Profile pf = [ Select id from Profile where name = 'Training - Customer Portal'];
        Profile pf1 = [ Select id from Profile where name = 'System Administrator'];
        Account A1 = new Account(Name = 'Test Account');
        insert A1;
        Contact C1 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User',Honeywell_ID__c='E812402', email = 'venkatesh.athanti@honeywell.com',Employee_Number__c = 'E123123' );
        insert C1;                            
        user u2=[select id,name,email from user where Batch_User__c = true and profileid =: pf.id and isactive = true limit 1];
        user u1=[select id,name,email from user where Batch_User__c = false and profileid =: pf.id and isactive = true limit 1];              
        user u3=[select id,name,email from user where Batch_User__c = false and profileid =: pf1.id and isactive = true limit 1];              
        try
        {
            C1.Customer_Portal_UserId__c =u2.id;
            upsert C1;
            upsert A1;
        }
        catch(Exception e){}
        product2 pr=[select id,name from product2 where  Name LIKE '%RMU%' limit 1];
        Location__c loc=[select id,name from Location__c where name like '%CAE - NJ%' limit 1];
        Class__c cs=new Class__c();        
        cs.Class_Name__c='test';
        cs.Start_Date__c=system.today()+3;
        cs.Total_Number_of_Seats__c=10;
        cs.End_Date__c=system.today()+10;
        cs.Course_Name__c=pr.id;
        cs.Location__c=loc.id;
        insert cs;
        System.runas(u2)
        {              
            ApexPages.StandardController sc = new ApexPages.standardController(cs);
            classdetailcls controller = new classdetailcls(sc);                          
            controller.getMemb();
            boolean showContent1=true;
            controller.reserve();
            controller.previous();
            controller.getprev();
            controller.getnxt();
            controller.newreservation();
            controller.reserveedit();
            controller.next();
            controller.getuse();
       } 
       System.runas(u1)
        {              
            ApexPages.StandardController sc = new ApexPages.standardController(cs);
            classdetailcls controller = new classdetailcls(sc);                          
            controller.getMemb();
            integer index = 2;
            integer blockSize = 5;
            integer totalRecs=1;  
            controller.getnxt();         
       } 
       System.runas(u3)
        {              
            ApexPages.StandardController sc = new ApexPages.standardController(cs);
            classdetailcls controller = new classdetailcls(sc);                          
            controller.getMemb();
            integer index = 0;
            controller.getprev();           
       }       
   }
}