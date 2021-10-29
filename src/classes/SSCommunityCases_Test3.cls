@isTest(seeAllData=true)
public class SSCommunityCases_Test3 {
    /***********************************************Test Method 3**********************************************************/
   /* static testMethod void testSSCommunityCases3(){
        test.startTest();
        
        SSCommunityCases_Cntrl sc = new SSCommunityCases_Cntrl();

        Live_Agent_Article__kav lak =[SELECT id FROM Live_Agent_Article__kav lak WHERE Language = 'en_US' AND PublishStatus = 'online' LIMIT 1];
        String lakID = String.valueOf(lak.Id);
        system.debug('<<<<lakID>>>>'+lakID);
        system.debug('<<<<lak>>>>'+lak);
        system.debug('<<<<lak.Id>>>>'+lak.Id);
        
        // Page 397  (ka0e)
        SSCommunityCases_Cntrl.getArticleOnClick(lakId);
        
        Case cas = new Case();
        cas.subject='Test Case Subject';
        cas.Description='Test Case Description';
        cas.Status='OPEN';
        cas.Classification__c='Test Classsification';
        cas.Origin='phone';
        //cas.No_FCR_Reason__c='AOG';For Ticket INC000009687923
        insert cas;
        
        String aCaseId=String.valueOf(cas.Id);
        
        // For Line 198 
        SSCommunityCases_Cntrl.AddComments(aCaseId,'status');
        
        test.stopTest();
        
        
    }

    */
   
}