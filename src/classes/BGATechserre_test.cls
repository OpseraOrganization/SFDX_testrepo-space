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


@istest(seealldata=true)

private class BGATechserre_test{


    BGATechserre_test(){
    }
    
    static Testmethod void getContact(){
        Account acc= new Account(name='Test Account');
        insert acc;
        //Contact con=New Contact();
        // con=[Select id,Name from Contact limit 1];
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
                                 Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E444567' );
        insert cont;
        String s='Areas Covered Canada';
        ApexPages.StandardController controller=New ApexPages.StandardController(cont);
        BGATechserre bga= new BGATechserre(controller);
        bga.getContact();
    }
    
    static testMethod void myUnitTest() {
        //user tstuser = [select id from user where name = 'sfdc admin'];
        test.starttest(); 
        Account acc= new Account(name='Test Account');
        insert acc;
        
        List<string> str=new List<string>();
        str.add('India');
        str.add('China');
        
        //creating contact;
        Account_Address__c Add=new Account_Address__c (BGAMob_Contact_Name__c='Test',BGAMob_Customer_Phone__c='9986502495',account_name__c = acc.id,
                                                       Mobile_App_Visibility__c=true,  Authorized_Avionics_Dealer__c=true, Authorized_Mechanical_Service_Center__c=true,BGAMob_Geo_Code__Longitude__s=-34.4938049,BGAMob_Geo_Code__Latitude__s=-58.6272715);
        insert Add;
        Account_Address__c skill=new Account_Address__c ();
        skill.BGAMob_Country_Nm__c='India';
        skill.BGAMob_State_Province__c='Chennai';
        skill.account_name__c=acc.id;
        insert skill;
        
        BGAMOBDel bga1=new BGAMOBDel();
        ApexPages.StandardController sc = new ApexPages.StandardController(skill);
        BGAMOBDel bga=new BGAMOBDel(sc);
        bga.getCountries();  
        
        //bga.setCountries(str); 
        
        BGAMOBDel.getState1(skill.BGAMob_Country_Nm__c); 
        //BGAMOBDel.getContactCloseTo(-34.4938049,-58.6272715);
        BGAMOBDel.getContactAll();
        BGAMOBDel.getProduct();
        BGAMOBDel.getCountriesFromAccounts();
        BGAMOBDel.AccAddresswithBool wrap = new BGAMOBDel.AccAddresswithBool();
        //BGAMOBDel.getContactByProductUsingGPS('ALF',-34.4938049,-58.6272715);
        BGAMOBDel.getContactByProduct('ALF'); 
        BGAMOBDel.getResultValue(skill.BGAMob_Country_Nm__c,skill.BGAMob_State_Province__c);
        
        BGAMOBDel.getContact(Add.id);
        
        test.stoptest(); 
        
    }
    
    
    static testMethod void myUnitTes12() {
        //user tstuser = [select id from user where name = 'sfdc admin'];
        test.starttest(); 
        Account acc= new Account(name='Test Account');
        insert acc;
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
                                 Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E111567' );
        insert cont;
        
        Account_Address__c accadd=new Account_Address__c ();
        accadd.BGAMob_Country_Nm__c='India';
        accadd.BGAMob_State_Province__c='Chennai';
        accadd.account_name__c=acc.id;
        insert accadd;
        
        PageReference pageRef1 = Page.BGAMob_ProductLine;
        pageRef1.getParameters().put('prod', 'AvionicsSalesInstallationandRepair');
        Test.setCurrentPage(pageRef1);
        
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(acc);
        BGAProductLine bgapl2=new BGAProductLine(sc2);
        BGAProductLine.getProductLineDealers('AvionicSalesInstallationandRepair');
        //BGAProductLine.getContactByProductUsingGPS('AvionicSalesInstallationandRepair',-34.4938049,-58.6272715);
        BGAProductLine.getContactByProduct('AvionicSalesInstallationandRepair');
        BGAProductLine.getProductLineDealers('AvionicSalesandInstallation');
        //BGAProductLine.getContactByProductUsingGPS('AvionicSalesandInstallation',-34.4938049,-58.6272715);
        BGAProductLine.getContactByProduct('AvionicSalesandInstallation');
        BGAProductLine.getContact(accadd.id);
        BGAProductLine.getProduct();
        
        
        test.stoptest();
    }
          
