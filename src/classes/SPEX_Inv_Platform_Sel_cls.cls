/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : SPEX_Inv_Platform_Sel_cls
* Description           : Apex class involved in SPEX Inventory - Platform Selection screen.
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 05-Oct-2012      0.01           NTTDATA               Initial Version

***********************************************************************************************************/
public class SPEX_Inv_Platform_Sel_cls
{
    public List<SPEXDTO_cls> lstPlatformSpexDto {get;set;}
    public String strOEMName {get;set;}
    public String strOEMImageName {get;set;}
    public String dtRefreshTime {get;set;}
    
    public SPEX_Inv_Platform_Sel_cls()
    {
        if(null!=System.currentPageReference().getParameters().get('OEM'))
        {
            strOEMName = System.currentPageReference().getParameters().get('OEM');            
            //strOEMImageName = 'img/SPEX-'+strOEMName+'-LOGO.png';
            strOEMImageName = SPEX_GetImage_cls.getImageName(strOEMName);
            getOEMDetails(strOEMName);
            dtRefreshTime = SPEXDTO_cls.getRefreshTime();
        }
    }
    
        
    /**
     * This method is used to get OEM details.
     * @param strOEMName - String - OEM Name for which details need to be fetched
    */
    public void getOEMDetails(String strOEMName)
    {
        List<sObject> lstObjPlatforms =  [select Platform__c,sum(StckOutAmer__c) Amer_SO_Count,sum(StckOutApac__c) Apac_SO_Count,
        sum(StckOutEMEA__c) Emea_SO_Count,sum(AtRisk_Americ__c) Amer_Risk_Count,sum(AtRisk_APAC__c) Apac_Risk_Count,
        sum(AtRisk_EMEA__c) Emea_Risk_Count
        from SPEX_DB_Platform_Summary__c where OEM_NAME__c =:strOEMName group by Platform__c order by sum(StckOutCnt__c) desc,sum(RiskCnt__c) desc, Platform__c asc limit 6];
        lstPlatformSpexDto = new List<SPEXDTO_cls>();   
        Integer intAmerSOCount;
        Integer intApacSOCount;
        Integer intEmeaSOCount;
        Integer intAmerRisk_Count;
        Integer intEmeaRiskCount;
        Integer intApacRiskCount;
        String strPlatform;
        SPEXDTO_cls objSPEXDTO = new SPEXDTO_cls();
        for (sObject query: lstObjPlatforms)
        {
            objSPEXDTO = new SPEXDTO_cls();
            strPlatform = String.valueOf(query.get('Platform__c'));
            objSPEXDTO.strPlatform = strPlatform;
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