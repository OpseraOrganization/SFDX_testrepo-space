@isTest(SeeAllData=true)
private class Test_CustomResOrganizerLookupController {
      static testMethod void CustomResOrganizerLookupController()
      {  
         
            Profile pf = [ Select id from Profile where name = 'Training - Customer Portal'];
            Account A1 = new Account(Name = 'Test Account');
            insert A1;
            Contact C1 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User',Honeywell_ID__c='E812402', email = 'venkatesh.athanti@honeywell.com',Employee_Number__c = 'E123123' );
            insert C1;                            
            user u2=[select id,name,email from user where Batch_User__c = true and profileid =: pf.id and isactive = true limit 1];             
            try
            {
                C1.Customer_Portal_UserId__c =u2.id;
                upsert C1;
                upsert A1;
            }
            catch(Exception e){}
            System.runas(u2)
            {                  
              CustomResOrganizerLookupController cus=new CustomResOrganizerLookupController(); 
              cus.next();
              cus.previous();
              cus.Search();
              //cus.runSearch();
              cus.getFormTag();
              cus.getTextBox(); 
            }
      }
  }