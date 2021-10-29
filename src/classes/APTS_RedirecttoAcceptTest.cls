@isTest
public class APTS_RedirecttoAcceptTest 
{
    public static testMethod void testAccept() 
    {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        User usr = new User(LastName = 'Test1',
                           FirstName='Test2',
                           Alias = 'jliv',
                           Email = 'Test1.Test2@sfdc.com',
                           Username = 'Test1.Test2@sfdc.com',
                           EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',
                           LocaleSidKey='en_US', ProfileId = profileId.Id,
                           TimeZoneSidKey='America/Los_Angeles');
         System.RunAs(usr)
        {                  
        Account objA= new Account();
        objA.name='Test';
        insert objA;
        Apttus_Proposal__Proposal__c objp= new Apttus_Proposal__Proposal__c();
        objp.Apttus_Proposal__Account__c=objA.id;
        insert objp;
        
                           
        APTS_User_Session_Proposal__c ObjU = new APTS_User_Session_Proposal__c();
        objU.Proposal_Record_id__c = objp.Id;
        objU.User_Session_id__c = userinfo.getsessionID();
        
        Insert ObjU;
        Update objU;
        
        Id proposalId = (Id)objp.get('id');
        PageReference pageRef = new PageReference('/' + proposalId);
        Test.setCurrentPage(pageRef);
      
        ApexPages.StandardController standardController  = new ApexPages.StandardController(objp);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', proposalId);
        APTS_RedirecttoAccept controller = new APTS_RedirecttoAccept(standardController); 
        controller.ProoposalDetails();
        }
    }
    
    public static testMethod void testAccept_Billto() 
    {
        Account objA= new Account();
        objA.name='Test';
        insert objA;
        Apttus_Proposal__Proposal__c objp= new Apttus_Proposal__Proposal__c();
        objp.Apttus_QPConfig__ShipToAccountId__c=objA.id;
        insert objp;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Developer Administrator (Non US)' LIMIT 1];
        
        User usr = new User(LastName = 'Test1',
                           FirstName='Test2',
                           Alias = 'jliv',
                           Email = 'Test1.Test2@sfdc.com',
                           Username = 'Test1.Test2@sfdc.com',
                           ProfileId = profileId.id);
                           
        APTS_User_Session_Proposal__c ObjU = new APTS_User_Session_Proposal__c();
        objU.Proposal_Record_id__c = objp.Id;
        objU.User_Session_id__c = usr.id;
        
        Insert ObjU;
        Update objU;
        Id proposalId = (Id)objp.get('id');
        PageReference pageRef = new PageReference('/' + proposalId);
        Test.setCurrentPage(pageRef);
      
        ApexPages.StandardController standardController  = new ApexPages.StandardController(objp);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', proposalId);
        APTS_RedirecttoAccept controller = new APTS_RedirecttoAccept(standardController); 
        controller.ProoposalDetails();
    }
    
    public static testMethod void testAccept_shipto() 
    {
        Account objA= new Account();
        objA.name='Test';
        insert objA;
        Apttus_Proposal__Proposal__c objp= new Apttus_Proposal__Proposal__c();
        objp.Apttus_QPConfig__BillToAccountId__c=objA.id;
        insert objp;
        
        APTS_User_Session_Proposal__c ObjU = new APTS_User_Session_Proposal__c();
        objU.Proposal_Record_id__c = objp.Id;
        objU.User_Session_id__c = userinfo.getuserid();
        
        Insert ObjU;
        Update objU;
        Id proposalId = (Id)objp.get('id');
        PageReference pageRef = new PageReference('/' + proposalId);
        Test.setCurrentPage(pageRef);
      
        ApexPages.StandardController standardController  = new ApexPages.StandardController(objp);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', proposalId);
        APTS_RedirecttoAccept controller = new APTS_RedirecttoAccept(standardController); 
        controller.ProoposalDetails();
    }
    
    public static testMethod void testAccept_ICAO() 
    {
        Account objA= new Account();
        objA.name='Test';
        objA.ICAO_Code__c='1234';
        insert objA;
        Apttus_Proposal__Proposal__c objp= new Apttus_Proposal__Proposal__c();
        objp.Apttus_Proposal__Account__c=objA.id;
        insert objp;
        
        APTS_User_Session_Proposal__c ObjU = new APTS_User_Session_Proposal__c();
        objU.Proposal_Record_id__c = objp.Id;
        objU.User_Session_id__c = userinfo.getuserid();
        
        Insert ObjU;
        Update objU;
        Id proposalId = (Id)objp.get('id');
        PageReference pageRef = new PageReference('/' + proposalId);
        Test.setCurrentPage(pageRef);
      
        ApexPages.StandardController standardController  = new ApexPages.StandardController(objp);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', proposalId);
        APTS_RedirecttoAccept controller = new APTS_RedirecttoAccept(standardController); 
        controller.ProoposalDetails();
    }
    
