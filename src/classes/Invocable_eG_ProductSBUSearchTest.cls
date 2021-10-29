@isTest 
private class Invocable_eG_ProductSBUSearchTest {
    static testMethod void approverIdsTest(){
      //Create Users for the SEA Approval Matrix
       Profile pf = [select id from profile where name='eGreensheet Approver'];    
       User u = new User();
           u.LastName = 'Approver Test User';
           u.Username = 'egreensheetApprover@test.com.honeywell';
           u.Email = 'Approver@test.com';
           u.Alias = 'appuser' ;
           u.CommunityNickname= 'approveruser';
           u.TimeZoneSidKey = 'America/Los_Angeles';
           u.LocaleSidKey='en_US';
           u.EmailEncodingKey= 'ISO-8859-1';
           u.ProfileId = pf.Id;
           u.LanguageLocaleKey = 'en_US';
           u.Functional_Role__c='testrole';
           u.SBU_User__c='testsbu';
           u.CBT__c='HTSI';
           u.CBT_Team__c ='testcbtteam';
       insert u; 
        
       User u2 = new User();
           u2.LastName = 'Approver Test User 2';
           u2.Username = 'egreensheetApprover2@test.com.honeywell';
           u2.Email = 'Approver2@test.com';
           u2.Alias = 'appuser2' ;
           u2.CommunityNickname= 'approveruser2';
           u2.TimeZoneSidKey = 'America/Los_Angeles';
           u2.LocaleSidKey='en_US';
           u2.EmailEncodingKey= 'ISO-8859-1';
           u2.ProfileId = pf.Id;
           u2.LanguageLocaleKey = 'en_US';
           u2.Functional_Role__c='testrole';
           u2.SBU_User__c='testsbu';
           u2.CBT__c='HTSI';
           u2.CBT_Team__c ='testcbtteam';
       insert u2; 
        
      //Add approvers to SEA Approval Matrix where Type = Product Approver
      Approver__c a = new Approver__c();
        a.Name = 'Approver Test user';
        a.Approver_Name__c = u.Id;
        a.Approver_type__c = 'Product Approver';
        a.Tier__c = 'Tier II';
        string productSBU = 'Electronic Solutions';
        a.Product_SBU__c = productSBU;
       insert a;
        
      Approver__c a2 = new Approver__c();
        a2.Name = 'Approver Test user 2';
        a2.Approver_Name__c = u2.Id;
        a2.Approver_type__c = 'Product Approver';
        a2.Tier__c = 'Tier II';
        string productSBU2 = 'Electronic Solutions; Engines & Power Systems';
        a.Product_SBU__c = productSBU2;
       insert a2;
        
      //Add eGreensheet record test 1
      Workflow_details__c eg = new Workflow_details__c();
        string productSBUeg = 'Electronic Solutions';
        eg.Product_SBU__c = productSBUeg;
        eg.Sales_Channel__c = 'Americas AM';
        eg.Wokflow_Name__c = 'Test eGreensheet';
       // eg.Customer_Name__c
        eg.Approval_Level_Required__c = 'Tier II';
        eg.Sales_K__c = 0;
        eg.X5_Year_Revenue_K__c = 0;
        eg.Terms_and_Conditions__c = 'Standard';
        eg.Front_End_Loss__c = 0;
        eg.Exposed_Cost__c = 0;
        eg.Documentum__c = 'test.com';
      insert eg;
        
      //Send through eGreensheet record into class
        String productSBUSearchString = eg.Id+','+eg.Approval_Level_Required__c;
     	List<String> productSBUSearch = new List<String>();
		productSBUSearch.add(productSBUSearchString);
        Invocable_eG_ProductSBUSearch.approverIds(productSBUSearch);
        system.debug(productSBUSearch);
        
        
      //Add eGreensheet record test 2
      Workflow_details__c eg2 = new Workflow_details__c();
        string productSBUeg2 = 'Other Aero';
        eg2.Product_SBU__c = productSBUeg2;
        eg2.Sales_Channel__c = 'Americas AM';
        eg2.Wokflow_Name__c = 'Test eGreensheet';
       // eg.Customer_Name__c
        eg2.Approval_Level_Required__c = 'Tier II';
        eg2.Sales_K__c = 0;
        eg2.X5_Year_Revenue_K__c = 0;
        eg2.Terms_and_Conditions__c = 'Standard';
        eg2.Front_End_Loss__c = 0;
        eg2.Exposed_Cost__c = 0;
        eg2.Documentum__c = 'test.com';
      insert eg2;
       
         //Send through invalid eGreensheet record
        String productSBUSearchString2 = eg2.Id+','+eg2.Approval_Level_Required__c;
     	List<String> productSBUSearch2 = new List<String>();
		productSBUSearch2.add(productSBUSearchString2);
        Invocable_eG_ProductSBUSearch.approverIds(productSBUSearch2);
                     
    }                                                               
}