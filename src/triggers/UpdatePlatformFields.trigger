trigger UpdatePlatformFields on SPEX_DB_Part_Summary__c (after update) 
{
    List<SPEX_DB_Platform_Summary__c> lstPlatforms;
    List<ID> lstPartId = new List<ID>();
    
    SPEX_DB_Platform_Summary__c objPlatform;
    Boolean isRecordUpdated;
    Map<ID,String> mpAmerStatus = new Map<ID,String>();
    Map<ID,String> mpApacStatus = new Map<ID,String>();
    Map<ID,String> mpEmeaStatus = new Map<ID,String>();
    Integer intlstPlatformsSize = 0;
    
    for(SPEX_DB_Part_Summary__c objPart : trigger.new)
    {
        isRecordUpdated = false; 
        if(System.Trigger.OldMap.get(objPart.Id).Status_AMERICAS__c != System.Trigger.NewMap.get(objPart.Id).Status_AMERICAS__c ||
           System.Trigger.OldMap.get(objPart.Id).Status_APAC__c != System.Trigger.NewMap.get(objPart.Id).Status_APAC__c ||
           System.Trigger.OldMap.get(objPart.Id).Status_EMEA__c!= System.Trigger.NewMap.get(objPart.Id).Status_EMEA__c)
        {     
            isRecordUpdated = true;
        }
        if(isRecordUpdated)
        {     
            lstPartId.add(objPart.id);
            mpAmerStatus.put(objPart.id,objPart.Status_AMERICAS__c);
            mpApacStatus.put(objPart.id,objPart.Status_APAC__c);
            mpEmeaStatus.put(objPart.id,objPart.Status_EMEA__c);
        }                           
    }
    if(lstPartId != null && lstPartId.size() > 0)
    {
        lstPlatforms = [select id,part_number__c from SPEX_DB_Platform_Summary__c where PART_NUMBER__C in :lstPartId];
    }
    if(lstPlatforms!=null)
    {
        intlstPlatformsSize = lstPlatforms.size();
    }
    for(Integer i=0; i<intlstPlatformsSize; i++)
    {
        lstPlatforms[i].Prt_Sts_EMEA__c = mpEmeaStatus.get(lstPlatforms[i].part_number__c); 
        lstPlatforms[i].Prt_Sts_APAC__c = mpApacStatus.get(lstPlatforms[i].part_number__c); 
        lstPlatforms[i].Prt_Sts_Amer__c = mpAmerStatus.get(lstPlatforms[i].part_number__c); 
    }
    if(lstPlatforms != null && lstPlatforms.size() > 0)
    {
        update lstPlatforms;
    }
}