    static testMethod void myUnitTes13() {
        //user tstuser = [select id from user where name = 'sfdc admin'];
        test.starttest(); 
        Account acc= new Account(name='Test Account');
        insert acc;
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
                                 Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='H222567' );
        insert cont;
        
        Account_Address__c accadd=new Account_Address__c ();
        accadd.BGAMob_Country_Nm__c='India';
        accadd.BGAMob_State_Province__c='Chennai';
        accadd.account_name__c = acc.id;
        insert accadd;
        
        
        PageReference pageRef2 = Page.BGAMob_ProductLine;
        pageRef2.getParameters().put('prod', 'AvionicsSalesandInstallation');
        Test.setCurrentPage(pageRef2);
        
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(acc);
        BGAProductLine bgapl1=new BGAProductLine(sc1);
        BGAProductLine.getProductLineDealers('AvionicsSalesandInstallation');
        //BGAProductLine.getContactByProductUsingGPS('AvionicsSalesandInstallation',-34.4938049,-58.6272715);
        BGAProductLine.getContactByProduct('AvionicsSalesandInstallation');
        BGAProductLine.getContact(accadd.id);
        BGAProductLine.getProduct();
        
        test.stoptest();
    }

    static testMethod void myUnitTest1() {
        //user tstuser = [select id from user where name = 'sfdc admin'];
        test.startTest(); 
        Account acc= new Account(name='Test Account');
        insert acc;
        
        List<string> str=new List<string>();
        str.add('India');
        str.add('China');
        
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
                                 Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E111567' );
        insert cont;
        
        /*Skills2__c skill=new Skills2__c();
        skill.Skill_Value__c='India';
        skill.Skill_Type__c='Area Covered US';
        skill.Skill_Value_Comments__c ='Tamil Nadu';
        insert skill;
        
        Skills2__c skill1=new Skills2__c();
        skill1.Skill_Value__c='India';
        skill1.Skill_Type__c='Area Test';
        skill1.Skill_Value_Comments__c ='Tamil Nadu';
        insert skill1;*/
        
        List<Skills2__c> skilllist = [select id,Skill_Value__c,Skill_Type__c,Skill_Value_Comments__c from Skills2__c limit 2];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(skilllist[0]);
        skils_testpage bga=new skils_testpage(sc);
        bga.mymethod();
        bga.getCountries();
        bga.getSkillValues();
        //bga.getSkillValue1();
        // bga.getAvionics();
        // bga.getSkillType();
        bga.skillvalue_selector();  
        //bga.getSkillValue1();
        //bga.getSelectedSkills();
        bga.setCountries(str); 
        bga.setSkillValues(str);
        //skils_testpage.getFSECountryvalues();
           
          //skils_testpage.getStatevalues(skill.Skill_Type__c); 
          skils_testpage.getResultValue(skilllist[0].Skill_Type__c,skilllist[0].Skill_Value__c);
          //skils_testpage.getContact(skill.id,cont.id);
         
          test.stoptest(); 
    }
    
    static testMethod void myUnitTestRec() {
        test.starttest(); 
        Account acc= new Account(name='Test Account');
        insert acc;
        Account_Address__c skill=new Account_Address__c ();
        skill.BGAMob_Country_Nm__c='India';
        skill.BGAMob_State_Province__c='Chennai';
        skill.account_name__c = acc.id;
        insert skill;
        ApexPages.StandardController sc = new ApexPages.StandardController(skill);
        BGAMObskils_RecDe obj = new BGAMObskils_RecDe (sc);
        test.stoptest(); 
    }
   
    static testMethod void myUnitTest2()
    {
        //user tstuser = [select id from user where name = 'sfdc admin'];
        test.starttest(); 
        Account acc= new Account(name='Test Account');
        insert acc;
        
        List<string> str=new List<string>();
        str.add('India');
        str.add('China');
        
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
                                 Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='H000567' );
        insert cont;

        /* Skills2__c skill=new Skills2__c();
        skill.Skill_Value__c='India';
        skill.Skill_Type__c='Area Covered US';
        skill.Skill_Value_Comments__c ='Tamil Nadu';
        insert skill;
        
        Skills2__c skill1=new Skills2__c();
        
        skill1.Skill_Type__c='Area Covered US';
        skill1.Skill_Value__c='--None--';
        insert skill1;
        
        Skills2__c skill2=new Skills2__c();
        skill2.Skill_Value__c='India';
        skill2.Skill_Value_Comments__c ='--None--';
        insert skill2;*/
        
        list<Skills2__c> tempskill= new list<skills2__c>();
        tempskill=[select id,Skill_Value__c,Skill_Type__c,Skill_Value_Comments__c  from Skills2__c where (Skill_Value_Comments__c ='--None--' or Skill_Type__c='Area Covered US') limit 3 ];
        Skills2__c skill=new Skills2__c();
        Skills2__c skill1=new Skills2__c();
        Skills2__c skill2=new Skills2__c();
        
        if(tempskill.size()>0)
            skill=tempskill[0];
        if(tempskill.size()>1)
            skill1=tempskill[1];
        if(tempskill.size()>2)
            skill2=tempskill[2];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(skill);
        BGACSM bga=new BGACSM(sc);
        BGACSM bga1=new BGACSM();
        bga.getSkillValue();
        bga.getCountries();
        
        // bga.getSkillType();  
        bga.skillvalue_selector();  
        bga.setCountries(str); 
        BGACSM.getStatevalues(skill.Skill_Type__c);
        BGACSM.getStatevalues(skill.Skill_Value__c);
        BGACSM.getResultValue(skill.Skill_Type__c,skill.Skill_Value__c);
        BGACSM.getResultValue(skill1.Skill_Type__c,skill1.Skill_Value__c);
        BGACSM.getResultValue(skill.Skill_Value__c,skill.Skill_Value_Comments__c );
        BGACSM.getResultValue(skill2.Skill_Value__c,skill2.Skill_Value_Comments__c );
        BGACSM.getResValue(skill.Skill_Type__c,skill.Skill_Value__c);
        BGACSM.getResValue(skill1.Skill_Type__c,skill1.Skill_Value__c);
        BGACSM.getResValue(skill.Skill_Value__c,skill.Skill_Value_Comments__c );
        BGACSM.getResValue(skill2.Skill_Value__c,skill2.Skill_Value_Comments__c );
        BGACSM.getCSM(skill.Id,cont.id);
        BGACSM.getASM(skill.Id,cont.id); 
        test.stoptest(); 
    }   
   static testMethod void myUnitTest3(){
        //user tstuser = [select id from user where name = 'sfdc admin'];
        case c1=[select id from case where Origin = 'BGAMobileApp' limit 1];
        test.starttest(); 
        Case c = new Case () ;
        ApexPages.StandardController s = new ApexPages.StandardController(c);
        BGAMobCustomWebtocase bga=new BGAMobCustomWebtocase(s);
        BGAMobCustomWebtocase bga1=new BGAMobCustomWebtocase();
        BGAMobCustomWebtocase.insertCase('123','abcd@gmail.com','abcd@gmail.com','Adam','Chennai','abc','sss','aaa','2013-08-08','test','aab','bcd','venkatesh'); 
        BGAMobCustomWebtocase.getMakeLists();                     
        //BGAMobCustomWebtocase.caseownerupdate(c1.id);                      
        //BGAMobCustomWebtocase.getAccessToken();
        //BGAMobCustomWebtocase.attachmenttocase(c1.id);
        test.stoptest();
    }
            
    static testMethod void myUnitTest4()
    {
        //user tstuser = [select id from user where name = 'sfdc admin'];
        
        List<Case> c1=[select id from case where Origin = 'BGAMobileApp' and RecordTypeId  =: label.Case_NavDB_Accts_RecordType limit 1];
        
        if(c1.size() > 0)
        {    
            test.starttest(); 
            Case c = new Case () ;
            ApexPages.StandardController s = new ApexPages.StandardController(c);
            BGAMobTOCMail bga=new  BGAMobTOCMail (s);
            BGAMobTOCMail bga1=new  BGAMobTOCMail ();
            BGAMobTOCMail.insertCase('navdb','123','abcd@gmail.com','abcd@gmail.com','abc','aa','bcd','venkatesh'); 
            //BGAMobTOCMail.attachmenttocase(c1.id);
            //BGAMobTOCMail.caseownerupdate(c1.id);
            //BGAMobTOCMail.getAccessToken();
            BGAMobTOCMail.OAuth wrap = new BGAMobTOCMail.OAuth();
            wrap.id = c1[0].id;
            wrap.issued_at = '1233';
            wrap.instance_url = 'http://test.salesforce.com/';
            wrap.signature = 'abc';
            wrap.access_token = '123abc!@#';
            test.stoptest();
        }
    }
   /* static testMethod void myUnitTestpilot()
    {
        //user tstuser = [select id from user where name = 'sfdc admin'];
        case c1=[select id from case where Origin = 'BGAMobileApp' and RecordTypeId  =: label.Case_Flight_Ops_Issue_pilot limit 1];
        //c1.Ownerid=label.AERODEFAULTUSER;
       // Update c1;
        test.starttest(); 
        Account acc= new Account(name='Test Account');
        insert acc;
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
                                 Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='H222567' );
        insert cont;
        Case c = new Case () ;
        ApexPages.StandardController s = new ApexPages.StandardController(c);
        BGAMobTOCMail bga=new  BGAMobTOCMail (s);
        BGAMobTOCMail bga1=new  BGAMobTOCMail ();
        BGAMobTOCMail.insertCase('pilot','123','abcd@gmail.com','abcd@gmail.com','abc','aa','bcd','venkatesh'); 
        //BGAMobTOCMail.insertCase('toc','123','abcd@gmail.com','abcd@gmail.com','abc','aa','bcd','venkatesh');
        //BGAMobTOCMail.attachmenttocase(c1.id);
        
        BGAMobTOCMail.caseownerupdate(c1.id);
        test.stoptest();
    }*/
    static testMethod void myUnitTest5()
    {
        //user tstuser = [select id from user where name = 'sfdc admin'];
        test.starttest(); 
        Case c = new Case () ;
        ApexPages.StandardController s = new ApexPages.StandardController(c);
        BGAMob_submit bga=new  BGAMob_submit (s);
        bga.casenumber='Case #6743373';
        bga.close();
        test.stoptest();
    }
    
               
    static testMethod void myUnitTestoffline()
    {
       
        //user tstuser = [select id from user where name = 'sfdc admin'];
        test.starttest(); 
        Account acc= new Account(name='Test Account');
        insert acc;
        Account_Address__c skill=new Account_Address__c ();
        skill.BGAMob_Country_Nm__c='India';
        skill.BGAMob_State_Province__c='Chennai';
        skill.account_name__c=acc.id;
        insert skill;
        
        List<string> str=new List<string>();
        str.add('India');
        str.add('China');
        
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
                                 Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E000567' );
        insert cont;
        PageReference pageRef = Page.BGAMob_PilotSupport;
        pageRef.getParameters().put('User-Agent', 'android');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController s = new ApexPages.StandardController(skill);
        BGAMob_Offline_Controller aoc= new BGAMob_Offline_Controller(s);
        //aoc.phoneGapUrl;
        BGAMob_Offline_Controller.queryContacts();
        BGAMob_Offline_Controller.querySkills();
        BGAMob_Offline_Controller.queryAccountAddress();
        
    } 
}