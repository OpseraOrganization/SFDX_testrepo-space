@isTest
    class Test_CaseHelperClass{        
        static testMethod void testMethod1() {
        test.startTest();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        
        insert acc;
        //Id rt= [select id,name from recordtype where sobjecttype='Case' and name='Orders'].id;
        Contact con = new Contact();
        con.LastName = 'Kulkarni';
        con.FirstName = 'Shrivaths';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'shrivaths.kulkarni@nttdata.com';
        con.Email='shrivaths.kulkarni@nttdata.com';
        insert con;
        
        
        Case cseLow = new Case();
        cseLow.Origin = 'Email-EMS-Norcross';
        //cseLow.Status = 'New';
        cseLow.RecordTypeId = Label.EMS_Orders_RecordType_ID;
       // cseLow.Classification__c = 'MyGDC';
        cseLow.ContactId = con.Id;
        cseLow.Type_of_Change__c = 'New Account';
        cseLow.Type = 'Other';
        cseLow.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cseLow.Government_Compliance_SM_M_Content__c = 'NO';  
        cseLow.OwnerId=label.aero_default_user_id;
        insert cseLow;        
        test.stopTest(); 
    }  
    static testMethod void testMethod2() {
        test.startTest();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        
        insert acc;
       // Id rt= [select id,name from recordtype where sobjecttype='Case' and name='Orders'].id;
        Contact con = new Contact();
        con.LastName = 'Kulkarni';
        con.FirstName = 'Shrivaths';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'shrivaths.kulkarni@nttdata.com';
        con.Email='shrivaths.kulkarni@nttdata.com';
        insert con;
        
        
        Case cseLow = new Case();
        cseLow.Origin = 'Email-EMS-Norcross';
        cseLow.OwnerId = Label.aero_default_user_id;
        //cseLow.Status = 'New';
        cseLow.RecordTypeId = Label.EMS_Orders_RecordType_ID;
       // cseLow.Classification__c = 'MyGDC';
        cseLow.ContactId = con.Id;
        cseLow.Type_of_Change__c = 'New Account';
        cseLow.Type = 'Other';
        cseLow.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cseLow.Government_Compliance_SM_M_Content__c = 'NO';         
        insert cseLow;        
        
        //cseLow.OwnerId = Label.Norcross_CSR_Queue_ID;
        cseLow.OwnerId=label.aero_default_user_id;
        Update cseLow;
        test.stopTest(); 
    }  
    
    /*static testMethod void testMethod3() 
    {
        test.startTest();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        
        insert acc;
       // Id rt= [select id,name from recordtype where sobjecttype='Case' and name='Orders'].id;
        Contact con = new Contact();
        con.LastName = 'Kulkarni';
        con.FirstName = 'Shrivaths';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'shrivaths.kulkarni@nttdata.com';
        con.Email='shrivaths.kulkarni@nttdata.com';
        insert con;
        
        
        Case cseLow = new Case();
        cseLow.Origin = 'Email-Orders';
        //cseLow.Status = 'New';
       // cseLow.RecordTypeId = rt;
        cseLow.Classification__c = 'MyGDC';
        cseLow.ContactId = con.Id;
        cseLow.Type_of_Change__c = 'New Account';
        cseLow.Type = 'Other';
        cseLow.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cseLow.Government_Compliance_SM_M_Content__c = 'NO';
         
        insert cseLow;
        
        cseLow.OwnerId = Label.Norcross_CSR_Queue_ID;
        update cseLow;
        
        test.stopTest(); 
    }  */
    static testMethod void testMethod4() 
    {
        test.startTest();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        
        insert acc;
       // Id rt= [select id,name from recordtype where sobjecttype='Case' and name='Orders'].id;
        Contact con = new Contact();
        con.LastName = 'Kulkarni';
        con.FirstName = 'Shrivaths';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'shrivaths.kulkarni@nttdata.com';
        con.Email='shrivaths.kulkarni@nttdata.com';
        insert con;
         list <string> origin = new list<string>{'Web-Pilots Corner Avionics','Web-Pilots Corner Avionics',
         'Email-Pilots Corner Avionics','Email-BGAOEMQuoteOrders','Email-AeroBoeing','Email-AeroAirbus',
         'Email-AeroComponents','Email-ROEMEAIAvionics','Email-ROEMEAIMechanical','Email-Spex Order',
         'Email-Hana','Email-Tyrone','Email-Barbora', 'Email-Jaime.bundy.aero','Email-Lori.nelton.aero',
          'Email-joseph.reyes.aero','Email-linda.alejandro.aero','Email-Will.Somphonphackdy.aero',
           'Email-zaymarie.ortiz.aero','Email-reanata.tresohlava.aero','Email-martin.jezek.aero','Email-robert.balmer.aero',
            'Email-katerina.balharova.aero','Email-petra.sebkova.aero','Email-laurentiu.creanga.aero','Email-linda.kodrazi.aero',
             'Email-jaroslav.drbout.aero','Email-jana.rakociova.aero','Email-nada.buresova.aero','Email-ivan.majzlik.aero',
              'Email-marcela.kostalova.aero', 'Email-michaela.adamova.aero','Email-marek.kazimir.aero','Email-michaela.koberova.aero',
               'Email-lukas.kapoun.aero','Email-cristina.sanchez.aero','Email-ludmila.rejzkova.aero','Email-barbora.podhradska.aero',
                'Email-lucia.mizenkova.aero', 'Email-kevin.dean2.aero', 'Email-Slavomir.jurica.aero', 'Email-Lesley.justiniano.aero'};

           
         list <case> clist = new list<case>();
         for(string s:origin){
        Case cseLow = new Case();
        cseLow.Origin = s;
        //cseLow.Status = 'New';
       // cseLow.RecordTypeId = rt;
        cseLow.Classification__c = 'MyGDC';
        cseLow.ContactId = con.Id;
        cseLow.Type_of_Change__c = 'New Account';
        cseLow.Type = 'Other';
        cseLow.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cseLow.Government_Compliance_SM_M_Content__c = 'NO';
         clist.add(cselow);}
        //insert clist;
        
        test.stopTest(); 
    }

}