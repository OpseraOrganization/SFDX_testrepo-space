@isTest
private class preventScheduleChange_Testcls{
static testmethod void preventScheduleChange_TstMthd(){
 
  Profile ProfRec = [select name from Profile where name = 'System Administrator'];
        User userRec = new User(LastName = 'Test',Username = 'testingHC@testHC.com',Email = 'test@test.com',Alias = 'Testing' ,
        CommunityNickname= 'Test' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',
        EmailEncodingKey= 'ISO-8859-1',ProfileId = ProfRec.Id, LanguageLocaleKey = 'en_US');
        insert userRec;
 
Date dl1 =Date.newInstance(2009,08,1);
Date dl2 =Date.newInstance(2009,09,12);
Date dl3 =Date.newInstance(2009,08,2);
   Test.startTest();
    Account acc=new Account();
    acc.name='Sample';
    insert acc;
            
    Opportunity opp=new Opportunity();
    opp.Name='Sample Opp';
    opp.Account=acc;
    opp.accountid=acc.id;
    opp.stageName='Cultivate';
    opp.closeDate=System.today();
    opp.Tech_Sales_Product_Area__c='Integrated Avionics';
    opp.Certification_Requirements__c = 'Direct Commercial';
    opp.CloseDate=Date.today();
    opp.RFP_Expected_Date__c = System.today();
    opp.ATR_Aircraft_Quantity__c = 1;
    insert opp;
    
    Pricebook2 pb = [select name, isactive from Pricebook2 where IsStandard = true Limit 1];
Product2 prdNew=new Product2(Name='NewProduct',ProductCode='xxx');
insert prdNew;
PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.id,Product2Id   = prdNew.id,IsActive     = true,     UnitPrice    = 1); 
    insert pbe;
    
    OpportunityLineItem LineItem=new OpportunityLineItem( OpportunityId=opp.Id,ServiceDate=dl1,quantity=10,pricebookentryid =pbe.Id,UnitPrice= 1,type__c='APO');
insert LineItem;
      
LineItem.quantity=12;
LineItem.TotalPrice=6;
System.runAs ( userRec) { 
try{
update LineItem;
}
catch(System.DMLException e){System.assert(e.getMessage().contains(
                'Schedule can be changed only by an admin'),
                  e.getMessage());
      }
      }
Test.stopTest();
}

 static testMethod void preventScheduleChange_TstMthd1()    
    {
        Test.startTest();
        
        OpportunityLineItem oppLine = [select OpportunityID from OpportunityLineItem where ServiceDate<>null and Type__c = 'Forecast' limit 1];
        Opportunity opp = [select id,CloseDate from Opportunity where CloseDate<>null and id =:oppLine.OpportunityID limit 1];
        opp.CloseDate = opp.CloseDate+1;
        opp.Push_Product_Date__c = true;
        opp.ATR_Probability__c = 10;
        opp.Program_Go_Probability__c = 10;
        update opp;
        
        Test.stopTest();
    }
}