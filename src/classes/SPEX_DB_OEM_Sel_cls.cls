/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : SPEX_DB_OEM_Sel_cls
* Description           : Apex class involved in SPEX Inventory - OEM Selection screen.
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 03-Oct-2012      0.01           NTTDATA               Initial Version

***********************************************************************************************************/
public class SPEX_DB_OEM_Sel_cls
{
    String strOEMName;
    Integer intPlatformCount;
    List<String> lstOEM = new List<String>();
    
    public List<SPEXDTO_cls> lstSpexDto {get;set;}
    public String dtRefreshTime {get;set;}
    
    public Map<String, SPEXDTO_cls> mapSpexDto {get;set;}
    
    public SPEX_DB_OEM_Sel_cls()
    {    
        lstSpexDto = new List<SPEXDTO_cls>();
        mapSpexDto = new Map<String, SPEXDTO_cls>();
        getOEMDetails();
        dtRefreshTime = SPEXDTO_cls.getRefreshTime();
    }
    
    /**
     * This method is used to get details of each OEM.
    */
    public void getOEMDetails()
    {
        List<sObject> lstOEM = [select OEM_NAME__C, sum(StckOutCnt__c) OEM_StockOut_Count, sum(RiskCnt__c) OEM_Risk_Count
        from Spex_DB_Platform_Summary__c group by OEM_NAME__C order by sum(StckOutCnt__c) desc, sum(RiskCnt__c) desc, OEM_NAME__C asc];
                
        Integer intPlatformCount;
        String strOEMName ;
        SPEXDTO_cls objSPEXDTO;
        for (sObject query: lstOEM)
        {
            objSPEXDTO = new SPEXDTO_cls();
            strOEMName = String.valueOf(query.get('OEM_NAME__C'));
            objSPEXDTO.strOEMName = strOEMName;
            objSPEXDTO.intStockOutPlatforms = 0;
            objSPEXDTO.intAtRiskPlatforms = 0;
            objSPEXDTO.intSafePlatforms = 0;
            
            if(Integer.valueof(query.get('OEM_StockOut_Count')) > 0)
            {
                objSPEXDTO.strOEMStatus = 'red';
            }
            else if(Integer.valueof(query.get('OEM_Risk_Count')) > 0)
            {
                objSPEXDTO.strOEMStatus = 'yellow';
            }
            else
            {
                 objSPEXDTO.strOEMStatus = 'green';
            }
            lstSpexDto.add(objSPEXDTO);
        }
    
        for(Integer i=0; i<lstSpexDto.size(); i++)
        {
            System.debug('lstSpexDto.get(i).strOEMName.toUpperCase() '+lstSpexDto.get(i).strOEMName.toUpperCase());        
            System.debug('lstSpexDto.get(i)   '+lstSpexDto.get(i));
            mapSpexDto.put(lstSpexDto.get(i).strOEMName.toUpperCase(),lstSpexDto.get(i));
        }
    }
}