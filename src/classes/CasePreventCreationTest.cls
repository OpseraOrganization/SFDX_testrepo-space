@isTest(SeeAllData=true)
private  class CasePreventCreationTest{

static testmethod void CasePreventCreationTest()
    {    
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = [Select id,Name,Email from User where id =: label.aero_default_user_id]; 

        Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='BGA',Concierge__c =False,Type='OEM' );
        insert acc;


        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Primary_Email_Address__c='test@nttdata.com');
        insert cont;
        
        Test.startTest();       
            System.runas(usr){
                Case cases1=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',Subject ='Test case1',
                //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
                Type='Order',Supported_Product__c='ADIRS',Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance',
                Emailbox_Origin__c='Email-Orders',PreventCloseonupdate__c = 2.00);
                insert cases1;
                
                cases1.PreventCloseonupdate__c = 5.00;
                Update cases1;
            }              
             
        Test.stopTest();

    }
    
    static testmethod void CasePreventCreationTest1()
    {    
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = [Select id,Name,Email from User where id =: label.aero_default_user_id]; 

        Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='BGA',Concierge__c =False,Type='OEM' );
        insert acc;       

        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Primary_Email_Address__c='test@testnttdata.com');
        insert cont;
        
        Test.startTest();       
           System.runas(usr){
                Case cases1=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',Subject ='Test case1',
                //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
                Type='Order',Supported_Product__c='ADIRS',Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance',
                Emailbox_Origin__c='Email-Orders',PreventCloseonupdate__c = 2.00,Suppliedemail='test@equipaero.com');
                insert cases1;

                cases1.PreventCloseonupdate__c = 4.00;
                Update cases1;
            }
           
        Test.stopTest();

    }
    static testmethod void CasePreventCreationTest2()
    {    
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = [Select id,Name,Email from User where id =: label.aero_default_user_id];       

        Account acc1= new Account(name='Test1 Account',Strategic_Business_Unit__c='ATR',Concierge__c =False,Type='Owner/Operator',Region_Name__c='Asia Pacific/Rim' );
        insert acc1;

        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc1.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Primary_Email_Address__c='test@nttdata.com');
        insert cont;
        
        Test.startTest();       
           
            System.runas(usr){
                Case cases3=new Case(AccountId=acc1.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',Subject ='Test case3',
                //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
                Type='Order',Supported_Product__c='ADIRS',Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance',
                Origin='Email',Emailbox_Origin__c='Email-Orders',PreventCloseonupdate__c = 2.00);
                insert cases3;

                cases3.PreventCloseonupdate__c = 3.00;
                Update cases3;
               
            }   
        Test.stopTest();

    }
    static testmethod void CasePreventCreationTest3()
    {    
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = [Select id,Name,Email from User where id =: label.aero_default_user_id]; 

        Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='BGA',Concierge__c =False,Type='OEM',Do_Not_Send_to_Portal__c=false );
        insert acc;        

        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Primary_Email_Address__c='test@nttdata.com');
        insert cont;
        
        Test.startTest();       
           
            System.runas(usr){
                Case cases4=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',Subject ='Test case3',
                //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
                Type='Order',Supported_Product__c='ADIRS',Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance',
                Origin='Email',Emailbox_Origin__c='Email-Order Status',PreventCloseonupdate__c = 4.00 );
                insert cases4;

                cases4.PreventCloseonupdate__c = 2.00;
                Update cases4;
                
            }   
        Test.stopTest();

    }
    static testmethod void CasePreventCreationTest4()
    {    
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = [Select id,Name,Email from User where id =: label.aero_default_user_id]; 
       
        Account acc2= new Account(name='Test1 Account',Strategic_Business_Unit__c='D&S',Concierge__c =false,Type='Owner/Operator',Region_Name__c='Asia Pacific/Rim' );
        insert acc2;

        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc2.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Primary_Email_Address__c='test@nttdata.com');
        insert cont;
        
        Test.startTest();       
           
            System.runas(usr){
                Case cases4=new Case(AccountId=acc2.id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',Subject ='Test case3',
                //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
                Type='Order',Supported_Product__c='ADIRS',Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance',
                Origin='Email',Emailbox_Origin__c='Email-Quotes',PreventCloseonupdate__c = 4.00);
                insert cases4;

                cases4.PreventCloseonupdate__c = 2.00;
                Update cases4;
                
            }   
        Test.stopTest();

    }
    static testmethod void CasePreventCreationTest5()
    {    
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = [Select id,Name,Email from User where id =: label.aero_default_user_id]; 
        datetime myDateTime = datetime.now();
        
        DateTime newDateTime = myDateTime.adddays(-11);       

        Account acc1= new Account(name='Test1 Account',Strategic_Business_Unit__c='ATR',Concierge__c =False,Type='Owner/Operator',Region_Name__c='Asia Pacific/Rim');
        insert acc1;
        
       
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc1.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Primary_Email_Address__c='test@nttdata.com');
        insert cont;
        
        Test.startTest();       
           
            System.runas(usr){
                Case cases4=new Case(AccountId=acc1.id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',Subject ='Test case3',
                //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
                Type='Order',Supported_Product__c='ADIRS',Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance',
                Origin='Email',Emailbox_Origin__c='Email-Quotes',PreventCloseonupdate__c = 4.00);
                insert cases4;

                cases4.PreventCloseonupdate__c = 2.00;
                Update cases4;
               
            }   
        Test.stopTest();

    }
    static testmethod void CasePreventCreationTest6()
    {    
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = [Select id,Name,Email from User where id =: label.aero_default_user_id]; 

        Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='BGA',Concierge__c =False,Type='OEM',Do_Not_Send_to_Portal__c=false );
        insert acc;        

        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Primary_Email_Address__c='test@nttdata.com');
        insert cont;
        
        Test.startTest();       
           
            System.runas(usr){
                Case cases4=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',Subject ='Test case3',
                //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
                Type='Order',Supported_Product__c='ADIRS',Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance',
                Origin='Email',Emailbox_Origin__c='Email-Quotes',PreventCloseonupdate__c = 4.00 );
                insert cases4;

                cases4.PreventCloseonupdate__c = 2.00;
                Update cases4;
                
            }   
        Test.stopTest();

    }
    static testmethod void CasePreventCreationTest7()
    {    
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = [Select id,Name,Email from User where id =: label.aero_default_user_id]; 
        datetime myDateTime = datetime.now();
        
        DateTime newDateTime = myDateTime.adddays(15);       

        Account acc1= new Account(name='Test1 Account',Strategic_Business_Unit__c='ATR',Concierge__c =False,Type='Owner/Operator',Region_Name__c='Asia Pacific/Rim',Quotes_Do_Not_Send_to_Portal__c=false);
        insert acc1;
        
       
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc1.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Primary_Email_Address__c='test@nttdata.com');
        insert cont;
        
        Test.startTest();       
           
            System.runas(usr){
                Case cases4=new Case(AccountId=acc1.id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',Subject ='Test case3',
                //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
                Type='Order',Supported_Product__c='ADIRS',Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance',
                Origin='Email',Emailbox_Origin__c='Email-Quotes',PreventCloseonupdate__c = 4.00);
                insert cases4;

                cases4.PreventCloseonupdate__c = 2.00;
                Update cases4;
               
            }   
        Test.stopTest();

    }
    static testmethod void CasePreventCreationTest8()
    {    
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = [Select id,Name,Email from User where id =: label.aero_default_user_id]; 
        datetime myDateTime = datetime.now();
        
        DateTime newDateTime = myDateTime.adddays(-15);       

        Account acc1= new Account(name='Test1 Account',Strategic_Business_Unit__c='ATR',Concierge__c =False,Type='Owner/Operator',Region_Name__c='Asia Pacific/Rim');
        insert acc1;
        
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc1.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Primary_Email_Address__c='test@nttdata.com');
        insert cont;
        
        Test.startTest();       
           
            System.runas(usr){
                Case cases4=new Case(AccountId=acc1.id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',Subject ='Test case3',
                //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
                Type='Order',Supported_Product__c='ADIRS',Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance',
                Origin='Email',Emailbox_Origin__c='Email-Quotes',PreventCloseonupdate__c = 4.00);
                insert cases4;

                cases4.PreventCloseonupdate__c = 2.00;
                Update cases4;
               
            }   
        Test.stopTest();

    }
    static testmethod void CasePreventCreationTest9()
    {    
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = [Select id,Name,Email from User where id =: label.aero_default_user_id]; 

        Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='BGA',Concierge__c =False,Type='OEM' );
        insert acc;


        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495', Phone_Tree_Extn__c='1234',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Primary_Email_Address__c='test@nttdata.com');
        insert cont;
        
        Test.startTest();       
            System.runas(usr){
                Case cases1=new Case(AccountId=acc.Id,ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',Subject ='Test case1',
                //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
                Type='Order',Supported_Product__c='ADIRS',Catalog_Product_Group__c='Cabin(SV)',Product_Type__c='Electrical',Sub_Class__c='Contracts',Detail_Class__c='Bench Assistance',
                Emailbox_Origin__c='Email-CSO BGA Spares',PreventCloseonupdate__c = 0.00);
                insert cases1;
                
                cases1.PreventCloseonupdate__c = 0.00;
                Update cases1;
            }              
             
        Test.stopTest();

    }
 }