@isTest
public class HwTrng_MassReserve2_cls_TestClass{
    static testmethod void mytest(){
        String uid = Userinfo.getuserid();
        //Userinfo.getuserid();
        Account acc =new Account();
        acc.name='Test';
        insert acc;
        List<Contact> conlist = new List<Contact>();
        Contact con = new Contact();
        con.lastname='test';
        con.AccountId = acc.id;
        // con.Customer_Portal_UserId__c= uid;
        con.Honeywell_ID__c = 'sbc2008';
        insert con;
        // Contact con1 = new Contact();
        //con1.lastname='test';
        //con1.AccountId = acc.id;
        con.Customer_Portal_UserId__c= uid;
        //con1.Honeywell_ID__c = 'sbc2008';
        update con;
        
        Contact con1 = new Contact();
        con1.lastname='test';
        con1.AccountId = acc.id;
        insert con1;
        
        User u = new User(
            ProfileId = label.Training_and_Idea_Customer_Portal_label,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            ContactId = con.id,
            //AccountId = acc.id,
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            //UserRoleId = r.Id
        );  
        insert u;
        
        con.Customer_Portal_UserId__c= uid;
        update con;
        Product2 pd = new Product2 ();
        pd.name = 'Test';
        insert pd;
        Location__c loc = new Location__c();
        loc.name='Ramapuram';
        loc.City__c='che';
        loc.State__c='TN';
        loc.Postal_Code__c='600089';
        loc.Country__c='India';
        loc.Region__c='Asia';
        loc.CurrencyIsoCode='EUR';
        insert loc;
        Profile pf= [select id from Profile where name = 'System Administrator' limit 1];
        //List<Class__c> clslist = new List<Class__c>();
        Class__c cls = new Class__c();
        cls.Class_Name__c=pd.id;
        //cls.Contact__c = con.id;
        cls.Course_Name__c=pd.id;
        cls.Description__c='test';
        cls.End_Date__c=system.today();
        cls.Start_Date__c=system.today();
        
        //cls.Product_Per_Student_Price__c='515';
        //cls.Course__c= 'Eng';
        cls.Location__c= loc.id;
        //cls.Duration__c='10'
        //cls.Seats_Remaining__c=10;
        //clslist.add(cls);
        insert cls;
        cls.Contact__c = con.id;
        update cls;
        Test.setCurrentPage(Page.CP_MassReserve2_VF);
        ApexPages.currentPage().getParameters().put('id',cls.id);
        //id i = ApexPages.currentPage().getParameters().put('id','cls.id');
        HwTrng_MassReserve2_cls Hw= new HwTrng_MassReserve2_cls();
        Hw.getdetails();     
        Reservation__c res = new Reservation__c();
        //res.name='Test';Student
        res.Attended__c ='Yes';
        res.CurrencyIsoCode = 'EUR';
        res.Reservation_Type__c = 'Student';
        res.Reservation_Status__c = 'Confirmed' ;
        res.Student__c = con.id;
        res.Class_Name__c = cls.id;
        // res.Student_Name__c = 'SURYA';
        //res.Class__c = cls.id;
        insert res;
        // id i = ApexPages.currentPage().getParameters().put('id','cls.id');
        HwTrng_MassReserve2_cls hwcls = new HwTrng_MassReserve2_cls();
        System.currentPagereference().getParameters().put('id', cls.Id);
        //hwcls.getdetails();
        hwcls.getclass();
        hwcls.getlistofcontacts();
        hwcls.setrelatedContactName(con.id);
        hwcls.getrelatedContactName();
        hwcls.getselectedcontactlist();
        hwcls.addrow();
        hwcls.getrelatedContactName();
        //hwcls.addrow();
        hwcls.reserve();
        hwcls.getrv();
       
        
    }
    static testmethod void mytest4(){
        String uid = Userinfo.getuserid();
        //Userinfo.getuserid();
        Account acc =new Account();
        acc.name='Test';
        insert acc;
        List<Contact> conlist = new List<Contact>();
        Contact con = new Contact();
        con.lastname='test';
        con.AccountId = acc.id;
        // con.Customer_Portal_UserId__c= uid;
        con.Honeywell_ID__c = 'sbc2008';
        insert con;
        // Contact con1 = new Contact();
        //con1.lastname='test';
        //con1.AccountId = acc.id;
        con.Customer_Portal_UserId__c= uid;
        //con1.Honeywell_ID__c = 'sbc2008';
        update con;
        
        Contact con1 = new Contact();
        con1.lastname='test';
        con1.AccountId = acc.id;
        con1.Honeywell_ID__c = 'sbc2009';
        insert con1;
        test.startTest();
        User u = new User(
            ProfileId = label.Training_and_Idea_Customer_Portal_label,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            ContactId = con1.id,
            //AccountId = acc.id,
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            //UserRoleId = r.Id
        );  
        insert u;
        test.stopTest();
        con.Customer_Portal_UserId__c= uid;
        update con;
        Product2 pd = new Product2 ();
        pd.name = 'Test';
        insert pd;
        Location__c loc = new Location__c();
        loc.name='Ramapuram';
        loc.City__c='che';
        loc.State__c='TN';
        loc.Postal_Code__c='600089';
        loc.Country__c='India';
        loc.Region__c='Asia';
        loc.CurrencyIsoCode='EUR';
        insert loc;
        Profile pf= [select id from Profile where name = 'System Administrator' limit 1];
        //List<Class__c> clslist = new List<Class__c>();
        Class__c cls = new Class__c();
        cls.Class_Name__c=pd.id;
        //cls.Contact__c = con1.id;
        cls.Course_Name__c=pd.id;
        cls.Description__c='test';
        cls.End_Date__c=system.today();
        cls.Start_Date__c=system.today();
        //cls.Product_Per_Student_Price__c='515';
        //cls.Course__c= 'Eng';
        cls.Location__c= loc.id;
        //cls.Duration__c='10'
        //cls.Seats_Remaining__c=10;
        //clslist.add(cls);
        insert cls;
        cls.Contact__c = con1.id;
        update cls;
        Test.setCurrentPage(Page.CP_MassReserve2_VF);
        ApexPages.currentPage().getParameters().put('id',cls.id);
        //id i = ApexPages.currentPage().getParameters().put('id','cls.id');
        HwTrng_MassReserve2_cls Hw= new HwTrng_MassReserve2_cls();
        Hw.getdetails();  
         
        Reservation__c res = new Reservation__c();
        //res.name='Test';Student
        res.Attended__c ='Yes';
        res.CurrencyIsoCode = 'EUR';
        res.Reservation_Type__c = 'Student';
        res.Reservation_Status__c = 'Confirmed' ;
        res.Student__c = con.id;
        res.Class_Name__c = cls.id;
        // res.Student_Name__c = 'SURYA';
        //res.Class__c = cls.id;
        insert res;
        id i = ApexPages.currentPage().getParameters().put('id',cls.id);
        HwTrng_MassReserve2_cls hwcls = new HwTrng_MassReserve2_cls();
        System.currentPagereference().getParameters().put('id', cls.Id);
        hwcls.getdetails();
        hwcls.getclass();
        hwcls.getlistofcontacts();
        hwcls.setrelatedContactName(null);
        hwcls.getrelatedContactName();
        hwcls.getselectedcontactlist();
        hwcls.addrow();
        hwcls.getrelatedContactName();
        //hwcls.addrow();
        hwcls.reserve();
        hwcls.getrv();
        hwcls.setrelatedContactName(null);
        hwcls.addrow();
        
    }
    
