/******************************************************************************************************
Name         : Test_Releatedcustomerstories
Created By   :Praveen Sampath
company Name :
Project      :Aero sales
created Date : 1/30/2014
Usages       :This Test class is used for creating new profile and user get standard pricebook
*************************************************************************************************/
@isTest(SeeAllData=true)
private class Test_Releatedcustomerstories{
    static testMethod void Releatedcustomerstories(){
       
        Account acc = new Account(
            Name = 'Test Account'            
        );
        //insert acc;
        
        Platform__c pltFrm = new Platform__c(name='Test Platform');
        
        //insert pltFrm;
        //INSERT MAKE AND MODEL
        Fleet_Asset_Detail__c make=new Fleet_Asset_Detail__c(
        name='<Make> <Model> T=2582 S=145-00495',
        Account__c=acc.id, Platform_Name__c=pltFrm.id
        );
        //insert make;
        //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];

        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
        //insert pbk1;
        Product2 prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC', isActive = true);
        //insert prd1;

        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=50, isActive=true);
        //insert pbe1;
        
        
         Test.startTest();
        //Opportunity opp1 = new Opportunity (Name='Opp1',recordtypeid = '01230000000bN7l',StageName='Prospecting',CloseDate=Date.today(),Pricebook2Id = pbe1.Pricebook2Id, AccountId = acc.id,Tech_Sales_Product_Area__c = 'APU');
        //insert opp1;
        Opportunity opp1 =[select id from Opportunity where recordtypeid = '01230000000bN7l' limit 1];
        //system.debug('pbe1 product Name:'+pbe1.Product2.Name);
        OpportunityLineItem itemRec = [select id,OpportunityID,Opportunity.AccountID,PriceBookEntryID from OpportunityLineItem  where Opportunity.recordtypeid='01230000000bN7l' limit 1];
        pbe1 = [select Product2ID,id,Product2.Name from PricebookEntry where id=:itemRec.PriceBookEntryID and isActive=true limit 1]; 
        Opportunity opp2 =[select id from Opportunity where id != :itemRec.OpportunityID and AccountId =:itemRec.Opportunity.AccountID limit 1];
        
        CustomerStory__c cs = new CustomerStory__c();
        cs.Product__c = pbe1.Product2ID;
        cs.Related_Opportunity__c = opp2.id;
        insert cs;
        
        OpportunityLineItem lineItem1 = new OpportunityLineItem 
        (OpportunityID=itemRec.OpportunityID,PriceBookEntryID=pbe1.id, quantity=4,totalprice=200);
        insert lineItem1;
       
        
        /*lineItem1.quantity=12;
        lineItem1.TotalPrice=6;
        try
        {
        //update lineItem1 ;
        }
        catch(System.DMLException e){System.assert(e.getMessage().contains(
                        'Schedule can be changed only by an admin'),
                          e.getMessage());
        }       
        
        opp1.StageName='Closed Won';
        //update opp1;
        Test.stopTest();
        
        //creating new profile and user                  
        Profile ProfRec = [select name from Profile where name = 'System Administrator'];
        User userRec = new User(LastName = 'venkat',Username = 'venkat@test.com.five',Email = 'venkat@test55.com',Alias = 'venkat5' ,CommunityNickname= 'venkat5' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = ProfRec.Id, LanguageLocaleKey = 'en_US');
        insert userRec;
        //new customer of checking if condition
        CustomerStory__c child=new CustomerStory__c();
        child.Related_Opportunity__c=opp1.id;
        child.Name='test';
        child.Product__c=prd1.id;
        child.Story_Type__c='Win';
        child.Status__c='Backlog';
        child.Sales_Reference__c='Yes';
        child.Sharing_Restriction__c='Educational Use Only - Do Not Mention Customer Name';
        child.Region1__c='APAC';
        child.SBU__c='BGA';
        child.Story_Owner__c=userRec.id;
        insert child; 
        System.assertEquals(child.Product__c,prd1.id);
        System.assertEquals(child.Make_Model__c,opp1.Make__c);
        
        Related_Customer_Stories__c pr=new Related_Customer_Stories__c();
        pr.name='releted customer';
        pr.Summary__c='new test customer story';
        pr.Files_Links_1__c='google.com';
        pr.Files_Links_2__c='yahoo.com';
        pr.Solutions__c='new tset';
        pr.CustomerStory__c=child.id;
        pr.Opportunity__c=opp1.Id;
        pr.Product__c=prd1.id;
        pr.Product_Line__c='new product line';
        pr.Make__c='test';
        pr.CustomerName__c=acc.Id;
        pr.Reason__c='Product';
        insert pr;  */    
    }
 }