/***********************************************************************************************
Name:                   Opportunityquery
Author:                 Satya Mohanty
Created Date:           12/13/2018
Use Case:               This class query Top 20 and last days wins/loss records from Opportunity object
                         Report is send every day to  Honeywell leaders .
                        It is fired by the Sendopportunitydetails
                        OWNED BY THE CRM SALES TEAM.
************************************************************************************************/
public with sharing class opportunityQuery{    
    public List<Opportunity> oppty{get;set;}
    public List<Opportunity> opptyL{get;set;}
    public List<Opportunity> opptyYTD{get;set;}
    public String opportunity { get; set; }
    public String xlsHeader { get; set; }
    /*public String xlsHeader {
            get {
                String strHeader = '';
                strHeader += '<?xml version="1.0"?>';
                strHeader += '<?mso-application progid="Excel.Sheet"?>';
                return strHeader;
            }
        }
     */
    public opportunityQuery(){
        //Date inputDate = null;
       // Date d = date.today();
        //Datetime dt = (DateTime)d;
        
        Datetime dt = System.today();
        System.debug('========'+dt);
        dt=dt+1;
        String dayOfWeek = dt.format('EEEE');
        System.debug('dayOfWeek'+dayOfWeek);
        Datetime inputDate;
        if(dayOfWeek == 'Monday'){
        inputDate = system.today().addDays(-3);
        }
        if(dayOfWeek != 'Monday'){
        inputDate = system.today().addDays(-1);
        }
        System.debug('inputDate===='+inputDate);
        String closeDate = dt.Year()+'-01-01';
        //String closeDateDec = d.Year()+'-12-31';
        xlsHeader = '';
        xlsHeader += '<?xml version="1.0"?>';
        xlsHeader += '<?mso-application progid="Excel.Sheet"?>';
        Set<Id> oppId = new Set<Id>();
        for(OpportunityFieldHistory ofh : [SELECT CreatedDate,Field,Id,NewValue,OldValue,OpportunityId FROM OpportunityFieldHistory WHERE CreatedDate >=: inputDate and CreatedDate < TODAY order by id DESC]){
           
            if(ofh.NewValue == 'Closed Won' || ofh.NewValue == 'Closed Lost'){
                oppId.add(ofh.OpportunityId);
            }
        }
        oppty = [SELECT StageName,Pipeline_Amount__c,Opportunity_Type__c ,Opportunity_Number__c,CBT_Tier_2__c ,closedate, Name, Account.Name ,id, Sales_Channel__c  FROM Opportunity where Id =: oppId AND (NOT Opportunity_Type__c   like '%Run Rate%') AND CBT_Tier_2__c <> 'HTSI'  and  SBU__c IN ('AERO LEVEL','ATR','BGA','D&S') and Pipeline_Amount__c > 10000 and Exclude_Form_Wins__c = false and IsClosed = True and (NOT Name like '%Blanket%') order by Pipeline_Amount__c Desc limit 20 ];   
        opptyL = [SELECT StageName,Pipeline_Amount__c,Opportunity_Type__c ,Opportunity_Number__c,CBT_Tier_2__c ,closedate, Name, Account.Name ,id, Sales_Channel__c,Description,Ownerfullname__c,SBU__c,Win_Loss_Reason_Code__c,Win_Loss_Reason_Text__c FROM Opportunity where Id =: oppId AND (NOT Opportunity_Type__c   like '%Run Rate%') and CBT_Tier_2__c <> 'HTSI'and  SBU__c IN ('AERO LEVEL','ATR','BGA','D&S')  and IsClosed = True and Exclude_Form_Wins__c = false and Pipeline_Amount__c > 10000  and (NOT Name like '%Blanket%') order by Pipeline_Amount__c Desc ];
        opptyYTD  =[SELECT StageName,Pipeline_Amount__c,Opportunity_Type__c ,Opportunity_Number__c,CBT_Tier_2__c ,closedate, Name, Account.Name ,id, Sales_Channel__c,Description,Ownerfullname__c,SBU__c,Win_Loss_Reason_Code__c,Win_Loss_Reason_Text__c FROM Opportunity where closedate >=: Date.valueOf(closeDate) and closedate < TODAY  and (stageName = 'closed won' or stageName = 'closed lost') AND  CBT_Tier_2__c <> 'HTSI'  AND (NOT Opportunity_Type__c   like '%Run Rate%') and IsClosed = True and   SBU__c  NOT IN ('ACS Labs','Intercompany','Intracompany') and Exclude_Form_Wins__c = false and Pipeline_Amount__c > 10000 and (NOT Name like '%Blanket%') order by Pipeline_Amount__c Desc limit 100] ;
    }
}