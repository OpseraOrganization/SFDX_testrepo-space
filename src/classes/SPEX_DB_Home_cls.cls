/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : SPEX_DB_Home_cls
* Description           : Apex class involved in SPEX - Honeywell Intelligence Center – Home.
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 03-Oct-2012      0.01           NTTDATA               Initial Version

***********************************************************************************************************/

public class SPEX_DB_Home_cls
{  
    public String strAmericStatus { get; set; }     
    public String strApacStatus { get; set; } 
    public String strEmeaStatus { get; set; }
    public String strStatus { get; set; }
    public String strAOGStatus { get; set; }
    public String dtRefreshTime {get;set;}
        
    public Map<string,String> mpStatus {get;set;}
    public List<string> lstStrPlatform {get;set;}
          
    public SPEX_DB_Home_cls()
    {       
        getTop3RiskPlatforms();
        getRegionStatus(); 
        getOverallStatus();
        //getAOGCases();
        dtRefreshTime = SPEXDTO_cls.getRefreshTime();
    } 
    
    /**
     * This method is used to get the open AOG cases and its status.
    */
    /*public void getAOGCases()
    { 
        DateTime dtFrame = system.now().addHours(-4);
        List<sObject> lstAOGRedCases = [SELECT count(Case_Number__c) Count_Red FROM Case 
        WHERE RecordTypeId =: label.Case_AOG_RecordType and isClosed = false and Created_date__c <: dtFrame ];
        
        Integer intRedAOGs = Integer.valueOf(lstAOGRedCases[0].get('Count_Red'));
        
        if(intRedAOGs > 0)
        {
            strAOGStatus = 'red';
        }
        else
        {
            List<sObject> lstAOGYellowCases = [SELECT count(Case_Number__c) Count_Yellow FROM Case 
        WHERE RecordTypeId =: label.Case_AOG_RecordType and isClosed = false and Created_date__c =: dtFrame ];
            
            Integer intYellowAOGs = Integer.valueOf(lstAOGYellowCases[0].get('Count_Yellow'));
            
            if(intYellowAOGs > 0)
            {
                strAOGStatus = 'yellow';
            }
            else
            {
                strAOGStatus = 'green';
            }
        }
    }*/
    
    /**
     * This method is used to identify top three platforms at risk.
    */
    public void getTop3RiskPlatforms()
    { 
        lstStrPlatform = new List<String>();
        
        List<sObject> lstPlatforms = [select Platform__c from SPEX_DB_Platform_Summary__c where StckOutCnt__c > 0 or RiskCnt__c > 0
        group by platform__c order by sum(StckOutCnt__c) desc,sum(RiskCnt__c) desc, Platform__c asc limit 3];
        
        for (sObject query: lstPlatforms)
        {
            lstStrPlatform.add(String.valueOf(query.get('Platform__c')));
        }
    }
    
    /**
     * This method is used to check the status for each region and return the appropriate color code.
     * Red - stockout parts are present. Yellow - No stockout parts and only AtRisk parts are present. Green - only safe parts exist.
    */
    public void getRegionStatus()
    {
        String strAmericStatus = null;
        String strApacStatus = null;
        String strEmeaStatus = null;        
        mpStatus = new Map<String,String>();
        
        List<sObject> lstAmerPartStockOut = [select count(PART_NUMBER__C) Count_Red
        from SPEX_DB_Part_Summary__c where STATUS_AMERICAS__C = 'Stock_Out'];
        
        Integer intAmerRed = Integer.valueOf(lstAmerPartStockOut[0].get('Count_Red'));
        
        if(intAmerRed > 0)
        {
            strAmericStatus = 'red';
        }
        else
        {
            List<sObject> lstAmerPartAtRisk = [select count(PART_NUMBER__C) Count_Yellow
            from SPEX_DB_Part_Summary__c where STATUS_AMERICAS__C = 'At_Risk'];
            
            Integer intAmerYellow = Integer.valueOf(lstAmerPartAtRisk[0].get('Count_Yellow'));
            
            if(intAmerYellow > 0)
            {
                strAmericStatus = 'yellow';
            }
            else
            {
                strAmericStatus = 'green';
            }
        }
        
        mpStatus.put('Americas',strAmericStatus);
        
        List<sObject> lstApacPartStockOut = [select count(PART_NUMBER__C) Count_Red
        from SPEX_DB_Part_Summary__c where STATUS_APAC__C = 'Stock_Out'];
        
        Integer intApacRed = Integer.valueOf(lstApacPartStockOut[0].get('Count_Red'));
        
        if(intApacRed > 0)
        {
            strApacStatus = 'red';
        }
        else
        {
            List<sObject> lstApacPartAtRisk = [select count(PART_NUMBER__C) Count_Yellow
            from SPEX_DB_Part_Summary__c where STATUS_APAC__C = 'At_Risk'];
            
            Integer intApacYellow = Integer.valueOf(lstApacPartAtRisk[0].get('Count_Yellow'));
            
            if(intApacYellow > 0)
            {
                strApacStatus = 'yellow';
            }
            else
            {
                strApacStatus = 'green';
            }
        }
        mpStatus.put('APAC',strApacStatus);
        
        List<sObject> lstEmeaPartStockOut = [select count(PART_NUMBER__C) Count_Red
        from SPEX_DB_Part_Summary__c where STATUS_EMEA__C = 'Stock_Out'];
        
        Integer intEmeaRed = Integer.valueOf(lstEmeaPartStockOut[0].get('Count_Red'));
        
        if(intEmeaRed > 0)
        {
            strEmeaStatus = 'red';
        }
        else
        {
            List<sObject> lstEmeaPartAtRisk = [select count(PART_NUMBER__C) Count_Yellow
            from SPEX_DB_Part_Summary__c where STATUS_EMEA__C = 'At_Risk'];
            
            Integer intEmeaYellow = Integer.valueOf(lstEmeaPartAtRisk[0].get('Count_Yellow'));
            
            if(intEmeaYellow > 0)
            {
                strEmeaStatus = 'yellow';
            }
            else
            {
                strEmeaStatus = 'green';
            }
        }
        mpStatus.put('EMEA',strEmeaStatus);
    }
    
    /**
     * This method is used to check the status for entire dashboard and return the appropriate color code.
     * Red - stockout parts exist. Yellow - No stockout parts and only AtRisk parts are present. Green - only safe parts.
    */
    public void getOverallStatus()
    {
        String strStatus = null;
        
        List<sObject> lstPartStockOut = [select count(PART_NUMBER__C) Count_Red
        from SPEX_DB_Part_Summary__c where overall_part_Status__c = 'Stock_Out'];
        
        Integer intRedPart = Integer.valueOf(lstPartStockOut[0].get('Count_Red'));
        
        if(intRedPart > 0)
        {
            strStatus = 'red';
        }
        else
        {
            List<sObject> lstPartAtRisk = [select count(PART_NUMBER__C) Count_Yellow
            from SPEX_DB_Part_Summary__c where overall_part_Status__c = 'At_Risk'];
            
            Integer intYellowPart = Integer.valueOf(lstPartAtRisk[0].get('Count_Yellow'));
            
            if(intYellowPart > 0)
            {
                strStatus = 'yellow';
            }
            else
            {
                strStatus = 'green';
            }
        }
        mpStatus.put('Overall Status',strStatus);
    }
}