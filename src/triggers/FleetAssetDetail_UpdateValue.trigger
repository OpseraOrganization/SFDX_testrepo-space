/*******************************************************************************************************************************************************
Name         : FleetAssetDetail_UpdateValue
Created By   : Sindhuja Velmurugan
Company Name : NTT Data
Project      : SR#380363
Created Date : 25 March 2013
Usages       : The trigger is to update Tail Number and Serial Number fields in Case Object if an update happens to these fields on Fleet Asset Aircraft object
********************************************************************************************************************************************************/
trigger FleetAssetDetail_UpdateValue on Fleet_Asset_Detail__c (after update) 
{
    List<Case> casupd = new List<Case>();
    String Tail=null;
    String SerialNo=null;
    String BaseICAO;
    
        for (Fleet_Asset_Detail__c aircft : Trigger.new)
        {
                if(Trigger.isupdate && ((Trigger.OldMap.get(aircft.id).Tail_Number__c != Trigger.NewMap.get(aircft.id).Tail_Number__c) || (Trigger.OldMap.get(aircft.id).Serial_Number__c != Trigger.NewMap.get(aircft.id).Serial_Number__c)||(Trigger.OldMap.get(aircft.id).Aircraft_Base__c != Trigger.NewMap.get(aircft.id).Aircraft_Base__c)))
                {
                    casupd = [select id,Tail__c,Serial_Number__c,Aircraft_Base_ICAO__c from Case where Aircraft_Name__c = :aircft.id];  
                    List<Fleet_Asset_Detail__c> FltAst = [Select Tail_Number__c,Serial_Number__c,Base_ICAO__c from Fleet_Asset_Detail__c where id = : aircft.id]; 
                    if(FltAst!=null && FltAst.size()>0)
                    {
                        Fleet_Asset_Detail__c objFlt = FltAst.get(0);
                        Tail = objFlt.Tail_Number__c;
                        SerialNo = objFlt.Serial_Number__c;
                        BaseICAO = ObjFlt.Base_ICAO__c;
                    }
                    List<Case> lstCaseUpdt = new List<Case>();
                    for(Integer i=0; i< casupd.size(); i++)
                    {
                        casupd[i].Tail__c=Tail;
                        casupd[i].Serial_Number__c=SerialNo;
                        casupd[i].Aircraft_Base_ICAO__c=BaseICAO;
                        lstCaseUpdt.add(casupd[i]);
                    }
                    if(lstCaseUpdt.size()>0)
                    {
                        update lstCaseUpdt;
                    } 
                }
         }
}