@isTest
private class TestSolutionRedirect  {

    static testMethod void SolutionRedirectTest() {
     Profile pf= [select id from Profile where name = 'Training – AERO Administrators'];
        User usr = new User(LastName = 'Test UserSol',Username = 'tu1cso@test.com',
        Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1sol' ,
        TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
        ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr;
     
     
        Profile pf1= [select id from Profile where name = 'System Administrator'];
        User usr1 = new User(LastName = 'Test UserSoldd',Username = 'tu1cso@testdd.com',
        Email = 'testuser@test.com',Alias = 'tdu1' ,CommunityNickname= 'tu1sodl' ,
        TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
        ProfileId = pf1.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr1; 
      Solution newsol = [select id,SolutionName,SolutionNumber,Status,Categorization__c,
      Product_Support_Engineer_Email__c,SBL_Solution_Legacy_Number__c,RecordTypeid,Approved_Date__c,
      Export_Controlled__c,Secure_Notes__c,FAQ__c,SolutionNote,Product_Type__c,Catalog_Product_Group__c,Supported_Product__c,Primary__c,Secondary__c,
      Product_Number__c,Audit_Frequency__c,Publish_Internal__c,Intellectual_Property_Review_By__c,
      Export_Review_Complete_NLR__c,Export_Review_Date__c,Expiration_Date__c,Publish_External__c,
      Intellectual_Property_Review_Date__c,Export_Review_By__c,Standards_Review_Approved_By__c,
      Technical_Review_Audit_Approved_By__c,Technical_Review_Approved_By__c,Approver__c,Approver_Name__c,
      Rejected_By__c,Legacy_Created_by__c,Legacy_Created_Date__c,Legacy_Solution_Approval_Date__c,
      Legacy_Last_Modified_by__c,Legacy_Last_Modifed_Date__c from solution where SolutionName != null limit 1];
     
     System.runas(usr){      
        PageReference pageRef  = Page.Solution_Override;  
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController std = new ApexPages.StandardController(newsol);  
        SolutionRedirect soln = new SolutionRedirect(std);
       soln.checkprofile();
     }  
     
      System.runas(usr1){           
        PageReference pageRef1  = Page.Solution_Override;  
        Test.setCurrentPage(pageRef1);
        ApexPages.StandardController std1 = new ApexPages.StandardController(newsol);  
        SolutionRedirect soln1 = new SolutionRedirect(std1);
       soln1.checkprofile();
     }  
     
     
    }
    
    }