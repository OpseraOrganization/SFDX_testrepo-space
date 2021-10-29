@isTest(SeeAllData = true)
public class choosemanager_Test
{
 static testMethod void approverselect(){
 
 //Data Setup for Flow 1
 
 Discretionary__c dExisting = [Select id , ownerId,Estimated_Completion_Date__c From Discretionary__c  Limit 1];
 Discretionary__c d= new Discretionary__c();
 d.ownerId = dExisting.ownerId  ;
 d.Estimated_Completion_Date__c = dExisting.Estimated_Completion_Date__c ;
 dExisting.CBT__c='EMS';
 update dExisting ;
 
 //Data Setup for flow 2
 
 //Data Setup for Flow 1
 
 User u = [Select  Discretionary_Workflow_Approver_Amount__c from User where Discretionary_Workflow_Approver_Amount__c  > 1  Limit 1 ] ;
 Discretionary__c dExisting1 = [Select id , ownerId,Estimated_Completion_Date__c,Total_Request_Amount_rollup__c,SBU__c,
 Current_Approver__c,CBT__c, Service_request__c From Discretionary__c where Total_Request_Amount_rollup__c > 1 and SR_number__c = ''
 and owner__r.Discretionary_Workflow_Approver_Amount__c >1  Limit 1];
 

 // Unit test Execution 
 Test.startTest();
  
 choosemanager cm=new choosemanager();
 cm.approverselect(dExisting1 );
 cm.approverselect(d);
 //System.assert(d!= Null );
 Test.stopTest(); 
 }
/*static testmethod void DLITestMethod1(){
        test.startTest();
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        insert acc;
        
        Platform__c p = new Platform__c();
        p.Name = 'Test Paltform';
        p.Model__c = '36-16A';
        p.Make__c = 'VARIOUS OEMS';
        p.SAP_External_System__c=True;
        insert p;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Method Opportunity';
        opp.SBU__c = 'D&S';
        opp.CBT_Tier_2__c = 'DAA';
        opp.CBT_Team_Tier_3__c = 'CBMS';
        opp.AccountId = acc.Id;
        opp.End_User__c = acc.Id;
        opp.Tech_Sales_Product_Area__c = 'APU';
        opp.Tech_Sales__c = 'AT';
        opp.Prime_Sub__c = 'Prime';
        opp.opportunity_Type__c = 'D&S Complex';
        opp.StageName = 'Offer/Negotiate/Close';
        opp.RecordtypeId=label.D_S_Complex;
        opp.CloseDate = System.today();
        opp.Revenue_Type__c = 'ENG';
        opp.Bid_Type_Name__c = 'LTA';
        opp.International_Code__c = 'FMS';
        opp.Incumbent__c = 'Incumbent';
        opp.RMU__c = 'YES';
        opp.Platform__c = p.Id; 
        opp.Active__c = TRUE;
        opp.Certification_Requirements__c = 'FAR 15 Tina';
        opp.Proposal_Complexity__c ='Pre-work initiated';
        opp.Ship_Set_Delivery_Period__c= 'test';
        opp.Ship_Set_Quantity__c = 1;
        opp.Ship_Set_Parts__c ='1234';
        opp.Proposal_Complexity_Description__c = 'test';
        opp.RFP_Expected_Date__c =System.today(); 
        triggerinactive.TestOppUpdate_UpdateStage = false;
        //insert opp;
        
        Plant_Code_Master__c pcm = new Plant_Code_Master__c();
        pcm.Postal_Code__c='Test Code';
        pcm.Plant_Name__c='Test Name';
        pcm.Public_Plant_Name__c='Test Public Name';
        pcm.City__c='KA';
        pcm.Country_Code__c='IN';
        pcm.SAP_Plant_Code__c='124421';
        insert pcm;
         User u = [Select  Discretionary_Workflow_Approver_Amount__c from User where Discretionary_Workflow_Approver_Amount__c  > 1 Limit 1 ] ;
        Discretionary__c dc = new Discretionary__c();
        dc.Fiscal_Year__c='2014';
        //dc.Opportunity__c=opp.id;
        dc.M_PM_Funded_VOC_Project__c='NO';
        dc.SBU__c='D&S';
        dc.CBT__c='Airbus';
        dc.CBT_Team__c='EMS';
        dc.Type__c='Demo';
        dc.Estimated_Completion_Date__c=system.today();
        dc.ownerid = u.id;
        insert dc;
        
        Plant_Code_del__c pcd = new Plant_Code_del__c();
        pcd.Name='Test PCD';
        pcd.Plant_Code_Master__c=pcm.Id;
        pcd.SBU__c='ATR';
        pcd.Backup_Account_Opener__c=Userinfo.getUserId();
        pcd.Primary_Account_Opener__c=Userinfo.getUserId();
        insert pcd;
        
        Discretionary_Line_Item__c dli = new Discretionary_Line_Item__c();
        dli.Discretionary_Request__c=dc.Id;
        dli.Plant_Code_Master__c=pcm.Id;
        dli.Cost_Type__c='Travel';
        dli.Plant_Code__c=pcd.Id;
        dli.Funding_Amount__c = 23.55;
        insert dli;
         choosemanager cm=new choosemanager();
         cm.approverselect(dc);
        test.stopTest();
        }*/
}