/*******************************************************************************
Name : S2S_CEC_2_Aero_Lead
Created By : Harry
Company Name : NTT Data China
Project : HW S2S Extension  
Created Date : 13th Oct 2016
Test Class : S2S_CEC_2_Aero_LeadTest
Description : sets lead record type and CEC_Lead_ID__c for leads which are shared
              from CEC to Aero.
*******************************************************************************/
trigger S2S_CEC_2_Aero_Lead on Lead (before insert, after insert) {
  // Get record type Id
  Schema.RecordTypeInfo leadType = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead Create Layout');
  Id leadTypeId;
  if (leadType == null )
  {
    return;
  }
  else
  {
    leadTypeId = leadType.getRecordTypeId();
  }

  // Set record types
  Set<Id> leadsToUpdate = new Set<Id>();
  if (Trigger.isBefore)
  {
    for (Lead newLead : Trigger.new)
    {
      // in case of lead type is not assigned, assign Values to Lead fields
      if (leadTypeId != null && newLead.CEC_Record_Type__c != null)
      {
        newLead.RecordTypeId = leadTypeId;
        if(newLead.CEC_Record_Type__c.startsWith('C3'))
        {
          newLead.LeadSource = 'Honeywell.com CEC';
        }
        else
        {
          newLead.LeadSource = 'Honeywell.com.cn';
        }
      }
    }
  }
  // After lead insertion in Aero, save the CEC lead id
  else if (Trigger.isAfter)
  {
    for (Lead newLead : Trigger.new)
    {
      if (newLead.CEC_Record_Type__c != null)
      {
        leadsToUpdate.add(newLead.Id);
      }
    }
    updateCECLeadId(leadsToUpdate);
  }

  private void updateCECLeadId(Set<Id> leadIds)
  {
    //Search received Lead from CEC
    List<PartnerNetworkRecordConnection> receivedLeads = [select Id, Status, LocalRecordId, PartnerRecordId
                                                          from PartnerNetworkRecordConnection
                                                          where Status='Received' and LocalRecordId in :leadIds];
    Map<Id, Id> leadSBUToCEC = new Map<Id, Id>();
    //Get partner record id (CEC lead Id)
    for (PartnerNetworkRecordConnection record : receivedLeads)
    {
      leadSBUToCEC.put(record.LocalRecordId, record.PartnerRecordId);
    }

    if (leadSBUToCEC.isEmpty() && (!Test.isRunningTest()))
    {
      return;
    }

    List<Lead> leadToUpdate = new List<Lead>();
    for (Lead newLead : [select Id, CEC_Lead_Id__c from Lead where Id in :leadIds])
    {
      if (leadSBUToCEC.containsKey(newLead.Id))
      {
        //assign CEC lead id to local record
        newLead.CEC_Lead_Id__c = leadSBUToCEC.get(newLead.Id);
        leadToUpdate.add(newLead);
      }
    }
    if(!leadToUpdate.isEmpty())
    {
      update leadToUpdate;
    }
  }
  /*
  Functionality: The below trigger function is used to send email to leads once they are created from Bullseye platform in Rep Locator Project.
  Created by: Nagarajan Varadarajan
  Created on: 27/6/2017
  */
 /* if(trigger.isInsert && Trigger.isBefore)
  {
   List<Lead> createdLeads = Trigger.new;
   for(Lead leads : createdLeads)
   {
    if(leads.Lead_Source_Other__c == 'Honeywell Representative')
    {
     leads.OwnerId = Label.RepLocator_HONRepEmailUser;
    }
   }
  } */
  
  
  if(trigger.isInsert && Trigger.isBefore) 
  {
  try{
   List<Lead> createdLeads = Trigger.new;
   List<String> leadUserId = new List<String>(); 
   Map<string,Contact> mapCon = new Map<string,Contact>();
   List<Contact> leadContactUser = new List<Contact>();
   for(Lead leads : createdLeads)
   {
   if(leads.Lead_Source_Other__c == 'Channel Partner' || leads.Lead_Source_Other__c == 'Honeywell Rep'){
       
       if(leads.Lead_Source_Other__c == 'Channel Partner'){
       leads.channel_partner_name__c = leads.channel_partner_id__c;
       }
    if(leads.FirstName == NULL ||  leads.FirstName == '')
    {
      leadUserId.add(leads.LastName);
    } 
   }
   }
   if(leadUserId.size() > 0){ 
       leadContactUser = [select id,firstname,lastname,accountid,Account.Name,Phone_1__c,Email,country_name__c,Honeywell_ID__c from Contact where Honeywell_ID__c IN: leadUserId];
   }
   for(Contact eachContact : leadContactUser)
   {
    if(!mapCon.containsKey(eachContact.Honeywell_ID__c.ToLowerCase() ))
    {
     mapCon.put(eachContact.Honeywell_ID__c.ToLowerCase(), eachContact);
    }
   }
   for(Lead leads : createdLeads)
   {
    if(mapCon.containsKey(leads.LastName.ToLowerCase()) && (leads.FirstName == NULL || leads.FirstName == ''))
    {
     leads.FirstName = mapCon.get(leads.LastName.ToLowerCase()).FirstName;
     leads.Company = mapCon.get(leads.LastName.ToLowerCase()).Account.Name;
     leads.Email = mapCon.get(leads.LastName.ToLowerCase()).Email;
     leads.Phone = mapCon.get(leads.LastName.ToLowerCase()).phone_1__c; 
     leads.Account_Country__c = mapCon.get(leads.LastName.ToLowerCase()).country_name__c; 
     leads.Contact__c = mapCon.get(leads.LastName.ToLowerCase()).id;
     leads.Account__c = mapCon.get(leads.LastName.ToLowerCase()).accountid; 
     leads.LastName = mapCon.get(leads.LastName.ToLowerCase()).LastName;
    }
   }
  } catch (exception e){
   system.debug('exception in S2S_CEC_2_Aero_Lead trigger: '+e);
  }
  }
  if(trigger.isInsert && Trigger.isAfter)
  {
      List<Lead> createdLeads = [select id, Primary_Work_Number__c,name,Account__r.description,Other__c, recordTypeid,Lead_Market__c, Lead_Source_Other__c,CreatedDate,
      Channel_Partner_Name__r.BGAMob_Contact_Email__c,Channel_Partner_Name__r.Report_Postal_Code__c, Channel_Partner_Name__r.id, Channel_Partner_Name__c,HONEYWELL_ID__c,
      Channel_Partner_Name__r.BGAMob_Customer_Name__c,Channel_Partner_Name__r.BGAMob_Address_1__c, Channel_Partner_Name__r.BGAMob_Address_2__c, 
      Channel_Partner_Name__r.BGAMob_City_Name__c, Channel_Partner_Name__r.BGAMob_State_Province__c, Channel_Partner_Name__r.BGAMob_Postal_Code__c, 
      Channel_Partner_Name__r.BGAMob_Country_Nm__c, Market__c, FirstName, LastName, Company, Email, Phone, Country, Type_of_Platform__c, Description, Account_Country__c,Lead_Description__c from lead where id IN:Trigger.New];
      List<String> leadEmailIds;
      List<String> leadCCEmailIds;
   
      
      for(Lead leads : createdLeads)
      {
              leadEmailIds = new List<String>();
              leadCCEmailIds = new List<String>();
              if(leads.Lead_Source_Other__c == 'Channel Partner' || leads.Lead_Source_Other__c == 'Honeywell Rep')
              {  
                     RepLocator_LeadCreationEmailClass.sendEmailtoLeads(leads);
                  
              }    
          
      }
  }
}