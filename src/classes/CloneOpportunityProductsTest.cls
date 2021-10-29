@isTest(seeAllData=true)
public class CloneOpportunityProductsTest {
    static Opportunity opp ;
    public static void dataLoad()
    {
        Account acct = new Account();
        acct.name ='Test';
        insert acct;
        
        Product2 p2 = new product2(name='y');
        insert p2;
        
        //define the standart price for the product
        Pricebook2 stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
        insert new PricebookEntry(pricebook2id = stdPb.id, product2id = p2.id,unitprice=1.0, isActive=true);
        
        Pricebook2 pb = new pricebook2(name='test');
        insert pb;
        
        PricebookEntry pbe = new PricebookEntry(pricebook2id=pb.id, product2id=p2.id,unitprice=1.0, isActive=true);
        insert pbe;
        
        opp = new Opportunity();
        opp.RecordTypeId =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Complex').getRecordTypeId();
        opp.Name ='test opp';
        opp.AccountId =acct.id;
        opp.StageName ='Prospecting';
        opp.CloseDate =System.today().addDays(1);
        insert opp;
        
       
        
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.UnitPrice = 100;
        oli.Quantity = 2;
        oli.pricebookentryid = pbe.id;
        oli.OpportunityId = opp.Id;                       
        insert oli;
        
    }
     public static testMethod void doTest()
     {
         dataLoad();
         Test.startTest();         
         String newId =CloneOpportunityProducts.getCloneOpp(opp.Id);                 
         Test.stopTest();         
     }
    public static testMethod void doTest1()
     {
         dataLoad();
         Test.startTest();         
         String newId =CloneOpportunityProducts.getCloneOpp(opp.Id);   
         CloneOpportunityProducts.createChilds(newId, opp.Id);
         Test.stopTest();         
     }
    public static testMethod void doTest2()
     {
         dataLoad();
         Test.startTest();         
         String newId =CloneOpportunityProducts.getCloneOpp(opp.Id);   
         CloneOpportunityProducts.deleteOpp(newId);
         Test.stopTest();         
     }
    public static testMethod void doTest3()
    {
        dataLoad();
        Test.startTest();  
         Discretionary__c DiscNew=new Discretionary__c ();
        DiscNew.CBT__c='Airlines';
        DiscNew.SBU__c='ATR';
        DiscNew.Estimated_Completion_Date__c = System.today()+10;
        DiscNew.Opportunity__c =opp.Id;
        insert DiscNew;
        CloneOpportunityProducts.fetchDRRecords(opp.Id);
        Test.stopTest();         
    }
   /*
   
    public static testMethod void doTest1()
    {
        
        Account acct = new Account();
        acct.name ='Test';
        insert acct;
        
        Product2 p2 = new product2(name='y');
        insert p2;
        
        //define the standart price for the product
        Pricebook2 stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
        insert new PricebookEntry(pricebook2id = stdPb.id, product2id = p2.id,unitprice=1.0, isActive=true);
        
        Pricebook2 pb = new pricebook2(name='test');
        insert pb;
        
        PricebookEntry pbe = new PricebookEntry(pricebook2id=pb.id, product2id=p2.id,unitprice=1.0, isActive=true);
        insert pbe;
        
        Test.startTest();
        
        
        
        
        String newId =CloneOpportunityProducts.getCloneOpp(opp.Id);
        CloneOpportunityProducts.createChilds(newId, opp.Id);
        CloneOpportunityProducts.deleteOpp(newId);
        CloneOpportunityProducts.fetchDRRecords(opp.Id);
        
        Test.stopTest();
        
        System.runAs(new User(id=UserInfo.getUserId()))
        {
            Discretionary__c DiscNew=new Discretionary__c ();
            DiscNew.CBT__c='Airlines';
            DiscNew.SBU__c='ATR';
            DiscNew.Estimated_Completion_Date__c = System.today()+10;
            DiscNew.Opportunity__c =opp.Id;
            insert DiscNew;
            
        }
        
        
    }

*/
}