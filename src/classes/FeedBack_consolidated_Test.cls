@isTest (seeAllData = true)
public class FeedBack_consolidated_Test {
    public static testMethod void FeedBack_consolidated_Method1(){
        Test.startTest();
        
        Account acc= new Account(name='Test Account');
        insert acc;
      
        
        AccountTeamMember accteam=[SELECT UserId,user.email,user.name,AccountId,account.name,TeamMemberRole FROM AccountTeamMember WHERE TeamMemberRole='Customer Business Manager (CBM)' limit 1];
        
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567' );
        insert cont;

        User userRec=[select id from user where id=:Userinfo.getUserId()];
        AccountTeamMember atm = new AccountTeamMember(UserId=userRec.id,teammemberRole='Customer Business Manager (CBM)',accountid=acc.id);  
        insert atm;
        
        Feedback__c fb = new Feedback__c();
        fb.Year__c='2015';
        fb.Contact__c=cont.Id;
        fb.Quarter__c='Q1';
        fb.Date_of_Interview__c=Date.today();
        fb.RecordTypeId = label.ATR_VOC_Record_Type;
        fb.ATR_Survey_Group__c='Airbus';
        fb.Account__c=acc.id;
        fb.Airbus_Rating__c = 'Red - Very Dissatisfied';
        
        fb.Warranty__c='1';
        
        fb.Repair_Performance__c='2';
       
        fb.Spares_Performance__c='2';
        
        fb.Recommend_HON__c='2';
        
        fb.Cost__c='1';
        
        fb.Overall_Perception__c='2';
        
        fb.Communication__c='2';
        
        fb.Documentation__c='2';
        
        fb.Global_Technical_Ops_Support__c='2';
        
        fb.Flexibility__c='2';
        
        fb.Customer_Overall_Satisfaction_Metric__c='1';
        
        fb.Metric_for_Value__c='2';
        
        fb.Metric_for_Service_Support__c='2';
        
        fb.Metric_for_Quality__c='2';
        
        fb.Metric_for_Reliability__c='2';
        
         fb.Metric_for_Responsiveness__c='4';
        
        fb.Metric_for_Delivery__c='4';
        
        insert fb;
        /*
        if(fb.Id != null){
            system.debug('update fbupdate fbupdate fb' + fb.Id);
            update fb;
        }
        */
            
        Test.stopTest();
    } 
    
    public static testMethod void FeedBack_consolidated_Method2(){
        Test.startTest();
        
        Account acc= new Account(name='Test Account');
        insert acc;
        
        AccountTeamMember accteam=[SELECT UserId,user.email,user.name,AccountId,account.name,TeamMemberRole FROM AccountTeamMember WHERE TeamMemberRole='Customer Business Manager (CBM)' limit 1];
        
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='H123567' );
        insert cont;
        
        Feedback__c fb = new Feedback__c();
        fb.Year__c='2015';
        fb.Contact__c=cont.Id;
        fb.Quarter__c='Q1';
        fb.Date_of_Interview__c=Date.today();
        fb.RecordTypeId = label.ATR_VOC_Record_Type;
        fb.ATR_Survey_Group__c='Airbus';
        
        fb.Warranty__c='3';
        
        fb.Repair_Performance__c='3';
       
        fb.Spares_Performance__c='3';
        
        fb.Recommend_HON__c='3';
        
        fb.Cost__c='3';
        
        fb.Overall_Perception__c='3';
        
        fb.Communication__c='3';
        
        fb.Documentation__c='3';
        
        fb.Global_Technical_Ops_Support__c='3';
        
        fb.Flexibility__c='3';        
        
        fb.Customer_Overall_Satisfaction_Metric__c='3';
        
        fb.Metric_for_Value__c='3';
                
        fb.Metric_for_Service_Support__c='3';
        
        fb.Metric_for_Quality__c='3';       
        
        fb.Metric_for_Responsiveness__c='5';      
        
        fb.Metric_for_Delivery__c='5';
        
        fb.Metric_for_Reliability__c='3';
        
        fb.RecordTypeId = label.ATR_VOC_Record_Type;
        
        insert fb;
        
        fb.ATR_Survey_Group__c='CPAR';
        fb.Warranty__c='5';
        
        fb.Repair_Performance__c='5';
       
        fb.Spares_Performance__c='5';
        
