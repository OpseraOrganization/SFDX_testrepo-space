/***********************************************************************************************
Name:                   ADDATRChildOpprtunity
Author:                 Haritha Lekkala
Created Date:            28/01/2020
Description:    used in AMFollowOnPage
                        OWNED BY THE CRM SALES TEAM.
************************************************************************************************/
public class ADDATRChildOpprtunity{
    public Opportunity oppstring{get; set;}
    public String oppId {get;set;}

    public ADDATRChildOpprtunity(ApexPages.StandardController controller)
    {
        oppId = ApexPages.currentPage().getParameters().get('Id');
        loadCloneOpp();
    }
    public ADDATRChildOpprtunity(){

    }
    public PageReference loadCloneOpp()
    {
        if(oppId != null)
        {
            oppstring = new Opportunity();

            String objectName = 'Opportunity';  // modify as needed
            String query = 'SELECT';
            Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();

            // Grab the fields from the describe method and append them to the queryString one by one.
            for(String s : objectFields.keySet()) {
                query += ' ' + s + ', ';
            }

            // Manually add related object's fields that are needed.
            query += 'Account.Name '; // modify as needed    'Account.Name';

            // Strip off the last comma if it exists.
            if (query.substring(query.length()-1,query.length()) == ','){
                query = query.substring(0,query.length()-1);
            }

            // Add FROM statement
            query += ' FROM ' + objectName;

            // Add on a WHERE/ORDER/LIMIT statement as needed
            query += ' WHERE Id =  \''+ oppId +'\'  LIMIT 1'; // modify as needed   WHERE Id = \'test\' AND HasOpportunityLineItem = true LIMIT 1';
            System.debug(query);

            Opportunity opp = Database.query(query);
            oppstring =opp.clone(false, false, false, false);
            oppstring.Name = null;
            oppstring.Parent_Opportunity__c =oppId;
            oppstring.RecordTypeId = label.AM_FollowOn;
            oppstring.Is_Follow_On_Opportunity__c=true;
            oppstring.Win_Only_Opportunity__c=true;

            oppstring.Amount = null;
            oppstring.PWin__c = null;
            oppstring.CloseDate = System.Today();
            oppstring.ATR_Base__c = null;
            oppstring.CampaignId = null;
            oppstring.Solution_Type__c = null;
            oppstring.Sub_Solution_Type__c = null;
            oppstring.Revenue_Type__c = null;
            oppstring.ATR_Review_Org__c = null;
            oppstring.Product_Line_Product_Group__c = null;
            oppstring.Is_HAT__c = false;
            oppstring.In_AOP__c = false;
            oppstring.Gap_Closure__c = false;
            oppstring.Package_Product__c = null;
            oppstring.Origin_Source__c = null;
            oppstring.Secondary_Lead_Source__c = null;
            oppstring.Lead_Creation_Date__c = null;
            oppstring.PGo__c = '1';
            oppstring.Next_Step_Date__c = null;
            oppstring.Status__c = null;
            oppstring.Next_Step__c = null;
            oppstring.Aircraft_Ref__c = null;
            oppstring.ATR_Aircraft_Quantity__c = null;
            oppstring.Platform__c = null;
            oppstring.ATR_Annual_Flight_Hours__c = null;
            oppstring.ATR_Payment_Terms__c = null;
            oppstring.RFI_Expected_Date__c = null;
            oppstring.ATR_Proposal_Validity__c = null;
            oppstring.RFP_Expected_Date__c = null;
            oppstring.ATR_Initial_Provisioning__c = false;
            oppstring.ATR_RFP__c = false;
            oppstring.ATR_Escalation__c = null;
            oppstring.Proposal_Due_Date__c = null;
            oppstring.ATR_Proposal_Type__c = null;
            oppstring.ATR_Unique_C_PS_or_ISC_Requirements__c = null;
            oppstring.Win_Loss_Proposal_Amount__c = null;
            oppstring.ATR_Agent_Commission_Percentage__c = null;
            oppstring.Contract_Number__c = null;
            oppstring.Customer_Purchase_Order__c = null;
            oppstring.Win_Loss_Amount__c = null;
            oppstring.Win_Loss_Reason_Code__c = null;
            oppstring.Win_Loss_Reason_Secondary__c = null;
            oppstring.Was_a_Value_Tool_Used__c = null;
            oppstring.Win_Loss_Reason_Text__c = null;
            oppstring.Primary_Competitor__c = null;
            oppstring.Cash_Rebate__c = null;
            oppstring.FOC_Spares__c = null;
            oppstring.Credit_Memo__c = null;
            oppstring.Extended_Warranty__c = null;
            oppstring.Merchandise_Credit_Voucher__c = null;
            oppstring.Other_Credits_Comments__c = null;
            oppstring.General_Sales_Credit_Voucher__c = null;
            oppstring.Other_Credits__c = null;
            oppstring.Type_of_Opportunity__c = null;
            oppstring.BAFO__c = null;
            oppstring.IC_Scorecard_Opportunity__c = false;
            oppstring.MB__c = null;
            oppstring.Annualized_Revenue_Years_SIP__c = null;
            oppstring.Offset_Status__c = null;
            oppstring.Offset_Estimated_Demand_Start_Date__c = null;
            oppstring.Offset_Percentage__c = null;
            oppstring.Offset_Estimated_Demand_End_Date__c = null;
            oppstring.Opportunity_Order_Numbers__c = null;
            oppstring.Duplicate_Order_Number__c = null;
            oppstring.TeamMemberLastName__c = null;
            oppstring.Probability = null;
            oppstring.Sales_Survey_Qualified__c = false;
            oppstring.Sales_Survey_Sent__c = false;
            oppstring.Reason_For_Not_Sending_Survey_Picklist__c = null;
            oppstring.Package_Product_Link__c = null;
            oppstring.OwnerId = UserInfo.getUserId();
            //Wipe out Tact.AI related fields
            oppstring.Status__c = null;
            oppstring.Next_Step__c = null;
            oppstring.Next_Step_Date__c = null;
            oppstring.Log_Virtual_Meeting__c = null;
            oppstring.Log_Virtual_Meeting_Date__c =null;
            oppstring.Log_F2F_Meeting__c = null;
            oppstring.Log_F2F_Meeting_Date__c = null;

            //Wipe out Lead reference
            oppstring.Lead_ID__c = null;

        }
        return null;
    }

    public PageReference onSave(){
        System.debug('After save value===='+oppstring);
        insert oppstring;
        return new PageReference('/' + oppstring.Id);

    }

    public PageReference onCancel(){
        return new PageReference('/' + oppId);

    }

}