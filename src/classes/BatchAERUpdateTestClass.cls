/*******************************************************************************
Name                        : BatchAERUpdateTestClass 
Created By                  : Haritha Lekkala
Company Name                : HoneyWell
Project                     : Aero Sales  
Created Date                : 2/27/2017    
Usages                      : This is a test class that will do the test coverage for BatchAERUpdate Batchclass
                                and BatchAERUpdateSchedule classes
Modification History        :
Date            Version No.     Modified by     Brief Description of Modification
1/3/2017        1.1            Haritha          Commented aer.RMU_Platform__c = rmu.id;line as part of CRQ000000163236.
*******************************************************************************/
@isTest
private class BatchAERUpdateTestClass{
    static testMethod void testBatchAERUpdateBatch(){
    
        RMU_VALUE__c rmuvalue = new RMU_VALUE__c(name='Test RMU Value');
        insert rmuvalue;
        
        OFFERING_MAPPER__c rmu = new OFFERING_MAPPER__c(name='Test RMU');
        rmu.RMU_VALUE__c = rmuvalue.id;
        rmu.RMU_Platform_Product_Ratio__c = 10.00;
        rmu.RMU_DEALER_PRC__c = 5.0;
        insert rmu;
        
        Account_Eligible_RMU__c aer= new Account_Eligible_RMU__c();
        /* Commenting the below line as part of CRQ000000163236, in the production Account_Eligible_RMU__c object we dont have 
           RMU_Platform__c field.Hence this test class is getting failed during deployment.
           Note:- This test class will fail in UAT till we get the refresh from Production.
        */
        //aer.RMU_Platform__c = rmu.id;
        insert aer;
        
        Account_Eligible_RMU_Fleet_Asset__c aerfa = new Account_Eligible_RMU_Fleet_Asset__c();
        aerfa.Account_Eligible_RMU__c = aer.id;
        aerfa.RMU_Platform__c = rmu.id;
        aerfa.AER_Update__c = false;
        aerfa.Aircraft_Count__c=10;
        aerfa.Aircraft_Installed_Count__c=8; 
        aerfa.RMU_Dealer_Work_Ext__c = 1.0;  
        aerfa.RMU_Flyaway_Work_Ext__c = 0.0;   
        insert aerfa;
        Account_Eligible_RMU_Fleet_Asset__c  aerfact = [select RMU_Flyaway_Extended_Price__c,RMU_Flyaway_Work_Ext__c
                            from Account_Eligible_RMU_Fleet_Asset__c where id =:aerfa.id];
        system.debug('aerfa value:'+aerfact);
        system.debug('RMU_Product_Ratio__c value:'+aerfa.RMU_Product_Ratio__c);
        system.debug('RMU_Dealer_Price__c value:'+aerfa.RMU_Dealer_Price__c);
        system.debug('Aircraft_Open_Count__c value:'+aerfa.Aircraft_Open_Count__c);        
        system.debug('RMU_Dealer_Extended_Price__c value:'+aerfa.RMU_Dealer_Extended_Price__c);
        Id batch = Database.executeBatch(new BatchAERUpdate(),10);
        
        Test.StartTest();
        BatchAERUpdateSchedule sh1 = new BatchAERUpdateSchedule();
        String sch = '0 0 23 * * ?';
        system.schedule('Test Territory Check', sch, sh1); Test.stopTest();
        
    }
}