@isTest
 class caseGDCTechIssueOpsTest{
 //Test method for caseGDCTechIssueOps
    /////////////////////
    static void implementaion123(String prior,String sts) 
    {
        test.startTest();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        
        insert acc;
        Id rt= [select id,name from recordtype where sobjecttype='Case' and name='GDC Tech Issue'].id;
        Contact con = new Contact();
        con.LastName = 'Kulkarni';
        con.FirstName = 'Shrivaths';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'shrivaths.kulkarni@nttdata.com';
        con.Email='shrivaths.kulkarni@nttdata.com';
        insert con;                    
         Case cse = new Case();
        cse.Origin = 'Email';
        cse.Status = 'New';
         cse.RecordTypeId = rt;
         cse.Classification__c = 'MyGDC';
         cse.ContactId = con.Id;
         cse.Type_of_Change__c = 'New Account';
         cse.Type = 'Other';
         cse.Export_Compliance_Content_ITAR_EAR__c = 'NO';
         cse.Government_Compliance_SM_M_Content__c = 'NO';
         cse.priority = prior;
         insert cse;        
        
         cse.Status = sts;
         update cse;
                 
        test.StopTest();
        
        
         }
         
         /// Anu Adddddded
         
       // public static void implementaion123(id rt,id contid,String prior, String sts) 
       /* public static void implementaion123(Case cse,String prior, String sts) 
    {
       // test.startTest();           
         cse.priority = prior;
         cse.Status = sts;
         update cse;                
        // test.StopTest();
         }
         */
         static testMethod void testcaseGDCTechIssueOps()
         {
        implementaion123(null,'Open');
        }
        static testMethod void testcaseGDCTechIssueOps11()
         {
        implementaion123('Low','Assigned');
        }
         static testMethod void testcaseGDCTechIssueOps12()
         {
        implementaion123('Low','Open');
        }
        static testMethod void testcaseGDCTechIssueOps13()
         {
        implementaion123('Low','Fixed');
        }
        static testMethod void testcaseGDCTechIssueOps21()
         {
        implementaion123('High','Assigned');
       }
       static testMethod void testcaseGDCTechIssueOps22()
         {
        implementaion123('High','Open');
        }
       static testMethod void testcaseGDCTechIssueOps23()
         {implementaion123('High','Fixed');
        }
       static testMethod void testcaseGDCTechIssueOps31()
         {implementaion123('Normal','Assigned');
        }
       static testMethod void testcaseGDCTechIssueOps32()
         {implementaion123('Normal','Open');
        }
       static testMethod void testcaseGDCTechIssueOps34()
         {implementaion123('Normal','Fixed');
         }
         
         ////// Anu addedd
         
        
}