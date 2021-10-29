@isTest
public class TestReg_cls_TestClass{
 static testmethod void mytest(){
  
 Account a1 = New Account(Name= 'sbuaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI',Market_Name__c='Space');
 insert a1;
  Contact cont=new Contact(firstname='Test',LastName='Contactfor massreg',AccountId=a1.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active' ,Employee_Number__c='E575671',Honeywell_ID__c ='E7776',Employee_Contact_Role__c='Administrator');
        insert cont;
        Contact cont1=new Contact(firstname='Test',LastName='Contactfor massreg2',AccountId=a1.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active' ,Employee_Number__c='E756711',Honeywell_ID__c ='E7777',Employee_Contact_Role__c='Administrator');
        insert cont1;
        //Profile pf= [select id from Profile where name = 'Custom Customer Portal'];
        //User u1 = new User(contactid= cont.Id,LastName = 'Test User',Username = 'trn@test.com',Email = 'testuser@test.com',Alias = 'tu101' ,CommunityNickname= 'tu1trng01' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        //insert u1;  
        
        User u1;
        List<User> lstU1 = [select id from user where profileid = '00e30000001Y4ARAA0' and IsActive =true];
        if(lstU1!=null && lstU1.size() > 0)
        {
            u1=lstu1[0];
        }
        else
        {
            u1=new User (id=userinfo.getuserid());
        }
        
        
        Contact cont2=new Contact(id=cont.id);    
        cont2.Customer_Portal_UserId__c=u1.id;
        update cont2;
        System.RunAs(u1){
  RecordType r2 = [select id , name from RecordType where name='HoneywellTraining Location'];
    Location__c lh = new Location__c(Name = 'LeMerdian chennai', recordtypeid=r2.Id,Region__c = 'chennai',public__c = True);
    insert lh;
    Location__c lh2 = new Location__c(Name = 'Place Holder', recordtypeid=r2.Id,Region__c = 'chennai',public__c = True);
    insert lh2;
  RecordType r3 = [select id , name from RecordType where name='ClassRoom'];
    Product2 p = new Product2(Name = 'SFDC ADM Training chennai',Description = 'ADM Course',Keywords__c = 'ADM',Make_this_course_public__c = 'Yes',isActive = TRUE,recordtypeid= r3.Id);
    insert p; 
    Class__c cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day1',Total_Number_of_Seats__c=20, Start_Date__c=system.today()+1, End_Date__c=system.today()+20);
    insert cs;
    TestReg_cls hwcls= new TestReg_cls();
    System.currentPagereference().getParameters().put('id', cs.Id); 
    hwcls.getdetails();
    hwcls.getclass();
    hwcls.addrow();
    hwcls.getselectedcontactlist();
    hwcls.reserve();
    hwcls.getrv();
    hwcls.Done();
 }
}

}