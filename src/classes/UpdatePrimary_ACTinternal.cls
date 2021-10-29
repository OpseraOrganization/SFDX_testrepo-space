/** * File Name: UpdatePrimary_ACTinternal
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private  class UpdatePrimary_ACTinternal{
    static testmethod void testUpdatePrimary(){

        //creating account;
        Account acc= new Account(name='Test Account');
        insert acc;
     
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E000006' );
        insert cont;


        Skills2__c skill= new Skills2__c (Primary_Secondary__c='Primary' ,Supported_Product__c='Radio',   Contact__c=cont.Id);
        insert skill;

        Test.startTest();
        List<Case> caslist = new List<Case>();
        Case cases19=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-ACTinternal');
        //insert cases19; 
        caslist.add(cases19);
        
        // Test class code for UpdatePrimary_AEROGCC
        Case cases16=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-AEROGCC');
        //insert cases16; 
        caslist.add(cases16);
        
        // Test class code for UpdatePrimary_ApexClass1
        Case cases5=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin ='Email-CPSQuotesCOE');
        //insert cases5;
        caslist.add(cases5);
        
        // Test class code for UpdatePrimary_ApexClass
        Case cases=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin ='Email-ISSweb');
        //insert cases;
        caslist.add(cases);
        
        // Test class code for UpdatePrimary_ApexClass10
        Case cases27=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-crc-spex');
        //insert cases27; 
        caslist.add(cases27);
        
        // Test class code for UpdatePrimary_ApexClass10a
        Case cases28=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-crc-Toronto');
        //insert cases28; 
        caslist.add(cases28);
        
        // Test class code for UpdatePrimary_ApexClass11
        Case cases29=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-deferredordersweb');
        //insert cases29; 
        caslist.add(cases29);
        
        // Test class code for UpdatePrimary_ApexClass11a
        Case cases30=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-EMEAACTInternal');
        //insert cases30;  
        caslist.add(cases30);
        
        // Test class code for UpdatePrimary_ApexClass11b
        Case cases31=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-gcc-als');
        //insert cases31;  
        caslist.add(cases31);
        
        // Test class code for UpdatePrimary_ApexClass12
        Case cases32=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-HW-Flame-Sensors');
        //insert cases32;
        caslist.add(cases32);
        
        // Test class code for UpdatePrimary_ApexClass12a
        Case cases34=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-Orders');
        //insert cases34;
        caslist.add(cases34);
        
        // Test class code for UpdatePrimary_ApexClass13
        Case cases35=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-Order Status');
        //insert cases35;
        caslist.add(cases35);
        
        // Test class code for UpdatePrimary_ApexClass13A
        Case cases37=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin =  'Email-QuotesWeb');
        //insert cases37;
        caslist.add(cases37);
        
        // Test class code for UpdatePrimary_ApexClass14
        Case cases39=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-SPEX_EMEA');
        //insert cases39;
        caslist.add(cases39);
        
        // Test class code for UpdatePrimary_ApexClass14a
        Case cases40=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-WebSupport');
        //insert cases40;
        caslist.add(cases40);
        
        // Test class code for UpdatePrimary_ApexClass15
        Case cases42=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
       //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
         Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-Aerotechsupport');
        //insert cases42; 
        caslist.add(cases42);
        
        // Test class code for UpdatePrimary_ApexClass16
        Case casesFAX=new Case(AccountId=acc.Id,subject='has sent ',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-CPSQuotesCOE');
        //insert casesFAX; 
        caslist.add(casesFAX);
        
        // Test class code for UpdatePrimary_ApexClass17
        Case cases15=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-MyAerospacePortalIssue');
        //insert cases15;  
        caslist.add(cases15);
        Case casesFAX1=new Case(AccountId=acc.Id,subject='has sent ',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-RSAeroQuoteQuality');
        //insert casesFAX;
        caslist.add(casesFAX1);
        
        // Test class code for UpdatePrimary_ApexClass1A 
        Case cases3=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        Type='Order',
        Supported_Product__c='Radio',Origin ='Email-Anniston.RFQ');
        //insert cases3;
        caslist.add(cases3);
        
        // Test class code for UpdatePrimary_ApexClass1_EmailAOG  
        Case cases4=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        Type='Order',
        Supported_Product__c='Radio',Origin ='Email-AOG');
        //insert cases4;
        caslist.add(cases4);
        
        // Test class code for UpdatePrimary_ApexClass2  
        Case cases6=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        Type='Order',
        Supported_Product__c='Radio',Origin ='Email-CPSQuotesCOEANNTMPTUC');
        //insert cases6;
        caslist.add(cases6);
        
        // Test class code for UpdatePrimary_ApexClass2A   
        Case cases7=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        Type='Order',
        Supported_Product__c='Radio',Origin ='Email-CPSQuotesCOEDVCR');
        //insert cases7;
        caslist.add(cases7);
        
        // Test class code for UpdatePrimary_ApexClass3    
        Case cases9=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        Type='Order',
        Supported_Product__c='Radio',Origin ='Email-bga-orders');
        //insert cases9;
        caslist.add(cases9);
        
        // Test class code for UpdatePrimary_ApexClass3A    
        Case cases10=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        Type='Order',
        Supported_Product__c='Radio',Origin ='Email-bga-orders');
        //insert cases10;
        caslist.add(cases10);
        
        // Test class code for UpdatePrimary_ApexClass4   
        Case cases14=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        Type='Order',
        //Supported_Product__c='Radio',Origin ='Email-GBS-AES-Repair'); -- Commented for INC000006656211
        Supported_Product__c='Radio',Origin ='Email-R&O Avionics');
        //insert cases14;
        caslist.add(cases14);
        
        // Test class code for UpdatePrimary_ApexClass4A
        Case cases141=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        Type='Order',
        //Supported_Product__c='Radio',Origin ='Email-GBS-AES-Repair'); -- Commented for INC000006656211
        Supported_Product__c='Radio',Origin ='Email-R&O Avionics');
        //insert cases141;
        caslist.add(cases141);
        
        // Test class code for UpdatePrimary_ApexClass5
        Case cases2=new Case(AccountId=acc.Id,subject='test data1',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-BGLRACTInternal');
        //insert cases2; 
        caslist.add(cases2);
        
        // Test class code for UpdatePrimary_ApexClass6
        Case cases151=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-GCCOEM');
        //insert cases15; 
        caslist.add(cases151);
        
        
        Test.stopTest();
    }
    
    static testmethod void testUpdatePrimary1(){

        //creating account;
        Account acc= new Account(name='Test Account');
        insert acc;
     
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E000006' );
        insert cont;


        Skills2__c skill= new Skills2__c (Primary_Secondary__c='Primary' ,Supported_Product__c='Radio',   Contact__c=cont.Id);
        insert skill;

        Test.startTest();
        List<Case> caslist = new List<Case>();
    
           // Test class code for UpdatePrimary_ApexClass6A
        Case cases17=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-REACH.AeroWeb');
        //insert cases17;  
        caslist.add(cases17);
        
        // Test class code for UpdatePrimary_ApexClass7
        Case cases18=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-RepairquotesEscalation');
        //insert cases18;  
        caslist.add(cases18);
        
        // Test class code for UpdatePrimary_ApexClass7A
        Case cases20=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-APACACTinternal');
        //insert cases20; 
        caslist.add(cases20);
        
        // Test class code for UpdatePrimary_ApexClass8
        Case cases21=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-Avionics');
        //insert cases21; 
        caslist.add(cases21);
        
        // Test class code for UpdatePrimary_ApexClass8a
        Case cases23=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-BKParts');
        //insert cases23; 
        caslist.add(cases23);
        
        // Test class code for UpdatePrimary_ApexClass9
        Case cases211=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-CASSD');
        //insert cases2; 
        caslist.add(cases211);
        
        // Test class code for UpdatePrimary_ApexClass9A
        Case cases25=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-crc-Air Transport');
        //insert cases25; 
        caslist.add(cases25);   

        // Test class code for UpdatePrimary_ApexClassA
        Case cases2a=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin ='Email-AeroRepairs');
        //insert cases2a;
        caslist.add(cases2a);
        
        // Test class code for UpdatePrimary_ApexClass_Email_crc_edi
        Case cases26=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin =  'Email-crc-edi');
        //insert cases26; 
        caslist.add(cases26);
        
        // Test class code for UpdatePrimary_bga
        Case cases22=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-bga-orders');
        //insert cases22; 
        caslist.add(cases22);
        
        // Test class code for UpdatePrimary_BRGACSSolathe
        Case cases24=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-BRGACSSolathe');
        //insert cases24; 
        caslist.add(cases24);
        
        // Test class code for UpdatePrimary_CPSQuotesCOEPHX
        Case cases8=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin ='Email-CPSQuotesCOEPHX');
        //insert cases8; 
        caslist.add(cases8);
        
        // Test class code for UpdatePrimary_Disputes
        Case cases11=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',Customer_PO_RO_WONumber__c='43545', 
        Supported_Product__c='Radio',Origin ='Email-Disputes');
        //insert cases11;
        caslist.add(cases11);
        
        // Test class code for UpdatePrimary_OrderChanges
        Case cases33=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin =  'Email-Order Changes');
        //insert cases33;  
        caslist.add(cases33);
        
        // Test class code for UpdatePrimary_OrdersWeb
        Case cases371=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin =  'Email-QuotesWeb');
        //insert cases37; 
        caslist.add(cases371);
        
        // Test class code for UpdatePrimary_OrdersWeb1
        Case cases36=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-OrdersWeb');
        //insert cases36;  
        caslist.add(cases36);
        
        // Test class code for UpdatePrimary_PortalIssue
        Case cases152=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-MyAerospacePortalIssue');
        //insert cases15;  
        caslist.add(cases152);
        
        // Test class code for UpdatePrimary_PubsAccess
        Case cases13=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin ='Email-GBS-AES-PubsAccess');
        //insert cases13; 
        caslist.add(cases13);
        
        // Test class code for UpdatePrimary_PubsWeb
        Case cases161=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-PubsWeb');
        //insert cases16;  
        caslist.add(cases161);
        
        // Test class code for UpdatePrimary_PubsAccess1
        Case cases131=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin ='Email-GBS-AES-PubsAccess');
        //insert cases131;  
        caslist.add(cases131);
        
        // Test class code for UpdatePrimary_Returns
        Case cases38=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-Returns');
        //insert cases38;  
        caslist.add(cases38);
        
        // Test class code for UpdatePrimary_WebSupportweb
        Case cases41=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'Email-WebSupportweb');
        //insert cases41; 
        caslist.add(cases41);
        
        // Test class code for UpdatePrimary_Spares
        Case cases1=new Case(AccountId=acc.Id,subject='test data1',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin = 'CSO BGA Spares');
        //insert cases1; 
        caslist.add(cases1);
        
        // Test class code for UpdatePrimary_WarrantyWeb
        Case cases1a=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',
        Supported_Product__c='Radio',Origin ='Email-WarrantyWeb');
        //insert cases1;
        caslist.add(cases1a);   

        insert caslist;
        Test.stopTest();
        }
}