@isTest(Seealldata=true)
public class TestClass_GetAgreementURL
{
    public static testMethod void calloutSigningURLTest()
    {
       
        Test.startTest();
        
        Test.setMock(WebServiceMock.class, new GetAgreementURLMockImpl());
          GetAgreementURL.calloutSigningURL();                            
       /* echosign_dev1__SIGN_Agreement__c AgmtList = new echosign_dev1__SIGN_Agreement__c();
        AgmtList.Name='TestAgreement';
        AgmtList.Agreement_Sign_URL__c='';
        AgmtList.echosign_dev1__Background_Action__c = 'Send';
        AgmtList.echosign_dev1__DateSent__c = system.now().addMinutes(-45);
        AgmtList.echosign_dev1__Status__c = 'Draft';
        insert AgmtList;
        String tempid = AgmtList.id;
                   
        GetAgreementURL.calloutSigningURL(); 
        List<echosign_dev1__SIGN_Agreement__c> AgmtListTemp = [SELECT Id,Agreement_Sign_URL__c,echosign_dev1__Document_Key__c,echosign_dev1__Status__c 
        FROM echosign_dev1__SIGN_Agreement__c WHERE Id = :tempid];   
        tempid = AgmtListTemp.get(0).id;
        system.debug('Mrina Here'+AgmtListTemp.get(0).Agreement_Sign_URL__c);
        system.debug(AgmtListTemp.get(0).echosign_dev1__Document_Key__c);
        system.debug(AgmtListTemp.get(0).echosign_dev1__Status__c);
        */
        Test.stopTest();
   }
}