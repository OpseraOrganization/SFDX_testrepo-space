/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class DashboardHome_Test{

    static testMethod void myUnitTest() 
    {
     DashboardHome dh= new DashboardHome();
     //RemFeedback rm= new RemFeedback('filter');
     dh.getcountgreen1() ;
     dh.getcountred();
     dh.getcountyellow();
     dh.getOverallAOGStatus();
     dh.getPlatformsAtRisk();
     dh.getmpStatus();
     dh.getscrollcomment();
     String s='ALL';
     DashboardHome.RemFeedback(s);
 
    }
    
     static testmethod void bgadrill(){
        //User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name != 'System Administrator' and isactive = true order by createddate asc limit 1];
       Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='ATR');
       Test.startTest();   
       insert acc;
       Test.stopTest();   
        //System.runAs(usr){
        Contact con = new Contact();
        con.LastName = 'testupdate';
        con.FirstName = 'sbucon';
        con.AccountId = acc.Id;
         con.Contact_Function__c='Infosys';
         con.Primary_Email_Address__c = 'sofiya.peermohamed@nttdata.com';
        con.Employee_Number__c = 'E123123';
        //con.Account_Contact_Name__c=acc.name;
        con.Email='harikishore.vutukuri@honeywell.com';
        //con.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
       // con.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;
          
        insert con;
       
         Case c1=new Case(App_Email__c='test1@g.com',SuppliedEmail='test@g.com',Origin='BGAMobileApp');
           
         insert c1; 
         
       Schema.DescribeSObjectResult FeedObj = Schema.SObjectType.Feedback__c;
     Map<String,Schema.RecordTypeInfo> feedrtMapByName = FeedObj.getRecordTypeInfosByName();
     Schema.RecordTypeInfo feedrtByName =  feedrtMapByName.get('Customer Rating');
     ID feedRecTypeid =  feedrtByName.getRecordTypeId();
        Feedback__c feed=new Feedback__c();
       
        feed.Year__c='2014';
        feed.Quarter__c='Q4';
        feed.Date_of_Interview__c=date.today();
        feed.Survey_Origin__c='Bombardier';
        feed.Account__c=acc.id;
        feed.Field_for_Weighting__c=5;
        feed.Overall_Rating__c=3;
        feed.Overall_Rating_Score__c=8;
        feed.Overall_Rating_Color__c='Red';
        feed.Aggregate_Scoring__c=True;
        feed.Include_on_Customer_Rating_Dashboard__c=True;
        feed.Additional_Comments__c='test comment';
        feed.recordtypeid=feedRecTypeid;
        //feed.recordtypeid=FeedRecordTypeInfo .get('A').getRecordTypeId();
         
        insert feed;
       
         Service_Request__c  Sr =new Service_Request__c();
        Sr.Subject__c='DS Test SR';
        Sr.SR_Type__c='Significant Customer Dissatisfier';
        Sr.Priority__c='High';
        Sr.Status__c='Open';
        Sr.Problem_Description__c='Technical Problem';
        Sr.Account_Name__c=acc.id;
        Sr.Customer_Due_Date__c=date.today();
        Sr.Top_Technical_Issue__c=true;
        Sr.VOC_Card_Numb__c=feed.id;
        Sr.Contact_Name__c = con.id;
        Sr.Case_Number__c = c1.Id;
        Sr.Show_on_Dashboard__c=true;
         
        insert Sr;
            
        DashboardHome dh= new DashboardHome();
        String s='APU';
       DashboardHome.RemFeedback(s);
 
        dh.getSBUValues();
        dh.getATRValues();
        dh.getBGAValues();
        dh.getDSValues();
        dh.getVOCfeedrecords();
        dh.getVOCfeedrecordsATR();
        dh.getSRDaysValues();
        dh.getSRValues();
        dh.getGreencountATR();
        dh.getYellowcountATR();
        dh.getRedcountATR();
        dh.getGreencountBGA();
        dh.getYellowcountBGA();
        dh.getRedcountBGA();
        dh.getGreencountDS();
        dh.getYellowcountDS();
        dh.getRedcountDS();
        dh.getGreencountColorATR();
        dh.getYellowcountColorATR();
        dh.getRedcountColorATR();
        dh.getGreencountColorBGA();
        dh.getYellowcountColorBGA();
        dh.getRedcountColorBGA();
        dh.getGreencountColorDS();
        dh.getYellowcountColorDS();
        dh.getRedcountColorDS();
        dh.getRecorddetails();
        dh.getRedcountColorDS();
        dh.getYellowcountColorDS();
        dh.getRedcountATR();
        dh.Feedredirect();
       // dh.TopSRDSRedirect();
        dh.ATRVOC();
        dh.closePopup();
        dh.showPopup();
        dh.getTotalpercentageColor();
        dh.getTotalpercentageColorATR();
        dh.getTotalpercentageColorBGA();
        dh.getTotalpercentageColorDS();
        dh.getTotalpercentage();
        dh.getTotalpercentageATR();
        dh.getTotalpercentageBGA();
        dh.getTotalpercentageDS();
        dh.getTotalSR();
        dh.getPastDueSR();
        dh.getTotalSRATR();
        dh.getPastDueSRATR();
        dh.getTotalSRBGA();
        dh.getPastDueSRBGA();
        dh.getTotalSRDS();
        dh.getPastDueSRDS();
        dh.getscrollcommentATR();
    //}
    }
     static testmethod void bgadrill1(){
        //User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name != 'System Administrator' and isactive = true order by createddate asc limit 1];
       Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='BGA');
       Test.startTest();   
       insert acc;
       Test.stopTest();
       //System.runAs(usr){
        Contact con = new Contact();
        con.LastName = 'testupdate';
        con.FirstName = 'sbucon';
        con.AccountId = acc.Id;
         con.Contact_Function__c='Infosys';
         con.Primary_Email_Address__c = 'sofiya.peermohamed@nttdata.com';
        con.Employee_Number__c = 'E123123';
        //con.Account_Contact_Name__c=acc.name;
        con.Email='harikishore.vutukuri@honeywell.com';
        //con.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
       // con.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;
      
        insert con;
        
         Case c1=new Case(App_Email__c='test1@g.com',SuppliedEmail='test@g.com',Origin='BGAMobileApp');
        
         insert c1; 
         
       Schema.DescribeSObjectResult FeedObj = Schema.SObjectType.Feedback__c;
     Map<String,Schema.RecordTypeInfo> feedrtMapByName = FeedObj.getRecordTypeInfosByName();
     Schema.RecordTypeInfo feedrtByName =  feedrtMapByName.get('Customer Rating');
     ID feedRecTypeid =  feedrtByName.getRecordTypeId();
        Feedback__c feed=new Feedback__c();
       
        feed.Year__c='2014';
        feed.Quarter__c='Q4';
        feed.Date_of_Interview__c=date.today();
        feed.Survey_Origin__c='Bombardier';
        feed.Account__c=acc.id;
        feed.Field_for_Weighting__c=5;
        feed.Overall_Rating__c=3;
        feed.Overall_Rating_Score__c=8;
        feed.Overall_Rating_Color__c='Red';
        feed.Aggregate_Scoring__c=True;
        feed.Include_on_Customer_Rating_Dashboard__c=True;
        feed.Additional_Comments__c='test comment';
        feed.recordtypeid=feedRecTypeid;
        //feed.recordtypeid=FeedRecordTypeInfo .get('A').getRecordTypeId();
         
        insert feed;
        
         Service_Request__c  Sr =new Service_Request__c();
        Sr.Subject__c='DS Test SR';
        Sr.SR_Type__c='Significant Customer Dissatisfier';
        Sr.Priority__c='High';
        Sr.Status__c='Open';
        Sr.Problem_Description__c='Technical Problem';
        Sr.Account_Name__c=acc.id;
        Sr.Customer_Due_Date__c=date.today();
        Sr.Top_Technical_Issue__c=true;
        Sr.VOC_Card_Numb__c=feed.id;
        Sr.Contact_Name__c = con.id;
        Sr.Case_Number__c = c1.Id;
        Sr.Show_on_Dashboard__c=true;
         
        insert Sr;
             
        DashboardHome dh= new DashboardHome();
        
        dh.getSBUValues();
        dh.getATRValues();
        dh.getBGAValues();
        dh.getDSValues();
        dh.getVOCfeedrecords();
        dh.getVOCfeedrecordsATR();
        dh.getSRDaysValues();
        dh.getSRValues();
        dh.getGreencountATR();
        dh.getYellowcountATR();
        dh.getRedcountATR();
        dh.getGreencountBGA();
        dh.getYellowcountBGA();
        dh.getRedcountBGA();
        dh.getGreencountDS();
        dh.getYellowcountDS();
        dh.getRedcountDS();
        dh.getGreencountColorATR();
        dh.getYellowcountColorATR();
        dh.getRedcountColorATR();
        dh.getGreencountColorBGA();
        dh.getYellowcountColorBGA();
        dh.getRedcountColorBGA();
        dh.getGreencountColorDS();
        dh.getYellowcountColorDS();
        dh.getRedcountColorDS();
        dh.getRecorddetails();
        dh.getRedcountColorDS();
        dh.getYellowcountColorDS();
        dh.getRedcountATR();
        dh.Feedredirect();
        //dh.TopSRDSRedirect();
        dh.ATRVOC();
        dh.closePopup();
        dh.showPopup();
        dh.getTotalpercentageColor();
        dh.getTotalpercentageColorATR();
        dh.getTotalpercentageColorBGA();
        dh.getTotalpercentageColorDS();
        dh.getTotalpercentage();
        dh.getTotalpercentageATR();
        dh.getTotalpercentageBGA();
        dh.getTotalpercentageDS();
        dh.getscrollcommentBGA();
    //}
    }
   
    static testmethod void bgadrill2(){
       // User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name != 'System Administrator' and isactive = true order by createddate asc limit 1];
       Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='D&S');
       Test.startTest();   
       insert acc;
       Test.stopTest();
       //System.runAs(usr){
        Contact con = new Contact();
        con.LastName = 'testupdate';
        con.FirstName = 'sbucon';
        con.AccountId = acc.Id;
         con.Contact_Function__c='Infosys';
         con.Primary_Email_Address__c = 'sofiya.peermohamed@nttdata.com';
        con.Employee_Number__c = 'E123123';
        //con.Account_Contact_Name__c=acc.name;
        con.Email='harikishore.vutukuri@honeywell.com';
        //con.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
       // con.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;
       
        insert con;
        
         Case c1=new Case(App_Email__c='test1@g.com',SuppliedEmail='test@g.com',Origin='BGAMobileApp');
          
         insert c1; 
         
       Schema.DescribeSObjectResult FeedObj = Schema.SObjectType.Feedback__c;
     Map<String,Schema.RecordTypeInfo> feedrtMapByName = FeedObj.getRecordTypeInfosByName();
     Schema.RecordTypeInfo feedrtByName =  feedrtMapByName.get('Customer Rating');
     ID feedRecTypeid =  feedrtByName.getRecordTypeId();
        Feedback__c feed=new Feedback__c();
       
        feed.Year__c='2014';
        feed.Quarter__c='Q4';
        feed.Date_of_Interview__c=date.today();
        feed.Survey_Origin__c='Bombardier';
        feed.Account__c=acc.id;
        feed.Field_for_Weighting__c=5;
        feed.Overall_Rating__c=3;
        feed.Overall_Rating_Score__c=8;
        feed.Overall_Rating_Color__c='Red';
        feed.Aggregate_Scoring__c=True;
        feed.Include_on_Customer_Rating_Dashboard__c=True;
        feed.Additional_Comments__c='test comment';
        feed.recordtypeid=feedRecTypeid;
        //feed.recordtypeid=FeedRecordTypeInfo .get('A').getRecordTypeId();
         
        insert feed;
        
         Service_Request__c  Sr =new Service_Request__c();
        Sr.Subject__c='DS Test SR';
        Sr.SR_Type__c='Significant Customer Dissatisfier';
        Sr.Priority__c='High';
        Sr.Status__c='Open';
        Sr.Problem_Description__c='Technical Problem';
        Sr.Account_Name__c=acc.id;
        Sr.Customer_Due_Date__c=date.today();
        Sr.Top_Technical_Issue__c=true;
        Sr.VOC_Card_Numb__c=feed.id;
        Sr.Contact_Name__c = con.id;
        Sr.Case_Number__c = c1.Id;
        Sr.Show_on_Dashboard__c=true;
          
        insert Sr;
    
           DashboardHome dh= new DashboardHome(); 
           
        dh.getscroll();
        dh.getscrollcomment();
        dh.getSBUValues();
        dh.getATRValues();
        dh.getBGAValues();
        dh.getDSValues();
        dh.getVOCfeedrecords();
        dh.getVOCfeedrecordsATR();
        dh.getSRDaysValues();
        dh.getSRValues();
        dh.getGreencountATR();
        dh.getYellowcountATR();
        dh.getRedcountATR();
        dh.getGreencountBGA();
        dh.getYellowcountBGA();
        dh.getRedcountBGA();
        dh.getGreencountDS();
        dh.getYellowcountDS();
        dh.getRedcountDS();
        dh.getGreencountColorATR();
        dh.getYellowcountColorATR();
        dh.getRedcountColorATR();
        dh.getGreencountColorBGA();
        dh.getYellowcountColorBGA();
        dh.getRedcountColorBGA();
        dh.getGreencountColorDS();
        dh.getYellowcountColorDS();
        dh.getRedcountColorDS();
        dh.getRecorddetails();
        dh.getRedcountColorDS();
        dh.getYellowcountColorDS();
        dh.getRedcountATR();
        dh.Feedredirect();
        //dh.TopSRDSRedirect();
        dh.ATRVOC();
        dh.closePopup();
        dh.showPopup();
        dh.getTotalpercentageColor();
        dh.getTotalpercentageColorATR();
        dh.getTotalpercentageColorBGA();
        dh.getTotalpercentageColorDS();
        dh.getTotalpercentage();
        dh.getTotalpercentageATR();
        dh.getTotalpercentageBGA();
        dh.getTotalpercentageDS();
        dh.getscrollcommentDS();
    //}
    }
     static testmethod void bgadrill3(){
        //User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name != 'System Administrator' and isactive = true order by createddate asc limit 1];
       Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='ATR');
       Test.startTest();   
       insert acc;
       Test.stopTest();   
        //System.runAs(usr){
        Contact con = new Contact();
        con.LastName = 'testupdate';
        con.FirstName = 'sbucon';
        con.AccountId = acc.Id;
         con.Contact_Function__c='Infosys';
         con.Primary_Email_Address__c = 'sofiya.peermohamed@nttdata.com';
        con.Employee_Number__c = 'E123123';
        //con.Account_Contact_Name__c=acc.name;
        con.Email='harikishore.vutukuri@honeywell.com';
        //con.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
       // con.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;
          
        insert con;
       
         Case c1=new Case(App_Email__c='test1@g.com',SuppliedEmail='test@g.com',Origin='BGAMobileApp');
           
         insert c1; 
         
       Schema.DescribeSObjectResult FeedObj = Schema.SObjectType.Feedback__c;
     Map<String,Schema.RecordTypeInfo> feedrtMapByName = FeedObj.getRecordTypeInfosByName();
     Schema.RecordTypeInfo feedrtByName =  feedrtMapByName.get('Customer Rating');
     ID feedRecTypeid =  feedrtByName.getRecordTypeId();
        Feedback__c feed=new Feedback__c();
       
        feed.Year__c='2014';
        feed.Quarter__c='Q4';
        feed.Date_of_Interview__c=date.today();
        feed.Survey_Origin__c='Bombardier';
        feed.Account__c=acc.id;
        feed.Field_for_Weighting__c=5;
        feed.Overall_Rating__c=3;
        feed.Overall_Rating_Score__c=8;
        feed.Overall_Rating_Color__c='Yellow';
        feed.Aggregate_Scoring__c=True;
        feed.Include_on_Customer_Rating_Dashboard__c=True;
        feed.Additional_Comments__c='test comment';
        feed.recordtypeid=feedRecTypeid;
        //feed.recordtypeid=FeedRecordTypeInfo .get('A').getRecordTypeId();
         
        insert feed;
       
         Service_Request__c  Sr =new Service_Request__c();
        Sr.Subject__c='DS Test SR';
        Sr.SR_Type__c='Significant Customer Dissatisfier';
        Sr.Priority__c='High';
        Sr.Status__c='Open';
        Sr.Problem_Description__c='Technical Problem';
        Sr.Account_Name__c=acc.id;
        Sr.Customer_Due_Date__c=date.today();
        Sr.Top_Technical_Issue__c=true;
        Sr.VOC_Card_Numb__c=feed.id;
        Sr.Contact_Name__c = con.id;
        Sr.Case_Number__c = c1.Id;
        Sr.Show_on_Dashboard__c=true;
         
        insert Sr;
            
        DashboardHome dh= new DashboardHome();
        String s='APU';
       DashboardHome.RemFeedback(s);
 
        dh.getSBUValues();
        dh.getATRValues();
        dh.getBGAValues();
        dh.getDSValues();
        dh.getVOCfeedrecords();
        dh.getVOCfeedrecordsATR();
        dh.getSRDaysValues();
        dh.getSRValues();
        dh.getGreencountATR();
        dh.getYellowcountATR();
        dh.getRedcountATR();
        dh.getGreencountBGA();
        dh.getYellowcountBGA();
        dh.getRedcountBGA();
        dh.getGreencountDS();
        dh.getYellowcountDS();
        dh.getRedcountDS();
        dh.getGreencountColorATR();
        dh.getYellowcountColorATR();
        dh.getRedcountColorATR();
        dh.getGreencountColorBGA();
        dh.getYellowcountColorBGA();
        dh.getRedcountColorBGA();
        dh.getGreencountColorDS();
        dh.getYellowcountColorDS();
        dh.getRedcountColorDS();
        dh.getRecorddetails();
        dh.getRedcountColorDS();
        dh.getYellowcountColorDS();
        dh.getRedcountATR();
        dh.Feedredirect();
       // dh.TopSRDSRedirect();
        dh.ATRVOC();
        dh.closePopup();
        dh.showPopup();
        dh.getTotalpercentageColor();
        dh.getTotalpercentageColorATR();
        dh.getTotalpercentageColorBGA();
        dh.getTotalpercentageColorDS();
        dh.getTotalpercentage();
        dh.getTotalpercentageATR();
        dh.getTotalpercentageBGA();
        dh.getTotalpercentageDS();
        dh.getTotalSR();
        dh.getPastDueSR();
        dh.getTotalSRATR();
        dh.getPastDueSRATR();
        dh.getTotalSRBGA();
        dh.getPastDueSRBGA();
        dh.getTotalSRDS();
        dh.getPastDueSRDS();
        dh.getscrollcommentATR();
    //}
    }
     static testmethod void bgadrill4(){
        //User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name != 'System Administrator' and isactive = true order by createddate asc limit 1];
       Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='BGA');
       Test.startTest();   
       insert acc;
       Test.stopTest();
       //System.runAs(usr){
        Contact con = new Contact();
        con.LastName = 'testupdate';
        con.FirstName = 'sbucon';
        con.AccountId = acc.Id;
         con.Contact_Function__c='Infosys';
         con.Primary_Email_Address__c = 'sofiya.peermohamed@nttdata.com';
        con.Employee_Number__c = 'E123123';
        //con.Account_Contact_Name__c=acc.name;
        con.Email='harikishore.vutukuri@honeywell.com';
        //con.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
       // con.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;
      
        insert con;
        
         Case c1=new Case(App_Email__c='test1@g.com',SuppliedEmail='test@g.com',Origin='BGAMobileApp');
        
         insert c1; 
         
       Schema.DescribeSObjectResult FeedObj = Schema.SObjectType.Feedback__c;
     Map<String,Schema.RecordTypeInfo> feedrtMapByName = FeedObj.getRecordTypeInfosByName();
     Schema.RecordTypeInfo feedrtByName =  feedrtMapByName.get('Customer Rating');
     ID feedRecTypeid =  feedrtByName.getRecordTypeId();
        Feedback__c feed=new Feedback__c();
       
        feed.Year__c='2014';
        feed.Quarter__c='Q4';
        feed.Date_of_Interview__c=date.today();
        feed.Survey_Origin__c='Bombardier';
        feed.Account__c=acc.id;
        feed.Field_for_Weighting__c=5;
        feed.Overall_Rating__c=3;
        feed.Overall_Rating_Score__c=8;
        feed.Overall_Rating_Color__c='Yellow';
        feed.Aggregate_Scoring__c=True;
        feed.Include_on_Customer_Rating_Dashboard__c=True;
        feed.Additional_Comments__c='test comment';
        feed.recordtypeid=feedRecTypeid;
        //feed.recordtypeid=FeedRecordTypeInfo .get('A').getRecordTypeId();
         
        insert feed;
        
         Service_Request__c  Sr =new Service_Request__c();
        Sr.Subject__c='DS Test SR';
        Sr.SR_Type__c='Significant Customer Dissatisfier';
        Sr.Priority__c='High';
        Sr.Status__c='Open';
        Sr.Problem_Description__c='Technical Problem';
        Sr.Account_Name__c=acc.id;
        Sr.Customer_Due_Date__c=date.today();
        Sr.Top_Technical_Issue__c=true;
        Sr.VOC_Card_Numb__c=feed.id;
        Sr.Contact_Name__c = con.id;
        Sr.Case_Number__c = c1.Id;
        Sr.Show_on_Dashboard__c=true;
         
        insert Sr;
             
        DashboardHome dh= new DashboardHome();
        
        dh.getSBUValues();
        dh.getATRValues();
        dh.getBGAValues();
        dh.getDSValues();
        dh.getVOCfeedrecords();
        dh.getVOCfeedrecordsATR();
        dh.getSRDaysValues();
        dh.getSRValues();
        dh.getGreencountATR();
        dh.getYellowcountATR();
        dh.getRedcountATR();
        dh.getGreencountBGA();
        dh.getYellowcountBGA();
        dh.getRedcountBGA();
        dh.getGreencountDS();
        dh.getYellowcountDS();
        dh.getRedcountDS();
        dh.getGreencountColorATR();
        dh.getYellowcountColorATR();
        dh.getRedcountColorATR();
        dh.getGreencountColorBGA();
        dh.getYellowcountColorBGA();
        dh.getRedcountColorBGA();
        dh.getGreencountColorDS();
        dh.getYellowcountColorDS();
        dh.getRedcountColorDS();
        dh.getRecorddetails();
        dh.getRedcountColorDS();
        dh.getYellowcountColorDS();
        dh.getRedcountATR();
        dh.Feedredirect();
        //dh.TopSRDSRedirect();
        dh.ATRVOC();
        dh.closePopup();
        dh.showPopup();
        dh.getTotalpercentageColor();
        dh.getTotalpercentageColorATR();
        dh.getTotalpercentageColorBGA();
        dh.getTotalpercentageColorDS();
        dh.getTotalpercentage();
        dh.getTotalpercentageATR();
        dh.getTotalpercentageBGA();
        dh.getTotalpercentageDS();
        dh.getscrollcommentBGA();
    //}
    }
   
    static testmethod void bgadrill5(){
       // User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name != 'System Administrator' and isactive = true order by createddate asc limit 1];
       Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='D&S');
       Test.startTest();   
       insert acc;
       Test.stopTest();
       //System.runAs(usr){
        Contact con = new Contact();
        con.LastName = 'testupdate';
        con.FirstName = 'sbucon';
        con.AccountId = acc.Id;
         con.Contact_Function__c='Infosys';
         con.Primary_Email_Address__c = 'sofiya.peermohamed@nttdata.com';
        con.Employee_Number__c = 'E123123';
        //con.Account_Contact_Name__c=acc.name;
        con.Email='harikishore.vutukuri@honeywell.com';
        //con.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
       // con.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;
       
        insert con;
        
         Case c1=new Case(App_Email__c='test1@g.com',SuppliedEmail='test@g.com',Origin='BGAMobileApp');
          
         insert c1; 
         
       Schema.DescribeSObjectResult FeedObj = Schema.SObjectType.Feedback__c;
     Map<String,Schema.RecordTypeInfo> feedrtMapByName = FeedObj.getRecordTypeInfosByName();
     Schema.RecordTypeInfo feedrtByName =  feedrtMapByName.get('Customer Rating');
     ID feedRecTypeid =  feedrtByName.getRecordTypeId();
        Feedback__c feed=new Feedback__c();
       
        feed.Year__c='2014';
        feed.Quarter__c='Q4';
        feed.Date_of_Interview__c=date.today();
        feed.Survey_Origin__c='Bombardier';
        feed.Account__c=acc.id;
        feed.Field_for_Weighting__c=5;
        feed.Overall_Rating__c=3;
        feed.Overall_Rating_Score__c=8;
        feed.Overall_Rating_Color__c='Yellow';
        feed.Aggregate_Scoring__c=True;
        feed.Include_on_Customer_Rating_Dashboard__c=True;
        feed.Additional_Comments__c='test comment';
        feed.recordtypeid=feedRecTypeid;
        //feed.recordtypeid=FeedRecordTypeInfo .get('A').getRecordTypeId();
         
        insert feed;
        
         Service_Request__c  Sr =new Service_Request__c();
        Sr.Subject__c='DS Test SR';
        Sr.SR_Type__c='Significant Customer Dissatisfier';
        Sr.Priority__c='High';
        Sr.Status__c='Open';
        Sr.Problem_Description__c='Technical Problem';
        Sr.Account_Name__c=acc.id;
        Sr.Customer_Due_Date__c=date.today();
        Sr.Top_Technical_Issue__c=true;
        Sr.VOC_Card_Numb__c=feed.id;
        Sr.Contact_Name__c = con.id;
        Sr.Case_Number__c = c1.Id;
        Sr.Show_on_Dashboard__c=true;
          
        insert Sr;
    
           DashboardHome dh= new DashboardHome(); 
           
        dh.getscroll();
        dh.getscrollcomment();
        dh.getSBUValues();
        dh.getATRValues();
        dh.getBGAValues();
        dh.getDSValues();
        dh.getVOCfeedrecords();
        dh.getVOCfeedrecordsATR();
        dh.getSRDaysValues();
        dh.getSRValues();
        dh.getGreencountATR();
        dh.getYellowcountATR();
        dh.getRedcountATR();
        dh.getGreencountBGA();
        dh.getYellowcountBGA();
        dh.getRedcountBGA();
        dh.getGreencountDS();
        dh.getYellowcountDS();
        dh.getRedcountDS();
        dh.getGreencountColorATR();
        dh.getYellowcountColorATR();
        dh.getRedcountColorATR();
        dh.getGreencountColorBGA();
        dh.getYellowcountColorBGA();
        dh.getRedcountColorBGA();
        dh.getGreencountColorDS();
        dh.getYellowcountColorDS();
        dh.getRedcountColorDS();
        dh.getRecorddetails();
        dh.getRedcountColorDS();
        dh.getYellowcountColorDS();
        dh.getRedcountATR();
        dh.Feedredirect();
        //dh.TopSRDSRedirect();
        dh.ATRVOC();
        dh.closePopup();
        dh.showPopup();
        dh.getTotalpercentageColor();
        dh.getTotalpercentageColorATR();
        dh.getTotalpercentageColorBGA();
        dh.getTotalpercentageColorDS();
        dh.getTotalpercentage();
        dh.getTotalpercentageATR();
        dh.getTotalpercentageBGA();
        dh.getTotalpercentageDS();
        dh.getscrollcommentDS();
    //}
    }
    static testmethod void bgadrill6(){
        //User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name != 'System Administrator' and isactive = true order by createddate asc limit 1];
       Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='ATR');
       Test.startTest();   
       insert acc;
       Test.stopTest();   
        //System.runAs(usr){
        Contact con = new Contact();
        con.LastName = 'testupdate';
        con.FirstName = 'sbucon';
        con.AccountId = acc.Id;
         con.Contact_Function__c='Infosys';
         con.Primary_Email_Address__c = 'sofiya.peermohamed@nttdata.com';
        con.Employee_Number__c = 'E123123';
        //con.Account_Contact_Name__c=acc.name;
        con.Email='harikishore.vutukuri@honeywell.com';
        //con.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
       // con.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;
          
        insert con;
       
         Case c1=new Case(App_Email__c='test1@g.com',SuppliedEmail='test@g.com',Origin='BGAMobileApp');
           
         insert c1; 
         
       Schema.DescribeSObjectResult FeedObj = Schema.SObjectType.Feedback__c;
     Map<String,Schema.RecordTypeInfo> feedrtMapByName = FeedObj.getRecordTypeInfosByName();
     Schema.RecordTypeInfo feedrtByName =  feedrtMapByName.get('Customer Rating');
     ID feedRecTypeid =  feedrtByName.getRecordTypeId();
        Feedback__c feed=new Feedback__c();
       
        feed.Year__c='2014';
        feed.Quarter__c='Q4';
        feed.Date_of_Interview__c=date.today();
        feed.Survey_Origin__c='Bombardier';
        feed.Account__c=acc.id;
        feed.Field_for_Weighting__c=5;
        feed.Overall_Rating__c=3;
        feed.Overall_Rating_Score__c=8;
        feed.Overall_Rating_Color__c='Green';
        feed.Aggregate_Scoring__c=True;
        feed.Include_on_Customer_Rating_Dashboard__c=True;
        feed.Additional_Comments__c='test comment';
        feed.recordtypeid=feedRecTypeid;
        //feed.recordtypeid=FeedRecordTypeInfo .get('A').getRecordTypeId();
         
        insert feed;
       
         Service_Request__c  Sr =new Service_Request__c();
        Sr.Subject__c='DS Test SR';
        Sr.SR_Type__c='Significant Customer Dissatisfier';
        Sr.Priority__c='High';
        Sr.Status__c='Open';
        Sr.Problem_Description__c='Technical Problem';
        Sr.Account_Name__c=acc.id;
        Sr.Customer_Due_Date__c=date.today();
        Sr.Top_Technical_Issue__c=true;
        Sr.VOC_Card_Numb__c=feed.id;
        Sr.Contact_Name__c = con.id;
        Sr.Case_Number__c = c1.Id;
        Sr.Show_on_Dashboard__c=true;
         
        insert Sr;
            
        DashboardHome dh= new DashboardHome();
        String s='APU';
       DashboardHome.RemFeedback(s);
 
        dh.getSBUValues();
        dh.getATRValues();
        dh.getBGAValues();
        dh.getDSValues();
        dh.getVOCfeedrecords();
        dh.getVOCfeedrecordsATR();
        dh.getSRDaysValues();
        dh.getSRValues();
        dh.getGreencountATR();
        dh.getYellowcountATR();
        dh.getRedcountATR();
        dh.getGreencountBGA();
        dh.getYellowcountBGA();
        dh.getRedcountBGA();
        dh.getGreencountDS();
        dh.getYellowcountDS();
        dh.getRedcountDS();
        dh.getGreencountColorATR();
        dh.getYellowcountColorATR();
        dh.getRedcountColorATR();
        dh.getGreencountColorBGA();
        dh.getYellowcountColorBGA();
        dh.getRedcountColorBGA();
        dh.getGreencountColorDS();
        dh.getYellowcountColorDS();
        dh.getRedcountColorDS();
        dh.getRecorddetails();
        dh.getRedcountColorDS();
        dh.getYellowcountColorDS();
        dh.getRedcountATR();
        dh.Feedredirect();
       // dh.TopSRDSRedirect();
        dh.ATRVOC();
        dh.closePopup();
        dh.showPopup();
        dh.getTotalpercentageColor();
        dh.getTotalpercentageColorATR();
        dh.getTotalpercentageColorBGA();
        dh.getTotalpercentageColorDS();
        dh.getTotalpercentage();
        dh.getTotalpercentageATR();
        dh.getTotalpercentageBGA();
        dh.getTotalpercentageDS();
        dh.getTotalSR();
        dh.getPastDueSR();
        dh.getTotalSRATR();
        dh.getPastDueSRATR();
        dh.getTotalSRBGA();
        dh.getPastDueSRBGA();
        dh.getTotalSRDS();
        dh.getPastDueSRDS();
        dh.getscrollcommentATR();
    //}
    }
     static testmethod void bgadrill7(){
        //User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name != 'System Administrator' and isactive = true order by createddate asc limit 1];
       Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='BGA');
       Test.startTest();   
       insert acc;
       Test.stopTest();
       //System.runAs(usr){
        Contact con = new Contact();
        con.LastName = 'testupdate';
        con.FirstName = 'sbucon';
        con.AccountId = acc.Id;
         con.Contact_Function__c='Infosys';
         con.Primary_Email_Address__c = 'sofiya.peermohamed@nttdata.com';
        con.Employee_Number__c = 'E123123';
        //con.Account_Contact_Name__c=acc.name;
        con.Email='harikishore.vutukuri@honeywell.com';
        //con.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
       // con.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;
      
        insert con;
        
         Case c1=new Case(App_Email__c='test1@g.com',SuppliedEmail='test@g.com',Origin='BGAMobileApp');
        
         insert c1; 
         
       Schema.DescribeSObjectResult FeedObj = Schema.SObjectType.Feedback__c;
     Map<String,Schema.RecordTypeInfo> feedrtMapByName = FeedObj.getRecordTypeInfosByName();
     Schema.RecordTypeInfo feedrtByName =  feedrtMapByName.get('Customer Rating');
     ID feedRecTypeid =  feedrtByName.getRecordTypeId();
        Feedback__c feed=new Feedback__c();
       
        feed.Year__c='2014';
        feed.Quarter__c='Q4';
        feed.Date_of_Interview__c=date.today();
        feed.Survey_Origin__c='Bombardier';
        feed.Account__c=acc.id;
        feed.Field_for_Weighting__c=5;
        feed.Overall_Rating__c=3;
        feed.Overall_Rating_Score__c=8;
        feed.Overall_Rating_Color__c='Green';
        feed.Aggregate_Scoring__c=True;
        feed.Include_on_Customer_Rating_Dashboard__c=True;
        feed.Additional_Comments__c='test comment';
        feed.recordtypeid=feedRecTypeid;
        //feed.recordtypeid=FeedRecordTypeInfo .get('A').getRecordTypeId();
         
        insert feed;
        
         Service_Request__c  Sr =new Service_Request__c();
        Sr.Subject__c='DS Test SR';
        Sr.SR_Type__c='Significant Customer Dissatisfier';
        Sr.Priority__c='High';
        Sr.Status__c='Open';
        Sr.Problem_Description__c='Technical Problem';
        Sr.Account_Name__c=acc.id;
        Sr.Customer_Due_Date__c=date.today();
        Sr.Top_Technical_Issue__c=true;
        Sr.VOC_Card_Numb__c=feed.id;
        Sr.Contact_Name__c = con.id;
        Sr.Case_Number__c = c1.Id;
        Sr.Show_on_Dashboard__c=true;
         
        insert Sr;
             
        DashboardHome dh= new DashboardHome();
        
        dh.getSBUValues();
        dh.getATRValues();
        dh.getBGAValues();
        dh.getDSValues();
        dh.getVOCfeedrecords();
        dh.getVOCfeedrecordsATR();
        dh.getSRDaysValues();
        dh.getSRValues();
        dh.getGreencountATR();
        dh.getYellowcountATR();
        dh.getRedcountATR();
        dh.getGreencountBGA();
        dh.getYellowcountBGA();
        dh.getRedcountBGA();
        dh.getGreencountDS();
        dh.getYellowcountDS();
        dh.getRedcountDS();
        dh.getGreencountColorATR();
        dh.getYellowcountColorATR();
        dh.getRedcountColorATR();
        dh.getGreencountColorBGA();
        dh.getYellowcountColorBGA();
        dh.getRedcountColorBGA();
        dh.getGreencountColorDS();
        dh.getYellowcountColorDS();
        dh.getRedcountColorDS();
        dh.getRecorddetails();
        dh.getRedcountColorDS();
        dh.getYellowcountColorDS();
        dh.getRedcountATR();
        dh.Feedredirect();
        //dh.TopSRDSRedirect();
        dh.ATRVOC();
        dh.closePopup();
        dh.showPopup();
        dh.getTotalpercentageColor();
        dh.getTotalpercentageColorATR();
        dh.getTotalpercentageColorBGA();
        dh.getTotalpercentageColorDS();
        dh.getTotalpercentage();
        dh.getTotalpercentageATR();
        dh.getTotalpercentageBGA();
        dh.getTotalpercentageDS();
        dh.getscrollcommentBGA();
    //}
    }
   
    static testmethod void bgadrill8(){
       // User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name != 'System Administrator' and isactive = true order by createddate asc limit 1];
       Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='D&S');
       Test.startTest();   
       insert acc;
       Test.stopTest();
       //System.runAs(usr){
        Contact con = new Contact();
        con.LastName = 'testupdate';
        con.FirstName = 'sbucon';
        con.AccountId = acc.Id;
         con.Contact_Function__c='Infosys';
         con.Primary_Email_Address__c = 'sofiya.peermohamed@nttdata.com';
        con.Employee_Number__c = 'E123123';
        //con.Account_Contact_Name__c=acc.name;
        con.Email='harikishore.vutukuri@honeywell.com';
        //con.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
       // con.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;
       
        insert con;
        
         Case c1=new Case(App_Email__c='test1@g.com',SuppliedEmail='test@g.com',Origin='BGAMobileApp');
          
         insert c1; 
         
       Schema.DescribeSObjectResult FeedObj = Schema.SObjectType.Feedback__c;
     Map<String,Schema.RecordTypeInfo> feedrtMapByName = FeedObj.getRecordTypeInfosByName();
     Schema.RecordTypeInfo feedrtByName =  feedrtMapByName.get('Customer Rating');
     ID feedRecTypeid =  feedrtByName.getRecordTypeId();
        Feedback__c feed=new Feedback__c();
       
        feed.Year__c='2014';
        feed.Quarter__c='Q4';
        feed.Date_of_Interview__c=date.today();
        feed.Survey_Origin__c='Bombardier';
        feed.Account__c=acc.id;
        feed.Field_for_Weighting__c=5;
        feed.Overall_Rating__c=3;
        feed.Overall_Rating_Score__c=8;
        feed.Overall_Rating_Color__c='Green';
        feed.Aggregate_Scoring__c=True;
        feed.Include_on_Customer_Rating_Dashboard__c=True;
        feed.Additional_Comments__c='test comment';
        feed.recordtypeid=feedRecTypeid;
        //feed.recordtypeid=FeedRecordTypeInfo .get('A').getRecordTypeId();
         
        insert feed;
        
         Service_Request__c  Sr =new Service_Request__c();
        Sr.Subject__c='DS Test SR';
        Sr.SR_Type__c='Significant Customer Dissatisfier';
        Sr.Priority__c='High';
        Sr.Status__c='Open';
        Sr.Problem_Description__c='Technical Problem';
        Sr.Account_Name__c=acc.id;
        Sr.Customer_Due_Date__c=date.today();
        Sr.Top_Technical_Issue__c=true;
        Sr.VOC_Card_Numb__c=feed.id;
        Sr.Contact_Name__c = con.id;
        Sr.Case_Number__c = c1.Id;
        Sr.Show_on_Dashboard__c=true;
          
        insert Sr;
    
           DashboardHome dh= new DashboardHome(); 
           
        dh.getscroll();
        dh.getscrollcomment();
        dh.getSBUValues();
        dh.getATRValues();
        dh.getBGAValues();
        dh.getDSValues();
        dh.getVOCfeedrecords();
        dh.getVOCfeedrecordsATR();
        dh.getSRDaysValues();
        dh.getSRValues();
        dh.getGreencountATR();
        dh.getYellowcountATR();
        dh.getRedcountATR();
        dh.getGreencountBGA();
        dh.getYellowcountBGA();
        dh.getRedcountBGA();
        dh.getGreencountDS();
        dh.getYellowcountDS();
        dh.getRedcountDS();
        dh.getGreencountColorATR();
        dh.getYellowcountColorATR();
        dh.getRedcountColorATR();
        dh.getGreencountColorBGA();
        dh.getYellowcountColorBGA();
        dh.getRedcountColorBGA();
        dh.getGreencountColorDS();
        dh.getYellowcountColorDS();
        dh.getRedcountColorDS();
        dh.getRecorddetails();
        dh.getRedcountColorDS();
        dh.getYellowcountColorDS();
        dh.getRedcountATR();
        dh.Feedredirect();
        //dh.TopSRDSRedirect();
        dh.ATRVOC();
        dh.closePopup();
        dh.showPopup();
        dh.getTotalpercentageColor();
        dh.getTotalpercentageColorATR();
        dh.getTotalpercentageColorBGA();
        dh.getTotalpercentageColorDS();
        dh.getTotalpercentage();
        dh.getTotalpercentageATR();
        dh.getTotalpercentageBGA();
        dh.getTotalpercentageDS();
        dh.getscrollcommentDS();
    //}
    }
}