    static testmethod void mytest1(){
        test.startTest();
        
        String uid = Userinfo.getuserid();
        //Userinfo.getuserid();
        Account acc =new Account();
        acc.name='Test';
        insert acc;
        
        List<Contact> conlist = new List<Contact>();
        Contact con = new Contact();
        con.lastname='test';
        con.AccountId = acc.id;
        // con.Customer_Portal_UserId__c= uid;
        con.Honeywell_ID__c = 'sbc2008';
        insert con;
        // Contact con1 = new Contact();
        //con1.lastname='test';
        //con1.AccountId = acc.id;
        con.Customer_Portal_UserId__c= uid;
        //con1.Honeywell_ID__c = 'sbc2008';
        update con;
        
        Contact con1 = new Contact();
        con1.lastname='test';
        con1.AccountId = acc.id;
        insert con1;
        
        User u = new User(
            ProfileId = label.Training_and_Idea_Customer_Portal_label,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            ContactId = con.id,
            //AccountId = acc.id,
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            //UserRoleId = r.Id
        );  
        insert u;
        
        con.Customer_Portal_UserId__c= uid;
        update con;
        Product2 pd = new Product2 ();
        pd.name = 'Test';
        insert pd;
        Location__c loc = new Location__c();
        loc.name='Ramapuram';
        loc.City__c='che';
        loc.State__c='TN';
        loc.Postal_Code__c='600089';
        loc.Country__c='India';
        loc.Region__c='Asia';
        loc.CurrencyIsoCode='EUR';
        insert loc;
        Profile pf= [select id from Profile where name = 'System Administrator' limit 1];
        //List<Class__c> clslist = new List<Class__c>();
        Class__c cls = new Class__c();
        cls.Class_Name__c=pd.id;
        //cls.Contact__c = con.id;
        cls.Course_Name__c=pd.id;
        cls.Description__c='test';
        cls.End_Date__c=system.today();
        cls.Start_Date__c=system.today();
        //cls.Product_Per_Student_Price__c='515';
        //cls.Course__c= 'Eng';
        cls.Location__c= loc.id;
        //cls.Duration__c='10'
        //cls.Seats_Remaining__c=10;
        //clslist.add(cls);
        insert cls;
        cls.Contact__c = con.id;
        update cls;
        Test.setCurrentPage(Page.CP_MassReserve2_VF);
        ApexPages.currentPage().getParameters().put('id',cls.id);
        //id i = ApexPages.currentPage().getParameters().put('id','cls.id');
        HwTrng_MassReserve2_cls Hw= new HwTrng_MassReserve2_cls();
        //     Hw.getdetails();     
        Reservation__c res = new Reservation__c();
        //res.name='Test';Student
        res.Attended__c ='Yes';
        res.CurrencyIsoCode = 'EUR';
        res.Reservation_Type__c = 'Student';
        res.Reservation_Status__c = 'Confirmed' ;
        res.Student__c = con.id;
        res.Class_Name__c = cls.id;
        // res.Student_Name__c = 'SURYA';
        //res.Class__c = cls.id;
        insert res;
        // id i = ApexPages.currentPage().getParameters().put('id','cls.id');
        HwTrng_MassReserve2_cls hwcls = new HwTrng_MassReserve2_cls();
        System.currentPagereference().getParameters().put('id', cls.Id);
        //hwcls.getdetails();
        hwcls.getclass();
        hwcls.getlistofcontacts();
        hwcls.setrelatedContactName(null);
        //hwcls.getrelatedContactName();
        hwcls.getselectedcontactlist();
        hwcls.addrow();
        //hwcls.getrelatedContactName();
        //hwcls.addrow();
        hwcls.reserve();
        hwcls.getrv();
        hwcls.setrelatedContactName(null);              
        hwcls.addrow(); 
        test.stopTest();
        
    }
    @isTest static void mytest2(){
        test.startTest();
        Account acco =new Account();
        acco.name='Test';
        insert acco;
        
        Contact cont=new Contact(firstname='Test',LastName='Contactfor massreg',AccountId=acco.Id,Phone_3__c='9986502495',
                                 Contact_Is_Employee__c=true,  Contact_Status__c='Active' ,Employee_Number__c='E756710',Honeywell_ID__c ='E7776',Employee_Contact_Role__c='Administrator');
        insert cont;
        
        User usr = new User(
            ProfileId = label.Training_and_Idea_Customer_Portal_label,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            ContactId = cont.id,
            //AccountId = acc.id,
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            //UserRoleId = r.Id
        );  
        insert usr;
        
        Contact conta=new Contact(firstname='Test',LastName='Contactfor massreg',AccountId=acco.Id,Phone_3__c='9986502495',
                                  Contact_Is_Employee__c=true,  Contact_Status__c='Active' ,Employee_Number__c='E75671110',Honeywell_ID__c ='E7776',Employee_Contact_Role__c='Administrator');
        insert conta;
        HwTrng_MassReserve2_cls Hwt= new HwTrng_MassReserve2_cls();
        
        
        system.runAs(usr)
        {
            
            
            RecordType r2 = [select id , name from RecordType where name='HoneywellTraining Location'];
            Location__c lh = new Location__c(Name = 'Place Holder', recordtypeid=r2.Id,Region__c = 'chennai',public__c = True);
            insert lh;
            RecordType r3 = [select id,name from RecordType where name='ClassRoom'];
            
            Product2 p = new Product2(Name = 'SFDC ADM Training chennai',Description = 'ADM Course',Keywords__c = 'ADM',Make_this_course_public__c = 'Yes',Per_student_Price__c=200,isActive = TRUE,recordtypeid= r3.Id);
            insert p; 
            Class__c cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day1',Total_Number_of_Seats__c=20, Start_Date__c=system.today()+1, End_Date__c=system.today()+20);
            insert cs;
            
            Reservation__c res = new Reservation__c();
            //res.name='Test';Student
            res.Attended__c ='Yes';
            res.CurrencyIsoCode = 'EUR';
            res.Reservation_Type__c = 'Student';
            res.Reservation_Status__c = 'Confirmed' ;
            res.Student__c = conta.id;
            res.Class_Name__c = cs.id;
            // res.Student_Name__c = 'SURYA';
            //res.Class__c = cls.id;
            insert res;
            ApexPages.currentPage().getParameters().put('id',cs.id);
  /*          List<Contact> conlist1 = new List<Contact>();
            for(integer i=0;i<600;i++ ){
                contact c= new contact(LastName='test'+i, FirstName = 'test',Email = i+'testmail@mail.com');
                conlist1.add(c);
            }
hwt.ls= conlist1;*/
            Hwt.getdetails();
            hwt.getlistofcontacts();
            hwt.relatedContactName =null;            
            hwt.addrow();
            
            
        }
        Hwt.getdetails();  
        hwt.getlistofcontacts();
        hwt.relatedContactName =null;            
        hwt.addrow();
        test.stopTest();
    }
    
