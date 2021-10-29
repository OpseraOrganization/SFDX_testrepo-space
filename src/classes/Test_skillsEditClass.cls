/** * File Name: Test_skillsEditClass
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
** 11/15/2013 SR#425182 modified test for to cover skilllevelchanges trigger
** 1.2 10/13/2017 NTT DATA Modified the test class for Save and New method in Skills edit page
* */ 
@isTest
private  class Test_skillsEditClass
 {
    static testmethod void testSkillsEditPage(){
    
    //Profile pf= [select id from Profile where name = 'System Administrator'];
    Id pfId = Label.Sys_Admin_Profile_Id;
    User usr = new User(LastName = 'Test UserCSO',FirstName='test',Username = 'tu1cso@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1cso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pfId, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
    insert usr;   
    //creating account;
    Account acc= new Account(name='Test Account'); 
    insert acc;
    //creating contact; 
    Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
    Contact_Is_Employee__c=true,email='venkatesh.athanti@honeywell.com',Mobile_App_Role__c='Customer Support Manager',Contact_Status__c='Active',Employee_Number__c='E008979',Employee_Contact_Role__c='Administrator' ); 
    insert cont;  
test.starttest();
   list<Skill_DataBase__c> skill=new list<Skill_DataBase__c>();   
    Skill_DataBase__c data= new Skill_DataBase__c(Master_Skill_Type__c ='Supported Product');
    skill.add(data);
    Skill_DataBase__c data1= new Skill_DataBase__c(Skill_Type__c ='Supported Product',
    Value1__c='Bendix King',Value2__c='Safety Systems (BK)',Value3__c='EGPWS (Early Ground Proximity Warning System)');
     skill.add(data1);
     insert skill;
     Skills2__c skills= new Skills2__c(Primary_Secondary__c='Primary' ,  Contact__c=cont.Id,
     Product_Type__c='Bendix King',Catalog_Product_Group__c='Safety Systems (BK)',
     Supported_Product__c='EGPWS (Early Ground Proximity Warning System)',Skill_Type__c ='Supported Product',
        Expertise__c='1-Basic',BGA_Skill_Value_Change__c=true);
     insert skills;
     Supported_Products__c sup = [select id from Supported_Products__c limit 1];
     skills.Supported_Products__c =sup.id;
     update skills;
     //try{
     //List<Skills2__c> skills = [select id, Contact__c,Primary_Secondary__c,Expertise__c,Product_Type__c,Catalog_Product_Group__c,Supported_Product__c,Skill_Type__c,BGA_Skill_Value_Change__c from Skills2__c where Primary_Secondary__c='Primary' and Product_Type__c='Bendix King' and Catalog_Product_Group__c='Safety Systems (BK)' and Supported_Product__c='EGPWS (Early Ground Proximity Warning System)' and Skill_Type__c ='Supported Product' and Expertise__c='1-Basic' and BGA_Skill_Value_Change__c=true limit 1];
          
  
     PageReference pageRef = Page.skills_edit;
     Test.setCurrentPage(pageRef);
     ApexPages.StandardController sc = new ApexPages.StandardController(skills);  
     pageRef.getParameters().put('Id',skills.Id);          
     skillsClass_edit skillsCon= new skillsClass_edit(sc);
     skillsCon.getvalue1();
     skillsCon.setvalue1('Supported Product');
     skillsCon.getvalue2();
     skillsCon.setvalue2('Bendix King');
     skillsCon.getvalue3();
     skillsCon.setvalue3('Safety Systems (BK)');
     skillsCon.getvalue4();
     skillsCon.setvalue4('EGPWS (Early Ground Proximity Warning System)');
     skillsCon.getskillrecd();
     skillsCon.setskillrecd(skills);
     skillsCon.ViewDetailsExp();
     skillsCon.getItems();
     skillsCon.getCPGPT();
     
     
     skillsCon.ViewDetails();
     skillsCon.getItems2(); 
     skillsCon.ViewDetails3();
     skillsCon.getItems3(); 
     skillsCon.ViewDetails4();
     skillsCon.getItems4(); 
     skillsCon.getmultivalues() ;
     List<String> tempList = new List<String>();
     tempList.add('test');
     tempList.add('test1');
     skillsCon.setmultivalues(tempList) ;

     skillsCon.SaveSkills();
     
     //SR#425182 starts here
     skills.Skill_Type__c='COE Product Type';
     skills.Skill_Value__c='Electrical';
     skills.Skill_Value_Comments__c='test comments';
     //update skills;
     //SR#425182 ends here
     
 
     skillsCon.AddNewSkills();
     skillsCon.Cancel();
     skillsCon.renderDetails();
     //skillsCon.setSkillsRec(skills[0]);
     skillsCon.setSkillsRec(skills);
     skillsCon.getSkillsRec();
     skillsCon.getPlatform();
     skillsCon.getvalue1();
     skillsCon.setvalue1('Aircraft Type');
     skillsCon.saveAndNewMethod();
     
     skillsCon.getvalue1();
     skillsCon.setvalue1('test');
     List<String> tempList1 = new List<String>();
     tempList1.add('test');
     tempList1.add('test1');
     skillsCon.setmultivalues(tempList1) ;
     skillsCon.ViewDetails();
     skillsCon.SaveSkills();
     
     
     
     /*
     PageReference pageRef1 = Page.skills_edit;
     Test.setCurrentPage(pageRef1);
     ApexPages.StandardController sc1 = new ApexPages.StandardController(skills);  
     pageRef.getParameters().put('Id',skills.Id);          
     skillsClass_edit skillsCon1= new skillsClass_edit(sc1);
     */
     
     skillsCon.getvalue1();
     skillsCon.setvalue1('COE Product Type');
     skillsCon.SaveSkills();
        test.stoptest();
     //}catch(Exception e1){}
     
     /*
     
     skillsCon.getvalue1();
     skillsCon.setvalue1('Site');
     skillsCon.getvalue2();
     skillsCon.setvalue2('Colorado Springs, CO');

     skillsCon.getskillrecd();
     skillsCon.setskillrecd(skills);
       skillsCon.SaveSkills();
   */
    }
    
    
    /*static testmethod void testSkillsEditPgemtd2(){
    
    Profile pf= [select id from Profile where name = 'System Administrator'];
    User usr = new User(LastName = 'Test UserCSO1',FirstName='test1',Username = 'tu1cso1@test.com',Email = 'testuser1@test.com',Alias = 'tu11' ,CommunityNickname= 'tu1cso1' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
    insert usr;   
    //creating account;
    Account acc= new Account(name='Test Account'); 
    insert acc;
    //creating contact; 
    Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
    Contact_Is_Employee__c=true,email='venkatesh.athanti@honeywell.com',Mobile_App_Role__c='Customer Support Manager',Contact_Status__c='Active',Employee_Number__c='8979',Employee_Contact_Role__c='Administrator' ); 
    insert cont;     
    test.starttest();
    list<Skill_DataBase__c> skill=new list<Skill_DataBase__c>();   
    Skill_DataBase__c data= new Skill_DataBase__c(Master_Skill_Type__c ='Supported Product');
    skill.add(data);
    Skill_DataBase__c data1= new Skill_DataBase__c(Skill_Type__c ='Supported Product',
    Value1__c='Bendix King',Value2__c='Safety Systems (BK)',Value3__c='EGPWS (Early Ground Proximity Warning System)');
     skill.add(data1);
     insert skill;
     Skills2__c skills= new Skills2__c(Primary_Secondary__c='Primary' ,  Contact__c=cont.Id,
     Product_Type__c='Bendix King',Catalog_Product_Group__c='Safety Systems (BK)',
     Supported_Product__c='EGPWS (Early Ground Proximity Warning System)',Skill_Type__c ='Supported Product',
        Expertise__c='1-Basic',BGA_Skill_Value_Change__c=true);
     insert skills;
     
  
     PageReference pageRef = Page.skills_edit;
     Test.setCurrentPage(pageRef);
     ApexPages.StandardController sc = new ApexPages.StandardController(skills);  
     pageRef.getParameters().put('Id',skills.Id);          
     skillsClass_edit skillsCon= new skillsClass_edit(sc);
     skillsCon.getvalue1();
     skillsCon.setvalue1('COE Product Type');
     skillsCon.getvalue2();
     skillsCon.setvalue2('Bendix King');
     skillsCon.getvalue3();
     skillsCon.setvalue3('Safety Systems (BK)');
     skillsCon.getvalue4();
     skillsCon.setvalue4('EGPWS (Early Ground Proximity Warning System)');
     skillsCon.getskillrecd();
     skillsCon.setskillrecd(skills);
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
     
     //SR#425182 starts here
     skills.Skill_Type__c='COE Product Type';
     skills.Skill_Value__c='Electrical';
     skills.Skill_Value_Comments__c='test comments';
     update skills;
     //SR#425182 ends here
     
     
    test.stoptest();
     skillsCon.AddNewSkills();
     skillsCon.Cancel();
     skillsCon.renderDetails();
     skillsCon.setSkillsRec(skills);
     skillsCon.getSkillsRec();
     
     
     /*
     
     skillsCon.getvalue1();
     skillsCon.setvalue1('Site');
     skillsCon.getvalue2();
     skillsCon.setvalue2('Colorado Springs, CO');

     skillsCon.getskillrecd();
     skillsCon.setskillrecd(skills);
       skillsCon.SaveSkills();
   */
    //}*/
    
    
}