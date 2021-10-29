@isTest(seeAllData = false)
public  class creatingportaluser_test{
    static testmethod void testcreatingportaluser(){
        
        //creating account;
        test.starttest();
        Account acc= new Account(name='Test Account',Market_name__C='Military');
        insert acc;
        
        //creating contact;
        List<Contact> contactList = new List<Contact>();
        Contact cont=new Contact(firstname='Test',LastName='Con',AccountId=acc.Id,Phone_3__c='9986502495',
                                 Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123568',Honeywell_ID__c='01499xxx40331',EMAIL='aldcv.sfwv@vfv.com',CBT__c = 'TEST',CBT_Team__c = 'test1');
        Contact cont3=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
                                  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123566',Honeywell_ID__c='01499xxx40334',EMAIL='aldcv.sfmv@vfv.com',CBT__c = 'TEST',CBT_Team__c = 'test1');
        Contact cont1=new Contact(firstname='Test',LastName='Contact1',AccountId=acc.Id,Phone_3__c='9986502495',
                                  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Honeywell_ID__c='01499xxx40332',EMAIL='aldcv.sfwy@vfv.com',CBT__c = 'TEST',CBT_Team__c = 'test1');
        Contact cont2=new Contact(firstname='Test',LastName='Contact2',AccountId=acc.Id,Phone_3__c='9986502495',
                                  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123569',Honeywell_ID__c='01499xxx40333',EMAIL='aldcv.sfww@vfv.com',CBT__c = 'TEST',CBT_Team__c = 'test1');
        contactList.add(cont);
        contactList.add(cont1);
        contactList.add(cont2);
        contactList.add(cont3);
        
        insert contactList;
        
        
        
        List<Contact_Tool_Access__c> conList = new List<Contact_Tool_Access__c>();
        Contact_Tool_Access__c tool=new Contact_Tool_Access__c(name='Honeywell Training',CRM_Contact_ID__c=cont.id,Request_Status__c='Approved',Portal_Honeywell_ID__c = 'E812402');
        //Contact_Tool_Access__c tool3=new Contact_Tool_Access__c(name='Honeywell Training',CRM_Contact_ID__c=cont3.id,Request_Status__c='Denied',Portal_Honeywell_ID__c = 'E812402');
        Contact_Tool_Access__c tool1=new Contact_Tool_Access__c(name='Honeywell Training',CRM_Contact_ID__c=cont1.id,Request_Status__c='Denied',Portal_Honeywell_ID__c = 'E812402');
        // Contact_Tool_Access__c tool22=new Contact_Tool_Access__c(name='Technical Knowledge Center',CRM_Contact_ID__c=cont2.id,Request_Status__c='Approved',Portal_Honeywell_ID__c = 'E812402'); 
        //Contact_Tool_Access__c tool23=new Contact_Tool_Access__c(name='Technical Knowledge Center',CRM_Contact_ID__c=cont2.id,Request_Status__c='Denied',Portal_Honeywell_ID__c = 'E812403'); 
        //conList.add(tool23);
        conList.add(tool);
        conList.add(tool1);
        //conList.add(tool22);
        //conList.add(tool3);
        insert conList;
        Case cases=new Case(AccountId=acc.Id,subject='MyAerospace Registration Request – Honeywell Training',ContactId=cont.Id,Resolution__c='test',Sub_Class__c='kgk',status='Denied',Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
                            //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
                            Type='Order');
        insert cases;
        cases.Resolution__c='None';
        cases.status='Approved';
        cases.Sub_Class__c='';
        cases.Export_Compliance_Content_ITAR_EAR__c='No';
        cases.Government_Compliance_SM_M_Content__c='No';
        update cases; 
        

















        //update
        Contact_Tool_Access__c tool2=new Contact_Tool_Access__c(Id=tool1.Id,name='Honeywell Training',CRM_Contact_ID__c=cont1.id,Request_Status__c='Denied',Portal_Honeywell_ID__c = 'E812402');
        update tool2;
        Contact_Tool_Access__c tool24=[select Id from Contact_Tool_Access__c where Request_Status__c='Approved' limit 1];
        update tool24;
        //Case cases12=new Case(Id = cases1.Id,AccountId=acc.Id,subject='MyAerospace Registration Request – Honeywell Training',ContactId=cont1.Id,Resolution__c='None',Sub_Class__c='hvgj',status='Denied',Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
                              //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
                              //Type='Order');
        //update cases12;
        //delete
        delete tool2;
        test.stoptest();
    }
    
     static testmethod void testcreatingportaluser1(){
        test.starttest();
        Account acc1= new Account(name='Test Account',Market_name__C='Military');
        insert acc1;
        Contact cont3=new Contact(firstname='Test2',LastName='Contact2',AccountId=acc1.Id,Phone_3__c='9986502495',
                                  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Honeywell_ID__c='01499xxx40331',EMAIL='aldcv.sfwv@vfv.com');
        insert cont3;
        contact c=[select id,LastName from contact where LastName='Contact2' limit 1];
        set<id> strList = new set<id>();
        strList.add(c.Id);
        contactToolAccessTriggerHelperClass.AfterDelete(strList);
        test.stoptest();
    }
    static testmethod void testcreatingportaluser2(){
        test.starttest();
        Account acc1= new Account(name='Test Account',Market_name__C='Military');
        insert acc1;
        Contact cont3=new Contact(firstname='Test2',LastName='Contact2',AccountId=acc1.Id,Phone_3__c='9986502495',
                                  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Honeywell_ID__c='01499xxx40331',EMAIL='aldcv.sfwv@vfv.com');
        insert cont3;
        contact c=[select id,firstname,LastName from contact where LastName='Contact2' limit 1];
        set<id> strList = new set<id>();
        strList.add(c.Id);
        system.assertEquals('Test2', c.firstname);
        contactToolAccessTriggerHelperClass.AfterUpdate(strList);
        test.stoptest();
    }
    //usertriggerhelperclass test class start
    static testmethod void testcreatingportaluser3(){
        test.starttest();
        Account acc1= new Account(name='Test Account',Market_name__C='Military');
        insert acc1;
        Contact cont3=new Contact(firstname='Test2',LastName='Contact2',AccountId=acc1.Id,Phone_3__c='9986502495',
                                  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Honeywell_ID__c='01499xxx40331',EMAIL='aldcv.sfwv@vfv.com');
        insert cont3;
        Contact_Tool_Access__c tool=new Contact_Tool_Access__c(name='Honeywell Training',CRM_Contact_ID__c=cont3.id,Request_Status__c='Approved',Portal_Honeywell_ID__c = 'E812402');
        insert tool;
        contact c=[select id,firstname,LastName from contact where LastName='Contact2' limit 1];
        set<id> strList = new set<id>();  
        strList.add(c.id);
        //system.assert(!c.isEmpty());
        system.assertEquals('Test2', c.firstname);
        userTriggerHelperClass.AfterUpsert(strList);
        test.stoptest();
    }
}