    /*
@isTest(SeeAllData=true)
public class HwTrng_MassReserve2_cls_TestClass{

static testmethod void mytest(){

account a1=[select id,name from account where name='HONEYWELL EMPLOYEE AMERICAS' limit 1];
account a2=[select id,name from account where name='HONEYWELL EMPLOYEE EMEAI' limit 1];
Contact cont=new Contact(firstname='Test',LastName='Contactfor massreg',AccountId=a1.Id,Phone_3__c='9986502495',
Contact_Is_Employee__c=true,  Contact_Status__c='Active' ,Employee_Number__c='E756710',Honeywell_ID__c ='E7776',Employee_Contact_Role__c='Administrator');
insert cont;
Test.startTest();
//user usr=new user(firstName='Test459',lastName='Manager455',ContactId=cont.id,employeenumber='E812402',CommunityNickname='TestUser455',Alias='Test5',TimeZoneSidKey='America/Los_Angeles',Email='test455@test.com',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',IsPortalSelfRegistered=TRUE,IsActive=TRUE,ProfileID= label.Training_and_Idea_Customer_Portal_label,USername='TEst455@test455.com',localesidkey='en_US');
insert usr;

System.RunAs(usr){  

// Account a1 = New Account(Name= 'sbuaccount', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI',Market_Name__c='Space');
//insert a1;


Contact cont1=new Contact(firstname='Test',LastName='Contactfor massreg2',AccountId=a2.Id,Phone_3__c='9986502495',
Contact_Is_Employee__c=true,  Contact_Status__c='Active' ,Employee_Number__c='E756711',Honeywell_ID__c ='E7777',Employee_Contact_Role__c='Administrator');
insert cont1;

//Profile pf= [select id from Profile where name = 'Custom Customer Portal'];

/* User u1;
List<User> lstU1 = [select id from user where profileid = '00e30000001Y4ARAA0' and IsActive =true];
if(lstU1!=null && lstU1.size() > 0)
{
u1=lstU1[0];
}
else
{
u1=new User (id=userinfo.getuserid());
}*/
    //Profile pf= [select id from Profile where name = 'System Administrator' limit 1];        
    
    
    
    
    // u1.Contact = cont;
    //u1.profileid = label.Training_Customer_Portal_label;
    // update u1; 
    
