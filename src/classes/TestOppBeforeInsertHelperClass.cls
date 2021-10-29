@isTest(SeeAllData=true)
public class TestOppBeforeInsertHelperClass{
    static testmethod void testMethodOppBeforeInsertHelperClass(){
         
    Date d1 =Date.newInstance(2009,08,12);
    Account a1 = New Account(Name= 'sbuaccount', 
    Strategic_Business_Unit__c = 'D&S', 
      CBT__c = 'HTSI');
      
    Profile ProfRec = [select name,id from Profile where name = 'System Administrator' limit 1];
        User userRec = [select id from user where ProfileId = :ProfRec.Id and isActive=true limit 1];
        system.runas(userRec)
        {
            insert a1;
        }
    
    RecordType r1 = [select id , name from RecordType where name='AM Standard'];
    Lead leadRec = [select id from lead limit 1];
    Opportunity o1 = new Opportunity(Name='Complexopp',recordtypeid =r1.id,Accountid=a1.Id,StageName='Prospecting',
    CloseDate=d1, Type_of_Opportunity__c = 'RMU – Level 3 (Low Probability)',Amount=1,Program_Terms__c='1',ATR_Aircraft_Quantity__c=1 );
    o1.Description ='test';
    o1.Is_Restricted_Opportunity__c = false;
    o1.Lead_ID__c = leadRec.id;
    insert o1;
    
    }
    
    static testmethod void testMethodOppBeforeInsertHelperClass2(){
         
    Date d1 =Date.newInstance(2009,08,12);
    Account a1 = New Account(Name= 'sbuaccount', 
    Strategic_Business_Unit__c = 'D&S', 
      CBT__c = 'HTSI');
      
    Profile ProfRec = [select name,id from Profile where name = 'System Administrator' limit 1];
        User userRec = [select id from user where ProfileId = :ProfRec.Id and isActive=true limit 1];
        system.runas(userRec)
        {
            insert a1;
        }
    
    RecordType r1 = [select id , name from RecordType where name='D&S Complex FollowOn'];
    
    Opportunity o1 = new Opportunity(Name='Complexopp',recordtypeid =r1.id,Accountid=a1.Id,StageName='Prospecting',
    CloseDate=d1, Type_of_Opportunity__c = 'RMU – Level 3 (Low Probability)',Amount=1,Program_Terms__c='1',ATR_Aircraft_Quantity__c=1 );
    o1.Description ='test';
    o1.Is_Restricted_Opportunity__c = false;
    insert o1;
    
    }
    
    static testmethod void testMethodOppBeforeInsertHelperClass3(){
         
    Date d1 =Date.newInstance(2009,08,12);
    Account a1 = New Account(Name= 'sbuaccount', 
    Strategic_Business_Unit__c = 'D&S', 
      CBT__c = 'HTSI');
      
    Profile ProfRec = [select name,id from Profile where name = 'System Administrator' limit 1];
        User userRec = [select id from user where ProfileId = :ProfRec.Id and isActive=true limit 1];
        system.runas(userRec)
        {
            insert a1;
        }
    
    RecordType r1 = [select id , name from RecordType where name='D&S PrePriced FollowOn'];
    
    Opportunity o1 = new Opportunity(Name='Complexopp',recordtypeid =r1.id,Accountid=a1.Id,StageName='Prospecting',
    CloseDate=d1, Type_of_Opportunity__c = 'RMU – Level 3 (Low Probability)',Amount=1,Program_Terms__c='1',ATR_Aircraft_Quantity__c=1 );
    o1.Description ='test';
    o1.Is_Restricted_Opportunity__c = false;
    insert o1;
    
    }
    
    static testmethod void testMethodOppBeforeInsertHelperClass4(){
         
    Date d1 =Date.newInstance(2009,08,12);
    Account a1 = New Account(Name= 'sbuaccount', 
    Strategic_Business_Unit__c = 'D&S', 
      CBT__c = 'HTSI');
      
    Profile ProfRec = [select name,id from Profile where name = 'System Administrator' limit 1];
        User userRec = [select id from user where ProfileId = :ProfRec.Id and isActive=true limit 1];
        system.runas(userRec)
        {
            insert a1;
        }
    
    RecordType r1 = [select id , name from RecordType where name='D&S Standard FollowOn'];
    RecordType r11 = [select id , name from RecordType where name='Meeting'];
    Planned_Meeting__c pm = new Planned_Meeting__c();
    pm.Assigned_To__c = [SELECT id FROM User limit 1].Id;
    pm.Name = 'Test PM';
    pm.Location__c = 'Bangalore';
    pm.Start_Date__c = d1;
    pm.End_Date__c = d1;
    pm.Meeting_Purpose__c = 'Test meeting';
    pm.SBU__c = 'ATR';
    pm.CBT__c = 'Airbus';
    pm.recordtypeid=r11.id;
    
    insert pm;

    Opportunity o1 = new Opportunity(Name='Complexopp',recordtypeid =r1.id,Accountid=a1.Id,StageName='Prospecting',
    CloseDate=d1, Type_of_Opportunity__c = 'RMU – Level 3 (Low Probability)',Amount=1,Program_Terms__c='1',ATR_Aircraft_Quantity__c=1 );
    o1.Description ='test';
    o1.Is_Restricted_Opportunity__c = false;
    o1.ATR_Opportunity_Type_Convert__c = 'OE Standard';
    o1.Planned_Meeting__c = pm.id;
    insert o1;
    
    }
}