@isTest
private class Test_updatecaseField {
 public static testMethod void testocc(){
 
 
     
     Test.startTest(); 
     
     list<Case> caselist=new List<Case>();
     set<ID> Feedid =new set<ID>();
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
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont; 
    
      
    Case c = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email-GDC Accounts',
            
            Type = 'Order'
        );
      insert c;
      
    Feedid.add(c.id);
    caselist = [SELECT id FROM Case WHERE ID IN :Feedid];
    
      Feedback__c fob=new Feedback__c();
      fob.Case__c=c.id;
      fob.Account__c=acc.id;
      fob.NPS_Recommend__c=5;
      fob.CES_Score__c=5;
      fob.Overall_satisfaction__c=5;
      fob.No_of_Contacts_to_Resolve__c='5';
      insert fob;
      
      
      c.NPS_Recommend__c = fob.NPS_Recommend__c;
            c.CES_Score__c =fob.CES_Score__c;
            c.Overall_Sat__c = fob.Overall_satisfaction__c;
            c.No_of_Contacts_to_Resolve__c =fob.No_of_Contacts_to_Resolve__c;
      update c;
      Test.stopTest();
      
  }
  }