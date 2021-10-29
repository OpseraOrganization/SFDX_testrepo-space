/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : SPEXDTO_cls
* Description           : Apex class used as DTO for all the SPEX related APEX classes
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 03-Oct-2012      0.01           NTTDATA               Initial Version

***********************************************************************************************************/
public class SPEXDTO_cls
{
    public string strPartNo {get;set;}
    public string strPartDesc{get;set;}
    public string strABCCode {get;set;}
    public string strPlatform {get;set;}
    
    public string strAmerStatus {get;set;}
    public string strApacStatus {get;set;}
    public string strEmeaStatus {get;set;}
    
    public string strImgFileName {get;set;}
    public string strOEMImgFileName {get;set;}

    public string strOEMName {get;set;}
    public string strOEMStatus {get;set;}
    
    public string strCaseId {get;set;}
    
    public Boolean bolAOGPart {get;set;}
    
    public integer intStockOut {get;set;}
    public integer intAtRisk {get;set;}
    
    public integer intAmerStock {get;set;}
    public integer intAmerDemand {get;set;}
    public integer intAmerStockOut {get;set;}
    
    public integer intApacStock {get;set;}
    public integer intApacDemand {get;set;}
    public integer intApacStockOut {get;set;}
    
    public integer intEmeaStock {get;set;}
    public integer intEmeaDemand {get;set;}
    public integer intEmeaStockOut {get;set;}
    
    public integer intStockOutPlatforms {get;set;}
    public integer intAtRiskPlatforms {get;set;}
    public integer intSafePlatforms {get;set;}
    public integer intTotalPlatforms {get;set;}
    
    public integer intPlatformAmerDemand{get;set;}
    public integer intPlatformApacDemand{get;set;}
    public integer intPlatformEmeaDemand{get;set;}
    
    public integer intAmerStockOutPlatforms {get;set;}
    public integer intApacStockOutPlatforms {get;set;}
    public integer intEmeaStockOutPlatforms {get;set;}
    
    public integer intAmerAtRiskPlatforms {get;set;}
    public integer intApacAtRiskPlatforms {get;set;}
    public integer intEmeaAtRiskPlatforms {get;set;}
    
    public integer intAmerSafePlatforms {get;set;}
    public integer intApacSafePlatforms {get;set;}
    public integer intEmeaSafePlatforms {get;set;}
    
    public static String getRefreshTime()
    {
        List<sObject> lstTime = [SELECT Refresh_Time__c from SPEX_DB_Data_Log__c where Load_Status__c != 'Failed' order by lastmodifieddate desc limit 1];
        if(lstTime.size()>0)
        {
            return Datetime.valueof(lstTime[0].get('Refresh_Time__c')).format();
        }
        return '';
    }
}