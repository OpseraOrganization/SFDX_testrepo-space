@isTest 
public class TestCampaignHSEMappercls 
{
    static testMethod void CampaignHSEMappercls() 
    {
                
         RMU_VALUE__c testOfferings = new RMU_VALUE__c();
         testOfferings.Name='TestOfferings' ;                  
         insert testOfferings;
         
         //testOffer=[SELECT Id,Name FROM RMU_VALUE__c  WHERE Id = testOfferings.Id ];
       
        //PageReference pageRef = Page.yourVisualforcePage;

        Test.startTest();
        //Test.setCurrentPage(Page.Campaign_HSB_Mapper);

        //ApexPages.StandardController stdCont = new Apexpages.StandardController(testOfferings); 
        //ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lstOffer);
        //stdSetController.setSelected(lstOffer);   
        CampaignHSEMappercls ext= new CampaignHSEMappercls();                    

            //assert suitable results.
            //System.assertEquals(TestOfferings,testOffer.Name);
            System.assertEquals(testOfferings.Id,ext.acclst[0].Id); // here verify that controller variable is instantiated with the right value, ie previously inserted record
            Test.stopTest();
    }
}