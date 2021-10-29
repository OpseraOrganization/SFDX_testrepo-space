/***********************************************************************************************
Name:                   ADDChildOpprtunity
Author:                 Satya Mohanty
Created Date:            9/6/2018
Description:    used in Add child Opportunity
                        OWNED BY THE CRM SALES TEAM.
************************************************************************************************/
public class ADDChildOpprtunity{
    public Opportunity oppstring{get; set;}
    public String oppId {get;set;}

    public ADDChildOpprtunity(ApexPages.StandardController controller)
    {
        oppId = ApexPages.currentPage().getParameters().get('Id');
        loadCloneOpp();
    }
    public ADDChildOpprtunity(){

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
            oppstring.Is_Follow_On_Opportunity__c=true;
            oppstring.Win_Only_Opportunity__c=true;

            oppstring.Amount = null;
            oppstring.RMU_Sales__c = null;
            oppstring.Next_Step__c = null;
            oppstring.Win_Loss_Amount__c = null;
            oppstring.Win_Loss_Reason_Code__c = null;
            oppstring.Avionics_Count__c = null;
            oppstring.BAFO__c = null;
            oppstring.Survey_Opt_Out_Reason__c = null;
            oppstring.Status__c = null;
            oppstring.next_steps__c = null;
            oppstring.CloseDate = System.Today();
            oppstring.Next_Step_Date__c = null;
            oppstring.RMU__c = null;
            oppstring.RMU_Sales__c = null;
            oppstring.Origin_Source__c = null;
            oppstring.Lead_Creation_Date__c = null;
            oppstring.Secondary_Lead_Source__c = null;
            oppstring.PGo__c = '1';
            oppstring.PWin__c = null;
            oppstring.CampaignId = null;
            oppstring.Reason_For_Not_Sending_Survey_Picklist__c = null;
            oppstring.RFI_Expected_Date__c = null;
            oppstring.ATR_RFP__c = false;
            oppstring.Sales_Survey_Qualified__c = false;
            oppstring.Sales_Survey_Sent__c = false;
            oppstring.Total_Program_Greensheet__c = null;
            oppstring.Was_a_Value_Tool_Used__c = null;
            oppstring.Win_Loss_Proposal_Amount__c = null;
            oppstring.Win_Loss_Reason_Text__c = null;
            oppstring.Win_Loss_Reason_Secondary__c = null;
            oppstring.Primary_Competitor__c = null;
            oppstring.Legacy_Opportunity_Number__c = null;
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