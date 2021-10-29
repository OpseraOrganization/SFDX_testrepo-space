@isTest(seeAllData=true)
    public class SSCommunityCases_Test4
     {
          /* static testMethod void testSSCommunityCases1()
             {
                  test.startTest();
                
                 List<Case> AllCasesList =[Select Id,CaseNumber,(select Subject__c, OwnerName__c , Name, Status__c from Service_Requests__r) from Case where Id='5003000000BjYZEAA3'];
                 SSCommunityCases_Cntrl.SRSearch(AllCasesList[0].Id);
                 system.assertEquals(AllCasesList[0].CaseNumber,'CASE-4687945');
                 test.stopTest();
             }
             
             
            static testMethod void testSSCommunityCases2()
             {
                  test.startTest();
                  
                  //Querying data usind id
                   
                  Service_Request__c srdata=[select id,OwnerName__c from Service_Request__c Limit 1];
                  Service_Request__c sr=SSCommunityCases_Cntrl.SRDetails(srdata.id);
                  system.assertEquals(sr.OwnerName__c,srdata.OwnerName__c);
                  test.stopTest();
             }
             
             
             static testMethod void testSSCommunityCases3()
             {
              
                  test.startTest();
                  
                  //Querying data usind id
                  
                  Case csdata=[select id,OwnerName__c from Case Limit 1];
                  Case cs=SSCommunityCases_Cntrl.CaseDetails(csdata.id);
                  system.assertEquals(cs.OwnerName__c,csdata.OwnerName__C);
                  test.stopTest();
             }
             
              static testMethod void testSSCommunityCases4()
             {
              
                  test.startTest();
                  
                  //Querying data usind id
                         
            Account acc = new Account();
            acc.Name = 'Test Account12';
            acc.Customer_Status__c = 'Active';
            insert acc;
            
             Contact con = new Contact();
            con.LastName = 'testLastName';
            con.FirstName = 'testFirstName';
            con.AccountId = acc.Id;
            con.Primary_Email_Address__c = 'test@tcs.com';
            con.Email='test1@tcs.com';
            insert con;

            Service_Request__c sr=new Service_Request__c();
          
            sr.Status__c='Open';
            insert sr;
            
             SSCommunityCases_Cntrl.CustomerCasesSearch('Open',acc.id);
             SSCommunityCases_Cntrl.CustomerCasesSearch('lastUpdated',acc.id);
             SSCommunityCases_Cntrl.CustomerCasesSearch('dateCreated',acc.id);
             SSCommunityCases_Cntrl.CustomerCasesSearch('aircrafttype',acc.id);
             SSCommunityCases_Cntrl.CustomerCasesSearch('atachap',acc.id);
             SSCommunityCases_Cntrl.CustomerCasesSearch('prodtype',acc.id);
             //SSCommunityCases_Cntrl.CustomerCasesSearch('partno',acc.id);
             SSCommunityCases_Cntrl.CustomerCasesSearch('subject',acc.id);
             SSCommunityCases_Cntrl.CustomerCasesSearch('status',acc.id);
                         
             system.assertEquals('Open',sr.Status__c);
             test.stopTest();
             }
             
             
             
              static testMethod void testSSCommunityCases6()
             {
              
                  test.startTest();
                  
                  //Querying data usind id
                         
            Account acc = new Account();
            acc.Name = 'Test Account12';
            acc.Customer_Status__c = 'Active';
            insert acc;
            SSCommunityCases_Cntrl.SearchAccount('Test');
             system.assertEquals('Test Account12',acc.Name);
             test.stopTest();
             }
             
             static testMethod void testSSCommunityCases7()
             {
                  test.startTest();
                  
                  //Querying data usind id
                  
                  Service_Request__c srdata=[select id,OwnerName__c from Service_Request__c Limit 1];
                  Service_Request__c sr=SSCommunityCases_Cntrl.SRDetails(srdata.id); 
                  SSCommunityCases_Cntrl.getUserIsEmloyee();
                  system.assertEquals(sr.OwnerName__c,srdata.OwnerName__c);
                  test.stopTest();
             }*/
             
      }