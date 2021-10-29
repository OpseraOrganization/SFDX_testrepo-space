/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : SPEX_DB_CriticalParts_cls
* Description           : Apex class involved in SPEX Inventory – Critical Parts (non-platform specific).
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 04-Oct-2012      0.01           NTTDATA               Initial Version
* 38-Nov-2013                     NTTDATA               To display View AOG button
***********************************************************************************************************/

public class SPEX_DB_CriticalParts_cls
{
    public List<SPEXDTO_cls> lstSpexDto {get;set;}
    public String dtRefreshTime {get;set;}
    public SPEX_DB_CriticalParts_cls()
    {
        getTop100PartDetails();
        dtRefreshTime = SPEXDTO_cls.getRefreshTime();
    }
    
    /**
     * This method is used to identify top 100 parts depending on Stock out value.
    */
    public void getTop100PartDetails()
    { 
        SPEXDTO_cls objSpexDto = new SPEXDTO_cls();
                      
        List<sObject> lstParts = [select PART_NUMBER__C,PART_DESCRIPTION__C,ABC_CODE__C,STATUS_AMERICAS__C,STATUS_APAC__C,STATUS_EMEA__C,
        STOCKOUT_AMERICAS__C, STOCKOUT_EMEA__C, STOCKOUT_APAC__C, STOCK_BY_AMERICAS__C, STOCK_BY_APAC__C, STOCK_BY_EMEA__C, DEMAND_BY_AMERICAS__C,
        DEMAND_BY_APAC__C, DEMAND_BY_EMEA__C
        from Spex_DB_Part_Summary__c order by StockOut_Part__c desc, Risk_Part__c desc, Grey_Part__c desc, Stockout_Cnt__c desc, RiskGreyCnt__c desc, Risk_Cnt__c desc, Grey_Cnt__c desc, STOCKOUT__C desc, PART_NUMBER__C asc limit 100];
        List<String> lstAtRiskPartNumbers = new List<String>();
        lstSpexDto = new List<SPEXDTO_cls>();
        
        for (sObject query: lstParts)
        {
            objSpexDto = new SPEXDTO_cls();
            objSpexDto.strPartNo = String.valueOf(query.get('PART_NUMBER__C'));
            objSpexDto.strPartDesc = String.valueOf(query.get('PART_DESCRIPTION__C'));
            objSpexDto.strABCCode = String.valueOf(query.get('ABC_CODE__C'));
            objSpexDto.intAmerStockOut = Integer.valueOf(query.get('STOCKOUT_AMERICAS__C'));            
            objSpexDto.intEmeaStockOut = Integer.valueOf(query.get('STOCKOUT_EMEA__C'));            
            objSpexDto.intApacStockOut = Integer.valueOf(query.get('STOCKOUT_APAC__C'));
            objSpexDto.strAmerStatus = SPEX_Status_ColorCode_cls.getColorCode(String.valueof(query.get('STATUS_AMERICAS__C')));
            objSpexDto.strApacStatus = SPEX_Status_ColorCode_cls.getColorCode(String.valueof(query.get('STATUS_APAC__C')));
            objSpexDto.strEmeaStatus = SPEX_Status_ColorCode_cls.getColorCode(String.valueof(query.get('STATUS_EMEA__C')));
            objSpexDto.intAmerStock=0;
            objSpexDto.intApacStock = 0;
            objSpexDto.intEmeaStock = 0;
            objSpexDto.intAmerDemand = 0;
            objSpexDto.intApacDemand = 0;
            objSpexDto.intEmeaDemand = 0;
            
            if(query.get('STOCK_BY_AMERICAS__C') != null)
            objSpexDto.intAmerStock = Integer.valueOf(query.get('STOCK_BY_AMERICAS__C'));
            
            if(query.get('STOCK_BY_APAC__C')!= null)
            objSpexDto.intApacStock = Integer.valueOf(query.get('STOCK_BY_APAC__C'));
            
            if(query.get('STOCK_BY_EMEA__C') != null)
            objSpexDto.intEmeaStock = Integer.valueOf(query.get('STOCK_BY_EMEA__C'));
            
            if(query.get('DEMAND_BY_AMERICAS__C') != null)
            objSpexDto.intAmerDemand = Integer.valueOf(query.get('DEMAND_BY_AMERICAS__C'));
            
            if(query.get('DEMAND_BY_APAC__C')!= null)
            objSpexDto.intApacDemand = Integer.valueOf(query.get('DEMAND_BY_APAC__C'));
            
            if(query.get('DEMAND_BY_EMEA__C')!= null)
            objSpexDto.intEmeaDemand = Integer.valueOf(query.get('DEMAND_BY_EMEA__C'));
            lstAtRiskPartNumbers.add(objSpexDto.strPartNo);
            lstSpexDto.add(objSpexDto);
        }
        
        //SR#395641
        List<sObject> lstAtRiskCases = [Select Id, Aircraft_Type__r.name, Product_Part__c From Case where RecordTypeId =: label.Case_AOG_RecordType and isClosed = false 
        and  Product_Part__c in :lstAtRiskPartNumbers and SPEX_EXCHANGE__C = TRUE and status !='Re-Open'];
        system.debug('lstAtRiskCases --->' + lstAtRiskCases );
        objSPEXDTO = new SPEXDTO_cls(); 
        Integer intlstSpexDto = lstSpexDto.size();
        string strPartNo, strPlatformName ;
        for(Integer i=0; i<intlstSpexDto ; i++)
        {     
            for (sObject query: lstAtRiskCases)
            {
                strPartNo = String.valueof(query.get('Product_Part__c'));
                Case objCase = (Case)query;
                system.debug('strPartNo --->' + strPartNo );
                system.debug('lstSpexDto.get(i).strPartNo--->' + lstSpexDto.get(i).strPartNo);
                if(strPartNo != null){                
                    if(strPartNo == lstSpexDto.get(i).strPartNo)
                    {
                        objSPEXDTO = lstSpexDto.get(i);
                        objSPEXDTO.bolAOGPart = true;
                        objSPEXDTO.strCaseId = String.valueof(query.get('id'));
                        lstSpexDto.set(i,objSPEXDTO);
                    }
                }
            }   
        }//End SR#395641
                                
            
    }

}