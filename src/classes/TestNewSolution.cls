/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestNewSolution {

    static testMethod void myUnitTest() {
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(LastName = 'Test UserSol',Username = 'tu1cso@test.com',
        Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1sol' ,
        TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
        ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr;
        Contact con = [select ID, accountId from Contact limit 1];
        Case  caserec = new Case();
        caserec.Export_Compliance_Content_ITAR_EAR__c='abc';
        caserec.Status='complete';
        caserec.HON_Commit_Date__c =system.today();
        caserec.Government_Compliance_SM_M_Content__c ='GTO DS';
        caserec.Classification__c='GTO';
         caserec.AccountId = con.accountId;
        caserec.Contact = con;
        caserec.Product_Type__c ='abc';
        caserec.Supported_Product__c ='def';
        caserec.Catalog_Product_Group__c ='aa';
        caserec.Description='';
        caserec.Resolution__c='';
        caserec.Origin = 'Email'; 
        caserec.Subject = '6:TestMethod';
        insert caserec;
        
        Solution newsol = [select id,SolutionName,SolutionNumber,Status,Categorization__c,Product_Support_Engineer_Email__c,SBL_Solution_Legacy_Number__c,RecordTypeid,Approved_Date__c,Export_Controlled__c,Secure_Notes__c,FAQ__c,SolutionNote,Product_Type__c,Catalog_Product_Group__c,Supported_Product__c,Primary__c,Secondary__c,Product_Number__c,Audit_Frequency__c,Publish_Internal__c,Intellectual_Property_Review_By__c,Export_Review_Complete_NLR__c,Export_Review_Date__c,Expiration_Date__c,Publish_External__c,Intellectual_Property_Review_Date__c,Export_Review_By__c,Standards_Review_Approved_By__c,Technical_Review_Audit_Approved_By__c,Technical_Review_Approved_By__c,Approver__c,Approver_Name__c,Rejected_By__c,Legacy_Created_by__c,Legacy_Created_Date__c,Legacy_Solution_Approval_Date__c,Legacy_Last_Modified_by__c,Legacy_Last_Modifed_Date__c from solution where SolutionName != null limit 1];
        List<Platform__c> plat = [select id, Name from platform__c where name like  'A%' limit 1];
        RecordType rec =[Select r.Name, r.Id From RecordType r where name = 'Solution Record Type'   or name = 'Solution GTO Technical' limit 1];
        
        PageReference pageRef  = Page.Solution_Page;  
        pageRef.getParameters().put('id', newsol.id);
        pageRef.getParameters().put('cas',caserec.Id); 
        pageRef.getParameters().put('rec',rec.id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController std = new ApexPages.StandardController(newsol);  
        new_solution_class soln = new new_solution_class(std);
        System.debug(plat);   
        soln.getSol();                                                  
        soln.getvalues();
        soln.list2 = 'A-E';
        soln.navigate();
        soln.list2 = 'F-J';
        soln.navigate();
        soln.list2 = 'K-O';
        soln.navigate();
        soln.list2 = 'P-T';
        soln.navigate();
        soln.list2 = 'U-Z';
        soln.navigate();
      //soln.ok();
        soln.bl =false;
        soln.docancel();
        soln.dosave();
      // soln.doSaveandNew();
        soln.list1 = plat;
        soln.getvalues();
        soln.getlist1();
        soln.getevallist();
        boolean b = soln.getevallist();
        solution s = soln.getsol();
        soln.setsol(s);
  

      }
      
  static testMethod void myUnitTest3() {
       
        Contact con = [select ID, accountId from Contact limit 1];
        Case  caserec = new Case();
        RecordType rec =[Select r.Name, r.Id From RecordType r where name = 'Solution Record Type'   or name = 'Solution GTO Technical' limit 1];
        caserec.Export_Compliance_Content_ITAR_EAR__c='abc';
        caserec.Status='complete';
        caserec.HON_Commit_Date__c =system.today();
        caserec.Government_Compliance_SM_M_Content__c ='GTO DS';
        caserec.Classification__c='GTO';
        caserec.AccountId = con.accountId;
        caserec.Contact = con;
        caserec.Product_Type__c ='ss';
        caserec.Supported_Product__c ='ss1';
        caserec.Catalog_Product_Group__c ='ss1';
        caserec.Description='ss';
        caserec.Resolution__c='s';
        caserec.Origin = 'Email'; 
        caserec.Subject = '6:TestMethod';
        insert caserec;
        system.debug('casereccasereccaserec test -- '+caserec);
        test.starttest();
        Solution newsol=new Solution();
        newsol.SolutionName='TestSol';
        newsol.Catalog_Product_Group__c = 'ABC';
        newsol.Supported_Product__c='ABC';
        newsol.Catalog_Product_Group__c = 'Hello'; 
        newsol.Export_Controlled__c='Yes';
        newsol.Secure_Notes__c='Test';     
        
        //newsol.RecordTypeId='01230000000T0tG';
        newsol.Export_Review_Date__c=System.today();
        newsol.Export_Review_By__c=Userinfo.getUserId();
        newsol.Publish_External__c = TRUE;
        insert newsol;
        PageReference pageRef  = Page.Solution_Page;  
        pageRef.getParameters().put('id', newsol.id); 
        pageRef.getParameters().put('rec',rec.Id);
         pageRef.getParameters().put('cas',caserec.Id);
        Test.setCurrentPage(pageRef);
        //ApexPages.CurrentPage().getParameters().Put('id',newsol.id); 
         //ApexPages.CurrentPage().getParameters().Put('solno',newsol.SolutionNumber);   
        ApexPages.StandardController std = new ApexPages.StandardController(newsol);  
        
        new_solution_class soln = new new_solution_class(std);
        
     //   soln.doSave();
        soln.bl = false;
       soln.doSaveandNew();
        test.stoptest();
        soln.getSol();                                                 
        soln.docancel();                                       
        soln.getvalues();
        soln.list2 = 'A-E';
        soln.navigate();
        soln.list2 = 'F-J';
        soln.navigate();
        soln.list2 = 'K-O';
        soln.navigate();
        soln.list2 = 'P-T';
        soln.navigate();
        soln.list2 = 'U-Z';
        soln.navigate();
        soln.getvalues();
        soln.getlist1();
        soln.getevallist();
        boolean b = soln.getevallist();
     
        solution s = soln.getsol();
        soln.setsol(s);
   // soln.ok();
  //  update newsol;
    }
}