        fb.Recommend_HON__c='5';
        
        fb.Cost__c='5';
        
        fb.Overall_Perception__c='5';
        
        fb.Communication__c='5';
        
        fb.Documentation__c='5';
        
        fb.Global_Technical_Ops_Support__c='5';
        
        fb.Flexibility__c='5';        
        
        fb.Customer_Overall_Satisfaction_Metric__c='5';
        
        fb.Metric_for_Value__c='5';
                
        fb.Metric_for_Service_Support__c='5';
        
        fb.Metric_for_Quality__c='5';
        fb.Metric_for_Responsiveness__c='10';
        
        fb.Metric_for_Delivery__c='10';
         update fb;
         
        Test.stopTest();
    } 
    public static testMethod void FeedBack_consolidated_Method3(){
        Test.startTest();
        
        Account acc= new Account(name='Test Account');
        insert acc;
        
        AccountTeamMember accteam=[SELECT UserId,user.email,user.name,AccountId,account.name,TeamMemberRole FROM AccountTeamMember WHERE TeamMemberRole='Customer Business Manager (CBM)' limit 1];
        
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='T123567' );
        insert cont;
        
        Feedback__c fb = new Feedback__c();
        fb.Year__c='2015';
        fb.Contact__c=cont.Id;
        fb.Quarter__c='Q1';
        fb.Date_of_Interview__c=Date.today();
        fb.RecordTypeId = label.ATR_VOC_Record_Type;
        fb.ATR_Survey_Group__c='GE';
        
        fb.Warranty__c='4';
        
        fb.Repair_Performance__c='4';
       
        fb.Spares_Performance__c='4';
        
        fb.Recommend_HON__c='4';
        
        fb.Cost__c='4';
        
        fb.Overall_Perception__c='4';
        
        fb.Communication__c='4';
        
        fb.Documentation__c='4';
        
        fb.Global_Technical_Ops_Support__c='4';
        
        fb.Flexibility__c='4';        
       
        
        fb.Customer_Overall_Satisfaction_Metric__c='4';
        
        fb.Metric_for_Value__c='4';
        
        fb.Metric_for_Service_Support__c='4';
        
        fb.Metric_for_Quality__c='4';
        
        fb.Metric_for_Reliability__c='4';
        
         fb.Metric_for_Responsiveness__c='4';
        
        fb.Metric_for_Delivery__c='4';
        
        insert fb;
        /*
        
        fb.ATR_Survey_Group__c='GE';
        fb.Warranty__c='4';
        
        fb.Repair_Performance__c='5';
       
        fb.Spares_Performance__c='5';
        
        fb.Recommend_HON__c='5';
        
        fb.Cost__c='5';
        
        fb.Overall_Perception__c='5';
        
        fb.Communication__c='5';
        
        fb.Documentation__c='5';
        
        fb.Global_Technical_Ops_Support__c='5';
        
        fb.Flexibility__c='5';        
       
        
        fb.Customer_Overall_Satisfaction_Metric__c='5';
        
        fb.Metric_for_Value__c='5';
        
        fb.Metric_for_Service_Support__c='5';
        
        fb.Metric_for_Quality__c='5';
        
        fb.Metric_for_Reliability__c='5';
                
        fb.Metric_for_Responsiveness__c='8';
        
        fb.Metric_for_Delivery__c='8';
        
        update fb;*/
        
        
        Test.stopTest();
    } 
    public static testMethod void FeedBack_consolidated_Method4(){
        Test.startTest();
        
        Account acc= new Account(name='Test Account');
        insert acc;
        
        AccountTeamMember accteam=[SELECT UserId,user.email,user.name,AccountId,account.name,TeamMemberRole FROM AccountTeamMember WHERE TeamMemberRole='Customer Business Manager (CBM)' limit 1];
        
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E567123' );
        insert cont;
        
        Feedback__c fb = new Feedback__c();
        fb.Year__c='2015';
        fb.Contact__c=cont.Id;
        fb.Quarter__c='Q1';
        fb.Date_of_Interview__c=Date.today();
        fb.RecordTypeId = label.ATR_VOC_Record_Type;
        fb.ATR_Survey_Group__c='Airbus';
                
        fb.Warranty__c='5';
        
        fb.Repair_Performance__c='5';
       
        fb.Spares_Performance__c='5';
        
        fb.Recommend_HON__c='5';
        
        fb.Cost__c='5';
        
        fb.Overall_Perception__c='5';
        
        fb.Communication__c='5';
        
        fb.Documentation__c='5';
        
        fb.Global_Technical_Ops_Support__c='5';
        
        fb.Flexibility__c='5';        
        
        fb.Customer_Overall_Satisfaction_Metric__c='5';
        
        fb.Metric_for_Value__c='5';
        
        fb.Metric_for_Service_Support__c='5';
        
        fb.Metric_for_Quality__c='5';
        
        fb.Metric_for_Reliability__c='5';
        
        insert fb;
        
                
        Test.stopTest();
    } 
    public static testMethod void FeedBack_consolidated_Method5(){
        Test.startTest();
        
        Account acc= new Account(name='Test Account');
        insert acc;
        
        AccountTeamMember accteam=[SELECT UserId,user.email,user.name,AccountId,account.name,TeamMemberRole FROM AccountTeamMember WHERE TeamMemberRole='Customer Business Manager (CBM)' limit 1];
        
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='H567123' );
        insert cont;
        
        Feedback__c fb = new Feedback__c();
        fb.Year__c='2015';
        fb.Contact__c=cont.Id;
        fb.Quarter__c='Q1';
        fb.Date_of_Interview__c=Date.today();
        fb.RecordTypeId = label.Feedback_RecordType;
        fb.ATR_Survey_Group__c='Airbus';
        fb.Account__c=acc.id;
        fb.NPS_Classification__c = 'Passive';
        
        fb.Warranty__c='1';
        
        fb.Repair_Performance__c='1';
       
        fb.Spares_Performance__c='1';
        
        fb.Recommend_HON__c='1';
        
        fb.Cost__c='1';
        
        fb.Overall_Perception__c='2';
        
        fb.Communication__c='2';
        
        fb.Documentation__c='2';
        
        fb.Global_Technical_Ops_Support__c='2';
        
        fb.Flexibility__c='2';      
        
        fb.Customer_Overall_Satisfaction_Metric__c='5';
        
        fb.Metric_for_Value__c='5';
        
        fb.Metric_for_Service_Support__c='5';
        
        fb.Metric_for_Quality__c='5';
        
        fb.Metric_for_Reliability__c='5';
        
        fb.Metric_for_Responsiveness__c='5';
        
        fb.Metric_for_Delivery__c='5';
        
        
        
        insert fb;
       
                
        Test.stopTest();
    } 

