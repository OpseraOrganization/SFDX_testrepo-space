/** * File Name: UpdateLeadCreator
* Description :Trigger to update lead creator
* Copyright : Wipro Technologies Limited Copyright (c) 2001 *
* @author : Wipro
* Modification Log ==================== Ver Date Author Modification ================================================*  
* INC000005550543   *  ver 1  * 18-Jun-2014  *  NTTDATA  *  Update the lead close date.

* Update By: Michael, NTTDATA CHINA
* Update Description: Avoid illegal assignment to Owner(User) by Queue from CEC
* INC000012880760 -- To Assign Owner field only when Lead Owner assigned to Individual User.
*                      OWNED BY THE CRM SALES TEAM
*********************************************************************************************************************/
trigger UpdateLeadCreator on Lead (before insert,before update) {
    String LeadOwnerid;
    for( Lead leads:Trigger.new)
    {
        if(leads.RecordTypeId != Label.BGA_Honeywell_Prospect &&
           leads.RecordTypeId != Label.BGA_Honeywell_Prospect_Convert
           && leads.LeadSource != 'Honeywell.com CEC' && leads.LeadSource != 'Honeywell.com.cn')
        {
            
            leads.Lead_Creator__c = leads.CreatedById;
            LeadOwnerid = leads.OwnerId;
            if(LeadOwnerid.substring(0,3) == '005')
                leads.Owner__c = leads.OwnerId;
        }
        
        if(leads.LeadSource == 'Honeywell.com.cn') {
            leads.Campaign_Custom__c = Label.CampaignRecord;
            //System.debug('2222222'+leads.Campaign_Custom__c );
        }
        //System.debug('!!!!!!!!!!!!'+leads.Campaign_Custom__c );
        if(( Trigger.isUpdate && Trigger.oldMap.get(leads.Id).LeadSource != leads.LeadSource) &&
           (leads.LeadSource == 'Honeywell.com.cn'))
            leads.Campaign_Custom__c = Label.CampaignRecord;
        //System.debug('@@@@@@@@'+leads);
        //Code added to INC000005550543 - Start
        if(( Trigger.isUpdate && Trigger.oldMap.get(leads.Id).Status != leads.Status) &&
           (leads.Status == 'Disqualified'))
            leads.Lead_Closed_date__c  = System.now();
        else
            leads.Lead_Closed_date__c  = null;
        //Code added to INC000005550543 - End
        /** Code for Record Type update start **/
        if(leads.RecordTypeId != Label.HQSLeadLayout ){
            if(leads.RecordTypeId == Label.Lead_Converted_C_PS  && leads.Status != 'Sales Qualified Lead (SQL)'){
                leads.RecordTypeId = Label.Converted_C_PS_Lead;
            }
            
            if(leads.RecordTypeId != Label.LeadConvertedLayout  && leads.RecordTypeId == Label.Lead_Converted_C_PS &&
               (leads.Status == 'Sales Accepted Leads (SAL)'||
                leads.Status == 'Engaged'||
                leads.Status == 'Disqualified'||
                leads.Status == 'Inquiry'|| 
                leads.Status == 'Marketing Qualified Leads (MQL)'||
                leads.Status == 'Recycle'||leads.Status == 'Converted - Channel Partner')){
                    system.debug('Inside loop');
                    leads.RecordTypeId = Label.Lead_Create_Layout;
                }
            
            if(leads.RecordTypeId != Label.LeadConvertedLayout && leads.RecordTypeId != Label.Lead_Converted_C_PS && leads.RecordTypeId != Label.Converted_C_PS_Lead   && leads.Status == 'Sales Qualified Lead (SQL)'){
                
                leads.RecordTypeId = Label.LeadConvertLayout;
            }
            
            if(leads.RecordTypeId == Label.Lead_Converted_C_PS || leads.RecordTypeId == Label.Converted_C_PS_Lead  && leads.Status == 'Sales Qualified Lead (SQL)'){
                leads.RecordTypeId = Label.Lead_Converted_C_PS;
            }
            
        }
    }
    
}