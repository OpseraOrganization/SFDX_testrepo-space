/** * File Name: D_S_TEST_ApexClass_add_acl
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
public class D_S_TEST_ApexClass_add_acl
{
    static testmethod void add_acl()
    {
    
    Profile pf = [select name from Profile where name = 'Sales D&S'];
    User uNew = new User(LastName = 'Test User',firstname='Check',Username = 'testuser@test.com.honeywell',Email = 'testuser@test.com',Alias = 
    
    'tuser' ,CommunityNickname= 'tuserhoney' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 
    
    'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 
    
    'en_US',Functional_Role__c='testrole',SBU_User__c='testsbu',CBT__c='HTSI',CBT_Team__c ='testcbtteam');insert uNew;
    uNew .Functional_Role__c='testroleupdate';
    update uNew ;
    
    System.assertEquals('testroleupdate',uNew .Functional_Role__c);
    ApexPages.StandardController Controller;
    ApexPages.StandardController Controller1;
    //add_acl a = new add_acl(Controller);
    //a.getoptions();
    //a.getoptions1();
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
    
    test.starttest();
    Opportunity o1 = new Opportunity(Name='Complexopp',recordtypeid =r1.id,Accountid=a1.Id,StageName='Prospecting',
    CloseDate=d1, Type_of_Opportunity__c = 'RMU – Level 3 (Low Probability)',Amount=1,Program_Terms__c='1',ATR_Aircraft_Quantity__c=1 );
    
    insert o1;
    test.stoptest();
    
    System.currentPagereference().getParameters().put('Id', o1.Id);
    System.currentPagereference().getParameters().put('Oppid1', o1.Id);
    Contact c=new Contact(lastname='Honeywell',firstname='Test',accountId=a1.Id,
    Contact_Is_Employee__c=true,Phone_3__c ='9986555678',Functional_Role__c='FunctionalRole1678',
    CBT__c = 'HTSI', Employee_Contact_Role__c='Analyst',Employee_Number__c='T123567');
    
    insert c;
    
    
    
}
static testmethod void add_ac2()
    {
        
        Profile pf = [select name from Profile where name = 'Sales D&S'];
    User uNew = new User(LastName = 'Test User',firstname='Check',Username = 'testuser@test.com.honeywell',Email = 'testuser@test.com',Alias = 
    
    'tuser' ,CommunityNickname= 'tuserhoney' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 
    
    'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 
    
    'en_US',Functional_Role__c='testrole',SBU_User__c='testsbu',CBT__c='HTSI',CBT_Team__c ='testcbtteam');insert uNew;
    uNew .Functional_Role__c='testroleupdate';
    update uNew ;
    
    System.assertEquals('testroleupdate',uNew .Functional_Role__c);
    ApexPages.StandardController Controller;
    ApexPages.StandardController Controller1;
    //add_acl a = new add_acl(Controller);
    //a.getoptions();
    //a.getoptions1();
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
    
        Opportunity o2 = new Opportunity(Name='Complexopp',recordtypeid =r1.id,Accountid=a1.Id,StageName='Prospecting',CloseDate=d1,CBT_Tier_2__c='testing',Tech_Sales_Product_Area__c='Electrical Power', Type_of_Opportunity__c = 'RMU – Level 3 (Low Probability)',Amount=1,Program_Terms__c='1',ATR_Aircraft_Quantity__c=1 );
    test.starttest();
    insert o2;
    test.stoptest();
    Contact cnt1 = new Contact(LastName = 'Test contact',firstname='Test',Contact_Is_Employee__c = true,Email='sumithameon@gmail.com',phone_3__c='89652', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567' );
    insert cnt1;
    Opportunity_Sales_Team__c ost1 = new Opportunity_Sales_Team__c(contact__c = cnt1.id,Opportunity__c = o2.id);
    insert ost1; 
    User u1 = new User(LastName = 'Test User',firstname='Check',Username = 'testuser5646@test.com',Email = 'testuser@test.com',Alias = 'tuser' 
    
    ,CommunityNickname= 'tstuser' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 
    
    'ISO-8859-1',ProfileId =pf.Id, LanguageLocaleKey = 'en_US');
    insert u1;
    
    // Opportunity_Sales_Team__c ost = new Opportunity_Sales_Team__c(User__c = u1.id ,Opportunity__c = o1.id );
    //insert ost;
    System.currentPagereference().getParameters().put('Id', o2.Id);
    add_acl ad1 = new add_acl(Controller1);
    ad1.getretrieveData();
    ad1.InsertSelected();
    List<selectoption> add=new List<selectoption>();
    ad1.setoptions1(add);
    ad1.getoptions1();
    //ad1.setoptions(add);
    //ad1.getoptions();
    //delete ost;
    //calling again for the if condition
    //RecordType r2 = [select id , name from RecordType where name='Catalog'];
    ID r2 = label.D_S_PrePriced;
    }
static testmethod void add_ac3()
    {
    ApexPages.StandardController Controller;
    ID r2 = label.D_S_PrePriced;
    test.starttest();
    
    Account a1 = New Account(Name= 'sbuaccount', 
    Strategic_Business_Unit__c = 'D&S', 
      CBT__c = 'HTSI');
      
    Profile ProfRec = [select name,id from Profile where name = 'System Administrator' limit 1];
        User userRec = [select id from user where ProfileId = :ProfRec.Id and isActive=true limit 1];
        system.runas(userRec)
        {
            insert a1;
        }
    Date d1 =Date.newInstance(2009,08,12);
    //Opportunity o3 = new Opportunity(Name='Complexopp',recordtypeid =r2.id,Accountid=a1.Id,StageName='Prospecting',
    Opportunity o3 = new Opportunity(Name='Complexopp',recordtypeid =r2,Accountid=a1.Id,StageName='Prospecting',
    CloseDate=d1,ATR_Aircraft_Quantity__c=1 );
    insert o3;
    test.stoptest();
    System.currentPagereference().getParameters().put('Id', o3.Id);
    System.currentPagereference().getParameters().put('Oppid3', o3.Id);
    Contact c1=new Contact(lastname='Honeywell',firstname='Test',accountId=a1.Id,
    Contact_Is_Employee__c=true,Phone_3__c ='9986555678',Functional_Role__c='FunctionalRole1678',
    CBT__c = 'HTSI', Employee_Contact_Role__c='Analyst',Employee_Number__c='H123567');
    insert c1;
    add_acl a = new add_acl(Controller);
    a.getcontacts();
    a.getretrieveData();
    a.InsertSelected();
    a.Cancelation();
    a.Back();
    
    
    }
}