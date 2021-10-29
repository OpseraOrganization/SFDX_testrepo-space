//Test class for UpdateDLI_Overspent-SR# INC000006238448 
@isTest
public class UpdateDLI_Overspent_test{ 
static testMethod void testUpdateDLI_Overspent()
{

 Profile p = [select id from profile where name='System Administrator' limit 1];
 User usr = new User();
        usr.alias = 'dhivya';
        usr.email = 'dhivya123@test.com';
        usr.emailencodingkey='UTF-8';
        usr.lastname='vnv';
        usr.languagelocalekey='en_US';
        usr.localesidkey='en_US';
        usr.profileid = p.Id;
        usr.timezonesidkey='America/Los_Angeles';
        usr.username='standarduser@testing.com.Test';
        usr.isactive=true;
        insert usr;
          User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
System.runAs ( thisUser ) {       
        Test.StartTest();
        
         Plant_Code_Master__c tstPCM = new Plant_Code_Master__c(
            Name = 'Test Plant Code Master'
        );
        insert tstPCM;
        Plant_Code_del__c tstPC = new Plant_Code_del__c(
            Name = 'Test Plant Code Master',
            Plant_Code_Master__c = tstPCM.id,
            Backup_Account_Opener__c = usr.id,
            Primary_Account_Opener__c = usr.id
        );
        insert tstPC;
              Campaign cam = new Campaign();
        cam.Name='test campaign12';
        cam.CampaignPrimarySBU__c='ATR';
        cam.CampaignPrimaryCBTTier2__c = 'Airbus';
        cam.CBT_Team__c = 'Airbus';
        cam.Status = 'Planned';
        cam.Type = 'Test';
        cam.RMU__c = 'No';
        cam.ExpectedRevenue = 645655;
        cam.Tech_Sales__c = 'Integrated Systems';
        cam.Tech_Sales_Product_Area__c = 'test';
        insert cam;

Discretionary__c DR=new Discretionary__c();
            DR.Type__c='Direct Sell';
            DR.Opportunity__c=NULL;
            
            DR.SBU__c='test';
            DR.CBT__c='test';
            DR.Fiscal_Year__c='2013';
            DR.Approval_Status__c='New';
            DR.Campaign__c=cam.id;
            DR.Estimated_Completion_Date__c = System.today();
            insert DR;
            
Discretionary_Line_Item__c DLI = new Discretionary_Line_Item__c(Plant_Code_Master__c=tstPCM.id,Plant_Code__c=tstPC.id,Discretionary_Request__c=DR.id,Funding_Amount__c=decimal.valueof('20'));
            insert DLI;
            
            Discretionary_Spend__c tstDS = new Discretionary_Spend__c(
            Discretionary_Line_Item__c = DLI.id,
            Weekly_Actuals__c = 500.00
        );        
        insert tstDS;
            
            UpdateDLI_Overspent testing1= new UpdateDLI_Overspent();      
        ID batchprocessid = Database.executeBatch(testing1);
        
        UpdateDLI_Overspent rem1= new UpdateDLI_Overspent ();
        String sch = '0 24 17 19 08 ?';
        System.Schedule('UpdateDLI_Overspent-Testing', sch, rem1 );    
 Test.StopTest();
}
}
}