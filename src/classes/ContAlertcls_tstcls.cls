/***********************************************************************************************************
* Company Name          : NTT Data
* Name                  : ContAlertCls_tstcls
* Description           : Test class for the Controller ContAlertCls
***********************************************************************************************************/
@isTest
public class ContAlertcls_tstcls{ 
    static testmethod void ContAlerttestcls(){
    test.starttest();
      User usr = new User( Alias = 'dhivtest' ,
                            Email ='testuser1234@test123.com',
                            EmailEncodingKey = 'UTF-8',
                            LastName = 'Testing',
                            LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', 
                            UserName='testuser1234@test123.com',
                            ProfileId=label.Sales_Admin_Profile_ID,
                            TimeZoneSidKey    = 'America/Los_Angeles');
       
        Account acc=new Account(name='Test dhiv',US_Govt_Sanctioned__c=false);
        insert acc;
                
        System.runas(usr){
        Contact c1=new Contact(Account=acc,lastname='TestDhivya',email='test@g.com',Contact_is_Employee__c=false,Honeywell_ID__c='E872345');
        insert c1;
           
        
        PageReference pageRef = Page.ContactAlertPage;
        pageRef.getParameters().put('id',c1.id);
        Test.setCurrentPage(pageRef); 
        
        Contact cont= new Contact();         
        ApexPages.StandardController con = new ApexPages.StandardController(cont);
        
        Contalertcls aler= new contalertcls(con);       
        aler.getcontact();
        //aler.closePopup1();
        //aler.showPopup();
        //aler.showPopup1(); 
        }   
        test.stoptest();
        }
        
    static testmethod void ContAlerttest1cls(){
    test.starttest();
      User usr = new User( Alias = 'dhivtest' ,
                            Email ='testuser1234@test123.com',
                            EmailEncodingKey = 'UTF-8',
                            LastName = 'Testing',
                            LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', 
                            UserName='testuser1234@test123.com',
                            ProfileId=label.Sales_Admin_Profile_ID,
                            TimeZoneSidKey    = 'America/Los_Angeles');
       
        Account acc=new Account(name='Test dhiv',US_Govt_Sanctioned__c=true);
        insert acc;
                
        System.runas(usr){
        Contact c1=new Contact(Account=acc,lastname='TestDhivya',email='test@g.com',Contact_is_Employee__c=false,Honeywell_ID__c='E872345');
        insert c1;
           
        
        PageReference pageRef = Page.ContactAlertPage;
        pageRef.getParameters().put('id',c1.id);
        Test.setCurrentPage(pageRef); 
        
        Contact cont= new Contact();         
        ApexPages.StandardController con = new ApexPages.StandardController(cont);
        
        Contalertcls aler= new contalertcls(con);       
        aler.getcontact();
        //aler.closePopup1();
        //aler.showPopup();
        //aler.showPopup1(); 
        }   
        test.stoptest();
        }
        
    
        static testmethod void ContAlerttestcls1(){
    test.starttest();
       User usr = new User( Alias = 'dhivtest' ,
                            Email ='testuser1234@test123.com',
                            EmailEncodingKey = 'UTF-8',
                            LastName = 'Testing',
                            LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', 
                            UserName='testuser1234@test123.com',
                            ProfileId=label.Sys_Admin_Profile_Id,
                            TimeZoneSidKey    = 'America/Los_Angeles');
       
        Account acc=new Account(name='Test dhiv',US_Govt_Sanctioned__c=false);
        insert acc;
            
        System.runas(usr){
        Contact c1=new Contact(Account=acc,lastname='TestDhivya',email='test@g.com',Contact_is_Employee__c=false,Honeywell_ID__c='E872345');
        insert c1;
        
        PageReference pageRef = Page.ContactAlertPage;
        pageRef.getParameters().put('id',c1.id);
        Test.setCurrentPage(pageRef); 
        
        Contact cont= new Contact();         
        ApexPages.StandardController con = new ApexPages.StandardController(cont);
        
        Contalertcls aler= new contalertcls(con);       
        aler.getcontact();
        }   
        test.stoptest();
        }
        
        static testmethod void ContAlerttestcls2(){
        test.starttest();
         User usr = new User( Alias = 'dhivtest' ,
                            Email ='testuser1234@test123.com',
                            EmailEncodingKey = 'UTF-8',
                            LastName = 'Testing',
                            LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', 
                            UserName='testuser1234@test123.com',
                            ProfileId=label.Honeywell_System_Administrator,
                            TimeZoneSidKey    = 'America/Los_Angeles');
        
        Account acc=new Account(name='Test dhiv',US_Govt_Sanctioned__c=true);
        insert acc;
        
        System.runas(usr){
        Contact c1=new Contact(Account=acc,lastname='TestDhivya',email='test@g.com');
        insert c1;
           
        
        PageReference pageRef = Page.ContactAlertPage;
        pageRef.getParameters().put('id',c1.id);
        Test.setCurrentPage(pageRef); 
        
        Contact cont= new Contact();         
        ApexPages.StandardController con = new ApexPages.StandardController(cont);
        
        Contalertcls aler= new contalertcls(con);       
        aler.getcontact();
        //aler.closePopup1();
        //aler.showPopup();
        //aler.showPopup1(); 
        }   
        test.stoptest();
        }
    static testmethod void ContAlerttestcls3(){
        test.starttest();
         User usr = new User( Alias = 'dhivtest' ,
                            Email ='testuser1234@test123.com',
                            EmailEncodingKey = 'UTF-8',
                            LastName = 'Testing',
                            LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', 
                            UserName='testuser1234@test123.com',
                            ProfileId=label.Sys_Admin_Profile_Id,
                            TimeZoneSidKey    = 'America/Los_Angeles');
        
        Account acc=new Account(name='Test dhiv',US_Govt_Sanctioned__c=true);
        insert acc;
        
        System.runas(usr){
        Contact c1=new Contact(Account=acc,lastname='TestDhivya',email='test@g.com');
        insert c1;
           
        
        PageReference pageRef = Page.ContactAlertPage;
        pageRef.getParameters().put('id',c1.id);
        Test.setCurrentPage(pageRef); 
        
        Contact cont= new Contact();         
        ApexPages.StandardController con = new ApexPages.StandardController(cont);
        
        Contalertcls aler= new contalertcls(con);       
        aler.getcontact();
        //aler.closePopup1();
        //aler.showPopup();
        //aler.showPopup1(); 
        //
        }   
        test.stoptest();
        }
    }