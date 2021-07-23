@isTest
private class NCP_Utils_Test{

  @isTest
  static void TestIsUserAuthenticated(){
    Test.startTest();
    Boolean isAut = NCP_Utils.isUserAuthenticated();
    System.assertEquals(isAut,true);
    Test.stopTest();
  }

  @isTest
  static void TestGetUserDetails(){
    Test.startTest();
    String detail = NCP_Utils.getUserDetails();
    System.debug('### detail '+detail);
    System.assertNotEquals(Null,detail);
    Test.stopTest();
  }

  @isTest
  static void TestSearchRecords(){
    Test.startTest();
    Product2 pr = NCP_TestFactory.createProductWithName('Laptop');
    //Lets Assume we are writing Controller extension to use on List View of Account
    List<Object> searchList = NCP_Utils.searchRecords('Laptop','Product2');
    System.assertEquals(searchList.size(),1);
    Test.stopTest();
  }
  @isTest
  static void TestCheckEmail(){
    Test.startTest();
    Boolean isEmail = NCP_Utils.checkEmail('test@mail.com');
    System.assertEquals(isEmail,true);
    Test.stopTest();
  }

  @isTest
  static void TestSelectProducts(){
    Test.startTest();
    Product2 pr = NCP_TestFactory.createProductWithName('Laptop');
    List<sObject> prList = NCP_Utils.selectProducts();
    System.assertEquals(prList.size(),1);
    Test.stopTest();
  }
  
  @isTest
  static void TestIsSandbox(){
    Test.startTest();
    Boolean detail = NCP_Utils.isSandbox();
    Test.stopTest();
  }
  
   @isTest
   static void TestHasCommunityLicense(){
     Test.startTest();
     Boolean detail = NCP_Utils.hasCommunityLicense();
     Test.stopTest();
   }
   
   @isTest
   static void TestCommunitySetting(){
     Test.startTest();
     NCP_Utils.communitySetting();
     Test.stopTest();
   }   
   
   
   @isTest
   static void TestHasEntitlementRelationship(){
     Test.startTest();
     Boolean detail = NCP_Utils.hasEntitlementRelationship();
     Test.stopTest();
   }    
   
   @isTest
   static void TestsendEmail(){
     Test.startTest();
     
         EmailTemplate et ;
         Map<Id, List<String>> caseEmailList = new Map<Id, List<String>>();
         List<String> lString = new list<String> {'testemail@nokiatest.com','testemail2@nokiatest.com'};
         Case myCase;
         
        User adminAccount = NCP_TestFactory.createUser(true,'AES Admin Account',null, 'testAccount@nokia.com.dev');
        
        System.runAs(adminAccount){         
         
            Account acc = NCP_TestFactory.createAccount();
            Account acc2 = NCP_TestFactory.createLegalAccount(acc.Id);        
            Contact cont = NCP_TestFactory.createContact(acc); 
            cont.Email = 'support.portal@nokia.com';
            cont.Email_Change_Source__c = 'Customer/Account request (e.g Name or Domain change)' ;
            update cont ;
        }
        User admin = NCP_TestFactory.createUser(true,'AES Admin',null, 'test@nokia.com.dev');
        System.runAs(admin){
     
            et = new EmailTemplate (developerName = 'test', TemplateType= 'Text', Name = 'test',
                                                    FolderId = UserInfo.getUserId(),IsActive = TRUE);         
            insert et; 
        }    
        
        User admin123 = NCP_TestFactory.createUser(true,'AES Admin2',null, 'test2@nokia.com.dev');         
        System.runAs(admin123){
            myCase = NCP_TestFactory.createEntitlementCase(null,null,'CDB','PIC');
        }
        caseEmailList.put(myCase.Id,lString);
        
        User adminContact = NCP_TestFactory.createUser(true,'AES AdminContact',null, 'testContact@nokia.com.dev');
        System.runAs(adminContact){
            NCP_Utils.sendEmail(caseEmailList, 'test');
        }
     
     Test.stopTest();
   }    
   
   @isTest
   static void TestretRecordTypeID(){
     Test.startTest();
     ID detail = NCP_Utils.retRecordTypeID('Case', NCP_Constants.CASE_RT_DEVNAME_ENTITLEMENT );
     Test.stopTest();
   }   
   
  @isTest
  static void TestIsInternalUser(){
    System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {
    Account acc = NCP_TestFactory.createAccount();
    Account acc2 = NCP_TestFactory.createLegalAccount(acc.Id);
    Contact cont = NCP_TestFactory.createContact(acc);

    Test.startTest();
    User CustomerUser = NCP_TestFactory.createUser(false,'test',cont, 'test2@nokian.com.dev');
    insert CustomerUser;
    Boolean detail = NCP_Utils.isInternalUser();
    Test.stopTest();
    }
  }

  @isTest
  static void TestGetConnectedUser(){
    Test.startTest();
    User admin = NCP_TestFactory.createUser(true,'AES Admin',null, 'test@nokia.com.dev');
    System.runAs(admin){
      User conUser = NCP_Utils.getConnectedUser();
      System.assertNotEquals(conUser,null);
    }
    Test.stopTest();
  }
  /*
  @isTest
  static void TestGetUserName(){
    Test.startTest();
   // NCP_Utils.communitySetting();
   // Boolean detail = NCP_Utils.isSandbox();
    String userName = NCP_Utils.getUsername('testemail@nokiatest.com');
    Test.stopTest();
  }  
 */
}