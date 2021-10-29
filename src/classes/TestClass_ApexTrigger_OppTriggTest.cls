/** * File Name:  TestClass_ApexTrigger_OppTriggTest
* Description Test Method
* Class Tested: EmailAlertOnOpportunityUpdates
* Copyright : Wipro Technologies Limited Copyright (c) 2011
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */
@isTest(SeeAllData=true)
private class TestClass_ApexTrigger_OppTriggTest {

    static testMethod void oppTriggTestTest() {
         
         Profile pf = [select name from Profile where name = 'System Administrator'];
            User testUser = new User(LastName = 'Trigger Test User',Username = 'triggertstuser@test.com.honeywell',Email = 'testuser@test.com',Alias = 
                'tuser' ,CommunityNickname= 'tuserhoney' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 
                'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 
                'en_US',Functional_Role__c='testrole',SBU_User__c='testsbu',CBT__c='HTSI',CBT_Team__c ='testcbtteam',
                Phone='123456789',Extension='234',Fax='123456789',MobilePhone='123456788'
                );
            insert testUser;
            
            User testUser2 = new User(LastName = 'Trigger Test User2',Username = 'triggertstuser2@test.com.honeywell',Email = 'testuser2@test.com',Alias = 
                'tuser2' ,CommunityNickname= 'tuser2honey' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 
                'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 
                'en_US',Functional_Role__c='testrole',SBU_User__c='testsbu',CBT__c='HTSI',CBT_Team__c ='testcbtteam',
                Phone='123456789',Extension='234',Fax='123456789',MobilePhone='123456788'
                );
            insert testUser2;
            
           
            system.runAs(testUser){
            
                RecordType tstRecTyp = [select id , name from RecordType where name='BGA OE'limit 1];
                Opportunity tstOpp3 = new Opportunity(
                        Name='Test Opp3',
                    ownerid=testUser.id,
                    amount =100.00,
                    Type = 'OCM Programs' ,
                    closedate = System.today(),
                    ForecastCategoryName = 'Pipeline',
                    Probability=10.0,
                    Tech_Sales_Product_Area__c='APU',
                    recordtypeid=tstRecTyp.Id,
                    Opportunity_Co_owner_new__c=testUser.id,
                    StageName='Launch',
               Proposal_Submitted_Date__c = System.today(),
        RFP_Expected_Date__c = System.today(),
        Proposal_Complexity_Description__c = 'test',
       Ship_Set_Parts__c = 'test',
        Ship_Set_Quantity__c = 11,
        Certification_Requirements__c = 'FAR 15 TINA',
       Ship_Set_Delivery_Period__c = 'test',
       Proposal_Due_Date__c = System.today(),       
            ATR_Aircraft_Quantity__c=1,
        Proposal_Kickoff_Date__c = System.today()
                    );   
                insert tstOpp3;
                
                tstOpp3.Type='BCM Programs' ;
                tstOpp3.Opportunity_Co_owner_new__c =testUser2.Id;
                tstOpp3.Opportunity_Notes__c='New Notes';
                tstOpp3.StageName='Offer/Negotiate/Close';
                update tstOpp3;
                
                Opportunity tstOpp4 = new Opportunity(
                        Name='Test Opp3',
                    ownerid=testUser.id,
                    amount =100.00,
                    Type = 'OCM Programs' ,
                    closedate = System.today()-1,
                    ForecastCategoryName = 'Pipeline',
                    Probability=10.0,
                     Proposal_Submitted_Date__c = System.today(),
        RFP_Expected_Date__c = System.today(),
        Proposal_Complexity_Description__c = 'test',
       Ship_Set_Parts__c = 'test',
        Ship_Set_Quantity__c = 11,
        Tech_Sales_Product_Area__c='APU',
        Certification_Requirements__c = 'FAR 15 TINA',
       Ship_Set_Delivery_Period__c = 'test',
       Proposal_Due_Date__c = System.today(),
       StageName='Launch',
       ATR_Aircraft_Quantity__c=1,
        Proposal_Kickoff_Date__c = System.today()
                    
                    );   
                insert tstOpp4;
                Product2 tstProduct3 = new Product2(name='Test Product3', RMU__c=true,
                    CanUseRevenueSchedule=true
                );
                insert tstProduct3;
                Pricebook2 tstPriceBook3 = [select id from Pricebook2 where IsStandard = true limit 1];      
                PricebookEntry tstPriceBkEntry3 = new PricebookEntry(product2id = tstProduct3.Id, UnitPrice=10.00 , Pricebook2Id=tstPriceBook3.Id ,  IsActive=TRUE, UseStandardPrice=false); 
                insert tstPriceBkEntry3;
                OpportunityLineItem tstOppLnItem3 = new OpportunityLineItem (OpportunityId = tstOpp4.Id , Quantity=10.00,TotalPrice=100.00, PricebookEntryId=tstPriceBkEntry3.Id,
                ServiceDate=System.today()-1);
                insert tstOppLnItem3;
        
                tstOpp4.closedate=System.today();
                Test.startTest(); 
                update tstOpp4;
                 Opportunity tstOppetc = new Opportunity(
                        Name='Test Oppetc',
                    ownerid=testUser.id,
                    amount =100.00,
                    Type = 'OCM Programs' ,
                    closedate = System.today(),
                    ForecastCategoryName = 'Pipeline',
                    Probability=10.0,
                    recordtypeid=tstRecTyp.Id,
                    Opportunity_Co_Owner__c=testUser.LastName+ ','+ testUSer.FirstName,
                    StageName='Launch',
                    Tech_Sales_Product_Area__c='APU',
                    ATR_Aircraft_Quantity__c = 1
        
                    );   
                insert tstOppetc;
                
            Test.stopTest();    
                
            }
            
         
         
    }
}