public static testMethod void FeedBack_consolidated_Method6(){
       
        
        Account acc= new Account(name='Test Account');
        insert acc;
        
        AccountTeamMember accteam=[SELECT UserId,user.email,user.name,AccountId,account.name,TeamMemberRole FROM AccountTeamMember WHERE TeamMemberRole='Customer Business Manager (CBM)' limit 1];
        
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='H567123' );
        insert cont;
        Case case1=new Case(contactid = Cont.id,Export_Compliance_Content_ITAR_EAR__c='No',Sales_Order_Number__c='test1234', Government_Compliance_SM_M_Content__c='No',origin='Web',
        // No_FCR_Reason__c='Not Trained',
        recordtypeid=label.Order_RecordType,Type='Order Changes',Order_Type__c = 'Spares',
         //cage_code__c = '22373', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Business Hold', reason_for_hold__c = '8130 TAG', vn_name__c =cont.id); //For ticket INC000010025414
         cage_code__c = '22373', classification__c = 'EMS',status = 'On Hold',sub_status__c = 'Business Hold', vn_name__c =cont.id); //For ticket INC000010025414
     insert case1;
         Test.startTest();
        Feedback__c fb = new Feedback__c();
        fb.Contact__c=cont.Id;

        fb.Date_of_Interview__c=Date.today();
        fb.RecordTypeId = '01230000000ZewI';
       
        fb.case__c = case1.id;
       fb.NPS_Recommend__c=5;
       fb.Ease_of_Contact_Availability__c=5;
       fb.Knowledge_Technical_Expertise__c=5; 
       fb.Timeliness_of_response__c=5;
       fb.Quality_and_Accuracy__c=5;
       fb.Courtesy_and_Professionalism__c=5;
       fb.Overall_satisfaction__c=5; 
        
        
        
        insert fb;
       
                
        Test.stopTest();
    } 
}