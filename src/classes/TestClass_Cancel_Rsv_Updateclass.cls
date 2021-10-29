@isTest(SeeAllData=true)
public class TestClass_Cancel_Rsv_Updateclass{
 
 static testmethod void Cancel_Rsv(){
   list< Contact> conlst = new list< Contact>();
   list<Reservation__c> Rsvlst = new list<Reservation__c>();

  Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
            insert acc;
  Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            //Employee_Number__c = 'E145687',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
            );
            conlst.add(cont);
  Contact cont1 = new Contact(
            firstname = 'Test',
            LastName = 'Contact1',
            AccountId = acc.Id,
            Phone_3__c = '9986502496',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            //Employee_Number__c = '5688',
            Honeywell_ID__c = '01499xxx40332',
            EMAIL = 'bldcv.sfwv@vfv.com'
            );
            conlst.add(cont1); 
  Contact cont2 = new Contact(
            firstname = 'Test',
            LastName = 'Contact2',
            AccountId = acc.Id,
            Phone_3__c = '9986502497',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            //Employee_Number__c = 'E123689',
            Honeywell_ID__c = '01499xxx40333',
            EMAIL = 'cldcv.sfwv@vfv.com'
            );
            conlst.add(cont2);   
            insert conlst;   
  product2 prod = new Product2(name='Test Product');
            insert prod;
  
  Class__c cls = new Class__c(
            Class_Name__c ='Test Class',
            Course_Name__c =prod.id,
            Start_Date__c = System.today(),
            End_Date__c = System.today().addDays(2),
            Location__c = [select id from Location__c limit 1].id,
            Total_Number_of_Seats__c = 2  
            ); 
            insert cls;   
                
  Reservation__c Reserv  = new Reservation__c(Class_Name__c =cls.id,Reservation_Status__c='registered',
                  Attended__c='No Show',Student__c=cont.id);
             Rsvlst.add(Reserv);
                  
  Reservation__c Reserv1  = new Reservation__c(Class_Name__c =cls.id,Reservation_Status__c='registered',
                  Attended__c='No Show',Student__c=cont1.id);
             Rsvlst.add(Reserv1);
                   
  Reservation__c Reserv2  = new Reservation__c(Class_Name__c =cls.id,Reservation_Status__c='wait list',
                  Attended__c='No Show',Student__c=cont2.id);
             Rsvlst.add(Reserv2);
             insert Rsvlst;
                  
        Reserv.Reservation_Status__c = 'cancel';
        update  Reserv;
    } 

 static testmethod void changestatusaswaitlist(){
   list< Contact> conlst = new list< Contact>();
   list<Reservation__c> Rsvlst = new list<Reservation__c>();

  Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
            insert acc;
  Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact5',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            //Employee_Number__c = 'E125690',
            Honeywell_ID__c = '01499xxx40335',
            EMAIL = 'eldcv.sfwv@vfv.com'
            );
           conlst.add(cont);
  Contact cont1 = new Contact(
            firstname = 'Test',
            LastName = 'Contact6',
            AccountId = acc.Id,
            Phone_3__c = '9986502496',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            //Employee_Number__c = 'E125691',
            Honeywell_ID__c = '01499xxx40336',
            EMAIL = 'fldcv.sfwv@vfv.com'
            );
           conlst.add(cont1);
           insert conlst;
                           
  product2 prod = new Product2(name='Test Product');
           insert prod;
         
  Class__c cls = new Class__c(
            Class_Name__c ='Test Class1',
            Course_Name__c =prod.id,
            Start_Date__c = System.today(),
            End_Date__c = System.today().addDays(1),
            Location__c = [select id from Location__c limit 1].id,
            Total_Number_of_Seats__c = 1  
            ); 
           insert cls;   
                
  Reservation__c Reserv3  = new Reservation__c(Class_Name__c =cls.id,Reservation_Status__c='registered',
                  Attended__c='No Show',Student__c=cont.id);
             insert Reserv3;
                    
  Reservation__c Reserv4  = new Reservation__c(Class_Name__c =cls.id,Reservation_Status__c='registered',
                  Attended__c='No Show',Student__c=cont1.id);
             insert Reserv4;
                    
     Reserv3.Reservation_Status__c = 'Registered';
             update  Reserv3;
    }
}