    /* Contact cont2=new Contact(id=cont.id);    
cont2.Customer_Portal_UserId__c=usr.id;
update cont2;



RecordType r2 = [select id , name from RecordType where name='HoneywellTraining Location'];
Location__c lh = new Location__c(Name = 'LeMerdian chennai', recordtypeid=r2.Id,Region__c = 'chennai',public__c = True);
insert lh;
//Location__c lh2 = new Location__c(Name = 'Place Holder', recordtypeid=r2.Id,Region__c = 'chennai',public__c = True);
// insert lh2;
RecordType r3 = [select id,name from RecordType where name='ClassRoom'];
Product2 p = new Product2(Name = 'SFDC ADM Training chennai',Description = 'ADM Course',Keywords__c = 'ADM',Make_this_course_public__c = 'Yes',Per_student_Price__c=200,isActive = TRUE,recordtypeid= r3.Id);
insert p; 
Class__c cs = new Class__c(Location__c=lh.Id,Course_name__c= p.Id,Class_Name__c = 'Day1',Total_Number_of_Seats__c=20, Start_Date__c=system.today()+1, End_Date__c=system.today()+20);
insert cs;

cs.Contact__c = cont2.id;
update cs;

HwTrng_MassReserve2_cls hwcls= new HwTrng_MassReserve2_cls();
System.currentPagereference().getParameters().put('id', cs.Id);

hwcls.getdetails();
hwcls.getclass();
hwcls.getlistofcontacts();
// hwcls.setrelatedContactName(cont1.id);
hwcls.getrelatedContactName();
hwcls.getselectedcontactlist();
hwcls.addrow();
hwcls.setrelatedContactName(cont1.id);
hwcls.getrelatedContactName();
//hwcls.addrow();
hwcls.reserve();
hwcls.getrv();
}
Test.stoptest();

}

}

*/
}