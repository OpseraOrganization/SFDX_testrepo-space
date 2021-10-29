/** * File Name:  TestClass_ApexShdlr_Hstry_EmailReminder
* Description Test Method
* Class Tested: ATR_Opp_Closed_yest
* Copyright : Wipro Technologies Limited Copyright (c) 2011
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest(seealldata = true)
public class TestClass_ATR_Opp_Closed_yest {
static testMethod void ATR_Opp_Closed_yest_Test() {
Date yest=System.today()-1;
list<User__c> Userlist= new list<User__c>();
attachment attchRec= new attachment();
//User__c userRec=User__c.getValues('anila.francis@wipro2234.com');
//User__c recipients = new user__c (
//email__c='anila.francis@wipro2234.com',
//Name='Anila');
//insert recipients;
//Userlist.add(recipients);
   List<User__c> recipients=User__c.getall().values();
list<Opportunity> Opplist= new list<Opportunity>();
Profile pf= [select id from Profile where name = 'System Administrator'];
User usr = new User(FirstName = 'Test1 ',LastName = 'UserEgreen',Username = '1tu1egreen@test.com',Email = recipients[0].email__c,Alias = 'tu1Test' ,
CommunityNickname= 'tu1csoTest' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
insert usr;
//List<User__c> recipients = new list<User__c>();
Account acc=new Account();
            acc.name='Sample';
            insert acc;
            
    
            
            Opportunity opp=new Opportunity();
            opp.Name='Sample Opp';
            opp.AccountId=acc.Id;
            //opp.stageName='Prospecting';
            opp.closeDate=yest;
            opp.Tech_Sales_Product_Area__c='Integrated Avionics';
            opp.SBU__c='ATR';
            opp.CBT_Tier_2__c='Boeing BDS';
            //opp.StageName='Closed Won';
            opp.Win_Loss_Reason_Text__c='Testing';
            opp.Win_Loss_Reason_Code__c='High Risk';
            opp.ATR_Actual_Close_Date__c=yest;
            opp.StageName='Closed Won';
            opp.ATR_Proposal_Type__c = 'AGMT';
            opp.Description='Testing';
            
            insert opp;
            opp.StageName='Closed Won';
			Test.startTest();
            update opp;
			Test.stopTest();
            
            
            Pricebook2 pb = [select name, isactive from Pricebook2 where IsStandard = true Limit 1];
            Product2 prdNew=new Product2(Name='NewProduct',ProductCode='xxx',CanUseRevenueSchedule=true);
            insert prdNew;
            PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.id,Product2Id   = prdNew.id,IsActive     = true,     UnitPrice    = 1); 
            insert pbe;
            Decimal q =5;
            Date dl1 =Date.newInstance(2011,08,1);
            Date dl2 =Date.newInstance(2011,09,12);
            OpportunityLineItem LineItem=new OpportunityLineItem( OpportunityId=Opp.Id,ServiceDate=dl1,quantity=10,pricebookentryid =pbe.Id,unitprice=1);
            insert LineItem;
            OpportunityLineItemSchedule oschedule = new OpportunityLineItemSchedule(ScheduleDate = dl2,Revenue = 10, OpportunityLineItemId=LineItem.Id,Type= 'Revenue');
            insert oschedule;
            
            
           // update opp;  
            Opplist.add(opp);
                      
    Attachment Attrec= new Attachment();
    Attrec.Name = 'TestAttachment';
    Attrec.ParentId = opp.ID;
    String body= 'testbody';       
    Blob myBlob = Blob.valueof(body);
    Attrec.body=myBlob;
    insert Attrec;
            

 ATR_Opp_Closed_yest ATrSchedule =new ATR_Opp_Closed_yest();
  String shdlr='0 0 23 * * ?';  
  System.schedule('Test ATR_Opp_Closed_yest Scheduling',shdlr,ATrSchedule);
          
}

static testMethod void ATR_Opp_Closed_yest_Test2() {
Date yest=System.today()-1;
list<User__c> Userlist= new list<User__c>();
attachment attchRec= new attachment();
//User__c userRec=User__c.getValues('anila.francis@wipro2234.com');
//User__c recipients = new user__c (
//email__c='anila.francis@wipro2234.com',
//Name='Anila');
//insert recipients;
//Userlist.add(recipients);
   List<User__c> recipients=User__c.getall().values();
list<Opportunity> Opplist= new list<Opportunity>();
Profile pf= [select id from Profile where name = 'System Administrator'];
User usr = new User(FirstName = 'Test1 ',LastName = 'UserEgreen',Username = '1tu1egreen@test.com',Email = recipients[0].email__c,Alias = 'tu1Test' ,
CommunityNickname= 'tu1csoTest' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
insert usr;
//List<User__c> recipients = new list<User__c>();
Account acc=new Account();
            acc.name='Sample';
            insert acc;
            
    
            
            Opportunity opp=new Opportunity();
            opp.Name='Sample Opp';
            opp.AccountId=acc.Id;
            //opp.stageName='Prospecting';
            opp.closeDate=yest;
            opp.Tech_Sales_Product_Area__c='Integrated Avionics';
            opp.SBU__c='ATR';
            opp.CBT_Tier_2__c='Boeing BDS';
            //opp.StageName='Closed Won';
            opp.Win_Loss_Reason_Text__c='Testing';
            opp.Win_Loss_Reason_Code__c='High Risk';
            opp.ATR_Actual_Close_Date__c=yest;
            opp.StageName='Closed Won';
            opp.ATR_Proposal_Type__c = 'AGMT';
            opp.Description='Testing';
            
            insert opp;
       

            
            
            Pricebook2 pb = [select name, isactive from Pricebook2 where IsStandard = true Limit 1];
            Product2 prdNew=new Product2(Name='NewProduct',ProductCode='xxx',CanUseRevenueSchedule=true);
            insert prdNew;
            PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.id,Product2Id   = prdNew.id,IsActive     = true,     UnitPrice    = 1); 
            insert pbe;
            Decimal q =5;
            Date dl1 =Date.newInstance(2011,08,1);
            Date dl2 =Date.newInstance(2011,09,12);
            OpportunityLineItem LineItem=new OpportunityLineItem( OpportunityId=Opp.Id,ServiceDate=dl1,quantity=10,pricebookentryid =pbe.Id,unitprice=1);
            insert LineItem;
            OpportunityLineItemSchedule oschedule = new OpportunityLineItemSchedule(ScheduleDate = dl2,Revenue = 10, OpportunityLineItemId=LineItem.Id,Type= 'Revenue');
            insert oschedule;
            
            
           // update opp;  
            Opplist.add(opp);
                      
    Attachment Attrec= new Attachment();
    Attrec.Name = 'TestAttachment';
    Attrec.ParentId = opp.ID;
    String body= 'testbody';       
    Blob myBlob = Blob.valueof(body);
    Attrec.body=myBlob;
    insert Attrec;
            
Test.startTest();
 ATR_Opp_Closed_yest ATrSchedule =new ATR_Opp_Closed_yest();
  String shdlr='0 0 23 * * ?';  
  System.schedule('Test ATR_Opp_Closed_yest Scheduling',shdlr,ATrSchedule);
Test.stopTest();          
}
}