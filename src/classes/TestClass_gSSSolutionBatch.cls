@isTest
class TestClass_gSSSolutionBatch{
    // For single record
    static testMethod void validateGSSSolutionBatch(){
        //Start -Create test data
        RecordType RecType = [Select Id From RecordType  Where SobjectType = 'Solution' and DeveloperName = 'GSS_Solution'];
        Id gssSolutionRTID = RecType.Id; 
        List<Solution> listSols = new List<Solution>();
        if(gssSolutionRTID != null){
        Solution sol1 = new Solution(SolutionName='Sol1',RecordTypeID=gssSolutionRTID, Audit_Frequency__c='18 Months',Status='Approved');
        listSols.add(sol1);
        Solution sol2 = new Solution(SolutionName='Sol2',RecordTypeID=gssSolutionRTID, Audit_Frequency__c='Monthly',Status='Approved');
        listSols.add(sol2);
        Solution sol3 = new Solution(SolutionName='Sol3',RecordTypeID=gssSolutionRTID, Audit_Frequency__c='Weekly',Status='Approved', Content_Review_Approval_Date__c= System.Today()-7);
        listSols.add(sol3);
        Solution sol4 = new Solution(SolutionName='Sol4',RecordTypeID=gssSolutionRTID, Audit_Frequency__c='Bi-Weekly',Status='Approved');
        listSols.add(sol4);
        Solution sol5 = new Solution(SolutionName='Sol5',RecordTypeID=gssSolutionRTID, Audit_Frequency__c='Annually',Status='Approved');
        listSols.add(sol5);
        Solution sol6 = new Solution(SolutionName='Sol6',RecordTypeID=gssSolutionRTID, Audit_Frequency__c='Semi-Annual',Status='Approved');
        listSols.add(sol6);
        Solution sol7 = new Solution(SolutionName='Sol7',RecordTypeID=gssSolutionRTID, Audit_Frequency__c='Biennal',Status='Approved');
        listSols.add(sol7);
        Solution sol8 = new Solution(SolutionName='Sol8',RecordTypeID=gssSolutionRTID, Audit_Frequency__c='Quarterly',Status='Approved');
        listSols.add(sol8);
        
        insert listSols;
        
        sol1.Content_Review_Approval_Date__c= System.Today()-540;
        update sol1;
        sol2.Content_Review_Approval_Date__c= System.Today()-30;
        update sol2;
        sol3.Content_Review_Approval_Date__c= System.Today()-7;
        update sol3;
        sol4.Content_Review_Approval_Date__c= System.Today()-14;
        update sol4;
        sol5.Content_Review_Approval_Date__c= System.Today()-365;
        update sol5;
        sol6.Content_Review_Approval_Date__c= System.Today()-180;
        update sol6;
        sol7.Content_Review_Approval_Date__c= System.Today()-730;
        update sol7;
        sol8.Content_Review_Approval_Date__c= System.Today()-90;
        update sol8;

        //End-Create test data
        
        //Start -Test
        Test.startTest();
        
        gSSSolutionBatch solbatch = new gSSSolutionBatch();
        Database.executebatch(solbatch,200);
        
        Test.stopTest();
        //End -Test
        
        //Start Validate Test
        List<Solution> solTests = [select id, Status from Solution where id =: sol1.id or id =: sol2.id or id =: sol3.id or id =: sol4.id or id =: sol5.id or id =: sol6.id or id =: sol7.id or id =: sol8.id];
        //List<Solution> solTests = [select id, Status from Solution where id =: sol3.id]; // or id =: sol2.id or id =: sol3.id or id =: sol4.id or id =: sol5.id or id =: sol6.id or id =: sol7.id or id =: sol8.id];
        System.assertEquals('Audit',solTests[0].Status);
        System.assertEquals('Audit',solTests[1].Status);
        System.assertEquals('Audit',solTests[3].Status);
        System.assertEquals('Audit',solTests[3].Status);
        System.assertEquals('Audit',solTests[4].Status);
        System.assertEquals('Audit',solTests[5].Status);
        System.assertEquals('Audit',solTests[6].Status);
        System.assertEquals('Audit',solTests[7].Status); 
        
        //End Validate Test
        }
    }
    
    static testMethod void validateGSSSolutionForBatch(){
        //Start -Create test data
        RecordType RecType = [Select Id From RecordType  Where SobjectType = 'Solution' and DeveloperName = 'GSS_Solution'];
        Id gssSolutionRTID = RecType.Id; 
        Solution sol = new Solution();
        List<Solution> listSols = new List<Solution>(); 
        for(Integer i=0;i<200;i++){
            sol = new Solution(SolutionName='Sol' + i,RecordTypeID=gssSolutionRTID, Audit_Frequency__c='18 Months',Status='Approved');
            listSols.add(sol);
        }
        insert listSols;
        List<Solution> updateSols = new List<Solution>();
        
        for(Solution soltn:listSols){
            
            soltn.Content_Review_Approval_Date__c = System.Today()-540;
            updateSols.add(soltn);
        }
        update updateSols;
        //End-Create test data
        //Start -Test
        Test.startTest();
        
        gSSSolutionBatch solbatch = new gSSSolutionBatch();
        Database.executebatch(solbatch,200);
        
        Test.stopTest();
        //End -Test
        
        //Start Validate Test
        Set<id> setSolIds = new Set<id>();
        for(Solution sl:listSols)
            setSolIds.add(sl.id);
        List<Solution> solTests = [select id, Status from Solution where id in: setSolIds];
        for(Solution solTest: solTests)
            System.assertEquals('Audit',solTest.Status);
        //End Validate Test
    }
}