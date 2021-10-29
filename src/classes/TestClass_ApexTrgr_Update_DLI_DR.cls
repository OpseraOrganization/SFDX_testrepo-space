/** * File Name:  TestClass_ApexTrigger_Update_DLI_DR
* Description : Test Method for Trigger
* Trigger Tested: Update_DLI_DR, Update_Discretionary_Plan_DLI_DR
* Copyright : Wipro Technologies Limited Copyright (c) 2011
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */
@isTest(SeeAllData=true)
private class TestClass_ApexTrgr_Update_DLI_DR {

    static testMethod void Update_DLI_DRTest() {
        
            Opportunity tstOpp = new Opportunity(
            Name='Test Opp',
            amount =100.00,
            Type = 'OCM Programs' ,
            closedate = System.today(),
            ForecastCategoryName = 'Pipeline',
            StageName='Prospecting',
            ATR_Aircraft_Quantity__c=1,
            CBT_Tier_2__c = 'Airbus'
        );   
        insert tstOpp;
       
  user tstuser = [select id from user where name = 'sfdc admin'];
       
        Plant_Code_Master__c tstPCM = new Plant_Code_Master__c(
            Name = 'Test Plant Code Master'
        );
        insert tstPCM;
         Plant_Code_del__c tstPC = new Plant_Code_del__c(
            Name = 'Test Plant Code Master',
             Plant_Code_Master__c = tstPCM.id,
            Backup_Account_Opener__c = tstuser.id,
            Primary_Account_Opener__c = tstuser.id
        );
        insert tstPC;
        
        Discretionary__c tstDR = new Discretionary__c(
            Fiscal_Year__c = '2012',
            Opportunity__c = tstOpp.ID,
            M_PM_Funded_VOC_Project__c = 'No',
            SBU__c = 'ATR',
            CBT__c = 'Airbus',
            Type__c = 'Demo',
            Estimated_Completion_Date__c = System.today()
        );
        insert tstDR;
        
        Discretionary_Line_Item__c tstDLL = new Discretionary_Line_Item__c(
            Discretionary_Request__c = tstDR.ID,
            Plant_Code_Master__c = tstPCM.ID,
            Plant_Code__c = tstPC.id,
            Funding_Amount__c = 100000.00
            
        );
        insert tstDLL;
        
        Discretionary_Spend__c tstDS = new Discretionary_Spend__c(
            Discretionary_Line_Item__c = tstDLL.ID,
            Weekly_Actuals__c = 5000.00
        );     
        test.starttest();   
        insert tstDS;
        
        Discretionary_Plan__c tstDP = new Discretionary_Plan__c(
            Opportunity__c = tstOpp.id,
            Year__c = '2012',
            Approved_Budget__c = 1000
        );
        insert tstDP;
        
        Discretionary_Line_Item__c tstDLL2 = new Discretionary_Line_Item__c(
            Discretionary_Request__c = tstDR.ID,
            Plant_Code_Master__c = tstPCM.ID,
             Plant_Code__c = tstPC.id,
            Funding_Amount__c = 1000000.00
        );
        
        insert tstDLL2;
        tstdll2.Discretionary_Account__c = '123';
        tstdll2.approval_status__c = 'approved';
        update tstDLL2;
        tstdll.Discretionary_Account__c = '12312';
        tstdll.approval_status__c = 'approved';
        update tstDLL;
        
        Discretionary_Spend__c tstDS2 = new Discretionary_Spend__c(
            Discretionary_Line_Item__c = tstDLL2.ID,
            Weekly_Actuals__c = 50000.00
        );        
        insert tstDS2;
        tstDR.approval_status__c = 'Approved';
        update tstDR;
 test.stoptest();       
    }        
}