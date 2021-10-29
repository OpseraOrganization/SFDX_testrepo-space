@isTest

public class ToolAccessNotificationtest{
    static testMethod void toolmethod(){
    Profile pf= [select id from Profile where name = 'Honeywell System Administrator'];
     User usr1 = new User(LastName = 'TestUsrCont',Username = 'tuContact@test.com',Email = 'testuserContact@test.com',Alias = 'tcnt' ,CommunityNickname= 'tucont' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',ProfileId = pf.Id);
        insert usr1;
        
        Contact_Tool_Access__c cta= new Contact_Tool_Access__c();
  cta.name='test';
  cta.Portal_Tool_Master__c=label.Technical_Publications;
  cta.Request_Status__c='Approved';
  //cta.CRM_Contact_ID__c=cont.id;
  cta.Portal_Honeywell_ID__c='text';
  insert cta;
        
        //creating account;
        Account acc= new Account(name='Test Contact Inactive Account');
        insert acc;

Account_Email_Domains__c objem=new Account_Email_Domains__c();
              objem.name='test';
              objem.Account_Email_Domain__c='gmail.com';
              objem.Account__c=acc.id;
              insert objem;
              
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact Inactive',AccountId=acc.Id,Phone_3__c='9986502456',
        Contact_Is_Employee__c=true,Email='test1234@gmail.com', Contact_Status__c='Active' ,Employee_Number__c='E534543',Employee_Contact_Role__c='Administrator',ownerid = usr1.Id,TOOLNAME1__c='test',ToolStatus__c='Approved',ToolId__c=cta.id);
        insert cont;
        
              
              
                
       
     cont.ToolStatus__c='Denied';
     cont.Tool_Image__c='abcd1234';
     //cont.ToolId__c='123456'; //Addedd by Radha
     //cont.ToolId__c='a0T010000008Upf';
     cont.TOOLNAME1__c='test23'; //Addedd by Radha
     update cont;
        
         Contact_Tool_Access__c cta1= new Contact_Tool_Access__c();
  cta1.name='test1';
  cta1.Portal_Tool_Master__c=label.Technical_Publications;
  cta1.Request_Status__c='Denied';
  //cta.CRM_Contact_ID__c=cont.id;
  cta1.Portal_Honeywell_ID__c='text1';
  insert cta1;
   
     Contact cont1=new Contact(firstname='Test1',LastName='Contact Inactive',AccountId=acc.Id,Phone_3__c='9986502465',
        Contact_Is_Employee__c=true,Email='test12345@gmail.com', Contact_Status__c='Active' ,Employee_Number__c='E534544',Employee_Contact_Role__c='Administrator',ownerid = usr1.Id,TOOLNAME1__c='test1',ToolStatus__c='Denied',ToolId__c=cta1.id );
        insert cont1;
         cont1.ToolStatus__c='Pending';
     update cont1;
     
     
      Contact_Tool_Access__c cta2= new Contact_Tool_Access__c();
  cta2.name='test2';
  cta2.Portal_Tool_Master__c=label.Technical_Publications;
  cta2.Request_Status__c='Pending';
  //cta.CRM_Contact_ID__c=cont.id;
  cta2.Portal_Honeywell_ID__c='text2';
  insert cta2;
  
  Contact cont2=new Contact(firstname='Test2',LastName='Contact Inactive',AccountId=acc.Id,Phone_3__c='9986502478',
        Contact_Is_Employee__c=true,Email='test123456@gmail.com', Contact_Status__c='Active' ,Employee_Number__c='E534545',Employee_Contact_Role__c='Administrator',ownerid = usr1.Id,TOOLNAME1__c='test2',ToolStatus__c='Pending',ToolId__c=cta2.id );
        insert cont2;
        
        
        
        
         cont2.ToolStatus__c='Approved';
     update cont2;
     
     test.starttest();
     
     Contact cont3=new Contact(firstname='Test3',LastName='Contact Inactive',AccountId=acc.Id,Phone_3__c='9986502488',Contact_Is_Employee__c=true,Email='test1234567@gmail.com', Contact_Status__c='Active' ,Employee_Number__c='E534546',Employee_Contact_Role__c='Administrator',ownerid = usr1.Id,Honeywell_ID__c='12344',Address_Line_1__c='testingaddress' ,Primary_Email_Address__c='testing1@gmail.com',Counter_on_update__c=0,Tool_Image__c='test 890',ToolId__c='test',ToolStatus__c='Denied');
     
     insert cont3;
     
     Portal_Honeywell_ID__c poId=new Portal_Honeywell_ID__c();
        poId.name='test';
        poId.Contact__c=cont3.id;
        insert poId;
     
     cont3.Address_Line_1__c='testingupdatedaddress';
     cont3.Tool_Image__c='abcd1234'; //addedd by Radha
    // Update cont3; //addedd by Radha
     
    /*
    //Addedd by Radha 
   
    Contact cont4=new Contact(firstname='Test4',LastName='Contact Inactive',AccountId=acc.Id,Phone_3__c='9986502488',Contact_Is_Employee__c=true,Email='test12345678@gmail.com', Contact_Status__c='Active' ,Employee_Number__c='E00000',Employee_Contact_Role__c='Administrator',ownerid = usr1.Id,Honeywell_ID__c='12345',Address_Line_1__c='testingaddress' ,Primary_Email_Address__c='testing1@gmail.com',Counter_on_update__c=0,ToolStatus__c='test');
     
     insert cont4;
     */
    test.stoptest();
    
    
    
 }
 
}