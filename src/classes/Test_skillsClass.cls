/** * File Name: Test_skillsClass
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private  class Test_skillsClass
 {
    static testmethod void testSkillsPage(){
    
    //Profile pf= [select id from Profile where name = 'System Administrator'];
    Id pfId = Label.Sys_Admin_Profile_Id;
    User usr = new User(LastName = 'Test UserCSO',Username = 'tu1csonn@test.com',Email = 'testuser@test.com',Alias = 'tuee1' ,CommunityNickname= 'tu1wcso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pfId, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');insert usr;   
    //creating account;
    Account acc= new Account(name='Test Account'); 
    insert acc;
     //creating contact; 
    Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
    Contact_Is_Employee__c=true,  Contact_Status__c='Active',Employee_Number__c='E128980',Employee_Contact_Role__c='Administrator' ); 
    insert cont;     
    
    Skill_DataBase__c data= new Skill_DataBase__c(Master_Skill_Type__c ='Supported Product');
    insert data;
    Skill_DataBase__c data1= new Skill_DataBase__c(Skill_Type__c ='Supported Product',
    Value1__c='Bendix King',Value2__c='Safety Systems (BK)',Value3__c='EGPWS (Early Ground Proximity Warning System)');
    insert data1;
     
     Skills2__c skills= new Skills2__c(Primary_Secondary__c='Primary' ,  Contact__c=cont.Id,Expertise__c='1-Basic');
     //insert skills;
     
     PageReference pageRef = Page.Skills;
     Test.setCurrentPage(pageRef);
     ApexPages.StandardController sc = new ApexPages.StandardController(skills);  
     
   list<SkillId__c> rtype=SkillId__c.getall().values();//get the values from profiles in custom settings
      String match='/'+rtype[0].Id__C+'/o';
     
     pageRef.getParameters().put('retURL',match); 
         
     skillsClass skillsCon= new skillsClass(sc);
     skillsCon.getvalue1();
     skillsCon.setvalue1('Supported Product');
     skillsCon.getvalue2();
     skillsCon.setvalue2('Bendix King');
     skillsCon.getvalue3();
     skillsCon.setvalue3('Safety Systems (BK)');
     skillsCon.getvalue4();
     skillsCon.setvalue4('EGPWS (Early Ground Proximity Warning System)');
     skillsCon.getSkillsRec();
     skillsCon.setSkillsRec(skills);
     skillsCon.ViewDetailsExp();
     skillsCon.getItems();
     skillsCon.ViewDetails();
     skillsCon.getItems2(); 
     skillsCon.ViewDetails3();
     skillsCon.getItems3(); 
     skillsCon.ViewDetails4();
     skillsCon.getItems4(); 
     skillsCon.getmultivalues() ;
     String[] str;
          skillsCon.setmultivalues(str) ;

     skillsCon.SaveSkills();
     skillsCon.AddNewSkills();
     skillsCon.Cancel();
     skillsCon.setvalue1('Testing');
     skillsCon.ViewDetails3();
     skillsCon.getItems2();
     skillsCon.getCPGPT();
     skillsCon.getPlatform();
    }
    static testmethod void testSkillsPage1(){
    
    //Profile pf= [select id from Profile where name = 'System Administrator'];
    Id pfId = Label.Sys_Admin_Profile_Id;
    User usr = new User(LastName = 'Test UserCSO',Username = 'tu1csonn@test.com',Email = 'testuser@test.com',Alias = 'tuee1' ,CommunityNickname= 'tu1wcso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pfId, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');insert usr;   
    //creating account;
    Account acc= new Account(name='Test Account'); 
    insert acc;
     //creating contact; 
    Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
    Contact_Is_Employee__c=true,  Contact_Status__c='Active',Employee_Number__c='E128980',Employee_Contact_Role__c='Administrator' ); 
    insert cont;     
    
    Skill_DataBase__c data= new Skill_DataBase__c(Master_Skill_Type__c ='COE Product Type');
    insert data;
    Skill_DataBase__c data1= new Skill_DataBase__c(Skill_Type__c ='COE Product Type',
    Value1__c='Bendix King',Value2__c='Safety Systems (BK)',Value3__c='EGPWS (Early Ground Proximity Warning System)');
    insert data1;
     
     Skills2__c skills= new Skills2__c(Primary_Secondary__c='Primary' ,  Contact__c=cont.Id,Expertise__c='1-Basic');
     //insert skills;
     
     PageReference pageRef = Page.Skills;
     Test.setCurrentPage(pageRef);
     ApexPages.StandardController sc = new ApexPages.StandardController(skills);  
     
   list<SkillId__c> rtype=SkillId__c.getall().values();//get the values from profiles in custom settings
      String match='/'+rtype[0].Id__C+'/o';
     
     pageRef.getParameters().put('retURL',match); 
         
     skillsClass skillsCon= new skillsClass(sc);
     skillsCon.getvalue1();
     skillsCon.setvalue1('COE Product Type');
     skillsCon.getvalue2();
     skillsCon.setvalue2('Bendix King');
     skillsCon.getvalue3();
     skillsCon.setvalue3('Safety Systems (BK)');
     skillsCon.getvalue4();
     skillsCon.setvalue4('EGPWS (Early Ground Proximity Warning System)');
     skillsCon.getSkillsRec();
     skillsCon.setSkillsRec(skills);
     skillsCon.ViewDetailsExp();
     skillsCon.getItems();
     skillsCon.ViewDetails();
     skillsCon.getItems2(); 
     skillsCon.ViewDetails3();
     skillsCon.getItems3(); 
     skillsCon.ViewDetails4();
     skillsCon.getItems4(); 
     skillsCon.getmultivalues() ;
     String[] str;
          skillsCon.setmultivalues(str) ;

     skillsCon.SaveSkills();
     skillsCon.AddNewSkills();
     skillsCon.Cancel();
     skillsCon.setvalue1('Testing');
     skillsCon.ViewDetails3();
     skillsCon.getItems2();
     skillsCon.getCPGPT();
     skillsCon.getPlatform();
    }
    static testmethod void testSkillsPage2(){
    
    //Profile pf= [select id from Profile where name = 'System Administrator'];
    Id pfId = Label.Sys_Admin_Profile_Id;
    User usr = new User(LastName = 'Test UserCSO',Username = 'tu1csonn@test.com',Email = 'testuser@test.com',Alias = 'tuee1' ,CommunityNickname= 'tu1wcso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pfId, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');insert usr;   
    //creating account;
    Account acc= new Account(name='Test Account'); 
    insert acc;
     //creating contact; 
    Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
    Contact_Is_Employee__c=true,  Contact_Status__c='Active',Employee_Number__c='E128980',Employee_Contact_Role__c='Administrator' ); 
    insert cont;     
    
    Skill_DataBase__c data= new Skill_DataBase__c(Master_Skill_Type__c ='Test Value');
    insert data;
    Skill_DataBase__c data1= new Skill_DataBase__c(Skill_Type__c ='Test Value',
    Value1__c='Bendix King',Value2__c='Safety Systems (BK)',Value3__c='EGPWS (Early Ground Proximity Warning System)');
    insert data1;
     
     Skills2__c skills= new Skills2__c(Primary_Secondary__c='Primary' ,  Contact__c=cont.Id,Expertise__c='1-Basic');
     //insert skills;
     
     PageReference pageRef = Page.Skills;
     Test.setCurrentPage(pageRef);
     ApexPages.StandardController sc = new ApexPages.StandardController(skills);  
     
   list<SkillId__c> rtype=SkillId__c.getall().values();//get the values from profiles in custom settings
      String match='/'+rtype[0].Id__C+'/o';
     
     pageRef.getParameters().put('retURL',match); 
         
     skillsClass skillsCon= new skillsClass(sc);
     skillsCon.getvalue1();
     skillsCon.setvalue1('Aircraft Type');
     skillsCon.getvalue2();
     skillsCon.setvalue2('Bendix King');
     skillsCon.getvalue3();
     skillsCon.setvalue3('Safety Systems (BK)');
     skillsCon.getvalue4();
     skillsCon.setvalue4('EGPWS (Early Ground Proximity Warning System)');
     skillsCon.getSkillsRec();
     skillsCon.setSkillsRec(skills);
     skillsCon.ViewDetailsExp();
     skillsCon.getItems();
     skillsCon.ViewDetails();
     skillsCon.getItems2(); 
     skillsCon.ViewDetails3();
     skillsCon.getItems3(); 
     skillsCon.ViewDetails4();
     skillsCon.getItems4(); 
     skillsCon.getmultivalues() ;
     String[] str;
          skillsCon.setmultivalues(str) ;

     //skillsCon.SaveSkills();
     skillsCon.AddNewSkills();
     skillsCon.Cancel();
     skillsCon.setvalue1('Aircraft Type');
     skillsCon.ViewDetails3();
     skillsCon.getItems2();
     skillsCon.getCPGPT();
     skillsCon.getPlatform();
    }
        static testmethod void testSkillsPage3(){
    
    //Profile pf= [select id from Profile where name = 'System Administrator'];
    Id pfId = Label.Sys_Admin_Profile_Id;
    User usr = new User(LastName = 'Test UserCSO',Username = 'tu1csonn@test.com',Email = 'testuser@test.com',Alias = 'tuee1' ,CommunityNickname= 'tu1wcso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pfId, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');insert usr;   
    //creating account;
    Account acc= new Account(name='Test Account'); 
    insert acc;
     //creating contact; 
    Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
    Contact_Is_Employee__c=true,  Contact_Status__c='Active',Employee_Number__c='E128980',Employee_Contact_Role__c='Administrator' ); 
    insert cont;     
    
    Skill_DataBase__c data= new Skill_DataBase__c(Master_Skill_Type__c ='Test Value');
    insert data;
    Skill_DataBase__c data1= new Skill_DataBase__c(Skill_Type__c ='Test Value',
    Value1__c='Bendix King',Value2__c='Safety Systems (BK)',Value3__c='EGPWS (Early Ground Proximity Warning System)');
    insert data1;
     
     Skills2__c skills= new Skills2__c(Primary_Secondary__c='Primary' ,  Contact__c=cont.Id,Expertise__c='1-Basic');
     //insert skills;
     
     PageReference pageRef = Page.Skills;
     Test.setCurrentPage(pageRef);
     ApexPages.StandardController sc = new ApexPages.StandardController(skills);  
     
   list<SkillId__c> rtype=SkillId__c.getall().values();//get the values from profiles in custom settings
      String match='/'+rtype[0].Id__C+'/c';
     
     pageRef.getParameters().put('retURL',match); 
         
     skillsClass skillsCon= new skillsClass(sc);
     skillsCon.getvalue1();
     skillsCon.setvalue1('Test Value');
     skillsCon.getvalue2();
     skillsCon.setvalue2('Bendix King');
     skillsCon.getvalue3();
     skillsCon.setvalue3('Safety Systems (BK)');
     skillsCon.getvalue4();
     skillsCon.setvalue4('EGPWS (Early Ground Proximity Warning System)');
     skillsCon.getSkillsRec();
     skillsCon.setSkillsRec(skills);
     skillsCon.ViewDetailsExp();
     skillsCon.getItems();
     skillsCon.ViewDetails();
     skillsCon.getItems2(); 
     skillsCon.ViewDetails3();
     skillsCon.getItems3(); 
     skillsCon.ViewDetails4();
     skillsCon.getItems4(); 
     skillsCon.getmultivalues() ;
     String[] str;
          skillsCon.setmultivalues(str) ;

     //skillsCon.SaveSkills();
     skillsCon.AddNewSkills();
     skillsCon.Cancel();
     skillsCon.setvalue1('Testing');
     skillsCon.ViewDetails3();
     skillsCon.getItems2();
     skillsCon.getCPGPT();
     skillsCon.getPlatform();
    }
    static testmethod void testSkillsPage4(){
    
    //Profile pf= [select id from Profile where name = 'System Administrator'];
    Id pfId = Label.Sys_Admin_Profile_Id;
    User usr = new User(LastName = 'Test UserCSO',Username = 'tu1csonn@test.com',Email = 'testuser@test.com',Alias = 'tuee1' ,CommunityNickname= 'tu1wcso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pfId, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');insert usr;   
    //creating account;
    Account acc= new Account(name='Test Account'); 
    insert acc;
     //creating contact; 
    Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
    Contact_Is_Employee__c=true,  Contact_Status__c='Active',Employee_Number__c='E128980',Employee_Contact_Role__c='Administrator' ); 
    insert cont;     
    
    Skill_DataBase__c data= new Skill_DataBase__c(Master_Skill_Type__c ='Mobile App Products');
    insert data;
    Skill_DataBase__c data1= new Skill_DataBase__c(Skill_Type__c ='Mobile App Products',
    Value1__c='Bendix King',Value2__c='Safety Systems (BK)',Value3__c='EGPWS (Early Ground Proximity Warning System)');
    insert data1;
     
     Skills2__c skills= new Skills2__c(Primary_Secondary__c='Primary' ,  Contact__c=cont.Id,Expertise__c='1-Basic');
     //insert skills;
     
     PageReference pageRef = Page.Skills;
     Test.setCurrentPage(pageRef);
     ApexPages.StandardController sc = new ApexPages.StandardController(skills);  
     
   list<SkillId__c> rtype=SkillId__c.getall().values();//get the values from profiles in custom settings
      String match='/'+rtype[0].Id__C+'/c';
     
     pageRef.getParameters().put('retURL',match); 
         
     skillsClass skillsCon= new skillsClass(sc);
     skillsCon.getvalue1();
     skillsCon.setvalue1('Mobile App Products');
     skillsCon.getvalue2();
     skillsCon.setvalue2('Bendix King');
     skillsCon.getvalue3();
     skillsCon.setvalue3('Safety Systems (BK)');
     skillsCon.getvalue4();
     skillsCon.setvalue4('EGPWS (Early Ground Proximity Warning System)');
     skillsCon.getSkillsRec();
     skillsCon.setSkillsRec(skills);
     skillsCon.ViewDetailsExp();
     skillsCon.getItems();
     skillsCon.ViewDetails();
     skillsCon.getItems2(); 
     skillsCon.ViewDetails3();
     skillsCon.getItems3(); 
     skillsCon.ViewDetails4();
     skillsCon.getItems4(); 
     skillsCon.getmultivalues() ;
     String[] str;
          skillsCon.setmultivalues(str) ;

     //skillsCon.SaveSkills();
     skillsCon.AddNewSkills();
     skillsCon.Cancel();
     skillsCon.setvalue1('Testing');
     skillsCon.ViewDetails3();
     skillsCon.getItems2();
     skillsCon.getCPGPT();
     skillsCon.getPlatform();
    }
    static testmethod void testSkillsPage5(){
    
    //Profile pf= [select id from Profile where name = 'System Administrator'];
    Id pfId = Label.Sys_Admin_Profile_Id;
    User usr = new User(LastName = 'Test UserCSO',Username = 'tu1csonn@test.com',Email = 'testuser@test.com',Alias = 'tuee1' ,CommunityNickname= 'tu1wcso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pfId, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');insert usr;   
    //creating account;
    Account acc= new Account(name='Test Account'); 
    insert acc;
     //creating contact; 
    Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
    Contact_Is_Employee__c=true,  Contact_Status__c='Active',Employee_Number__c='E128980',Employee_Contact_Role__c='Administrator' ); 
    insert cont;     
    
    Skill_DataBase__c data= new Skill_DataBase__c(Master_Skill_Type__c ='Supported Product');
    insert data;
    Skill_DataBase__c data1= new Skill_DataBase__c(Skill_Type__c ='Supported Product',
    Value1__c='Bendix King',Value2__c='Safety Systems (BK)',Value3__c='EGPWS (Early Ground Proximity Warning System)');
    insert data1;
     
     Skills2__c skills= new Skills2__c(Primary_Secondary__c='Primary' ,  Contact__c=cont.Id,Expertise__c='');
     //insert skills;
     
     PageReference pageRef = Page.Skills;
     Test.setCurrentPage(pageRef);
     ApexPages.StandardController sc = new ApexPages.StandardController(skills);  
     
   list<SkillId__c> rtype=SkillId__c.getall().values();//get the values from profiles in custom settings
      String match='/00g/c';
     
     pageRef.getParameters().put('retURL',match); 
         
     skillsClass skillsCon= new skillsClass(sc);
     skillsCon.getvalue1();
     skillsCon.setvalue1('Supported Product');
     skillsCon.getvalue2();
     skillsCon.setvalue2('Bendix King');
     skillsCon.getvalue3();
     skillsCon.setvalue3('Safety Systems (BK)');
     skillsCon.getvalue4();
     skillsCon.setvalue4('EGPWS (Early Ground Proximity Warning System)');
     skillsCon.getSkillsRec();
     skillsCon.setSkillsRec(skills);
     skillsCon.ViewDetailsExp();
     skillsCon.getItems();
     skillsCon.ViewDetails();
     skillsCon.getItems2(); 
     skillsCon.ViewDetails3();
     skillsCon.getItems3(); 
     skillsCon.ViewDetails4();
     skillsCon.getItems4(); 
     skillsCon.getmultivalues() ;
     String[] str;
          skillsCon.setmultivalues(str) ;

     skillsCon.SaveSkills();
     skillsCon.AddNewSkills();
     skillsCon.Cancel();
     skillsCon.setvalue1('Testing');
     skillsCon.ViewDetails3();
     skillsCon.getItems2();
     skillsCon.getCPGPT();
     skillsCon.getPlatform();
     
     skillsCon.getvalue1();
     skillsCon.setvalue1('test');
     List<String> tempList1 = new List<String>();
     tempList1.add('test');
     tempList1.add('test1');
     skillsCon.setmultivalues(tempList1) ;
     skillsCon.SaveSkills();
     
     skillsCon.getvalue1();
     skillsCon.setvalue1('Aircraft Type');
     skillsCon.SaveSkills();
     
     skillsCon.saveAndNewMethod();
     
    }

}