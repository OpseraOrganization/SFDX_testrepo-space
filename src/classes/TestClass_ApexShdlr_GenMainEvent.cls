/** * File Name:  TestClass_ApexShdlr_GenMainEvent
* Description Test Method
* Class Tested: GenMaintEvent_A_Scheduler, GenMaintEvent_B_Scheduler , GenMaintEvent_C_Scheduler
* Copyright : Wipro Technologies Limited Copyright (c) 2011
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
public with sharing class TestClass_ApexShdlr_GenMainEvent {

    static testMethod void genMainEventATest(){
            Platform__c testPltfrmRec = new Platform__c (
                Name='Test Platform for EventA', 
                ACHK_NUM__c = 10 ,
                A_Event_Duration__c=10,
                Avg_Flying_Hours_Per_Month__c =2
            );
            insert testPltfrmRec;
            Test.startTest();
            GenMaintEvent_A_Scheduler genMainEventAShdlr =new GenMaintEvent_A_Scheduler();
            String Shdlr='0 0 23 * * ?';  
            System.schedule('Test GenMaintEvent_A  Scheduling',Shdlr,genMainEventAShdlr);
            Test.stoptest();
    }
    static testMethod void genMainEventBTest(){
            Platform__c testPltfrmRec = new Platform__c (
                Name='Test Platform for EventB', 
                ACHK_NUM__c = 10 ,
                A_Event_Duration__c=10,
                Avg_Flying_Hours_Per_Month__c =2
            );
            insert testPltfrmRec;
            Test.startTest();
            GenMaintEvent_B_Scheduler genMainEventBShdlr =new GenMaintEvent_B_Scheduler();
            String Shdlr='0 0 23 * * ?';  
            System.schedule('Test GenMaintEvent_B  Scheduling',Shdlr,genMainEventBShdlr);
            Test.stoptest();
    }
    static testMethod void genMainEventCTest(){
            Platform__c testPltfrmRec = new Platform__c (
                Name='Test Platform for EventC', 
                ACHK_NUM__c = 10 ,
                A_Event_Duration__c=10,
                Avg_Flying_Hours_Per_Month__c =2
            );
            insert testPltfrmRec;
            Test.startTest();
            GenMaintEvent_C_Scheduler genMainEventCShdlr =new GenMaintEvent_C_Scheduler();
            String Shdlr='0 0 23 * * ?';  
            System.schedule('Test GenMaintEvent_C  Scheduling',Shdlr,genMainEventCShdlr);
            Test.stoptest();
    }
}