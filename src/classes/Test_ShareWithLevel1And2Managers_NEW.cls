@istest
class Test_ShareWithLevel1And2Managers_NEW
{
    static testmethod void testMthd_SharewithMngrs_UpdateOwner_UpdateProf_RoleA1() 
    {
            Profile p4 = [SELECT Id FROM Profile WHERE Name='Standard User'];
              User u4 = new User(
     ProfileId = p4.id,
     LastName = 'last',
     Email = 'puser000@amamama.com',
     Username = 'puser000@amamama.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     //ContactId = con.id,
     //AccountId = acc.id,
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     //Level_1_Manager__c = ,
     //Level_2_Manager__c = ,
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
     //UserRoleId = r.Id
); 
        insert u4;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
              User u1 = new User(
     ProfileId = p.id,
     LastName = 'last',
     Email = 'puser000@amamama.com',
     Username = 'puser000@amamama.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     //ContactId = con.id,
     //AccountId = acc.id,
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     Level_1_Manager__c = u4.id,
     //Level_2_Manager__c = ,
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
     //UserRoleId = r.Id
); 
        insert u1;
        
         Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
              User u2 = new User(
     ProfileId = p1.id,
     LastName = 'last',
     Email = 'puser000@amamama.com',
     Username = 'puser000@amamama.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     //ContactId = con.id,
     //AccountId = acc.id,
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     Level_1_Manager__c = u1.id,
     Level_2_Manager__c = u4.id,
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
     //UserRoleId = r.Id
); 
        insert u2;
        
        
        
        Profile p3 = [SELECT Id FROM Profile WHERE Name = 'System Administrator']; 
          User u = new User(
     ProfileId = p3.id,
     LastName = 'last',
     Email = 'puser000@amamama.com',
     Username = 'puser000@amamama.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     //ContactId = con.id,
     //AccountId = acc.id,
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     Level_1_Manager__c = u1.id,
     Level_2_Manager__c = u2.id,
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
     //UserRoleId = r.Id
); 
        insert u;
        
        Sales_Competency__c sc = new Sales_Competency__c();
        sc.User__c = u.id ;
        sc.Name = 'TEst';
        sc.CurrencyIsoCode	= 'EUR';
        sc.Job_Title__c = 'TestTitle';
        sc.Role_Category__c = 'A';
        
        insert sc;
        
        sc.User__c = u1.id ;
        sc.Name = 'TEst';
        sc.CurrencyIsoCode	= 'EUR';
        sc.Job_Title__c = 'TestTitle';
        sc.Role_Category__c = 'B';
        sc.Reason_for_Role_Category_Change__c = 'Test Change';
        update sc;
    }
    
