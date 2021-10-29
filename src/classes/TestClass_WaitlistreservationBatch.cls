@isTest(SeeAllData=true)
public class TestClass_WaitlistreservationBatch{

 static testmethod void Test_WaitlistreservationBatch(){
 
   list< Contact> conlst = new list< Contact>();
   list<Reservation__c> Rsvlst = new list<Reservation__c>();

  Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
            insert acc;
  Contact cont5 = new Contact(
            firstname = 'Test',
            LastName = 'Contact5',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E125687',
            Honeywell_ID__c = '01499xxx40336',
            EMAIL = 'gldcv.sfwv@vfv.com'
            );
            conlst.add(cont5);
  Contact cont6 = new Contact(
            firstname = 'Test',
            LastName = 'Contact6',
            AccountId = acc.Id,
            Phone_3__c = '9986502496',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E125688',
            Honeywell_ID__c = '01499xxx40338',
            EMAIL = 'hldcv.sfwv@vfv.com'
            );
            conlst.add(cont6); 
  Contact cont7 = new Contact(
            firstname = 'Test',
            LastName = 'Contact7',
            AccountId = acc.Id,
            Phone_3__c = '9986502497',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E125689',
            Honeywell_ID__c = '01499xxx40337',
            EMAIL = 'jldcv.sfwv@vfv.com'
            );
            conlst.add(cont7);   
            insert conlst;   
  product2 prod = new Product2(name='Test Product1');
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
                
  Reservation__c Reserv5  = new Reservation__c(Class_Name__c =cls.id,Reservation_Status__c='registered',
                  Attended__c='No Show',Student__c=cont5.id);
             Rsvlst.add(Reserv5);
                  
 Reservation__c Reserv6  = new Reservation__c(Class_Name__c =cls.id,Reservation_Status__c='wait list',
                  Attended__c='No Show',Student__c=cont6.id);
             Rsvlst.add(Reserv6);
                   
  Reservation__c Reserv7  = new Reservation__c(Class_Name__c =cls.id,Reservation_Status__c='wait list',
                  Attended__c='No Show',Student__c=cont7.id);
             Rsvlst.add(Reserv7);
             insert Rsvlst;
             
             Reserv5.Reservation_Status__c = 'cancel';
             update  Reserv5 ;
             
             
             Reserv6.Mail_send_date__c = system.now().addDays(-4);
             update Reserv6; 
             
    Test.startTest();
        
        WaitlistreservationBatch Waitbatch = new WaitlistreservationBatch();
        Database.executebatch(Waitbatch,200);
        
    Test.stopTest();
   }
 }