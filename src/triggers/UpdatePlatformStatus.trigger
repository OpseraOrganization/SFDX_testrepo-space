trigger UpdatePlatformStatus on SPEX_DB_Platform_Summary__c(before insert, before update)
{
    List<SPEX_DB_Part_Summary__c> lstPartsIns;
    List<SPEX_DB_Part_Summary__c> lstPartsUpd;
    //List<SPEX_DB_Platform_Summary__c> lstPlatforms;
    List<ID> lstPartIdPlatformIns = new List<ID>();
    List<ID> lstPartIdPlatformUpd = new List<ID>();
    Boolean isRecordUpdated;
    Map<ID,String> mpAmerStatusIns = new Map<ID,String>();
    Map<ID,String> mpApacStatusIns = new Map<ID,String>();
    Map<ID,String> mpEmeaStatusIns = new Map<ID,String>();
    Map<ID,String> mpAmerStatusUpd = new Map<ID,String>();
    Map<ID,String> mpApacStatusUpd = new Map<ID,String>();
    Map<ID,String> mpEmeaStatusUpd = new Map<ID,String>();
    Integer lstPartsInsSize;
    Integer lstPartsUpdSize;
    
    for(SPEX_DB_Platform_Summary__c objPlatform : trigger.new)
    {
        if(Trigger.IsInsert)
        {
            if(objPlatform.part_number__c!=null)
            {
                //lstPlatformId.add(objPlatform.id);
                lstPartIdPlatformIns.add(objPlatform.Part_Number__c);
            }
        }
        if(Trigger.IsUpdate)
        {
            if(objPlatform.part_number__c!=null && (System.Trigger.OldMap.get(objPlatform.Id).part_number__c!= System.Trigger.NewMap.get(objPlatform.Id).part_number__c))
            {
                //lstPlatformId.add(objPlatform.id);
                lstPartIdPlatformUpd.add(objPlatform.Part_Number__c);
                System.debug('SPEXDATA objPlatform.Part_Number__c'+objPlatform.Part_Number__c);
            }
        }
    }    
    if(lstPartIdPlatformIns.size() > 0)
    {
        lstPartsIns = [select id,Status_AMERICAS__c,Status_APAC__c,Status_EMEA__c from SPEX_DB_Part_Summary__c where id in :lstPartIdPlatformIns];        
        lstPartsInsSize = lstPartsIns.size();
        System.debug('SPEXDATA lstPartsInsSize '+lstPartsInsSize );
    }
    if(lstPartIdPlatformUpd.size() > 0)
    {
        lstPartsUpd = [select id,Status_AMERICAS__c,Status_APAC__c,Status_EMEA__c from SPEX_DB_Part_Summary__c where id in :lstPartIdPlatformUpd];
        lstPartsUpdSize = lstPartsUpd.size();        
        System.debug('SPEXDATA lstPartsUpdSize '+lstPartsUpdSize);
    }
    
    for(Integer i=0; i<lstPartsInsSize; i++)
    {        
        mpEmeaStatusIns.put(lstPartsIns[i].id,lstPartsIns[i].Status_EMEA__c);
        mpApacStatusIns.put(lstPartsIns[i].id,lstPartsIns[i].Status_APAC__c);
        mpAmerStatusIns.put(lstPartsIns[i].id,lstPartsIns[i].Status_AMERICAS__c);
    }    
    for(Integer i=0; i<lstPartsUpdSize; i++)
    {        
        mpEmeaStatusUpd.put(lstPartsUpd[i].id,lstPartsUpd[i].Status_EMEA__c);
        System.debug('SPEXDATA lstPartsUpd[i].Status_EMEA__c'+lstPartsUpd[i].Status_EMEA__c);
        System.debug('SPEXDATA lstPartsUpd[i].id'+lstPartsUpd[i].id);
        mpApacStatusUpd.put(lstPartsUpd[i].id,lstPartsUpd[i].Status_APAC__c);
        mpAmerStatusUpd.put(lstPartsUpd[i].id,lstPartsUpd[i].Status_AMERICAS__c);
    }
    for(SPEX_DB_Platform_Summary__c objPlatform : trigger.new)
    {
        if(Trigger.IsInsert)
        {
            if(objPlatform.part_number__c!=null)
            {
                objPlatform.Prt_Sts_EMEA__c = mpEmeaStatusIns.get(objPlatform.part_number__c); 
                objPlatform.Prt_Sts_APAC__c = mpApacStatusIns.get(objPlatform.part_number__c); 
                objPlatform.Prt_Sts_Amer__c = mpAmerStatusIns.get(objPlatform.part_number__c); 
                //lstPlatforms.add(objPlatform);
            }
        }
        if(Trigger.IsUpdate)
        {
            if(objPlatform.part_number__c!=null && (System.Trigger.OldMap.get(objPlatform.Id).part_number__c!= System.Trigger.NewMap.get(objPlatform.Id).part_number__c))
            {
                objPlatform.Prt_Sts_EMEA__c = mpEmeaStatusUpd.get(objPlatform.part_number__c); 
                objPlatform.Prt_Sts_APAC__c = mpApacStatusUpd.get(objPlatform.part_number__c); 
                objPlatform.Prt_Sts_Amer__c = mpAmerStatusUpd.get(objPlatform.part_number__c);
            }
        }
    }
    /*if(lstPlatforms.size() > 0)
    {
        update lstPlatforms;
    }*/
}