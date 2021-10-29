public with sharing class AircraftPlatformSTDConf 
{
    
    private List<Aircraft_Platform_Configuration__c> pltConf;
    private List<Aircraft_Custom_Configuration__c> airConf;
    private Fleet_Asset_Detail__c air;
    
    public AircraftPlatformSTDConf(ApexPages.StandardController controller) 
    {
        this.air= (Fleet_Asset_Detail__c)controller.getRecord();
    }
    public List<Aircraft_Platform_Configuration__c> getPltConf()
    {
        List<Aircraft_Custom_Configuration__c> airCustConf = [Select Aircraft_Platform_Standard_Configuration__c from Aircraft_Custom_Configuration__c where Fleet_Asset_Detail__c = :air.Id];
        
        integer i = 0;
        if(airCustConf != null && airCustConf.size() > 0)
        {
            i = airCustConf.size();
        }
        string[] ids = new string[i];
        for (integer cnt=0;cnt<i;cnt++)
        {
             ids[cnt] =  airCustConf[cnt].Aircraft_Platform_Standard_Configuration__c;      
        }  
        
        
        if(i > 0)
        {
            pltConf = [Select id,Platform_Name__r.Name, Name,AIRCRAFT_PART_MODEL_NM__c,AIRCRAFT_CLASSIFICATION_CD__c,AVEL_MECH_IND__c,DESCRIPTION_NM__c,AIRCRAFT_PART_NUM__c,Manufacturer__c,Secondary__c,SITE_CD__c,Epic__c from Aircraft_Platform_Configuration__c where Platform_Name__c = :air.Platform_Name__c And Secondary__c = 'Primary' And Id NOT IN :ids ORDER BY Secondary__c,Epic__c];
        }
        else
        {
            pltConf = [Select id,Platform_Name__r.Name, Name,AIRCRAFT_PART_MODEL_NM__c,AIRCRAFT_CLASSIFICATION_CD__c,AVEL_MECH_IND__c,DESCRIPTION_NM__c,AIRCRAFT_PART_NUM__c,Manufacturer__c,Secondary__c,SITE_CD__c,Epic__c from Aircraft_Platform_Configuration__c where Platform_Name__c = :air.Platform_Name__c And Secondary__c = 'Primary' ORDER BY Secondary__c,Epic__c];
        }
        
        return pltConf;
        
    }

    public List<Aircraft_Custom_Configuration__c> getAirConf()
    {
        airConf = [Select id,Name,DESCRIPTION_NM__c,Sub_System__c,AVEL_MECH_IND__c,Manufacturer__c,SITE_CD__c from Aircraft_Custom_Configuration__c where Fleet_Asset_Detail__c = :air.Id];
        return airConf;
        
    }

}