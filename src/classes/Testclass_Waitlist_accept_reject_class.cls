@isTest
public class Testclass_Waitlist_accept_reject_class {

    public static testMethod void Test_Waitlist_accept_reject_class() {
      list< Contact> conlst = new list< Contact>();
   list<Reservation__c> Rsvlst = new list<Reservation__c>();
 test.startTest();
  Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
            insert acc;
  Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact3',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E125690',
            Honeywell_ID__c = '01499xxx40335',
            EMAIL = 'eldcv.sfwv@vfv.com'
            );
           conlst.add(cont);
  Contact cont9 = new Contact(
            firstname = 'Test',
            LastName = 'Contact9',
            AccountId = acc.Id,
            Phone_3__c = '9986502496',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E125691',
            Honeywell_ID__c = '01499xxx40336',
            EMAIL = 'kldcv.sfwv@vfv.com'
            );
           conlst.add(cont9);
   Contact cont2 = new Contact(
            firstname = 'Test',
            LastName = 'Contact7',
            AccountId = acc.Id,
            Phone_3__c = '9986502497',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E125692',
            Honeywell_ID__c = '01499xxx40337',
            EMAIL = 'fldcv.sfwv@vfv.com'
            );
           conlst.add(cont2);         
           insert conlst;
       
  Location__c lc = new Location__c(   
            Name = 'Place Holder',
            City__c = 'Bangalore',
            State__c = 'Karnataka',
            Postal_Code__c ='562110',
            Country__c ='India',
            Region__c = 'Asia'
            );
          insert lc;
                               
  product2 prod = new Product2(name='TestProduct1');
       
           insert prod;
       
   // product2 prod=[SELECT Id FROM Product2 LIMIT 1];
         
  Class__c cls = new Class__c(
            Class_Name__c ='Test Class5',
            Course_Name__c = prod.id,
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
                  Attended__c='No Show',Student__c=cont2.id);
             insert Reserv4;
   Reservation__c Reserv5  = new Reservation__c(Class_Name__c =cls.id,Reservation_Status__c='registered',
                  Attended__c='No Show',Student__c=cont9.id);
            insert Reserv5;    
           Reserv3.Reservation_Status__c='Cancel';
           update Reserv3; 

         PageReference pageRef = page.Waitlist_accept_reject_vf;
          Test.setCurrentPage(pageRef);      
          
        pageRef.getParameters().put('rsv',Reserv4.Id);   
        pageRef.getParameters().put('rsvAccepted','True'); 
       
        Waitlist_accept_reject_class controller = new Waitlist_accept_reject_class();
        controller.ok();
       
         pageRef.getParameters().put('rsv',Reserv4.Id);
        pageRef.getParameters().put('rsvAccepted','True'); 
         Waitlist_accept_reject_class controller1 = new Waitlist_accept_reject_class();
        controller1.ok();
         test.stopTest();
    
        
        
   }
 public static testMethod void Test_Waitlist_accept_reject_class1() {
     list< Contact> conlst = new list< Contact>();
     list<Reservation__c> Rsvlst = new list<Reservation__c>();
 test.startTest();
  Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
            insert acc;
  Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact2',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E125694',
            Honeywell_ID__c = '01499xxx40338',
            EMAIL = 'dldcv.sfwv@vfv.com'
            );
           conlst.add(cont);
  Contact cont9 = new Contact(
            firstname = 'Test',
            LastName = 'Contact5',
            AccountId = acc.Id,
            Phone_3__c = '9986502496',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E123565',
            Honeywell_ID__c = '01499xxx40339',
            EMAIL = 'jldcv.sfwv@vfv.com'
            );
           conlst.add(cont9);
   Contact cont2 = new Contact(
            firstname = 'Test',
            LastName = 'Contact6',
            AccountId = acc.Id,
            Phone_3__c = '9986502487',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E125696',
            Honeywell_ID__c = '01499xxx40340',
            EMAIL = 'ildcv.sfwv@vfv.com'
            );
           conlst.add(cont2);         
           insert conlst;
       
  Location__c lc = new Location__c(   
            Name = 'Place Holder',
            City__c = 'Bangalore',
            State__c = 'Karnataka',
            Postal_Code__c ='562110',
            Country__c ='India',
            Region__c = 'Asia'
            );
            insert lc;
                               
  product2 prod = new Product2(name='TestProduct1');
       
           insert prod;
       
   // product2 prod=[SELECT Id FROM Product2 LIMIT 1];
         
  Class__c cls = new Class__c(
            Class_Name__c ='Test Class5',
            Course_Name__c = prod.id,
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
                  Attended__c='No Show',Student__c=cont2.id);
             insert Reserv4;
   Reservation__c Reserv5  = new Reservation__c(Class_Name__c =cls.id,Reservation_Status__c='registered',
                  Attended__c='No Show',Student__c=cont9.id);
            insert Reserv5;    
           Reserv3.Reservation_Status__c='Cancel';
           update Reserv3; 

         PageReference pageRef = page.Waitlist_accept_reject_vf;
          Test.setCurrentPage(pageRef);      
          
        pageRef.getParameters().put('rsv',Reserv4.Id);   
        pageRef.getParameters().put('rsvRejected','True'); 
        
        Waitlist_accept_reject_class controller = new Waitlist_accept_reject_class();
        controller.ok();
        Reserv4.Reservation_Status__c='Declined';
         update Reserv4;
         pageRef.getParameters().put('rsv',Reserv4.Id);
        pageRef.getParameters().put('rsvRejected','True'); 
         Waitlist_accept_reject_class controller1 = new Waitlist_accept_reject_class();
        controller1.ok();
  
        
         test.stopTest();
      
        
        
   }
   
   
 }