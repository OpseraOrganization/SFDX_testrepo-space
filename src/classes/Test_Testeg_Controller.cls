@isTest//(SeeAllData=true)
 private  class Test_Testeg_Controller
 {
 
  
    
   static testmethod void oppdns(){
    
    test.startTest();
 
    Profile pf= [select id from Profile where name = 'System Administrator'];
    User usr = new User(LastName = 'Test UserCSO',FirstName='test',Username = 'tu1cso@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1cso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
    insert usr;   
    //creating account;
    Account acc= new Account(name='Test Account',Region_Name__c='Americas'); 
    insert acc;
    //creating contact; 
    Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
    Contact_Is_Employee__c=true,email='venkatesh.athanti@honeywell.com',Mobile_App_Role__c='Customer Support Manager',Contact_Status__c='Active',Employee_Number__c='E148979',Employee_Contact_Role__c='Administrator' ); 
    insert cont;   
    
    /*Case cas=new Case(AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email-GDC Accounts',
            //No_FCR_Reason__c = 'Not Trained', For Ticket INC000009687923
            Type = 'Order');
     insert cas;*/
    
     Opportunity opp=new Opportunity();
            opp.Name='Sample Opp';
            opp.Accountid=acc.id;
            //opp.Account_Contact_Name__c=cont.id;
            opp.RecordTypeId=label.OE_Complex;
            opp.stageName='Prospecting';
            opp.closeDate=system.today();
            opp.Tech_Sales_Product_Area__c='Integrated Avionics';
            opp.SBU__c='d&s';
            opp.CBT_Tier_2__c='Airlines';
            opp.StageName='Closed Won';
            opp.Win_Loss_Reason_Text__c='Testing';
            opp.Win_Loss_Reason_Code__c='High Risk';
            opp.ATR_Actual_Close_Date__c=system.today();
            opp.StageName='Closed Won';
            opp.Description='Testing';
            insert opp;  
    
         Opportunity_Proposal__c opro = new Opportunity_Proposal__c();
     opro.Last_Opened_Case__c=  '5001300000q8R3wAAE';
    
     insert opro;

    
    PageReference pageRef = Page.Testeg;
     Workflow_details__c WFrec1= new Workflow_details__c();
      WFRec1.Opportunity_Description__c=opp.id;
       WFRec1.Opportunity_Proposal__c =opro.id;
      WFRec1.Sales_Channel__c = 'Americas AM';
      WFRec1.Product_SBU__c = 'Electronic solutions';
      WFRec1.Defence_Space__c=true;
      // WFRec1.Case__c = cas.id;
      WFRec1.EMEAI__c=false;
      WFRec1.APAC__c=false;
      WFRec1.Global__c =false;
      
      String inst = URL.getSalesforceBaseUrl().getHost();
      String propurl = inst+'/apex/TESTEG_OPRO?Opportunity_Description__c='+opro.id+'&retURL='+opro.id+'&propid='+opro.id;
     Test.setCurrentPage(pageRef);
     ApexPages.StandardController egr= new ApexPages.StandardController(WFrec1);  
     //pageRef.getParameters().put('Id',WFrec.Id);
     ApexPages.currentPage().getParameters().put('str', propurl);
     ApexPages.currentPage().getParameters().put('strId', opro.id);          
     Testeg_Controller testcon= new testeg_controller(egr);
     
     testcon.opportunityid=opp.id;
     testcon.oppNumber='12345';
     testcon.oppNamm='test5';
     testcon.apac=false;
     testcon.atr=false;
     testcon.airlines=false;
     testcon.airbus=false;
     testcon.america=false;
     testcon.bga=false;
     testcon.am=false;
     testcon.boeing=false;
     testcon.dns=false;
     testcon.his=false;
     testcon.comp=false;
     testcon.oe=false;
     testcon.emeai=false;
     testcon.globall=false;
     testcon.htsi=false;
     testcon.acctid=acc.id; 
     //testcon.Case__c=cas.id;  
      testcon.saveAAS();
      TESTEG_Controller.getnameandnum(opp.id);
      test.stopTest();
    }
   static testmethod void oppbga(){
    test.startTest();
 
    Profile pf= [select id from Profile where name = 'System Administrator'];
    User usr = new User(LastName = 'Test UserCSO',FirstName='test',Username = 'tu1cso@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1cso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
    insert usr;   
    //creating account;
    Account acc= new Account(name='Test Account',Region_Name__c='Europe/MiddleEast/Africa/India'); 
    insert acc;
    //creating contact; 
    Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
    Contact_Is_Employee__c=true,email='venkatesh.athanti@honeywell.com',Mobile_App_Role__c='Customer Support Manager',Contact_Status__c='Active',Employee_Number__c='E148979',Employee_Contact_Role__c='Administrator' ); 
    insert cont;   
    
     Opportunity opp=new Opportunity();
            opp.Name='Sample Opp';
            opp.Accountid=acc.id;
            //opp.Account_Contact_Name__c=cont.id;
            opp.stageName='Prospecting';
            opp.closeDate=system.today();
            opp.Tech_Sales_Product_Area__c='Integrated Avionics';
            opp.SBU__c='bga';
            opp.CBT_Tier_2__c='Airbus';
            opp.StageName='Closed Won';
            opp.RecordTypeId=label.OE_Complex;
            //opp.Account_Contact_Name__c=cont.id;
            opp.Win_Loss_Reason_Text__c='Testing';
            opp.Win_Loss_Reason_Code__c='High Risk';
            opp.ATR_Actual_Close_Date__c=system.today();
            opp.StageName='Closed Won';
            opp.Description='Testing';
            opp.type='Complex';
            insert opp;  
     
     Opportunity_Proposal__c opro = new Opportunity_Proposal__c();
     opro.Last_Opened_Case__c=  '5001300000q8R3wAAE';
    
     insert opro;
     
    PageReference pageRef = Page.Testeg;
     Workflow_details__c WFrec1= new Workflow_details__c();
      WFRec1.Opportunity_Description__c=opp.id;
      WFRec1.Defence_Space__c=true;
     Test.setCurrentPage(pageRef);
     ApexPages.StandardController egr= new ApexPages.StandardController(WFrec1);     
     Testeg_Controller testcon= new testeg_controller(egr);
     
     testcon.opportunityid=opp.id;
     testcon.oppNumber='12345';
     testcon.oppNamm='test5';
     testcon.apac=false;
     testcon.atr=false;
     testcon.airlines=false;
     testcon.airbus=false;
     testcon.america=true;
     testcon.bga=false;
     testcon.am=false;
     testcon.boeing=false;
     testcon.dns=false;
     testcon.his=false;
     testcon.comp=false;
     testcon.oe=false;
     testcon.emeai=false;
     testcon.globall=false;
     testcon.htsi=false;
     testcon.acctid=acc.id;
     testcon.saveAAS();
     TESTEG_Controller.getnameandnum(opp.id);
        Contact c = new Contact(FirstName='â–¼',LastName='â–¼');
        insert c;
        //Contact[] cc = globalTest.findContacts('â–¼ â–¼');
     //string s='006c000000B6J7y';
    //testcon.remotegetnameandnum(s);
     //string s='006c000000B6J7y';
     //testcon.getnameandnum(s);
      test.stopTest();
          }
          
     static testmethod void oppatr(){
        test.startTest();
 
    Profile pf= [select id from Profile where name = 'System Administrator'];
    User usr = new User(LastName = 'Test UserCSO',FirstName='test',Username = 'tu1cso@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1cso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
    insert usr;   
    //creating account;
    Account acc= new Account(name='Test Account'); 
    acc.Region_Name__c='Asia/Pacific Rim';
    insert acc;
    //creating contact; 
    Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
    Contact_Is_Employee__c=true,email='venkatesh.athanti@honeywell.com',Mobile_App_Role__c='Customer Support Manager',Contact_Status__c='Active',Employee_Number__c='E148979',Employee_Contact_Role__c='Administrator' ); 
    insert cont;   
    
     Opportunity opp=new Opportunity();
            opp.Name='Sample Opp';
            opp.Accountid=acc.id;
            //opp.Account_Contact_Name__c=cont.id;
            opp.RecordTypeId=label.OE_Complex;
            system.debug('ACCOUNT OPP'+acc);
            opp.stageName='Prospecting';
            opp.closeDate=system.today();
            opp.Tech_Sales_Product_Area__c='Integrated Avionics';
            opp.SBU__c='ATR';
            opp.CBT_Tier_2__c='DAA';
            opp.StageName='Closed Won';
            opp.Win_Loss_Reason_Text__c='Testing';
            opp.Win_Loss_Reason_Code__c='High Risk';
            opp.ATR_Actual_Close_Date__c=system.today();
            opp.StageName='Closed Won';
            opp.Description='Testing';            
            insert opp;  
    
    PageReference pageRef = Page.Testeg;
     Workflow_details__c WFrec1= new Workflow_details__c();
      WFRec1.Opportunity_Description__c=opp.id;
      WFRec1.Americas__c =false;
      WFRec1.Defence_Space__c=true;
      WFRec1.EMEAI__c=false;
      WFRec1.Global__c =false;
      
     Test.setCurrentPage(pageRef);
     ApexPages.StandardController egr= new ApexPages.StandardController(WFrec1);  
     Testeg_Controller testcon= new testeg_controller(egr);
     
     testcon.opportunityid=opp.id;
     testcon.oppNumber='12345';
     testcon.oppNamm='test5';
     testcon.apac=false;
     testcon.atr=false;
     testcon.airlines=false;
     testcon.airbus=false;
     testcon.america=false;
     testcon.bga=false;
     testcon.am=false;
     testcon.boeing=false;
     testcon.dns=false;
     testcon.his=false;
     testcon.comp=false;
     testcon.oe=false;
     testcon.emeai=false;
     testcon.globall=false;
     testcon.htsi=false;   
     testcon.acctid=acc.id;   
      testcon.saveAAS();
     TESTEG_Controller.getnameandnum(opp.id);
      test.stopTest();
          }
 
    static testmethod void campatr(){
        test.startTest();
        
           campaign camp=new campaign();
            camp.Name ='Name';
            camp.CampaignPrimarySBU__c='D&S';
            camp.CampaignPrimaryCBTTier2__c='DAA';
            camp.CBT_Team__c='CBMS';
            camp.Primary_Sales_Channel__c='Americas AM';
            camp.SC1__c='DAA Americas';
            camp.Type='D&S Complex';           
                        
            insert camp;  
    
    PageReference pageRef = Page.TESTEG_Campaign;
     Workflow_details__c WFrec1= new Workflow_details__c();
      WFRec1.Americas__c =false;
      WFRec1.EMEAI__c=false;
      WFRec1.Global__c =false;
      
     Test.setCurrentPage(pageRef);
     ApexPages.StandardController egr= new ApexPages.StandardController(WFrec1);  
     Testeg_Controller testcon1= new testeg_controller(egr);
     
     testcon1.campaignid=camp.id;
     testcon1.apac=false;
     testcon1.atr=false;
     testcon1.airlines=false;
     testcon1.airbus=false;
     testcon1.america=false;
     testcon1.bga=false;
     testcon1.am=false;
     testcon1.boeing=false;
     testcon1.dns=false;
     testcon1.his=false;
     testcon1.comp=false;
     testcon1.oe=false;
     testcon1.emeai=false;
     testcon1.globall=false;
     testcon1.htsi=false;   
     
      testcon1.saveAAS();
     
      test.stopTest();
          }
 static testmethod void oppsCbtTier(){
    test.startTest();
 
    Profile pf= [select id from Profile where name = 'System Administrator'];
    User usr = new User(LastName = 'Test UserCSO',FirstName='test',Username = 'tu1cso@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1cso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
    insert usr;   
    //creating account;
    Account accAsia= new Account(name='Test Account Asia'); 
    accAsia.Region_Name__c = 'Asia/Pacific Rim';
    accAsia.cbt__c='Airlines';
    insert accAsia;
    //creating contact; 
    Contact contAsia=new Contact(firstname='Test',LastName='Contact',AccountId=accAsia.Id,Phone_3__c='9986502495',
    Contact_Is_Employee__c=true,email='venkatesh.athanti@honeywell.com',Mobile_App_Role__c='Customer Support Manager',Contact_Status__c='Active',Employee_Number__c='E148979',Employee_Contact_Role__c='Administrator'); 
    insert contAsia;   
    
   /* Case casAsia=new Case(AccountId = accAsia.Id,
            subject = 'ARINC Update',
            ContactId = contAsia.Id,
            Origin = 'Email-GDC Accounts',
            //No_FCR_Reason__c = 'Not Trained', For Ticket INC000009687923
            Type = 'Order');
     insert casAsia;*/
    
     Opportunity oppAsia=new Opportunity();
            oppAsia.Name='Sample Opp';
            oppAsia.Accountid=accAsia.id;
            oppAsia.RecordTypeId=label.AM_Catalog;
            oppAsia.IC_Scorecard_Opportunity__c =true;
            oppAsia.Type_of_Opportunity__c = 'R&O â€“ APU';
            oppAsia.Lead_Number__c = '1234';
            //opp.Account_Contact_Name__c=cont.id;
            oppAsia.stageName='Prospecting';
            oppAsia.closeDate=system.today();
            oppAsia.Tech_Sales_Product_Area__c='Integrated Avionics';
            oppAsia.SBU__c='ACS Labs';
            oppAsia.CBT_Tier_2__c='Airlines';
            //opp.CBT_Tier_2__c='Components Business';
            oppAsia.StageName='Closed Won';
           
            oppAsia.Win_Loss_Reason_Text__c='Testing';
            oppAsia.Win_Loss_Reason_Code__c='High Risk';
            oppAsia.ATR_Actual_Close_Date__c=system.today();
            //oppAsia.StageName='Closed Won';
            oppAsia.Description='Testing'; 
            insert oppAsia;  
            system.debug('oppAsia$$$$'+oppAsia);
     
    PageReference pageRef = Page.Testeg;
     Workflow_details__c WFrec1= new Workflow_details__c();
     // WFrec1.Case__c = casAsia.id;
      WFRec1.Opportunity_Description__c=oppAsia.id;
      system.debug('OppDescription'+WFRec1.Opportunity_Description__c);
      WFRec1.Americas__c =false;
       WFRec1.Defence_Space__c=true;
      WFRec1.APAC__c=false;
      WFRec1.Global__c =false;
      
     Test.setCurrentPage(pageRef);
     ApexPages.StandardController egr= new ApexPages.StandardController(WFrec1);  
     ApexPages.CurrentPage().getParameters().Put('str','test123@test.com');
     //pageRef.getParameters().put('Id',WFrec.Id);          
     Testeg_Controller testconAsia= new testeg_controller(egr);
     
     testconAsia.opportunityid=oppAsia.id;
     testconAsia.oppNumber='12345';
     testconAsia.oppNamm='test5';
     testconAsia.apac=false;
     testconAsia.atr=false;
     testconAsia.airlines=false;
     testconAsia.airbus=false;
     testconAsia.america=false;
     testconAsia.bga=false;
     testconAsia.am=false;
     testconAsia.boeing=false;
     testconAsia.dns=false;
     testconAsia.his=false;
     testconAsia.comp=false;
     testconAsia.oe=false;
     testconAsia.emeai=true;
     testconAsia.globall=false;
     testconAsia.htsi=false;
     testconAsia.acctid=accAsia.id;
     testconAsia.saveAAS();
     testconAsia.oppnum = 'test';
     testconAsia.acctname = 'test';
     list<String> s = TESTEG_Controller.getnameandnum(oppAsia.id);
     
      test.stopTest();
     
          } 
       
                      
    
    
      }