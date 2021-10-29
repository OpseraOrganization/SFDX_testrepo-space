@isTest(seealldata=true)
global class CaseClassForPublicMethodsTest {
    testMethod static void TestCaseMethod() {
        Profile ProfRec = [select name,id from Profile where name = 'System Administrator' limit 1];
        User userRec = [select id from user where ProfileId = :ProfRec.Id and isActive=true limit 1];
        
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678'           
        );
        caselist.add(cs);
        insert caselist; 
        Map<ID,Case> oldMap = new Map<ID,Case>();
        oldMap.put(cs.id,cs);
        
        Test.startTest();
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        //csmethod.UpdateOppProposalCase(caselist,oldMap);
        Test.stopTest();   
    }
    
    /*testMethod static void ACSMSendCaseEmailMethodTest() {
        //Profile ProfRec = [select id,name from Profile where id = '0051300000BwOLSAA3'];
        //User userRec = [select id from user where ProfileId = :ProfRec.Id and isActive=true limit 1];
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        //system.runAs(userRec) {
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=Label.FSS_Tech_Issue_RT_ID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678',
            Emailbox_Origin__c='Email-FSS Tech Support'
            
        );
        caselist.add(cs);
        insert cs; 
        Map<ID,Case> oldMap = new Map<ID,Case>();
        oldMap.put(cs.id,cs);
        Test.startTest();
        TriggerCheck.ACSMMailsend = true;
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        csmethod.ACSMSendCaseEmailMethod(caselist,oldMap,'update');
        Test.stopTest(); 
        //}  
    }
    */
    testMethod static void sendCaseEmailMethodTest() {
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'CPS BGA Process',
            VN_Name__c =cont.Id,
            RecordtypeId=Label.CaseRecordTypeId_General,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678',
            Status = 'On Hold'
        );
        caselist.add(cs);
        
        Case cs1 = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'AEROEBIZSUPPORT-WINGMAN',
            VN_Name__c =cont.Id,
            RecordtypeId=label.AerobizRecType,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678',
            NSN__c = 'Test long',
            Part_Number__c = '12334',
            Emailbox_Origin__c='Email-AVSAT Orders'
        );
        caselist.add(cs1);
        
        Case cs2 = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'CPS BGA Process',
            VN_Name__c =cont.Id,
            RecordtypeId=Label.CaseRecordTypeId_General,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678',
            Status = 'On Hold',
            NSN__c = '',
            Part_Number__c = ''
        );
        caselist.add(cs2);
        Map<ID,Case> oldMap = new Map<ID,Case>();
        oldMap.put(cs.id,cs);
        Test.startTest();
        TriggerCheck.ACSMMailsend = true;
        AircraftNotificationsTriggerStopper.hasalreadyExecutedPPO();
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        // csmethod.sendCaseEmailMethod(caselist,oldMap,'update');
        
        Test.stopTest();   
    }
    testMethod static void RnOCaseOwnerAssignOnCreationMethodTest() {
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678'
        );
        caselist.add(cs);
        insert cs; 
        Map<ID,Case> oldMap = new Map<ID,Case>();
        oldMap.put(cs.id,cs);
        Test.startTest();
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        //csmethod.RnOCaseOwnerAssignOnCreationMethod(caselist,oldMap,'insert');
        TriggerInactive.AvoidRecursionCase=true;
        Test.stopTest();   
    }
    testMethod static void AOGAlertTest() {
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678'
        );
        caselist.add(cs);
        insert cs; 
        string grpname = 'airbus';
        Map<String,list<Case>> oldMap = new Map<String,list<Case>>();
        oldMap.put(grpname,caselist);
        Test.startTest();
        if(oldMap.containskey('airbus')) {
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        //csmethod.AOGAlert(oldMap);
        }
        Test.stopTest();   
    }
    testMethod static void AOGAlertTest1() {
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678'
        );
        caselist.add(cs);
        insert cs; 
        string grpname = 'Boeing';
        Map<String,list<Case>> oldMap = new Map<String,list<Case>>();
        oldMap.put(grpname,caselist);
        Test.startTest();
        if(oldMap.containskey('Boeing')) {
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        //csmethod.AOGAlert(oldMap);
        }
        Test.stopTest();   
    }
    testMethod static void AOGAlertTest2() {
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678'
        );
        caselist.add(cs);
        insert cs; 
        string grpname = 'Bombardier ATR';
        Map<String,list<Case>> oldMap = new Map<String,list<Case>>();
        oldMap.put(grpname,caselist);
        Test.startTest();
        if(oldMap.containskey('Bombardier ATR')) {
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        //csmethod.AOGAlert(oldMap);
        }
        Test.stopTest();   
    }
    testMethod static void AOGAlertTest3() {
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678'
        );
        caselist.add(cs);
        insert cs; 
        string grpname = 'Airlines';
        Map<String,list<Case>> oldMap = new Map<String,list<Case>>();
        oldMap.put(grpname,caselist);
        Test.startTest();
        if(oldMap.containskey('Airlines')) {
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        //csmethod.AOGAlert(oldMap);
        }
        Test.stopTest();   
    }
    testMethod static void AOGAlertTest4() {
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678'
        );
        caselist.add(cs);
        insert cs; 
        string grpname = 'Helicopter';
        Map<String,list<Case>> oldMap = new Map<String,list<Case>>();
        oldMap.put(grpname,caselist);
        Test.startTest();
        if(oldMap.containskey('Helicopter')) {
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        //csmethod.AOGAlert(oldMap);
        }
        Test.stopTest();   
    }
    testMethod static void AOGAlertTest5() {
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678'
        );
        caselist.add(cs);
        insert cs; 
        string grpname = 'Gulfstream';
        Map<String,list<Case>> oldMap = new Map<String,list<Case>>();
        oldMap.put(grpname,caselist);
        Test.startTest();
        if(oldMap.containskey('Gulfstream')) {
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        //csmethod.AOGAlert(oldMap);
        }
        Test.stopTest();   
    }
    testMethod static void AOGAlertTest6() {
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678'
        );
        caselist.add(cs);
        insert cs; 
        string grpname = 'Dassault';
        Map<String,list<Case>> oldMap = new Map<String,list<Case>>();
        oldMap.put(grpname,caselist);
        Test.startTest();
        if(oldMap.containskey('Dassault')) {
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        //csmethod.AOGAlert(oldMap);
        }
        Test.stopTest();   
    }
    testMethod static void AOGAlertTest7() {
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678'
        );
        caselist.add(cs);
        insert cs; 
        string grpname = 'Pilatus';
        Map<String,list<Case>> oldMap = new Map<String,list<Case>>();
        oldMap.put(grpname,caselist);
        Test.startTest();
        if(oldMap.containskey('Pilatus')) {
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        //csmethod.AOGAlert(oldMap);
        }
        Test.stopTest();   
    }
    testMethod static void AOGAlertTest8() {
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678'
        );
        caselist.add(cs);
        insert cs; 
        string grpname = 'BombardierBGA';
        Map<String,list<Case>> oldMap = new Map<String,list<Case>>();
        oldMap.put(grpname,caselist);
        Test.startTest();
        if(oldMap.containskey('BombardierBGA')) {
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        //csmethod.AOGAlert(oldMap);
        }
        Test.stopTest();   
    }
    testMethod static void AOGAlertTest9() {
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678'
        );
        caselist.add(cs);
        insert cs; 
        string grpname = 'Hawker';
        Map<String,list<Case>> oldMap = new Map<String,list<Case>>();
        oldMap.put(grpname,caselist);
        Test.startTest();
        if(oldMap.containskey('Hawker')) {
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        //csmethod.AOGAlert(oldMap);
        }
        Test.stopTest();   
    }
    testMethod static void AOGAlertTest10() {
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678'
        );
        caselist.add(cs);
        insert cs; 
        string grpname = 'Cessna';
        Map<String,list<Case>> oldMap = new Map<String,list<Case>>();
        oldMap.put(grpname,caselist);
        Test.startTest();
        if(oldMap.containskey('Cessna')) {
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        //csmethod.AOGAlert(oldMap);
        }
        Test.stopTest();   
    }
    testMethod static void AOGAlertTest11() {
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678'
        );
        caselist.add(cs);
        insert cs; 
        string grpname = 'Embraer BGA';
        Map<String,list<Case>> oldMap = new Map<String,list<Case>>();
        oldMap.put(grpname,caselist);
        Test.startTest();
        if(oldMap.containskey('Embraer BGA')) {
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        //csmethod.AOGAlert(oldMap);
        }
        Test.stopTest();   
    }
    testMethod static void AOGAlertTest12() {
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678'
        );
        caselist.add(cs);
        insert cs; 
        string grpname = 'Embraer ATR';
        Map<String,list<Case>> oldMap = new Map<String,list<Case>>();
        oldMap.put(grpname,caselist);
        Test.startTest();
        if(oldMap.containskey('Embraer ATR')) {
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        ///csmethod.AOGAlert(oldMap);
        }
        Test.stopTest();   
    }
    testMethod static void AOGAlertTest13() {
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678',
            Detail_Class__c = 'AOG - IFSD Uncommanded'
        );
        caselist.add(cs);
        insert cs; 
        string grpname = 'Components';
        Map<String,list<Case>> oldMap = new Map<String,list<Case>>();
        oldMap.put(grpname,caselist);
        Test.startTest();
        if(oldMap.containskey('Components')) {
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        //csmethod.AOGAlert(oldMap);
        }
        Test.stopTest();   
    }
    testMethod static void AOGAlertTest14() {
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.QuotesRecordID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678',
            Detail_Class__c = 'AOG - IFSD Commanded'
        );
        caselist.add(cs);
        insert cs; 
        string grpname = 'Miscellaneous';
        Map<String,list<Case>> oldMap = new Map<String,list<Case>>();
        oldMap.put(grpname,caselist);
        Test.startTest();
        if(oldMap.containskey('Miscellaneous')) {
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        //csmethod.AOGAlert(oldMap);
        }
        Test.stopTest();   
    }
    testMethod static void setCaseDetailsTest() {
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        Platform__c pl = new Platform__c();
        pl.name = 'Boeing';
        insert pl;
        
        Map<String,R_O_Case_Reassignment_Queue__c> mapROQ = new Map<String,R_O_Case_Reassignment_Queue__c> ();
        Map<Id,String> mapGroupQName = new Map<ID, String>(); 
        String queueid = '01pa0000001FFvIAAW';
        R_O_Case_Reassignment_Queue__c ro = new R_O_Case_Reassignment_Queue__c();
        ro.Name = 'Test RO queue';
        ro.QueueId__c = '00Ga0000002svi9EAA';
        insert ro;
        mapGroupQName.put(ro.id,queueid);
        mapROQ.put(queueid,ro);
        Case cs1 = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'CPS BGA Process',
            VN_Name__c =cont.Id,
            RecordtypeId=label.CaseRecordTypeId_General,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678',
            NSN__c = 'Test long',
            Part_Number__c = '12334',
            Aircraft_Type__c = pl.id
        );
        insert cs1;
        
        Test.startTest();
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        //csmethod.setCaseDetails(queueid,cs1);
        Test.stopTest();   
    }
    testMethod static void sendAOGAlertMethodTest() {
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        
        Platform__c pl = new Platform__c();
        pl.name = 'Boeing';
        insert pl;
        
        Supported_Products__c sp = new Supported_Products__c();
        sp.name = 'Airbus';
        insert sp;
        
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.TechnicalIssue_RecordTypeID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678',
            aog__c= true,
            Expected_Update__c = system.now(),
            Resolution__c = null,
            Aircraft_Type__c = pl.id
        );
        caselist.add(cs);
        insert caselist;
        Map<ID,Case> oldMap = new Map<ID,Case>();
        if(caselist.size() >0) {
        oldMap.put(caselist[0].id,caselist[0]);
        }
        caselist[0].Resolution__c = 'Test';
        //update caselist[0];
        
        Map<ID,Case> NewMap = new Map<ID,Case>();
        if(caselist.size() >0) {
        NewMap.put(caselist[0].id,caselist[0]);
        }
        
        map<id,string> mapCaseIdACTname = new map<id,string>(); 
        string ab = 'Airbus';
        mapCaseIdACTname.put(caselist[0].id,ab);
        Test.startTest();
        if(caselist != null && oldMap !=null) {
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        //csmethod.sendAOGAlertMethod(caselist,oldMap,'update',NewMap);
        }
        Test.stopTest();   
    }
    testMethod static void sendAOGAlertMethodTest1() {
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        
        Platform__c pl = new Platform__c();
        pl.name = 'Boeing';
        insert pl;
        
        Supported_Products__c sp = new Supported_Products__c();
        sp.name = 'Boeing';
        insert sp;
        
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.TechnicalIssue_RecordTypeID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678',
            aog__c= true,
            Expected_Update__c = system.now(),
            Resolution__c = null,
            Aircraft_Type__c = pl.id
        );
        caselist.add(cs);
        insert caselist;
        Map<ID,Case> oldMap = new Map<ID,Case>();
        if(caselist.size() >0) {
        oldMap.put(caselist[0].id,caselist[0]);
        }
        caselist[0].Resolution__c = 'Test';
        // update caselist[0];
        
        Map<ID,Case> NewMap = new Map<ID,Case>();
        if(caselist.size() >0) {
        NewMap.put(caselist[0].id,caselist[0]);
        }
        
        map<id,string> mapCaseIdACTname = new map<id,string>(); 
        string ab = 'Airbus';
        mapCaseIdACTname.put(caselist[0].id,ab);
        Test.startTest();
        if(caselist != null && oldMap !=null) {
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        //csmethod.sendAOGAlertMethod(caselist,oldMap,'update',NewMap);
        }
        Test.stopTest();   
    }
   /*testMethod static void SendAOGAlertTest() {
        //creating sccount
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont;
        
        Platform__c pl = new Platform__c();
        pl.name = 'Boeing';
        insert pl;
        
        Supported_Products__c sp = new Supported_Products__c();
        sp.name = 'Boeing';
        insert sp;
        
        list<case> caselist = new list<case>();   
        Case cs = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            Type = 'Quote',
            VN_Name__c =cont.Id,
            RecordtypeId=label.TechnicalIssue_RecordTypeID,
            Customer_PO_RO_WONumber__c ='p0123',
            Sales_Order_Number__c ='12345678',
            Detail_Class__c = 'AOG - IFSD Commanded',
            Resolution__c = '',
            Aircraft_Type__c = pl.id,
            Supported_Products__c =sp.id
        );
        caselist.add(cs);
        insert caselist; 
        
        caselist[0].Resolution__c ='Test Resolution';
        update caselist;
        
        Test.startTest();
        CaseClassForPublicMethods csmethod = new CaseClassForPublicMethods();
        
        Test.stopTest();   
    }*/
}