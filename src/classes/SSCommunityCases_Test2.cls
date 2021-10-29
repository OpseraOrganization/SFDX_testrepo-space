@isTest(seeAllData=true)
public class SSCommunityCases_Test2 {
    /************************************************Test Method 2********************************************************************/
   /* static testMethod void testSSCommunityCases2(){
        test.startTest();
        
        SSCommunityCases_Cntrl sc = new SSCommunityCases_Cntrl();
                 
        Technical_Videos__kav techVdoKav=[SELECT Id,Title FROM Technical_Videos__kav WHERE Language = 'en_US' AND PublishStatus = 'online' LIMIT 1];
        String stringTechVdoKav= string.valueOf(techVdoKav.id);
        system.debug('>>>>>>>>>>>>>stringTechVdoKav>>>>>>>>>>>>'+stringTechVdoKav);
        // Line 397
        //SSCommunityCases_Cntrl.getArticleOnClick(techVdoId);
        SSCommunityCases_Cntrl.getArticleOnClick(stringTechVdoKav);
        
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
        SSCommunityCases_Cntrl.AddComments(aCaseId,'dateCreated');
        
        CaseComment casCom1 = new CaseComment();
        casCom1.CommentBody = 'Test Case Comment Body';
        casCom1.ParentId=cas.id;
        casCom1.isPublished=false;
        insert casCom1;
                
        test.stopTest();
        
        
    }
       */ 
    
    
}