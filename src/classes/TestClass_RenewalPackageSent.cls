/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : TestClass_RenewalPackageSent
* Description           : Test Class to test the functionality of the trigger RenewalPackageSent.
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 24-Oct-2012      0.01           NTTData         Initial Version

***********************************************************************************************************/
@isTest(SeeAllData=true)
private class TestClass_RenewalPackageSent
{
    static testMethod void TestMthd_RenewalPackageSent()
    {
          
           account newAcct = new account();
        newAcct.name = 'test account code coverage';
        newAcct.type='Distributor';
        newAcct.Strategic_Business_Unit__c='ATR';
        insert newAcct;  
         
        Profile p = [select id from profile where name='ACS Sales' limit 1];
        User usr = new User();
        usr.alias = 'dhivya';
        usr.email = 'dhivya124553@test.com';
        usr.emailencodingkey='UTF-8';
        usr.lastname='testtddhhi';
        usr.languagelocalekey='en_US';
        usr.localesidkey='en_US';
        usr.profileid = p.Id;
        usr.timezonesidkey='America/Los_Angeles';
        usr.username='standarduserdhiv@testing.com';
        usr.isactive=true;
        insert usr;
          User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
          
          System.runAs ( usr )  {   
          Test.StartTest();   
    
        List<RecordType> rt = [select id from recordtype where (name='MSP Contracts' or name='HAPP/MPP Contracts') and SObjectType='Contract' ];
                
            
        
        Contract objContract = new Contract();
        objContract.recordtypeid = rt[1].id;
        objContract.name = 'Con1';
        objContract.AccountId = newAcct.id;
        objContract.Renewal_Package_Sent__c =null;
        objContract.Renewal_Package_Sent__c = date.parse('03/27/2011');
      
        insert objContract;
        
        date testdate = date.parse('03/27/2011');
      //  date agmtDate = date.parse('04/29/2012');
        
        objContract.name = 'Con2';
        update objContract;
   

      
        
    //   objContract.name = 'New Con Test';
     //   update objContract;
        
     Test.StopTest();
    }   
    
   }
}