    public static testMethod void testAccept_Billto_ICAO() 
    {
        Account objA= new Account();
        objA.name='Test';
        objA.ICAO_Code__c='1234';
        insert objA;
        Apttus_Proposal__Proposal__c objp= new Apttus_Proposal__Proposal__c();
        objp.Apttus_QPConfig__ShipToAccountId__c=objA.id;
        insert objp;
        
        APTS_User_Session_Proposal__c ObjU = new APTS_User_Session_Proposal__c();
        objU.Proposal_Record_id__c = objp.Id;
        objU.User_Session_id__c = userinfo.getuserid();
        
        Insert ObjU;
        Update objU;
        Id proposalId = (Id)objp.get('id');
        PageReference pageRef = new PageReference('/' + proposalId);
        Test.setCurrentPage(pageRef);
      
        ApexPages.StandardController standardController  = new ApexPages.StandardController(objp);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', proposalId);
        APTS_RedirecttoAccept controller = new APTS_RedirecttoAccept(standardController); 
        controller.ProoposalDetails();
    }
    
    public static testMethod void testAccept_shipto_ICAO() 
    {
        Account objA= new Account();
        objA.name='Test';
        objA.ICAO_Code__c='1234';
        insert objA;
        Apttus_Proposal__Proposal__c objp= new Apttus_Proposal__Proposal__c();
        objp.Apttus_QPConfig__BillToAccountId__c=objA.id;
        insert objp;
        
        APTS_User_Session_Proposal__c ObjU = new APTS_User_Session_Proposal__c();
        objU.Proposal_Record_id__c = objp.Id;
        objU.User_Session_id__c = userinfo.getuserid();
        
        Insert ObjU;
        Update objU;
        Id proposalId = (Id)objp.get('id');
        PageReference pageRef = new PageReference('/' + proposalId);
        Test.setCurrentPage(pageRef);
      
        ApexPages.StandardController standardController  = new ApexPages.StandardController(objp);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', proposalId);
        APTS_RedirecttoAccept controller = new APTS_RedirecttoAccept(standardController); 
        controller.ProoposalDetails();
    }
    
    public static testMethod void testAccept_BS() 
    {
        Account objA= new Account();
        objA.name='Test';
        objA.ICAO_Code__c='1234';
        objA.BillingStreet='test';
        objA.BillingCountry='tes1';
        insert objA;
        Apttus_Proposal__Proposal__c objp= new Apttus_Proposal__Proposal__c();
        objp.Apttus_Proposal__Account__c=objA.id;
        insert objp;
        
        APTS_User_Session_Proposal__c ObjU = new APTS_User_Session_Proposal__c();
        objU.Proposal_Record_id__c = objp.Id;
        objU.User_Session_id__c = userinfo.getuserid();
        
        Insert ObjU;
        Update objU;
        Id proposalId = (Id)objp.get('id');
        PageReference pageRef = new PageReference('/' + proposalId);
        Test.setCurrentPage(pageRef);
      
        ApexPages.StandardController standardController  = new ApexPages.StandardController(objp);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', proposalId);
        APTS_RedirecttoAccept controller = new APTS_RedirecttoAccept(standardController); 
        controller.ProoposalDetails();
    }
    
    public static testMethod void testAccept_Billto_BS() 
    {
        Account objA= new Account();
        objA.name='Test';
        objA.ICAO_Code__c='1234';
        objA.BillingStreet='test';
        insert objA;
        Apttus_Proposal__Proposal__c objp= new Apttus_Proposal__Proposal__c();
        objp.Apttus_QPConfig__ShipToAccountId__c=objA.id;
        insert objp;
        
        APTS_User_Session_Proposal__c ObjU = new APTS_User_Session_Proposal__c();
        objU.Proposal_Record_id__c = objp.Id;
        objU.User_Session_id__c = userinfo.getuserid();
        
        Insert ObjU;
        Update objU;
        Id proposalId = (Id)objp.get('id');
        PageReference pageRef = new PageReference('/' + proposalId);
        Test.setCurrentPage(pageRef);
      
        ApexPages.StandardController standardController  = new ApexPages.StandardController(objp);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', proposalId);
        APTS_RedirecttoAccept controller = new APTS_RedirecttoAccept(standardController); 
        controller.ProoposalDetails();
    }
    
