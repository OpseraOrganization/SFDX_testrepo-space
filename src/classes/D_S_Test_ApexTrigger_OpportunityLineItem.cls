@isTest
public  class D_S_Test_ApexTrigger_OpportunityLineItem
{
    static testmethod void Opportunity_LineItem(){

    Account a1 = New Account(Name= 'sbuaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
    insert a1;
    Date d1 =Date.newInstance(2009,08,12);
    Date d2 =Date.newInstance(2009,08,13);
    //RecordType r1 = [select id , name from RecordType where name='Competitive'];
    Id r1 = label.D_S_Complex;
    //Opportunity o1 = new Opportunity(Name='Complexopp',recordtypeid =r1.id,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1,ATR_Aircraft_Quantity__c=1 );
    Opportunity o1 = new Opportunity(Name='Complexopp',recordtypeid =r1,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1,ATR_Aircraft_Quantity__c=1 );
    insert o1;
    Pricebook2 pb = [select name, isactive from Pricebook2 where IsStandard = true Limit 1];
    Product2 prdNew=new Product2(Name='NewProduct',ProductCode='xxx');
    insert prdNew;
    PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.id,Product2Id   = prdNew.id,IsActive     = true,     UnitPrice    = 1); 
        insert pbe;
    Decimal q =5;
    Date dl1 =Date.newInstance(2009,08,1);
    Date dl2 =Date.newInstance(2009,09,12);
    Date dl3 =Date.newInstance(2009,08,2);
    OpportunityLineItem LineItem=new OpportunityLineItem( OpportunityId=o1.Id,ServiceDate=dl1,quantity=10,pricebookentryid =pbe.Id,unitprice=1);
    insert LineItem;
    //OpportunityLineItemSchedule oschedule = new OpportunityLineItemSchedule(Quantity = q,ScheduleDate = dl3,OpportunityLineItemId=LineItem.Id,Type= 'Revenue');
    //insert oschedule;
    Test.startTest();
    o1.closedate = d2;
    update o1;
    system.AssertEquals(dl1,LineItem.ServiceDate);
    LineItem.ServiceDate = dl2;
    update LineItem;
    Test.stopTest();
    }

}