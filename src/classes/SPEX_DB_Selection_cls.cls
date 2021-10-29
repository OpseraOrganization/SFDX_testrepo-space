/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : SPEX_DB_Selection_cls
* Description           : Apex class involved in SPEX Dashboard Selection screen. 
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 03-Oct-2012      0.01           NTTDATA               Initial Version

***********************************************************************************************************/
public class SPEX_DB_Selection_cls
{
    public List<SPEXDTO_cls> lstPlatformSpexDto {get;set;}
    public List<SPEXDTO_cls> lstSpexDto2 {get;set;}
    public String dtRefreshTime {get;set;}
    
    public SPEX_DB_Selection_cls()
    {   
        getTop8CriticalParts();
    //    getRiskPlatforms();
        getOEMDetails();
        dtRefreshTime = SPEXDTO_cls.getRefreshTime();
    }        
    
    /**
     * This method is used to identify top 8 critical parts.
     */
    public void getTop8CriticalParts()
    {
        lstSpexDto2 = new List<SPEXDTO_cls>();   
        List<sObject> lstObjCriticalParts = [select PART_NUMBER__C, Part_Description__c
        from SPEX_DB_Part_Summary__c order by StockOut_Part__c desc, Risk_Part__c desc, Grey_Part__c desc, Stockout_Cnt__c desc, RiskGreyCnt__c desc, Risk_Cnt__c desc, Grey_Cnt__c desc, STOCKOUT__C desc, PART_NUMBER__C asc limit 8];
    
        for (sObject query: lstObjCriticalParts)
        { 
            SPEXDTO_cls objSPEXDTO= new SPEXDTO_cls();
            objSPEXDTO.strPartNo=String.valueOf(query.get('PART_NUMBER__C'));
            if(null!=String.valueOf(query.get('Part_Description__c')))
            {
                objSPEXDTO.strPartDesc=String.valueOf(query.get('Part_Description__c')).toLowerCase();
            }
            lstSpexDto2.add(objSPEXDTO);
        }
    } 
        
    /**
     * This method is used to identify platforms at risk (ie) platforms with Stock out and Risk status.
    */
/*    public void getRiskPlatforms()
    {
        lstPlatformSpexDto = new List<SPEXDTO_cls>();   
        List<sObject> lstObjStockOutPlatforms = [select Platform__c,sum(StckOutCnt__c) StockOut_Count,sum(RiskCnt__c) AtRisk_Count from SPEX_DB_Platform_Summary__c  
        where StckOutCnt__c > 0 or RiskCnt__c > 0 group by Platform__c order by sum(StckOutCnt__c) desc,sum(RiskCnt__c) desc, Platform__c asc];
        String strPlatform;
        SPEXDTO_cls objSPEXDTO;
        for (sObject query: lstObjStockOutPlatforms)
        {
            objSPEXDTO = new SPEXDTO_cls();
            strPlatform = String.valueOf(query.get('Platform__c'));
            objSPEXDTO.strPlatform = strPlatform;
            objSPEXDTO.intStockOut = Integer.valueof(query.get('StockOut_Count'));
            objSPEXDTO.intAtRisk = Integer.valueof(query.get('AtRisk_Count'));
            objSPEXDTO.strImgFileName = SPEX_GetImage_cls.getImageName('DASSAULT', strPlatform);
            lstPlatformSpexDto.add(objSPEXDTO);
        }
    } */
    
        /**
     * This method is used to get OEM details.
     * @param strOEMName - String - OEM Name for which details need to be fetched
    */
    public void getOEMDetails()
    {
        List<sObject> lstObjPlatforms =  [select Platform__c,sum(StckOutAmer__c) Amer_SO_Count,sum(StckOutApac__c) Apac_SO_Count,
        sum(StckOutEMEA__c) Emea_SO_Count,sum(AtRisk_Americ__c) Amer_Risk_Count,sum(AtRisk_APAC__c) Apac_Risk_Count,
        sum(AtRisk_EMEA__c) Emea_Risk_Count,OEM_NAME__c
        from SPEX_DB_Platform_Summary__c group by OEM_NAME__c,Platform__c order by sum(StckOutCnt__c) desc,sum(RiskCnt__c) desc, Platform__c asc limit 6];
        lstPlatformSpexDto = new List<SPEXDTO_cls>();   
        Integer intAmerSOCount;
        Integer intApacSOCount;
        Integer intEmeaSOCount;
        Integer intAmerRisk_Count;
        Integer intEmeaRiskCount;
        Integer intApacRiskCount;
        String strPlatform;
        String strOEMName;
        SPEXDTO_cls objSPEXDTO = new SPEXDTO_cls();
        for (sObject query: lstObjPlatforms)
        {
            objSPEXDTO = new SPEXDTO_cls();
            strPlatform = String.valueOf(query.get('Platform__c'));
            objSPEXDTO.strPlatform = strPlatform;
            strOEMName = String.valueOf(query.get('OEM_NAME__c'));
            objSPEXDTO.strOEMName = strOEMName;
            intAmerSOCount = Integer.valueof(query.get('Amer_SO_Count'));
            intApacSOCount = Integer.valueof(query.get('Apac_SO_Count'));
            intEmeaSOCount = Integer.valueof(query.get('Emea_SO_Count'));
            intAmerRisk_Count = Integer.valueof(query.get('Amer_Risk_Count'));
            intApacRiskCount = Integer.valueof(query.get('Apac_Risk_Count'));
            intEmeaRiskCount = Integer.valueof(query.get('Emea_Risk_Count'));
            
            if(intAmerSOCount > 0)
            {
                objSPEXDTO.strAmerStatus = 'val red';
            }else if(intAmerRisk_Count > 0)
            {
                objSPEXDTO.strAmerStatus = 'val yellow';
            }else
            {
                objSPEXDTO.strAmerStatus = 'val green';
            }
            
            if(intApacSOCount > 0)
            {
                objSPEXDTO.strApacStatus= 'val red';
            }else if(intApacRiskCount > 0)
            {
                objSPEXDTO.strApacStatus = 'val yellow';
            }else
            {
                objSPEXDTO.strApacStatus = 'val green';
            }
            
            if(intEmeaSOCount > 0)
            {
                objSPEXDTO.strEmeaStatus = 'val red';
            }else if(intEmeaRiskCount > 0)
            {
                objSPEXDTO.strEmeaStatus = 'val yellow';
            }else
            {
                objSPEXDTO.strEmeaStatus = 'val green';
            }
            
            objSPEXDTO.intAmerStockOutPlatforms = intAmerSOCount;
            objSPEXDTO.intApacStockOutPlatforms = intApacSOCount;
            objSPEXDTO.intEmeaStockOutPlatforms = intEmeaSOCount;
            objSPEXDTO.intAmerAtRiskPlatforms = intAmerRisk_Count;
            objSPEXDTO.intApacAtRiskPlatforms = intApacRiskCount;
            objSPEXDTO.intEmeaAtRiskPlatforms = intEmeaRiskCount;
            objSPEXDTO.strImgFileName = SPEX_GetImage_cls.getImageName(strOEMName, strPlatform);
            lstPlatformSpexDto.add(objSPEXDTO);
        }
    }
   
}