    /* static testmethod void testMthd_SharewithMngrs_UpdateOwner_UpdateProf_RoleA() 
    {
       Test.startTest();
        Sales_Competency__c sc = new Sales_Competency__c();
        
        Long lunique = DateTime.now().getTime()+1;  
        Long lunique1 = DateTime.now().getTime()+2;  
        Long lunique2 = DateTime.now().getTime()+3;  
        Profile guestUserProfile = [select id from profile where name='ATR Sales'];
                            
        User Level2Mngr = new User(alias = 'stan07', email='standarduser@testorg.com',emailencodingkey='UTF-8'
                               , lastname='Testing', languagelocalekey='en_US',localesidkey='en_US'
                               , profileid = guestUserProfile.Id,timezonesidkey='America/Los_Angeles'
                               , username='stand@a'+lunique+'.com');
                               //,SBU__c = 'Fluorine Products', SBE__c = 'Fluorine Products'
                               //, Role_Function__c = 'Sales',Region__c = 'APAC');
        insert Level2Mngr;
        
        User Level1Mngr = new User(alias = 'stan08', email='standarduser@testorg.com',emailencodingkey='UTF-8'
                               , lastname='Testing', languagelocalekey='en_US',localesidkey='en_US'
                               , profileid = guestUserProfile.Id,timezonesidkey='America/Los_Angeles'
                               , username='stand@a'+lunique1+'.com');
                               //,SBU__c = 'Fluorine Products', SBE__c = 'Fluorine Products'
                               //, Role_Function__c = 'Sales',Region__c = 'APAC');
        insert Level1Mngr;
        
        User employee = new User(alias = 'stan09', email='standarduser@testorg.com',emailencodingkey='UTF-8'
                               , lastname='Testing', languagelocalekey='en_US',localesidkey='en_US'
                               , profileid = guestUserProfile.Id,timezonesidkey='America/Los_Angeles'
                               , username='stand@a'+lunique2+'.com', Level_1_Manager__c=Level1Mngr.Id, Level_2_Manager__c=Level2Mngr.Id);
                               //,SBU__c = 'Fluorine Products', SBE__c = 'Fluorine Products'
                               //, Role_Function__c = 'Sales',Region__c = 'APAC');
                               
        insert employee;
        
        system.RunAs(Level1Mngr){
            sc.Name = 'Test';
            sc.User__c = employee.Id;
            sc.OwnerId = Level1Mngr.Id;
            sc.Status__c  = 'Draft';    
            sc.Role_Category__c = 'A';
            sc.Job_Category__c = 'Sales';
            sc.Reason_for_Role_Category_Change__c = 'Test Reason';              
            insert sc;
                                                    
            Sales_Competency_Rating__c scRating1 = new Sales_Competency_Rating__c();
            scRating1.Competency__c = 'Organizational Agility';
            scRating1.Sales_Competency_Assessment__c = sc.Id;
            scRating1.Employee_Proficiency_Rating__c = '4';
            insert scRating1;   

            Sales_Competency_Rating__c scRating2 = new Sales_Competency_Rating__c();
            scRating2.Competency__c = 'Driving Momentum';
            scRating2.Sales_Competency_Assessment__c = sc.Id;
            scRating2.Employee_Proficiency_Rating__c = '4';
            insert scRating2;

            Sales_Competency_Rating__c scRating3 = new Sales_Competency_Rating__c();
            scRating3.Competency__c = 'Value Propositions';
            scRating3.Sales_Competency_Assessment__c = sc.Id;
            scRating3.Employee_Proficiency_Rating__c = '4';
            insert scRating3;
            
            Sales_Competency_Rating__c scRating4 = new Sales_Competency_Rating__c();
            scRating4.Competency__c = 'Industry/Customer IQ';
            scRating4.Sales_Competency_Assessment__c = sc.Id;
            scRating4.Employee_Proficiency_Rating__c = '4';
            insert scRating4;
            
            Sales_Competency_Rating__c scRating5 = new Sales_Competency_Rating__c();
            scRating5.Competency__c = 'Negotiations/Closing';
            scRating5.Sales_Competency_Assessment__c = sc.Id;
            scRating5.Employee_Proficiency_Rating__c = '4';
            insert scRating5;
            
            Sales_Competency_Rating__c scRating6 = new Sales_Competency_Rating__c();
            scRating6.Competency__c = 'Account Planning';
            scRating6.Sales_Competency_Assessment__c = sc.Id;
            scRating6.Employee_Proficiency_Rating__c = '4';
            insert scRating6;
            
            Sales_Competency_Rating__c scRating7 = new Sales_Competency_Rating__c();                
            scRating7.Competency__c = 'Opportunity Conversion';
            scRating7.Sales_Competency_Assessment__c = sc.Id;
            scRating7.Employee_Proficiency_Rating__c = '4';
            insert scRating7;
                                        
            sc.Status__c  = 'Draft (Manager)';   
            sc.Role_Category__c = 'B';
            sc.Reason_for_Role_Category_Change__c = 'Test Reason';              
            update sc;
            
            sc.Status__c  = 'In Review (Employee)';
            sc.Development_Discussion_Held_Date__c = date.parse('4/22/2013');
            //sc.OwnerId = employee.Id;
            update sc;
        }
                                                                
        Test.stopTest();
    }
    
    static testmethod void testMthd_UpdateProf_RoleB() 
    {
        Test.startTest();
        Sales_Competency__c sc = new Sales_Competency__c();
        
        Long lunique = DateTime.now().getTime()+1;  
        Long lunique1 = DateTime.now().getTime()+2;  
        Long lunique2 = DateTime.now().getTime()+3;  
        Profile guestUserProfile = [select id from profile where name='ATR Sales'];
                            
        User Level2Mngr = new User(alias = 'stan07', email='standarduser@testorg.com',emailencodingkey='UTF-8'
                               , lastname='Testing', languagelocalekey='en_US',localesidkey='en_US'
                               , profileid = guestUserProfile.Id,timezonesidkey='America/Los_Angeles'
                               , username='stand@a'+lunique+'.com');
                               //,SBU__c = 'Fluorine Products', SBE__c = 'Fluorine Products'
                               //, Role_Function__c = 'Sales',Region__c = 'APAC');
        insert Level2Mngr;
        
        User Level1Mngr = new User(alias = 'stan08', email='standarduser@testorg.com',emailencodingkey='UTF-8'
                               , lastname='Testing', languagelocalekey='en_US',localesidkey='en_US'
                               , profileid = guestUserProfile.Id,timezonesidkey='America/Los_Angeles'
                               , username='stand@a'+lunique1+'.com');
                               //,SBU__c = 'Fluorine Products', SBE__c = 'Fluorine Products'
                               //, Role_Function__c = 'Sales',Region__c = 'APAC');
        insert Level1Mngr;
        
        User employee = new User(alias = 'stan09', email='standarduser@testorg.com',emailencodingkey='UTF-8'
                               , lastname='Testing', languagelocalekey='en_US',localesidkey='en_US'
                               , profileid = guestUserProfile.Id,timezonesidkey='America/Los_Angeles'
                               , username='stand@a'+lunique2+'.com', Level_1_Manager__c=Level1Mngr.Id, Level_2_Manager__c=Level2Mngr.Id);
                               //,SBU__c = 'Fluorine Products', SBE__c = 'Fluorine Products'
                               //, Role_Function__c = 'Sales',Region__c = 'APAC');
                               
        insert employee;
        
        system.RunAs(Level1Mngr){
            sc.Name = 'Test';
            sc.User__c = employee.Id;
            sc.OwnerId = Level1Mngr.Id;
            sc.Status__c  = 'Draft';    
            sc.Role_Category__c = 'B';
            sc.Job_Category__c = 'Sales';
            sc.Reason_for_Role_Category_Change__c = 'Test Reason';              
            insert sc;
                            
            Sales_Competency_Rating__c scRating1 = new Sales_Competency_Rating__c();
            scRating1.Competency__c = 'Organizational Agility';
            scRating1.Sales_Competency_Assessment__c = sc.Id;
            scRating1.Employee_Proficiency_Rating__c = '4';
            insert scRating1;   

            Sales_Competency_Rating__c scRating2 = new Sales_Competency_Rating__c();
            scRating2.Competency__c = 'Driving Momentum';
            scRating2.Sales_Competency_Assessment__c = sc.Id;
            scRating2.Employee_Proficiency_Rating__c = '4';
            insert scRating2;

            Sales_Competency_Rating__c scRating3 = new Sales_Competency_Rating__c();
            scRating3.Competency__c = 'Value Propositions';
            scRating3.Sales_Competency_Assessment__c = sc.Id;
            scRating3.Employee_Proficiency_Rating__c = '4';
            insert scRating3;
            
            Sales_Competency_Rating__c scRating4 = new Sales_Competency_Rating__c();
            scRating4.Competency__c = 'Industry/Customer IQ';
            scRating4.Sales_Competency_Assessment__c = sc.Id;
            scRating4.Employee_Proficiency_Rating__c = '4';
            insert scRating4;
            
            Sales_Competency_Rating__c scRating5 = new Sales_Competency_Rating__c();
            scRating5.Competency__c = 'Negotiations/Closing';
            scRating5.Sales_Competency_Assessment__c = sc.Id;
            scRating5.Employee_Proficiency_Rating__c = '4';
            insert scRating5;
            
            Sales_Competency_Rating__c scRating6 = new Sales_Competency_Rating__c();
            scRating6.Competency__c = 'Account Planning';
            scRating6.Sales_Competency_Assessment__c = sc.Id;
            scRating6.Employee_Proficiency_Rating__c = '4';
            insert scRating6;
            
            Sales_Competency_Rating__c scRating7 = new Sales_Competency_Rating__c();                
            scRating7.Competency__c = 'Opportunity Conversion';
            scRating7.Sales_Competency_Assessment__c = sc.Id;
            scRating7.Employee_Proficiency_Rating__c = '4';
            insert scRating7;
            
            sc.Status__c  = 'Draft (Manager)';   
            sc.Role_Category__c = 'C';
            sc.Reason_for_Role_Category_Change__c = 'Test Reason';              
            update sc;
                                        
            sc.Status__c  = 'In Review (Employee)';
            sc.Development_Discussion_Held_Date__c = date.parse('4/22/2013');
            //sc.OwnerId = employee.Id;
            update sc;
        }
                                                                
        Test.stopTest();
    }
    
    static testmethod void testMthd_UpdateProf_RoleC() 
    {
        Test.startTest();
        Sales_Competency__c sc = new Sales_Competency__c();
        
        Long lunique = DateTime.now().getTime()+1;  
        Long lunique1 = DateTime.now().getTime()+2;  
        Long lunique2 = DateTime.now().getTime()+3;  
        Profile guestUserProfile = [select id from profile where name='ATR Sales'];
                            
        User Level2Mngr = new User(alias = 'stan07', email='standarduser@testorg.com',emailencodingkey='UTF-8'
                               , lastname='Testing', languagelocalekey='en_US',localesidkey='en_US'
                               , profileid = guestUserProfile.Id,timezonesidkey='America/Los_Angeles'
                               , username='stand@a'+lunique+'.com');
                               //,SBU__c = 'Fluorine Products', SBE__c = 'Fluorine Products');
                               //, Role_Function__c = 'Sales',Region__c = 'APAC');
        insert Level2Mngr;
        
        User Level1Mngr = new User(alias = 'stan08', email='standarduser@testorg.com',emailencodingkey='UTF-8'
                               , lastname='Testing', languagelocalekey='en_US',localesidkey='en_US'
                               , profileid = guestUserProfile.Id,timezonesidkey='America/Los_Angeles'
                               , username='stand@a'+lunique1+'.com');
                               //,SBU__c = 'Fluorine Products', SBE__c = 'Fluorine Products');
                               //, Role_Function__c = 'Sales',Region__c = 'APAC');
        insert Level1Mngr;
        
        User employee = new User(alias = 'stan09', email='standarduser@testorg.com',emailencodingkey='UTF-8'
                               , lastname='Testing', languagelocalekey='en_US',localesidkey='en_US'
                               , profileid = guestUserProfile.Id,timezonesidkey='America/Los_Angeles'
                               , username='stand@a'+lunique2+'.com', Level_1_Manager__c=Level1Mngr.Id, Level_2_Manager__c=Level2Mngr.Id);
                               //,SBU__c = 'Fluorine Products', SBE__c = 'Fluorine Products'
                               //, Role_Function__c = 'Sales',Region__c = 'APAC');
                               
        insert employee;
        
        system.RunAs(Level1Mngr){
            sc.Name = 'Test';
            sc.User__c = employee.Id;
            sc.OwnerId = Level1Mngr.Id;
            sc.Status__c  = 'Draft';    
            sc.Role_Category__c = 'C';
            sc.Job_Category__c = 'Sales';
            sc.Reason_for_Role_Category_Change__c = 'Test Reason';              
            insert sc;
                            
            Sales_Competency_Rating__c scRating1 = new Sales_Competency_Rating__c();
            scRating1.Competency__c = 'Organizational Agility';
            scRating1.Sales_Competency_Assessment__c = sc.Id;
            scRating1.Employee_Proficiency_Rating__c = '4';
            insert scRating1;   

            Sales_Competency_Rating__c scRating2 = new Sales_Competency_Rating__c();
            scRating2.Competency__c = 'Driving Momentum';
            scRating2.Sales_Competency_Assessment__c = sc.Id;
            scRating2.Employee_Proficiency_Rating__c = '4';
            insert scRating2;

            Sales_Competency_Rating__c scRating3 = new Sales_Competency_Rating__c();
            scRating3.Competency__c = 'Value Propositions';
            scRating3.Sales_Competency_Assessment__c = sc.Id;
            scRating3.Employee_Proficiency_Rating__c = '4';
            insert scRating3;
            
            Sales_Competency_Rating__c scRating4 = new Sales_Competency_Rating__c();
            scRating4.Competency__c = 'Industry/Customer IQ';
            scRating4.Sales_Competency_Assessment__c = sc.Id;
            scRating4.Employee_Proficiency_Rating__c = '4';
            insert scRating4;
            
            Sales_Competency_Rating__c scRating5 = new Sales_Competency_Rating__c();
            scRating5.Competency__c = 'Negotiations/Closing';
            scRating5.Sales_Competency_Assessment__c = sc.Id;
            scRating5.Employee_Proficiency_Rating__c = '4';
            insert scRating5;
            
            Sales_Competency_Rating__c scRating6 = new Sales_Competency_Rating__c();
            scRating6.Competency__c = 'Account Planning';
            scRating6.Sales_Competency_Assessment__c = sc.Id;
            scRating6.Employee_Proficiency_Rating__c = '4';
            insert scRating6;
            
            Sales_Competency_Rating__c scRating7 = new Sales_Competency_Rating__c();                
            scRating7.Competency__c = 'Opportunity Conversion';
            scRating7.Sales_Competency_Assessment__c = sc.Id;
            scRating7.Employee_Proficiency_Rating__c = '4';
            insert scRating7;
            
            sc.Status__c  = 'Draft (Manager)';   
            sc.Role_Category__c = 'D';
            sc.Reason_for_Role_Category_Change__c = 'Test Reason';              
            update sc;
                                        
            sc.Status__c  = 'In Review (Employee)';
            sc.Development_Discussion_Held_Date__c = date.parse('4/22/2013');
            //sc.OwnerId = employee.Id;
            update sc;
        }
                                                                
        Test.stopTest();
    }
    
    static testmethod void testMthd_UpdateProf_RoleD() 
    {
        Test.startTest();
        Sales_Competency__c sc = new Sales_Competency__c();
        
        Long lunique = DateTime.now().getTime()+1;  
        Long lunique1 = DateTime.now().getTime()+2;  
        Long lunique2 = DateTime.now().getTime()+3;  
        Profile guestUserProfile = [select id from profile where name='ATR Sales'];
                            
        User Level2Mngr = new User(alias = 'stan07', email='standarduser@testorg.com',emailencodingkey='UTF-8'
                               , lastname='Testing', languagelocalekey='en_US',localesidkey='en_US'
                               , profileid = guestUserProfile.Id,timezonesidkey='America/Los_Angeles'
                               , username='stand@a'+lunique+'.com');
                               //,SBU__c = 'Fluorine Products', SBE__c = 'Fluorine Products'
                               //, Role_Function__c = 'Sales',Region__c = 'APAC');
        insert Level2Mngr;
        
        User Level1Mngr = new User(alias = 'stan08', email='standarduser@testorg.com',emailencodingkey='UTF-8'
                               , lastname='Testing', languagelocalekey='en_US',localesidkey='en_US'
                               , profileid = guestUserProfile.Id,timezonesidkey='America/Los_Angeles'
                               , username='stand@a'+lunique1+'.com');
                               //,SBU__c = 'Fluorine Products', SBE__c = 'Fluorine Products'
                               //, Role_Function__c = 'Sales',Region__c = 'APAC');
        insert Level1Mngr;
        
        User employee = new User(alias = 'stan09', email='standarduser@testorg.com',emailencodingkey='UTF-8'
                               , lastname='Testing', languagelocalekey='en_US',localesidkey='en_US'
                               , profileid = guestUserProfile.Id,timezonesidkey='America/Los_Angeles'
                               , username='stand@a'+lunique2+'.com', Level_1_Manager__c=Level1Mngr.Id, Level_2_Manager__c=Level2Mngr.Id);
                               //,SBU__c = 'Fluorine Products', SBE__c = 'Fluorine Products'
                               //, Role_Function__c = 'Sales',Region__c = 'APAC');
                               
        insert employee;
        
        system.RunAs(Level1Mngr){
            sc.Name = 'Test';
            sc.User__c = employee.Id;
            sc.OwnerId = Level1Mngr.Id;
            sc.Status__c  = 'Draft';    
            sc.Role_Category__c = 'D';
            sc.Job_Category__c = 'Sales';
            sc.Reason_for_Role_Category_Change__c = 'Test Reason';              
            insert sc;
                            
            Sales_Competency_Rating__c scRating1 = new Sales_Competency_Rating__c();
            scRating1.Competency__c = 'Organizational Agility';
            scRating1.Sales_Competency_Assessment__c = sc.Id;
            scRating1.Employee_Proficiency_Rating__c = '4';
            insert scRating1;   

            Sales_Competency_Rating__c scRating2 = new Sales_Competency_Rating__c();
            scRating2.Competency__c = 'Driving Momentum';
            scRating2.Sales_Competency_Assessment__c = sc.Id;
            scRating2.Employee_Proficiency_Rating__c = '4';
            insert scRating2;

            Sales_Competency_Rating__c scRating3 = new Sales_Competency_Rating__c();
            scRating3.Competency__c = 'Value Propositions';
            scRating3.Sales_Competency_Assessment__c = sc.Id;
            scRating3.Employee_Proficiency_Rating__c = '4';
            insert scRating3;
            
            Sales_Competency_Rating__c scRating4 = new Sales_Competency_Rating__c();
            scRating4.Competency__c = 'Industry/Customer IQ';
            scRating4.Sales_Competency_Assessment__c = sc.Id;
            scRating4.Employee_Proficiency_Rating__c = '4';
            insert scRating4;
            
            Sales_Competency_Rating__c scRating5 = new Sales_Competency_Rating__c();
            scRating5.Competency__c = 'Negotiations/Closing';
            scRating5.Sales_Competency_Assessment__c = sc.Id;
            scRating5.Employee_Proficiency_Rating__c = '4';
            insert scRating5;
            
            Sales_Competency_Rating__c scRating6 = new Sales_Competency_Rating__c();
            scRating6.Competency__c = 'Account Planning';
            scRating6.Sales_Competency_Assessment__c = sc.Id;
            scRating6.Employee_Proficiency_Rating__c = '4';
            insert scRating6;
            
            Sales_Competency_Rating__c scRating7 = new Sales_Competency_Rating__c();                
            scRating7.Competency__c = 'Opportunity Conversion';
            scRating7.Sales_Competency_Assessment__c = sc.Id;
            scRating7.Employee_Proficiency_Rating__c = '4';
            insert scRating7;
            
            sc.Status__c  = 'Draft (Manager)';   
            sc.Role_Category__c = 'E';
            sc.Reason_for_Role_Category_Change__c = 'Test Reason';              
            update sc;
                                        
            sc.Status__c  = 'In Review (Employee)';
            sc.Development_Discussion_Held_Date__c = date.parse('4/22/2013');
            //sc.OwnerId = employee.Id;
            update sc;
        }
                                                                
        Test.stopTest();
    }
    
    static testmethod void testMthd_UpdateProf_RoleE() 
    {
        Test.startTest();
        Sales_Competency__c sc = new Sales_Competency__c();
        
        Long lunique = DateTime.now().getTime()+1;  
        Long lunique1 = DateTime.now().getTime()+2;  
        Long lunique2 = DateTime.now().getTime()+3;  
        Profile guestUserProfile = [select id from profile where name='ATR Sales'];
                            
        User Level2Mngr = new User(alias = 'stan07', email='standarduser@testorg.com',emailencodingkey='UTF-8'
                               , lastname='Testing', languagelocalekey='en_US',localesidkey='en_US'
                               , profileid = guestUserProfile.Id,timezonesidkey='America/Los_Angeles'
                               , username='stand@a'+lunique+'.com');
                               //,SBU__c = 'Fluorine Products', SBE__c = 'Fluorine Products'
                               //, Role_Function__c = 'Sales',Region__c = 'APAC');
        insert Level2Mngr;
        
        User Level1Mngr = new User(alias = 'stan08', email='standarduser@testorg.com',emailencodingkey='UTF-8'
                               , lastname='Testing', languagelocalekey='en_US',localesidkey='en_US'
                               , profileid = guestUserProfile.Id,timezonesidkey='America/Los_Angeles'
                               , username='stand@a'+lunique1+'.com');
                               //,SBU__c = 'Fluorine Products', SBE__c = 'Fluorine Products'
                               //, Role_Function__c = 'Sales',Region__c = 'APAC');
        insert Level1Mngr;
        
        User employee = new User(alias = 'stan09', email='standarduser@testorg.com',emailencodingkey='UTF-8'
                               , lastname='Testing', languagelocalekey='en_US',localesidkey='en_US'
                               , profileid = guestUserProfile.Id,timezonesidkey='America/Los_Angeles'
                               , username='stand@a'+lunique2+'.com', Level_1_Manager__c=Level1Mngr.Id, Level_2_Manager__c=Level2Mngr.Id);
                               //,SBU__c = 'Fluorine Products', SBE__c = 'Fluorine Products'
                               //, Role_Function__c = 'Sales',Region__c = 'APAC');
                               
        insert employee;
        
        system.RunAs(Level1Mngr){
            sc.Name = 'Test';
            sc.User__c = employee.Id;
            sc.OwnerId = Level1Mngr.Id;
            sc.Status__c  = 'Draft';    
            sc.Role_Category__c = 'E';
            sc.Job_Category__c = 'Sales';
            sc.Reason_for_Role_Category_Change__c = 'Test Reason';              
            insert sc;
                            
            Sales_Competency_Rating__c scRating1 = new Sales_Competency_Rating__c();
            scRating1.Competency__c = 'Organizational Agility';
            scRating1.Sales_Competency_Assessment__c = sc.Id;
            scRating1.Employee_Proficiency_Rating__c = '4';
            insert scRating1;   

            Sales_Competency_Rating__c scRating2 = new Sales_Competency_Rating__c();
            scRating2.Competency__c = 'Driving Momentum';
            scRating2.Sales_Competency_Assessment__c = sc.Id;
            scRating2.Employee_Proficiency_Rating__c = '4';
            insert scRating2;

            Sales_Competency_Rating__c scRating3 = new Sales_Competency_Rating__c();
            scRating3.Competency__c = 'Value Propositions';
            scRating3.Sales_Competency_Assessment__c = sc.Id;
            scRating3.Employee_Proficiency_Rating__c = '4';
            insert scRating3;
            
            Sales_Competency_Rating__c scRating4 = new Sales_Competency_Rating__c();
            scRating4.Competency__c = 'Industry/Customer IQ';
            scRating4.Sales_Competency_Assessment__c = sc.Id;
            scRating4.Employee_Proficiency_Rating__c = '4';
            insert scRating4;
            
            Sales_Competency_Rating__c scRating5 = new Sales_Competency_Rating__c();
            scRating5.Competency__c = 'Negotiations/Closing';
            scRating5.Sales_Competency_Assessment__c = sc.Id;
            scRating5.Employee_Proficiency_Rating__c = '4';
            insert scRating5;
            
            Sales_Competency_Rating__c scRating6 = new Sales_Competency_Rating__c();
            scRating6.Competency__c = 'Account Planning';
            scRating6.Sales_Competency_Assessment__c = sc.Id;
            scRating6.Employee_Proficiency_Rating__c = '4';
            insert scRating6;
            
            Sales_Competency_Rating__c scRating7 = new Sales_Competency_Rating__c();                
            scRating7.Competency__c = 'Opportunity Conversion';
            scRating7.Sales_Competency_Assessment__c = sc.Id;
            scRating7.Employee_Proficiency_Rating__c = '4';
            insert scRating7;
                                    
            sc.Status__c  = 'Draft (Manager)';   
            sc.Role_Category__c = 'A';
            sc.Reason_for_Role_Category_Change__c = 'Test Reason';              
            update sc;
            
            sc.Status__c  = 'In Review (Employee)';
            sc.Development_Discussion_Held_Date__c = date.parse('4/22/2013');
            //sc.OwnerId = employee.Id;
            update sc;
        }
                                                                
        Test.stopTest();
    }*/
}