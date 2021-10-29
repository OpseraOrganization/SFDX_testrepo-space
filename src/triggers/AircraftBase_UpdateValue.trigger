/*******************************************************************************************************************************************************
Name         : AircraftBase_UpdateValue
Created By   : Sindhuja Velmurugan
Company Name : NTT Data
Project      : SR#380363
Created Date : 25 March 2013
Usages       : The trigger is to update Aircraft Base ICAO field in Case Object if an update happens to this field on  Aircraft Base ( Airport )object
********************************************************************************************************************************************************/
trigger AircraftBase_UpdateValue on Aircraft_Base__c (after update) 
{
    List<Case> csupd = new List<Case>();
    String BaseICAO=null;
        
       for (Aircraft_Base__c airbas : Trigger.new)
       {
            if(Trigger.isupdate && (Trigger.OldMap.get(airbas.id).Base_ICAO__c != Trigger.NewMap.get(airbas.id).Base_ICAO__c))
            {
              csupd = [select id,Aircraft_Base_ICAO__c from Case where Aircraft_Name__c in (select id from Fleet_Asset_Detail__c where Aircraft_Base__c = :airbas.id)];  
              List<Aircraft_Base__c> LstAir = [Select Base_ICAO__c from Aircraft_Base__c where id = : airbas.id]; 
              if(LstAir!=null && LstAir.size()>0)
              {
                Aircraft_Base__c objAir = LstAir.get(0);
                BaseICAO=objAir.Base_ICAO__c;
              }
              List<Case> lstCaseUpdt = new List<Case>();
              for(Integer i=0; i< csupd.size(); i++)
          {
            csupd[i].Aircraft_Base_ICAO__c=BaseICAO;
            lstCaseUpdt.add(csupd[i]);
          }
          if(lstCaseUpdt.size()>0)
          {
            update lstCaseUpdt;
              } 
            }
         }  
}