    public static testMethod void testAccept_shipto_BCity() 
    {
        Account objA= new Account();
        objA.name='Test';
        objA.ICAO_Code__c='1234';
        objA.BillingStreet='test';
        objA.BillingCity='test';
        insert objA;
        Apttus_Proposal__Proposal__c objp= new Apttus_Proposal__Proposal__c();
        objp.Apttus_QPConfig__BillToAccountId__c=objA.id;
        insert objp;
       
        APTS_User_Session_Proposal__c ObjU = new APTS_User_Session_Proposal__c();
        objU.Proposal_Record_id__c = objp.Id;
        objU.User_Session_id__c = userinfo.getuserid();
        
        Insert ObjU;
         Update objU;
        Id proposalId = (Id)objp.get('id');
        PageReference pageRef = new PageReference('/' + proposalId);
        Test.setCurrentPage(pageRef);
      
        ApexPages.StandardController standardController  = new ApexPages.StandardController(objp);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', proposalId);
        APTS_RedirecttoAccept controller = new APTS_RedirecttoAccept(standardController); 
        controller.ProoposalDetails();
    }
    
    public static testMethod void testAccept_Billto_BCity() 
    {
        Account objA= new Account();
        objA.name='Test';
        objA.ICAO_Code__c='1234';
        objA.BillingStreet='test';
        objA.BillingCity='test';
       
        insert objA;
        Apttus_Proposal__Proposal__c objp= new Apttus_Proposal__Proposal__c();
        objp.Apttus_QPConfig__ShipToAccountId__c=objA.id;
        insert objp;
        
        APTS_User_Session_Proposal__c ObjU = new APTS_User_Session_Proposal__c();
        objU.Proposal_Record_id__c = objp.Id;
        objU.User_Session_id__c = userinfo.getuserid();
        
        Insert ObjU;
        Update objU;
        Id proposalId = (Id)objp.get('id');
        PageReference pageRef = new PageReference('/' + proposalId);
        Test.setCurrentPage(pageRef);
      
        ApexPages.StandardController standardController  = new ApexPages.StandardController(objp);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', proposalId);
        APTS_RedirecttoAccept controller = new APTS_RedirecttoAccept(standardController); 
        controller.ProoposalDetails();
    }
    
    public static testMethod void testAccept_shipto_BCity1() 
    {
        Account objA= new Account();
        objA.name='Test';
        objA.ICAO_Code__c='1234';
        objA.BillingStreet='test';
        
        insert objA;
        Apttus_Proposal__Proposal__c objp= new Apttus_Proposal__Proposal__c();
        objp.Apttus_QPConfig__BillToAccountId__c=objA.id;
        insert objp;
        
        APTS_User_Session_Proposal__c ObjU = new APTS_User_Session_Proposal__c();
        objU.Proposal_Record_id__c = objp.Id;
        objU.User_Session_id__c = userinfo.getuserid();
        
        Insert ObjU;
        Update objU;
        Id proposalId = (Id)objp.get('id');
        PageReference pageRef = new PageReference('/' + proposalId);
        Test.setCurrentPage(pageRef);
      
        ApexPages.StandardController standardController  = new ApexPages.StandardController(objp);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', proposalId);
        APTS_RedirecttoAccept controller = new APTS_RedirecttoAccept(standardController); 
        controller.ProoposalDetails();
    }
     public static testMethod void testAccept_TwoUsers() 
    {
        
        Account objA= new Account();
        objA.Name = 'Test123';
        objA.ICAO_Code__c='1234';
        objA.BillingStreet='test';
        objA.BillingCity='test';
        objA.BillingCountry='tes1';
        insert objA;
        
        Apttus_Proposal__Proposal__c objp= new Apttus_Proposal__Proposal__c();
        objp.Apttus_Proposal__Account__c=objA.id;
        objp.Apttus_Proposal__Approval_Stage__c ='Presented';
        insert objp;
        
        objp.Apttus_Proposal__Approval_Stage__c ='Approved';
        Update objp;
        
        APTS_User_Session_Proposal__c ObjU = new APTS_User_Session_Proposal__c();
        objU.Proposal_Record_id__c = objp.Id;
        objU.User_Session_id__c = userinfo.getuserid();
        
        Insert ObjU;
        Update objU;
             
        Id proposalId = (Id)objp.get('id');
        PageReference pageRef = new PageReference('/' + proposalId);
        Test.setCurrentPage(pageRef);
                        
        ApexPages.StandardController standardController  = new ApexPages.StandardController(objp);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', proposalId);
        APTS_RedirecttoAccept controller = new APTS_RedirecttoAccept(standardController); 
                      
        controller.ProoposalDetails();
       
       
        }
}