@isTest(SeeAllData=true)
Public class Testcls_HwTrng_Reserve2_cls
{
    static testMethod void Testcls_HwTrng_Reserve2_cls()
    { 
        
        Profile pf= [select id from Profile where name = 'System Administrator'];        
        user usr=new user(firstName='Test455',lastName='Manager455',employeenumber='E812402',CommunityNickname='TestUser455',Alias='Test5',TimeZoneSidKey='America/Los_Angeles',Email='test455@test.com',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',IsPortalSelfRegistered=TRUE,IsActive=TRUE,ProfileID=pf.id,USername='TEst455@test455.com',localesidkey='en_US');
        //insert usr;
        user usr1=new user(firstName='Test555',lastName='Manager555',employeenumber='E812401',CommunityNickname='TestUser555',Alias='Tes1',TimeZoneSidKey='America/Los_Angeles',Email='test11@test.com',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',IsPortalSelfRegistered=TRUE,IsActive=TRUE,ProfileID=pf.id,USername='TEst555@test11.com',localesidkey='en_US');
        //insert usr1;
        
        
           
            System.runas(usr)
         {
           
           Account acc = new Account();
        acc.Name='Account';
        acc.Customer_Status__c='Active';
        acc.Region_Name__c='Americas';
        acc.Sub_Region_Name__c='Africa';
        acc.Service_Level__c='Comprehensive';
        acc.Strategic_Business_Unit__c='ATR';
        acc.CBT__c='Airbus';
        acc.CBT_Team__c='Airbus';
        acc.Market_Name__c='Air Transport';
        acc.Business_Owner__c='Ryan, Justin';
        acc.Type='Air Cargo Transporter';
        acc.REPORT_ACCOUNT_NAME__c='Test Report';
        insert acc;
              
        Contact con= new Contact();           
        con.AccountId=acc.Id;
        con.FirstName='terst1';
        con.LastName='test2';
        con.Primary_Email_Address__c='vvvv@gmail.com';
        con.Portal_Company_Name__c='keane';
        con.Job_Title__c='software';
        con.Company_E_Mail_Address__c='vvvvv@yahoo.com';
        con.Phone_1__c='12345678523';
        con.Phone_2__c='586974238';
        con.Phone_3__c='123546987';
        con.Company_Address__c='bangalo';
        con.State_Code__c='nnnnnn';
        con.Country_Name__c='iiiii';
        con.Postal_Code__c='45267421';                                
        con.City_Name__c='hhhhh';                           
        con.Contact_Birth_Country__c='lllll';
        con.Citizenship_Country__c='kkkkk';
        con.Dual_Citizenship_Country__c='jjjjj';         
        con.Passport_Number__c='256365';
        con.Passport_Expiry_Date__c=system.today()+3;
        con.Visa_Number__c='589500';
        con.Visa_Expiry_Date__c=system.today()+3;      
        insert con;
               
        
        
        con.Customer_Portal_UserId__c=usr.id;
        con.Email = usr.Email;
        Update con;
         String  uid = Userinfo.getuserid();
        
        Reservation__c rv0 = new Reservation__c();
        rv0.Student__c = usr.id;
        rv0.Class_Name__c = 'a0Ba000000J2GirEAF';
        rv0.Reservation_Type__c = 'Item';
        rv0.Reservation_Status__c = 'Registered';
        rv0.Attended__c = 'No Show';
      
                        
        ApexPages.StandardController sc = new ApexPages.StandardController(rv0);
        ApexPages.currentPage().getParameters().put('ID',rv0.Class_Name__c);
        
        //Reservation__c rv = new Reservation__c();
        
        /*rv.Student__c=rv0.Student__c;
        rv.Class_Name__c= rv0.Class_Name__c;
        rv.Reservation_Type__c=rv0.Reservation_Type__c;
        rv.Reservation_Status__c=rv0.Reservation_Status__c;
        rv.Attended__c=rv0.Attended__c;
        rv.id=rv0.id;*/
           
           HwTrng_Reserve2_cls r=new HwTrng_Reserve2_cls();
         
           r.getLstcon();
           r.getshowdetails();
           r.reserve();
           r.getdata();
           r.getclass();
           r.getLstres();
           r.HwTrng_Reserve2_cls();
           r.getdetails();
           r.reserve();
         }
    }
}