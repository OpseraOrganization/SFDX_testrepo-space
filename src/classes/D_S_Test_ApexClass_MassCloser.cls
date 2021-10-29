/** * File Name:  D_S_Test_ApexClass_MassCloser
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
public with sharing class D_S_Test_ApexClass_MassCloser {

static testMethod void MassCloser(){
    Integer yr=System.today().year();
    String year=String.valueof(yr);
    
    Account acc=new Account();
    acc.name='Sample';
    insert acc;
            
    Opportunity opp=new Opportunity();
    opp.Name='Sample Opp';
    opp.Account=acc;
    opp.stageName='Cultivate';
    opp.closeDate=System.today();
    opp.Tech_Sales_Product_Area__c='Integrated Avionics';
    opp.Certification_Requirements__c = 'Direct Commercial';
    opp.ATR_Aircraft_Quantity__c = 1;
    opp.RFP_Expected_Date__c = System.today(); 
    insert opp;
    
    Profile ProfRec = [select name from Profile where name = 'D&S Sales'];

User userRec = new User(Discretionary_Workflow_Approver_Amount__c=2,FirstName='check',LastName = 'Test User',Username = 'testuser@test3.com.honeywell',Email = 'testuser@test.com',Alias = 't3user' ,CommunityNickname= 't3user' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = ProfRec.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testrole');
insert userRec;
    
     Discretionary__c d=new Discretionary__c();
    d.Type__c='Direct Sell';
    d.Opportunity__c=opp.id;
    d.Approval_Status__c='New';
    d.SBU__c='D&S';
    d.CBT__c='Advanced Technology';
    d.ownerid=userRec.id;
    d.Estimated_Completion_Date__c = System.today();
     insert d;
    d.Fiscal_Year__c=year;
    update d;
    system.assertEquals(year,d.Fiscal_Year__c);
    
    
   /* Discretionary_Line_Item__c DisLineitem=new Discretionary_Line_Item__c();
    DisLineitem.Discretionary_Request__c=d.id;
    insert DisLineitem;*/
    
    Test.startTest();
    //Discretionary__c  dis =[Select d.Id, d.Fiscal_Year__c, d.Approval_Status__c From Discretionary__c d where d.Approval_Status__c<>'Approved' and d.Approval_Status__c <>'Rejected' and
                            //d.Approval_Status__c <>'Closed' and d.Fiscal_Year__c=:year and id='a06Q0000003EWtw'];
    /*Discretionary_Mass_Closer DMC=new Discretionary_Mass_Closer();
    
    String sch='0 0 23 * * ?';  
    System.schedule('Sample Scheduling',sch,DMC);*/
    Test.stoptest();
}
}