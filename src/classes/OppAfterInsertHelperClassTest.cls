@istest(SeeAllData=true)
public class OppAfterInsertHelperClassTest{

static testMethod void OppAfterInsertHelper(){

Account acc = new Account();
        acc.Ownerid= '005300000041ohb' ;
        acc.Name = 'Honeywell';
        acc.Customer_Status__c = 'Active';
        //acc.Strategic_Business_Unit__c = 'Intercompany';
        acc.CBT__c = 'Intercompany';
        acc.Region_Name__c = 'Asia/Pacific Rim';
        acc.Sub_Region_Name__c = 'China / HKG';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        Acc.Strategic_Business_Unit__c = 'D&S';
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell Boyun Aero Systems Hunan Co Ltd';
        Profile ProfRec = [select name,id from Profile where name = 'System Administrator' limit 1];
        User userRec = [select id from user where ProfileId = :ProfRec.Id and isActive=true limit 1];
        system.runas(userRec)
        {
            insert acc;
        }
        Id rtType = Schema.SObjectType.Opportunity.getRecordTypeInfosbyName().get('D&S Complex').getRecordTypeId();
        Id rtType3 = Schema.SObjectType.Opportunity.getRecordTypeInfosbyName().get('OE Complex').getRecordTypeId();
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Method Opportunity';
        opp1.SBU__c = 'ATR';
        opp1.CBT_Tier_2__c = 'DAA';
        opp1.IC_Scorecard_Opportunity__c = false;
        opp1.Description='test restricted opp';
        opp1.CBT_Team_Tier_3__c = 'CBMS';
        opp1.Customer_Last_Modified_Date__c = System.today() - 1;
        opp1.AccountId = acc.Id;
        opp1.End_User__c = acc.Id;
        opp1.RecordTypeid = rtType;
        opp1.Tech_Sales_Product_Area__c = 'APU';
        opp1.Tech_Sales__c = 'Mechanical Systems';
        opp1.Prime_Sub__c = 'Prime';
        //opp.opportunity_Type__c = 'Competitive';
        opp1.StageName = 'Launch';
        opp1.RecordtypeId= rtType;
        opp1.CUSTOMER_LICENSE_NEED_DATE__c= system.today();
        opp1.RFP_Expected_Date__c = null;   
        opp1.CloseDate = System.today();
        opp1.Revenue_Type__c = 'ENG';
        opp1.Solution_Type__c= 'Other';
        opp1.Bid_Type_Name__c = 'LTA';
        opp1.International_Code__c = 'FMS';
        opp1.Incumbent__c = 'Incumbent';
        opp1.RMU__c = 'YES';
        //opp1.Platform__c = p.Id; 
        opp1.Active__c = TRUE;
        opp1.Certification_Requirements__c = 'FAR 15 Tina';
        opp1.Proposal_Complexity__c ='Pre-work initiated';
        opp1.Ship_Set_Quantity__c = 1;
        opp1.Ship_Set_Parts__c ='1234';
        opp1.ATR_Aircraft_Quantity__c = 1;
        opp1.RFP_Request_Date__c=null;
        opp1.Proposal_Complexity_Description__c = 'test'; 
        opp1.Ship_Set_Delivery_Period__c= 'test';
        opp1.Is_Restricted_Opportunity__c=false;
        opp1.Is_Follow_On_Opportunity__c=false;  
        opp1.Parent_Opportunity__c = [select id from opportunity WHERE Amount = 0 and SBU__c = 'D&S' and Win_Only_Opportunity__c =false limit 1].id; 
        opp1.Win_Only_Opportunity__c = true;
        opp1.Win_Loss_Amount__c = 10000;
        opp1.Win_Loss_Proposal_Amount__c =10000;
        opp1.Win_Probability__c = 100;
        opp1.Win_Loss_Reason_Text__c = 'test';
        TriggerInactive.TestOppRequiredFields = true;
        opp1.StageName = 'Cultivate';
        opp1.Certification_Requirements__c ='FAR 15 Tina';
        opp1.RFP_Expected_Date__c = null;
        opp1.Proposal_Complexity_Description__c=null;
        opp1.Proposal_Complexity__c = 'Pre-work initiated';
        opp1.Certification_Requirements__c= null;    
        insert opp1;
        
          Test.startTest();
        TriggerInactive.testTrigger = false;
        TriggerInactive.TestCaseCancelled = false;
        TriggerInactive.TestCSMCaseCreation = false;
        TriggerInactive.TestOppRequiredFields = false;
        TriggerInactive.TestOppUpdate_UpdateStage = false;
        TriggerInactive.TestCasValUpdtBasOnOwner = false;
        TriggerInactive.TestATROpp_ContentDeliveries_Automation = false;
        TriggerInactive.TestOpportunityProduct_UpdateTechSales = false;
        TriggerInactive.TestOpportunity_InsertPhases = false;
        
       
        
        opp1.active__c = false;
        opp1.Is_Restricted_Opportunity__c = false;
        opp1.Is_Follow_On_Opportunity__c = true;
        opp1.Win_Loss_Amount__c = 10001;
        opp1.Win_Loss_Reason_Code__c = 'Best Value Solution';
        opp1.SBU__c = 'D&S';
        opp1.Tech_Sales__c = 'AT';
        //update opp1;
         try
        {
            update opp1;
        }
        catch(Exception e)
        {
            opp1.RecordtypeId= rtType3;
            opp1.SBU__c='ATR';
            opp1.StageName ='cultivate';
            try
            {
                update opp1;
            }
            catch(Exception ex)
            {
              system.debug(ex);
            }
          }
        Opportunity opp2 = new Opportunity(id=opp1.Parent_Opportunity__c);
        opp2.Win_Only_Opportunity__c = true;
        opp2.Win_Loss_Amount__c = 10000;
        opp2.Win_Loss_Proposal_Amount__c =10000;
        opp2.Win_Probability__c = 100;
        opp2.Win_Loss_Reason_Text__c = 'test';
        opp2.Opp_Update__c = true;
        opp2.StageName = 'closed won';
        opp2.active__c = false;
        opp2.IC_Scorecard_Opportunity__c = false;
        opp2.Win_Loss_Reason_Code__c = 'Best Value Solution';
        update opp2;
        
        Id rtType2 = Schema.SObjectType.Opportunity.getRecordTypeInfosbyName().get('D&S Complex').getRecordTypeId();
        
        opp1.RecordTypeId = rtType2;
        opp1.Certification_Requirements__c = 'FAR 15 Tina';
        try
        {
            update opp1;
        }
        catch(Exception e)
        {
            opp1.Certification_Requirements__c = 'testing';
            opp1.RFP_Expected_Date__c = null;
            try
            {
                update opp1;
            }
            catch(Exception ex)
            {
                opp1.RFP_Expected_Date__c = System.today();
                opp1.Proposal_Complexity_Description__c= null;
                try
                {
                    update opp1;
                }
                catch(Exception en)
                {
                    opp1.Proposal_Complexity_Description__c = 'description';
                    opp1.Proposal_Complexity__c = null;
                    try
                    {
                        update opp1;
                    }
                    catch(Exception exc)
                    {
                        
                    }
                }
            }
        }
    }


static testMethod void OppAfterInsertHelper2(){

Account acc = new Account();
        acc.Ownerid= '005300000041ohb' ;
        acc.Name = 'Honeywell';
        acc.Customer_Status__c = 'Active';
        acc.CBT__c = 'Intercompany';
        acc.Region_Name__c = 'Asia/Pacific Rim';
        acc.Sub_Region_Name__c = 'China / HKG';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        Acc.Strategic_Business_Unit__c = 'D&S';
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell Boyun Aero Systems Hunan Co Ltd';
        Profile ProfRec = [select name,id from Profile where name = 'System Administrator' limit 1];
        User userRec = [select id from user where ProfileId = :ProfRec.Id and isActive=true limit 1];
        system.runas(userRec)
        {
            insert acc;
        }
        
        Id rtType3 = Schema.SObjectType.Opportunity.getRecordTypeInfosbyName().get('OE Complex').getRecordTypeId();

        Id rtType = Schema.SObjectType.Opportunity.getRecordTypeInfosbyName().get('AM Complex').getRecordTypeId();
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Method Opportunity';
        opp1.SBU__c = 'ATR';
        opp1.CBT_Tier_2__c = 'DAA';
        opp1.Description='test restricted opp';
        opp1.CBT_Team_Tier_3__c = 'CBMS';
        opp1.Customer_Last_Modified_Date__c = System.today() - 1;
        opp1.AccountId = acc.Id;
        opp1.End_User__c = acc.Id;
        opp1.RecordTypeid = rtType;
        opp1.CreatedByid = '0051300000BbHC4';
        opp1.Tech_Sales_Product_Area__c = 'APU';
        opp1.IC_Scorecard_Opportunity__c = false;
        opp1.Tech_Sales__c = 'Mechanical Systems';
        opp1.Prime_Sub__c = 'Prime';
        opp1.StageName = 'Launch';
        opp1.RecordtypeId= rtType;
        opp1.CUSTOMER_LICENSE_NEED_DATE__c= system.today();
        opp1.RFP_Expected_Date__c = null;   
        opp1.CloseDate = System.today();
        opp1.Revenue_Type__c = 'ENG';
        opp1.Solution_Type__c= 'Other';
        opp1.Bid_Type_Name__c = 'LTA';
        opp1.International_Code__c = 'FMS';
        opp1.Incumbent__c = 'Incumbent';
        opp1.RMU__c = 'YES';
        opp1.Active__c = TRUE;
        opp1.Certification_Requirements__c = 'FAR 15 Tina';
        opp1.Proposal_Complexity__c ='Pre-work initiated';
        opp1.Ship_Set_Quantity__c = 1;
        opp1.Ship_Set_Parts__c ='1234';
        opp1.ATR_Aircraft_Quantity__c = 1;
        opp1.RFP_Request_Date__c=null;
        opp1.Proposal_Complexity_Description__c = 'test'; 
        opp1.Ship_Set_Delivery_Period__c= 'test';
        opp1.Is_Restricted_Opportunity__c=false;
        opp1.Is_Follow_On_Opportunity__c=false;  
        opp1.Parent_Opportunity__c = [select id from opportunity WHERE Amount = 0 and SBU__c = 'D&S' and Win_Only_Opportunity__c =false limit 1].id; 
        opp1.Win_Only_Opportunity__c = true;
        opp1.Win_Loss_Amount__c = 10000;
        opp1.Win_Loss_Proposal_Amount__c =10000;
        opp1.Win_Probability__c = 100;
        opp1.Win_Loss_Reason_Text__c = 'test';
        opp1.StageName = 'Cultivate';
        opp1.Certification_Requirements__c ='FAR 15 Tina';
        opp1.RFP_Expected_Date__c = null;
        opp1.Proposal_Complexity_Description__c=null;
        opp1.Proposal_Complexity__c = 'Pre-work initiated';
        opp1.Certification_Requirements__c= null;    
        insert opp1;
        
        Test.startTest();
        TriggerInactive.TestOppRequiredFields = true;
        TriggerInactive.testTrigger = false;
        TriggerInactive.TestCaseCancelled = false;
        TriggerInactive.TestCSMCaseCreation = false;
        TriggerInactive.TestOppRequiredFields = false;
        TriggerInactive.TestOppUpdate_UpdateStage = false;
        TriggerInactive.TestCasValUpdtBasOnOwner = false;
        TriggerInactive.TestATROpp_ContentDeliveries_Automation = false;
        TriggerInactive.TestOpportunityProduct_UpdateTechSales = false;
        TriggerInactive.TestOpportunity_InsertPhases = false;
        
       
        
        opp1.active__c = false;
        opp1.Is_Restricted_Opportunity__c = false;
        opp1.Is_Follow_On_Opportunity__c = true;
        opp1.Win_Loss_Amount__c = 10001;
        opp1.Win_Loss_Reason_Code__c = 'Best Value Solution';
        opp1.SBU__c = 'D&S';
        opp1.Tech_Sales__c = 'AT';
        //update opp1;
         try
        {
            update opp1;
        }
        catch(Exception e)
        {
            //opp1.RecordtypeId= rtType3;
           // opp1.SBU__c='ATR';
           // opp1.StageName ='cultivate';
            try
            {
                update opp1;
            }
            catch(Exception ex)
            {
              system.debug(ex);
            }
          } 
        Opportunity opp2 = new Opportunity(id=opp1.Parent_Opportunity__c);
        opp2.Win_Only_Opportunity__c = true;
        opp2.Win_Loss_Amount__c = 10000;
        opp2.Win_Loss_Proposal_Amount__c =10000;
        opp2.Win_Probability__c = 100;
        opp2.Win_Loss_Reason_Text__c = 'test';
        opp2.IC_Scorecard_Opportunity__c = false;
        opp2.Opp_Update__c = true;
        opp2.StageName = 'closed won';
        opp2.active__c = false;
        opp2.Win_Loss_Reason_Code__c = 'Best Value Solution';
        update opp2;
        
        Id rtType2 = Schema.SObjectType.Opportunity.getRecordTypeInfosbyName().get('D&S Complex').getRecordTypeId();
        
        opp1.RecordTypeId = rtType2;
        opp1.Certification_Requirements__c = 'FAR 15 Tina';
        //update opp1;
        try
        {
            update opp1;
        }
        catch(Exception e)
        {
        
            opp1.Certification_Requirements__c = 'testing';
            opp1.RFP_Expected_Date__c = null;
            try
            {
                update opp1;
            }
            catch(Exception ex)
            {
                opp1.RFP_Expected_Date__c = System.today();
                opp1.Proposal_Complexity_Description__c= null;
                try
                {
                    update opp1;
                }
                catch(Exception en)
                {
                    opp1.Proposal_Complexity_Description__c = 'description';
                    opp1.Proposal_Complexity__c = null;
                    try
                    {
                        update opp1;
                    }
                    catch(Exception exc)
                    {
                        
                    }
                }
            }
        } 
    }


static testMethod void OppAfterInsertHelper3(){

Account acc = new Account();
        acc.Ownerid= '005300000041ohb' ;
        acc.Name = 'Honeywell';
        acc.Customer_Status__c = 'Active';
        acc.CBT__c = 'Intercompany';
        acc.Region_Name__c = 'Asia/Pacific Rim';
        acc.Sub_Region_Name__c = 'China / HKG';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        Acc.Strategic_Business_Unit__c = 'D&S';
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell Boyun Aero Systems Hunan Co Ltd';
        Profile ProfRec = [select name,id from Profile where name = 'System Administrator' limit 1];
        User userRec = [select id from user where ProfileId = :ProfRec.Id and isActive=true limit 1];
        system.runas(userRec)
        {
            insert acc;
        }
        Id rtType3 = Schema.SObjectType.Opportunity.getRecordTypeInfosbyName().get('OE Complex').getRecordTypeId();

        Id rtType = Schema.SObjectType.Opportunity.getRecordTypeInfosbyName().get('M&PM SIM Licensing').getRecordTypeId();
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Method Opportunity';
        opp1.IC_Scorecard_Opportunity__c = false;
        opp1.SBU__c = 'ATR';
        opp1.CBT_Tier_2__c = 'DAA';
        opp1.Description='test restricted opp';
        opp1.CBT_Team_Tier_3__c = 'CBMS';
        opp1.Customer_Last_Modified_Date__c = System.today() - 1;
        opp1.AccountId = acc.Id;
        opp1.End_User__c = acc.Id;
        opp1.RecordTypeid = rtType;
        opp1.CreatedByid = '0051300000BbHC4';
        opp1.License_Draft__c= system.today();
        //opp1.Record_Data_Owner__c = '0035600000F5bgBAAR';
        opp1.Engineer_Manager_Review_Date__c = system.today();
        opp1.Tech_Sales_Product_Area__c = 'APU';
        opp1.Tech_Sales__c = 'Mechanical Systems';
        opp1.Prime_Sub__c = 'Prime';
        opp1.StageName = 'Launch';
        opp1.RecordtypeId= rtType;
        opp1.CUSTOMER_LICENSE_NEED_DATE__c= system.today();
        opp1.RFP_Expected_Date__c = null;   
        opp1.CloseDate = System.today();
        opp1.Revenue_Type__c = 'ENG';
        opp1.Solution_Type__c= 'Other';
        opp1.Bid_Type_Name__c = 'LTA';
        opp1.International_Code__c = 'FMS';
        opp1.Incumbent__c = 'Incumbent';
        opp1.RMU__c = 'YES';
        opp1.Active__c = TRUE;
        opp1.Certification_Requirements__c = 'FAR 15 Tina';
        opp1.Proposal_Complexity__c ='Pre-work initiated';
        opp1.Ship_Set_Quantity__c = 1;
        opp1.Ship_Set_Parts__c ='1234';
        opp1.ATR_Aircraft_Quantity__c = 1;
        opp1.RFP_Request_Date__c=null;
        opp1.Proposal_Complexity_Description__c = 'test'; 
        opp1.Ship_Set_Delivery_Period__c= 'test';
        opp1.Is_Restricted_Opportunity__c=false;
        opp1.Is_Follow_On_Opportunity__c=false;  
        opp1.Parent_Opportunity__c = [select id from opportunity WHERE Amount = 0 and SBU__c = 'D&S' and Win_Only_Opportunity__c =false limit 1].id; 
        opp1.Win_Only_Opportunity__c = true;
        opp1.Win_Loss_Amount__c = 10000;
        opp1.Win_Loss_Proposal_Amount__c =10000;
        opp1.Win_Probability__c = 100;
        opp1.Win_Loss_Reason_Text__c = 'test';
        opp1.StageName = 'Cultivate';
        opp1.Certification_Requirements__c ='FAR 15 Tina';
        opp1.RFP_Expected_Date__c = null;
        opp1.Proposal_Complexity_Description__c=null;
        opp1.Proposal_Complexity__c = 'Pre-work initiated';
        opp1.Certification_Requirements__c= null;    
        insert opp1;
        
        Test.startTest();
        TriggerInactive.TestOppRequiredFields = true;
        TriggerInactive.testTrigger = false;
        TriggerInactive.TestCaseCancelled = false;
        TriggerInactive.TestCSMCaseCreation = false;
        TriggerInactive.TestOppRequiredFields = false;
        TriggerInactive.TestOppUpdate_UpdateStage = false;
        TriggerInactive.TestCasValUpdtBasOnOwner = false;
        TriggerInactive.TestATROpp_ContentDeliveries_Automation = false;
        TriggerInactive.TestOpportunityProduct_UpdateTechSales = false;
        TriggerInactive.TestOpportunity_InsertPhases = false;
        
       
        
        opp1.active__c = false;
        opp1.Is_Restricted_Opportunity__c = false;
        opp1.Is_Follow_On_Opportunity__c = true;
        opp1.Win_Loss_Amount__c = 10001;
        opp1.Win_Loss_Reason_Code__c = 'Best Value Solution';
        opp1.SBU__c = 'D&S';
        opp1.Tech_Sales__c = 'AT';
        //update opp1;
         try
        {
            update opp1;
        }
        catch(Exception e)
        {
            //opp1.RecordtypeId= rtType3;
           // opp1.SBU__c='ATR';
           // opp1.StageName ='cultivate';
            try
            {
                update opp1;
            }
            catch(Exception ex)
            {
              system.debug(ex);
            }
          } 
        Opportunity opp2 = new Opportunity(id=opp1.Parent_Opportunity__c);
        opp2.Win_Only_Opportunity__c = true;
        opp2.Win_Loss_Amount__c = 10000;
        opp2.Win_Loss_Proposal_Amount__c =10000;
        opp2.Win_Probability__c = 100;
        opp2.Win_Loss_Reason_Text__c = 'test';
        opp2.Opp_Update__c = true;
        opp2.StageName = 'closed won';
        opp2.active__c = false;
        opp2.Win_Loss_Reason_Code__c = 'Best Value Solution';
        opp2.IC_Scorecard_Opportunity__c = false;

        update opp2;
        
        Id rtType2 = Schema.SObjectType.Opportunity.getRecordTypeInfosbyName().get('D&S Complex').getRecordTypeId();
        
        opp1.RecordTypeId = rtType2;
        opp1.Certification_Requirements__c = 'FAR 15 Tina';
        //update opp1;
        try
        {
            update opp1;
        }
        catch(Exception e)
        {
        
            opp1.Certification_Requirements__c = 'testing';
            opp1.RFP_Expected_Date__c = null;
            try
            {
                update opp1;
            }
            catch(Exception ex)
            {
                opp1.RFP_Expected_Date__c = System.today();
                opp1.Proposal_Complexity_Description__c= null;
                try
                {
                    update opp1;
                }
                catch(Exception en)
                {
                    opp1.Proposal_Complexity_Description__c = 'description';
                    opp1.Proposal_Complexity__c = null;
                    try
                    {
                        update opp1;
                    }
                    catch(Exception exc)
                    {
                        
                    }
                }
            }
        } 

}

static testMethod void OppAfterInsertHelper4(){

Account acc = new Account();
        acc.Ownerid= '005300000041ohb' ;
        acc.Name = 'Honeywell';
        acc.Customer_Status__c = 'Active';
        acc.CBT__c = 'Intercompany';
        acc.Region_Name__c = 'Asia/Pacific Rim';
        acc.Sub_Region_Name__c = 'China / HKG';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        Acc.Strategic_Business_Unit__c = 'D&S';
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell Boyun Aero Systems Hunan Co Ltd';
        Profile ProfRec = [select name,id from Profile where name = 'System Administrator' limit 1];
        User userRec = [select id from user where ProfileId = :ProfRec.Id and isActive=true limit 1];
        system.runas(userRec)
        {
            insert acc;
        }
        Id rtType3 = Schema.SObjectType.Opportunity.getRecordTypeInfosbyName().get('OE Complex').getRecordTypeId();

        Id rtType = Schema.SObjectType.Opportunity.getRecordTypeInfosbyName().get('M&PM SIM Licensing').getRecordTypeId();
        Opportunity opp1 = new Opportunity();
        opp1.IC_Scorecard_Opportunity__c = false;
        opp1.Name = 'Test Method Opportunity';
        opp1.SBU__c = 'ATR';
        opp1.CBT_Tier_2__c = 'DAA';
        opp1.Description='test restricted opp';
        opp1.CBT_Team_Tier_3__c = 'CBMS';
        opp1.Customer_Last_Modified_Date__c = System.today() - 1;
        opp1.AccountId = acc.Id;
        opp1.End_User__c = acc.Id;
        opp1.RecordTypeid = rtType;
        opp1.CreatedByid = '0051300000BbHC4';
        opp1.License_Draft__c= system.today();
        //opp1.Record_Data_Owner__c = '0035600000F5bgBAAR';
        opp1.BusinessContact__c = '0051300000BbHC4';
        opp1.Engineer_Manager_Review_Date__c = system.today();
        opp1.Tech_Sales_Product_Area__c = 'APU';
        opp1.Tech_Sales__c = 'Mechanical Systems';
        opp1.Prime_Sub__c = 'Prime';
        opp1.StageName = 'Launch';
        opp1.RecordtypeId= rtType;
        opp1.CUSTOMER_LICENSE_NEED_DATE__c= system.today();
        opp1.RFP_Expected_Date__c = null;   
        opp1.CloseDate = System.today();
        opp1.Revenue_Type__c = 'ENG';
        opp1.Solution_Type__c= 'Other';
        opp1.Bid_Type_Name__c = 'LTA';
        opp1.International_Code__c = 'FMS';
        opp1.Incumbent__c = 'Incumbent';
        opp1.RMU__c = 'YES';
        opp1.Active__c = TRUE;
        opp1.Certification_Requirements__c = 'FAR 15 Tina';
        opp1.Proposal_Complexity__c ='Pre-work initiated';
        opp1.Ship_Set_Quantity__c = 1;
        opp1.Ship_Set_Parts__c ='1234';
        opp1.ATR_Aircraft_Quantity__c = 1;
        opp1.RFP_Request_Date__c=null;
        opp1.Proposal_Complexity_Description__c = 'test'; 
        opp1.Ship_Set_Delivery_Period__c= 'test';
        opp1.Is_Restricted_Opportunity__c=false;
        opp1.Is_Follow_On_Opportunity__c=false;  
        opp1.Parent_Opportunity__c = [select id from opportunity WHERE Amount = 0 and SBU__c = 'D&S' and Win_Only_Opportunity__c =false limit 1].id; 
        opp1.Win_Only_Opportunity__c = true;
        opp1.Win_Loss_Amount__c = 10000;
        opp1.Win_Loss_Proposal_Amount__c =10000;
        opp1.Win_Probability__c = 100;
        opp1.Win_Loss_Reason_Text__c = 'test';
        opp1.StageName = 'Cultivate';
        opp1.Certification_Requirements__c ='FAR 15 Tina';
        opp1.RFP_Expected_Date__c = null;
        opp1.Proposal_Complexity_Description__c=null;
        opp1.Proposal_Complexity__c = 'Pre-work initiated';
        opp1.Certification_Requirements__c= null;    
        insert opp1;
        
        Test.startTest();
        TriggerInactive.TestOppRequiredFields = true;
        TriggerInactive.testTrigger = false;
        TriggerInactive.TestCaseCancelled = false;
        TriggerInactive.TestCSMCaseCreation = false;
        TriggerInactive.TestOppRequiredFields = false;
        TriggerInactive.TestOppUpdate_UpdateStage = false;
        TriggerInactive.TestCasValUpdtBasOnOwner = false;
        TriggerInactive.TestATROpp_ContentDeliveries_Automation = false;
        TriggerInactive.TestOpportunityProduct_UpdateTechSales = false;
        TriggerInactive.TestOpportunity_InsertPhases = false;
        
       
        
        opp1.active__c = false;
        opp1.Is_Restricted_Opportunity__c = false;
        opp1.Is_Follow_On_Opportunity__c = true;
        opp1.Win_Loss_Amount__c = 10001;
        opp1.Win_Loss_Reason_Code__c = 'Best Value Solution';
        opp1.BusinessContact__c = '0051300000BbHC4';
        opp1.SBU__c = 'D&S';
        opp1.Tech_Sales__c = 'AT';
        //update opp1;
         try
        {
            update opp1;
        }
        catch(Exception e)
        {
            //opp1.RecordtypeId= rtType3;
           // opp1.SBU__c='ATR';
           // opp1.StageName ='cultivate';
            try
            {
                update opp1;
            }
            catch(Exception ex)
            {
              system.debug(ex);
            }
          } 
        Opportunity opp2 = new Opportunity(id=opp1.Parent_Opportunity__c);
        opp2.Win_Only_Opportunity__c = true;
        opp2.Win_Loss_Amount__c = 10000;
        opp2.Win_Loss_Proposal_Amount__c =10000;
        opp2.Win_Probability__c = 100;
        opp2.Win_Loss_Reason_Text__c = 'test';
        opp2.Opp_Update__c = true;
        opp2.StageName = 'closed won';
        opp2.active__c = false;
        opp2.Win_Loss_Reason_Code__c = 'Best Value Solution';
        opp2.BusinessContact__c = '0051300000BbHC4';
        opp2.IC_Scorecard_Opportunity__c = false;
        update opp2;
        
        Id rtType2 = Schema.SObjectType.Opportunity.getRecordTypeInfosbyName().get('D&S Complex').getRecordTypeId();
        
        opp1.RecordTypeId = rtType2;
        opp1.Certification_Requirements__c = 'FAR 15 Tina';
        //update opp1;
        try
        {
            update opp1;
        }
        catch(Exception e)
        {
        
            opp1.Certification_Requirements__c = 'testing';
            opp1.RFP_Expected_Date__c = null;
            try
            {
                update opp1;
            }
            catch(Exception ex)
            {
                opp1.RFP_Expected_Date__c = System.today();
                opp1.Proposal_Complexity_Description__c= null;
                try
                {
                    update opp1;
                }
                catch(Exception en)
                {
                    opp1.Proposal_Complexity_Description__c = 'description';
                    opp1.Proposal_Complexity__c = null;
                    try
                    {
                        update opp1;
                    }
                    catch(Exception exc)
                    {
                        
                    }
                }
            }
        } 

}



}