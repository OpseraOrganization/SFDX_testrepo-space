@isTest
public class TestClass_CSM_EMEAReport_cls{ 
    static testmethod void CSM_EMEAReport_cls(){

        
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        RECORDTYPE RT = [Select id from recordtype where name =: 'CSM Toolbox' limit 1 ];
        Profile pf= [select id from Profile where name = 'Honeywell System Administrator'];
        User usr1 = new User(LastName = 'Test', FirstName = 'UsrCont', Username = 'tuContact@test.com',Email = 'testuserContact@test.com',Alias = 'tcnt' ,CommunityNickname= 'tucont' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',ProfileId = pf.Id);
        insert usr1;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E123567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont; 
        
       
        Case cases = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            status = 'Open',
            CSM_Region__c = 'EMEAI',
            recordtypeid = rt.id,
            CSM_Feedback_Case__c = false,
            Origin = 'Email-GDC Accounts',
            //No_FCR_Reason__c = 'Not Trained', For Ticket INC000009687923
            Type = 'Order'
        );
        insert cases;
        update cases;
        
     
        Test.startTest();
        Case cases1 = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            status = 'Open',
            CSM_Region__c = 'EMEAI',
            recordtypeid = rt.id,
            CSM_Feedback_Case__c = false,
            Origin = 'Email-GDC Accounts',
            //No_FCR_Reason__c = 'Not Trained', For Ticket INC000009687923
            Type = 'Order',
            Createddate = system.today()-10
        );
        insert cases1;
        update cases1; 
        
         Case cases2 = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            status = 'Closed',
            ClosedDate = system.today(),
            CSM_Region__c = 'EMEAI',
            recordtypeid = rt.id,
            CSM_Feedback_Case__c = false,
            Origin = 'Email-GDC Accounts',
            //No_FCR_Reason__c = 'Not Trained', For Ticket INC000009687923
            Type = 'Order',
            Createddate = system.today()-10
        );
        insert cases2;
        update cases2; 
        
        
        Task tsk = new Task(
            Status = 'Approved',
            Subject = 'Test Subject',
            Priority = 'Normal',
            Resolution__c='Working On CSM_EMEAReport',
            Ownerid = usr1.id,
            whatid = cases.id
        );
        insert tsk;
        
        
        ApexPages.StandardController con = new ApexPages.StandardController(cases);
        CSM_EMEAReport_cls test1 = new CSM_EMEAReport_cls(con);
        
        
        test1.getemearecords();
        test1.getserverUrl();
        test1.gettasks();
        test1.getshowcases();
        test1.getclosedcases();
        test1.getopencases();
        test1.getproducts();
        test1.getemeaclosecases();
        test1.getemeaopencases();
        
        Test.stoptest();       
    }
}