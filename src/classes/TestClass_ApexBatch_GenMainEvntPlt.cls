/** * File Name:  TestClass_ApexShdlr_GenMainEvntPlt
* Description Test Method
* Class Tested: GenerateMaintEvent_Platform_C 
* Copyright : Wipro Technologies Limited Copyright (c) 2011
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private class TestClass_ApexBatch_GenMainEvntPlt {

    static testMethod void genMainEvntPltATest() {
    	
    	Platform__c testPltfrmRec = new Platform__c (
                Name='Test Platform for EventA', 
                ACHK_NUM__c = 10 ,
                A_Event_Duration__c=10,
                Avg_Flying_Hours_Per_Month__c =2
            );
        insert testPltfrmRec;    
        Test.StartTest();
        GenerateMaintEvent_Platform_A tstGenMaintEvntPltfrmA = new GenerateMaintEvent_Platform_A();
        tstGenMaintEvntPltfrmA.query='SELECT Id From Platform__c Where (ACHK_NUM__c > 0 OR A_Event_Duration__c > 0) AND Avg_Flying_Hors_Per_Year__c > 0 and ID=\''+testPltfrmRec.Id+'\'';
        ID batchprocessId = Database.executeBatch(tstGenMaintEvntPltfrmA);
        Test.StopTest();
    }
    static testMethod void genMainEvntPltBTest() {
        Platform__c testPltfrmRec = new Platform__c (
                Name='Test Platform for EventB', 
                BCHK_NUM__c = 10 ,
                B_Event_Duration__c=10,
                Avg_Flying_Hours_Per_Month__c =2
            );
        insert testPltfrmRec;    
        Test.StartTest();
        GenerateMaintEvent_Platform_B tstGenMaintEvntPltfrmB = new GenerateMaintEvent_Platform_B();
        tstGenMaintEvntPltfrmB.query='SELECT Id From Platform__c Where (BCHK_NUM__c > 0 OR B_Event_Duration__c > 0) AND Avg_Flying_Hors_Per_Year__c > 0 and ID=\''+testPltfrmRec.Id+'\'';
        ID batchprocessId = Database.executeBatch(tstGenMaintEvntPltfrmB);
        Test.StopTest();
    }
    static testMethod void genMainEvntPltCTest() {
        Platform__c testPltfrmRec = new Platform__c (
                Name='Test Platform for EventC', 
                CCHK_NUM__c = 10 ,
                C_Event_Duration__c=10,
                Avg_Flying_Hours_Per_Month__c =2
            );
        insert testPltfrmRec;    
        Test.StartTest();
        GenerateMaintEvent_Platform_C tstGenMaintEvntPltfrmC = new GenerateMaintEvent_Platform_C();
        tstGenMaintEvntPltfrmC.query='SELECT Id From Platform__c Where (CCHK_NUM__c > 0 OR C_Event_Duration__c > 0) AND Avg_Flying_Hors_Per_Year__c > 0 and ID=\''+testPltfrmRec.Id+'\'';
        ID batchprocessId = Database.executeBatch(tstGenMaintEvntPltfrmC);
        Test.StopTest();
    }
}