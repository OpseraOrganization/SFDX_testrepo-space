public with sharing class HwTrng_Reserve2_cls {

    public Date getToday() {
        return today1;
    }  
    Date today1 = date.valueof(system.today());
    String  uid = Userinfo.getuserid();
    //String  uid = '005c0000000nKzSAAU';
    //string classid='a0Ba000000R6IHgEAN';
    list<Class__c> c = new list<Class__c>();
    boolean  showdetails =false;
    public void HwTrng_Reserve2_cls ()
    {
        if(showdetails==true)
        {
            system.debug('Testing insdie constr');
        }  
    }
        
    Reservation__c rv  = new Reservation__c ();
    list<Contact> userlst = new List<Contact>();
       
    Id i;
    {
       
        system.debug('WWWWWWWWWWWWWWWWWWWWWWWWWWW');
        if(uid!= null)
        {
        system.debug('WWWWWWWWWWWWWWWWWWWWWWWWWWW'+uid);
        userlst =[select name,Customer_Portal_UserId__c from Contact where Customer_Portal_UserId__c = :uid limit 1];
        system.debug('WWWWWWWWWWWWWWWWWWWWWWWWWWWuserlst'+userlst);
        }                    
    }
      
    public contact getLstcon() 
    {  
        contact lstcon=[SELECT FirstName,LastName,Birth_City__c,City_Name__c,Visa_Expiry_Date__c,Dual_Citizenship_Country__c,Citizenship_Country__c,Is_US_Citizen__c,State_Code__c,Passport_Number__c,Passport_Expiry_Date__c,Address_Line_1__c,Portal_Company_Name__c,Contact_Birth_Country__c,Job_Title__c,Phone_1__c,AccountId,Phone_2__c,Phone_3__c,Country_Name__c,Primary_Email_Address__c,Customer_Portal_UserId__c,Postal_Code__c FROM Contact WHERE Customer_Portal_UserId__c = :uid limit 1]; 
        return lstcon;
    }
    public user getLstres() 
    {  
        user lstres=[SELECT ID,email,LastModifiedDate,createddate from user WHERE ID = :uid limit 1]; 
        system.debug('test--->'+lstres.LastModifiedDate);
        Datetime  lastCreatedDate=lstres.LastModifiedDate;
        Datetime d=lastCreatedDate.addMonths(6);
        //lstres.LastModifiedDate=d;
        //Reservation__c lstres=[SELECT Class__c,CreatedDate,Created_Date__c FROM Reservation__c WHERE CreatedById = :uid ORDER BY Created_Date__c  desc limit 1]; 
        return lstres;
    }
    public void getdetails()
    {
     i = ApexPages.currentPage().getParameters().get('id');
     c  = [select name,Course_Name__c,Description__c,Product_Per_Student_Price__c,End_Date__c,Start_Date__c,Course__c,Location__r.name,Duration__c,Seats_Remaining__c  from Class__c where id =:i limit 1]; 
     
         system.debug('check1111---->'+i);    
         Class__c c1=[select id,name,Reserve_Class__c from Class__c where id=: i];
         if(c1.Reserve_Class__c == true)
         {
            c1.Reserve_Class__c = false;
            update c1;
            reserve();
            
            system.debug('check222222---->'+c1.Reserve_Class__c);    
         }  
    }
    public boolean getshowdetails()
    {
    return showdetails;
    }
    public class__c getclass()
    {
    if(c.size()>0)
    { 
        return c[0];
    }
    return null;     
    }
    public void reserve()
    {
        System.debug('************************* Inside reserve block');
        Reservation__c  rv0 = new Reservation__c();
        rv0.Student__c = userlst[0].id;
        rv0.Class_Name__c = i;
        rv0.Reservation_Type__c = 'Item';
        rv0.Reservation_Status__c = 'Registered';
        rv0.Attended__c = 'No Show';
        if(c.size()>0)
        rv0.Booking_Per_student_Price__c = c[0].Product_Per_Student_Price__c;
        try
        {
            insert rv0;
            system.debug('TestAnu-1');
            system.debug(rv0.Student__r.Email);
            rv  = [select name,Reservation_Type__c,Reservation_Status__c,Student__c,Course_Name__c,Class_Name__c,Student_Name__c,Class__c from Reservation__c where id =:rv0.id]; 
            system.debug('TestAnu-2');
            showdetails = true;
            system.debug('TestAnu-3');
        }
        catch(Exception e)
        {
            String str = String.valueof(e);
            system.debug('TestAnu-4');
            if(str.contains('Unique_Field__c duplicates value'))
            {
            system.debug('TestAnu-5');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You already have a reservation.');
            ApexPages.addMessage(myMsg);
            }
            else
            {
            system.debug('TestAnu-6');
            //ApexPages.addMessages(e);
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You already have a reservation.');
            ApexPages.addMessage(myMsg);
            }
            System.debug('************************* Exception in inserting reservation records');
        }
    }
    public Reservation__c getdata()
    {
        return rv;
    }

}