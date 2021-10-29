@isTest(SeeAllData=true)
private class test_addcustomerstories
{
   static testMethod void addcustomerstories ()
   {
      //Profile ProfRec = [select name from Profile where name = 'System Administrator'];
        //User userRec = new User(LastName = 'venkat',Username = 'venkat@test.com',Email = 'venkat@test55.com',Alias = 'venkat' ,CommunityNickname= 'venkat' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = ProfRec.Id, LanguageLocaleKey = 'en_US');
        //insert userRec;
      
      User userRec=[select id from user where id=:Userinfo.getUserId()];
     {
       String profileId;profileId=Userinfo.getprofileId();String profileName = [SELECT Name FROM Profile where Id  =: profileId].Name;
       Account acc = new Account(
            Name = 'Test Account'            
        );
        insert acc;
        Platform__c plname=[select id from Platform__c where Model__c!= null limit 1];
        //INSERT MAKE AND MODEL
        Fleet_Asset_Detail__c make=new Fleet_Asset_Detail__c(
        Platform_Name__c = plname.id,
        Account__c=acc.id
        );
        insert make;
        //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];

        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
        insert pbk1;

        Product2 prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC', isActive = true);
        insert prd1;

        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=50, isActive=true);
        insert pbe1;

        Opportunity opp1 = new Opportunity (Name='Opp1',StageName = 'Offer/Negotiate/Close',
        CloseDate=Date.today(),Pricebook2Id = pbe1.Pricebook2Id, AccountId = acc.id,Active__c=TRUE, Aircraft_Ref__c = make.id,Certification_Requirements__c='Direct Commercial',ATR_Aircraft_Quantity__c=1,RFP_Expected_Date__c = System.today());
        insert opp1;
        
         OpportunityCompetitor comp=new OpportunityCompetitor();
        comp.CompetitorName='vikram';
        comp.OpportunityID=opp1.id;
        insert comp;          
        
        OpportunityLineItem lineItem1 = new OpportunityLineItem 
        (OpportunityID=opp1.id,PriceBookEntryID=pbe1.id, quantity=4,totalprice=200);
        insert lineItem1;

       
         //inserting new opportunity line item
        
        //creating new profile and user                  
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
        //test record in releated customer story
        Related_Customer_Stories__c p1=new Related_Customer_Stories__c();
        p1.name='releted customer';
        p1.Summary__c='new test customer story';
        p1.Files_Links_1__c='google.com';
        p1.Files_Links_2__c='yahoo.com';
        p1.Solutions__c='new tset';
        p1.CustomerStory__c=child.id;
        p1.Opportunity__c=opp1.Id;
        p1.Product__c=prd1.id;
        p1.Product_Line__c='new product line';
        p1.Make__c='test';
        p1.CustomerName__c=acc.Id;
        p1.Reason__c='Product';
        insert p1;
        
        //test record in releated customer story  one
       // Related_Customer_Stories__c pr=new Related_Customer_Stories__c();
       // pr.name='releted customer';
       // pr.Summary__c='new test customer story';
       // pr.Files_Links_1__c='google.com';
       // pr.Files_Links_2__c='yahoo.com';
      //  pr.Solutions__c='new tset';
       // pr.CustomerStory__c=child.id;
       // pr.Opportunity__c=opp1.Id;
        //p1.Product__c='';
        //pr.Product_Line__c='new product line';
        //pr.Make__c='test';
       // pr.CustomerName__c=acc.Id;
       // pr.Reason__c='Product';
        //upsert pr;
        
        //OpportunityLineItem oli1 = new OpportunityLineItem();
        //[Select UnitPrice, Quantity, Type__c,Active__c from OpportunityLineItem where Id =: oli.Id];
        //oli1.UnitPrice = 150;
        //oli1.Quantity = 3;
        //oli1.Type__c = 'APO';
        //oli1.Active__c = true;
        //oli1.OpportunityId = opp1.Id;
        //oli1.pricebookentryid = [Select Id from PricebookEntry where IsActive=TRUE limit 1].Id;
        //insert oli1;
        
         Test.startTest();
         Opportunity opp2 = new Opportunity (Name='Opp1',
        CloseDate=Date.today(),ATR_Aircraft_Quantity__c=1,Pricebook2Id = pbe1.Pricebook2Id, AccountId = acc.id,Active__c=TRUE, Aircraft_Ref__c= make.id,StageName='Prospecting');
        insert opp2;
         
        OpportunityLineItem oli1 = new OpportunityLineItem();
        //[Select UnitPrice, Quantity, Type__c,Active__c from OpportunityLineItem where Id =: oli.Id];
        oli1.UnitPrice = 150;
        oli1.Quantity = 3;
        oli1.Type__c = 'APO';
        oli1.Active__c = true;
        oli1.OpportunityId = opp2.Id;
        oli1.pricebookentryid = pbe1.Id;
        insert oli1;
        
        CustomerStory__c child1=new CustomerStory__c();
        child1.Related_Opportunity__c=opp1.id;
        child1.Name='test';
        child1.Product__c=prd1.id;
        child1.Story_Type__c='Win';
        child1.Status__c='Backlog';
        child1.Sales_Reference__c='Yes';
        child1.Sharing_Restriction__c='Educational Use Only - Do Not Mention Customer Name';
        child1.Region1__c='APAC';
        child1.SBU__c='BGA';
        child1.Story_Owner__c=userRec.id;
        insert child1; 
        
        opp2.Add_reference_material__c = true;
        update opp2;
        Test.stopTest(); 
        
                       
       }   
       
 }      
}