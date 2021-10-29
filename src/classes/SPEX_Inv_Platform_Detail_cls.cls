/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : SPEX_Inv_Platform_Detail_cls
* Description           : Apex class involved in SPEX Inventory - Platform Details screen.
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 05-Oct-2012      0.01           NTTDATA               Initial Version

***********************************************************************************************************/
public class SPEX_Inv_Platform_Detail_cls
{
    public List<SPEXDTO_cls> lstStockOutSpexDto {get;set;}
    public List<SPEXDTO_cls> lstAtRiskSpexDto {get;set;}
    public SPEXDTO_cls objSpexStatusDto {get;set;}
    public SPEXDTO_cls objSPEXDTO_cls {get;set;}
    public String dtRefreshTime {get;set;}
    
    public SPEX_Inv_Platform_Detail_cls()
    {        
        this(System.currentPageReference().getParameters().get('OEM'), System.currentPageReference().getParameters().get('PLATFORM'));
        dtRefreshTime = SPEXDTO_cls.getRefreshTime();     
    }
    
    public SPEX_Inv_Platform_Detail_cls(String strOEMName, String strPlatform)
    {             
        objSPEXDTO_cls = new SPEXDTO_cls();
        objSPEXDTO_cls.strOEMName = strOEMName;
        objSPEXDTO_cls.strPlatform = strPlatform;
        objSPEXDTO_cls.strImgFileName = SPEX_GetImage_cls.getImageName(strOEMName, strPlatform);
        objSPEXDTO_cls.strOEMImgFileName = SPEX_GetImage_cls.getImageName(strOEMName);
        getPlatformDetails(strOEMName, strPlatform);
        objSpexStatusDto = getStatusPercent(strOEMName, strPlatform);
    }
    
    /**
     * This method is used to calculate the precentage of parts in each status.
     * @param strPlatform - String - Platform Name for which calculation need to be done.
     * @return SPEXDTO_cls - DTO class having the count of parts in each status.
    */
    public SPEXDTO_cls getStatusPercent(String strOEMName, String strPlatform)
    {
        List<sObject> lstStatusPlatforms = [SELECT sum(StckOutAmer__c) StockOut_Amer, sum(StckOutApac__c) StockOut_Apac, sum(StckOutEMEA__c) StockOut_Emea, 
        sum(AtRisk_Americ__c) Risk_Amer, sum(AtRisk_APAC__c) Risk_Apac, sum(AtRisk_EMEA__c) Risk_Emea,
        sum(Safe_Americ__c) Safe_Amer, sum(Safe_APAC__c) Safe_Apac, sum(SAFE_EMEA__c) Safe_Emea
        FROM SPEX_DB_Platform_Summary__c where OEM_NAME__C =:strOEMName and PLATFORM__C =: strPlatform group by OEM_NAME__C, Platform__c];
        
        SPEXDTO_cls objSpexDto = new SPEXDTO_cls();
        objSpexDto.intAmerStockOutPlatforms = 0;
        objSpexDto.intApacStockOutPlatforms = 0;
        objSpexDto.intEmeaStockOutPlatforms = 0;
        objSpexDto.intAmerAtRiskPlatforms = 0;
        objSpexDto.intApacAtRiskPlatforms = 0;
        objSpexDto.intEmeaAtRiskPlatforms = 0;
        objSpexDto.intAmerSafePlatforms = 0;
        objSpexDto.intApacSafePlatforms = 0;
        objSpexDto.intEmeaSafePlatforms = 0;
            
        if(lstStatusPlatforms.size() > 0)
        {
            objSpexDto.intAmerStockOutPlatforms = Integer.valueof(lstStatusPlatforms[0].get('StockOut_Amer'));
            objSpexDto.intApacStockOutPlatforms = Integer.valueof(lstStatusPlatforms[0].get('StockOut_Apac'));
            objSpexDto.intEmeaStockOutPlatforms = Integer.valueof(lstStatusPlatforms[0].get('StockOut_Emea'));
            objSpexDto.intAmerAtRiskPlatforms = Integer.valueof(lstStatusPlatforms[0].get('Risk_Amer'));
            objSpexDto.intApacAtRiskPlatforms = Integer.valueof(lstStatusPlatforms[0].get('Risk_Apac'));
            objSpexDto.intEmeaAtRiskPlatforms = Integer.valueof(lstStatusPlatforms[0].get('Risk_Emea'));
            objSpexDto.intAmerSafePlatforms = Integer.valueof(lstStatusPlatforms[0].get('Safe_Amer'));
            objSpexDto.intApacSafePlatforms = Integer.valueof(lstStatusPlatforms[0].get('Safe_Apac'));
            objSpexDto.intEmeaSafePlatforms = Integer.valueof(lstStatusPlatforms[0].get('Safe_Emea'));
        }
        /*List<sObject> lstSafePlatforms = [SELECT count(Part_Number__c) Total_Count
        FROM SPEX_DB_Platform_Summary__c where OEM_NAME__C =:strOEMName and PLATFORM__C =: strPlatform];
        
        Integer intTotal;
        if(lstSafePlatforms.size() > 0)
        {
            intTotal = Integer.valueof(lstSafePlatforms[0].get('Total_Count'));                        
            objSpexDto.intAmerSafePlatforms = intTotal - (objSpexDto.intAmerStockOutPlatforms + objSpexDto.intAmerAtRiskPlatforms);
            objSpexDto.intApacSafePlatforms = intTotal - (objSpexDto.intApacStockOutPlatforms + objSpexDto.intApacAtRiskPlatforms);
            objSpexDto.intEmeaSafePlatforms = intTotal - (objSpexDto.intEmeaStockOutPlatforms + objSpexDto.intEmeaAtRiskPlatforms);
        }*/
        return objSpexDto;        
    }
    
    /**
     * This method is used to get platform details.
     * @param strPlatform - String - Platform Name for details need to be fetched.
     * @param strStatus - String - Status of the platform.
     * @return List<SPEXDTO_cls> - List having DTO class which contains the details of the platform.
    */
    public void getPlatformDetails(String strOEMName, String strPlatform)
    {        
        List<sObject> lstStockOutPlatformDetails = [SELECT Part_Number__r.Part_Number__c, Part_Number__r.Part_Description__c, 
        Part_Number__r.ABC_CODE__C, PLATFORM__C, Prt_Plt_Sts_AMER__c, Prt_Plt_Sts_APAC__c, Prt_Plt_Sts_EMEA__c
        FROM SPEX_DB_Platform_Summary__c where OEM_NAME__C =:strOEMName and PLATFORM__C =: strPlatform and
        StckOutCnt__c > 0 order by StckOutCnt__c desc, RiskGreyCnt__c desc, RiskCnt__c desc, GreyCnt__c asc, Part_Number__r.Part_Number__c asc];
        
        List<String> lstStockOutPartNumbers = new List<String>();
        List<String> lstAtRiskPartNumbers = new List<String>();
        lstStockOutSpexDto = new List<SPEXDTO_cls>();
        lstAtRiskSpexDto = new List<SPEXDTO_cls>();
        Integer intPlatformAmerDemand;
        Integer intPlatformApacDemand;
        Integer intPlatformEmeaDemand;
        SPEXDTO_cls objSPEXDTO;
                
        for (sObject query: lstStockOutPlatformDetails)
        {
            objSPEXDTO = new SPEXDTO_cls();
            SPEX_DB_PLATFORM_SUMMARY__C objSpexPlatform = (SPEX_DB_PLATFORM_SUMMARY__C)query;
            SPEX_DB_PART_SUMMARY__C objSpexPart = objSpexPlatform.PART_NUMBER__r;
            String strPartNumber = objSpexPart.PART_NUMBER__c;
            objSPEXDTO.strPlatform = String.valueOf(query.get('PLATFORM__C'));
            objSPEXDTO.strPartNo = strPartNumber;
            objSPEXDTO.strABCCode = objSpexPart.ABC_CODE__C;
            if(null != objSpexPart.Part_Description__c)
            {
                objSPEXDTO.strPartDesc = objSpexPart.Part_Description__c.toLowerCase();            
            }
            objSPEXDTO.strAmerStatus = SPEX_Status_ColorCode_cls.getColorCode(String.valueof(query.get('Prt_Plt_Sts_AMER__c')));
            objSPEXDTO.strApacStatus = SPEX_Status_ColorCode_cls.getColorCode(String.valueof(query.get('Prt_Plt_Sts_APAC__c')));
            objSPEXDTO.strEmeaStatus = SPEX_Status_ColorCode_cls.getColorCode(String.valueof(query.get('Prt_Plt_Sts_EMEA__c')));            
            
            objSPEXDTO.bolAOGPart = false;
            System.debug('Stockout Case: ' + objSPEXDTO.bolAOGPart);
            lstStockOutPartNumbers.add(strPartNumber);
            lstStockOutSpexDto.add(objSPEXDTO);
        }
                
        List<sObject> lstStockOutCases = [Select Id, Aircraft_Type__r.name, Product_Part__c From Case where RecordTypeId =: label.Case_AOG_RecordType and isClosed = false 
        and  Product_Part__c in :lstStockOutPartNumbers and SPEX_EXCHANGE__C = TRUE and status !='Re-Open'];
        objSPEXDTO = new SPEXDTO_cls(); 
        String strPartNo; 
        String strPlatformName; 
        Integer intlstStockOutSpexDto = lstStockOutSpexDto.size();
        for(Integer i=0; i<intlstStockOutSpexDto; i++)
        {     
            for (sObject query: lstStockOutCases)
            {
                strPartNo = String.valueof(query.get('Product_Part__c'));
                Case objCase = (Case)query;
                Platform__c objPlatform = objCase.Aircraft_Type__r;
                if(objPlatform != null)
                {
                    strPlatformName = objPlatform.name;
                    
                    if(strPlatformName != null && strPlatformName != '')
                    {     
                    System.debug('Stockout Case1: ');  
                    System.debug('strPartNo: ' + strPartNo);           
                    System.debug('lstStockOutSpexDto.get(i).strPartNo: ' + lstStockOutSpexDto.get(i).strPartNo);
                    System.debug('strPlatformName.toLowerCase(): ' + strPlatformName.toLowerCase());
                    System.debug('lstStockOutSpexDto.get(i).strPlatform.toLowerCase(): ' + lstStockOutSpexDto.get(i).strPlatform.toLowerCase());                      
            /*            if(strPartNo == lstStockOutSpexDto.get(i).strPartNo && lstStockOutSpexDto.get(i).strPlatform.toLowerCase().contains(strPlatformName.toLowerCase()))
                        {
                     System.debug('Stockout Case2: ');
                            objSPEXDTO = lstStockOutSpexDto.get(i);
                            objSPEXDTO.bolAOGPart = true;
                            System.debug('Stockout Case: ' + objSPEXDTO.bolAOGPart);
                            objSPEXDTO.strCaseId = String.valueof(query.get('id'));
                            lstStockOutSpexDto.set(i,objSPEXDTO);
                        } */
                     if (lstStockOutSpexDto.get(i).strPlatform == 'G350, G450, G500, G550')  
                      {
                          if(strPartNo == lstStockOutSpexDto.get(i).strPartNo && (strPlatformName.containsIgnoreCase('Gulfstream 350') || strPlatformName.containsIgnoreCase('Gulfstream 450') || strPlatformName.containsIgnoreCase('Gulfstream 500') || strPlatformName.containsIgnoreCase('Gulfstream 550')))
                            {
                              objSPEXDTO = lstStockOutSpexDto.get(i);
                              objSPEXDTO.bolAOGPart = true;
                              objSPEXDTO.strCaseId = String.valueof(query.get('id'));
                              lstStockOutSpexDto.set(i,objSPEXDTO);
                             }
                      }
                    else if (lstStockOutSpexDto.get(i).strPlatform == 'GIV CLASSIC (G300,G400,GIV,GIVSP)')
                      {  
                           if(strPartNo == lstStockOutSpexDto.get(i).strPartNo && (strPlatformName.containsIgnoreCase('Gulfstream 300') || strPlatformName.containsIgnoreCase('Gulfstream 400') || strPlatformName.containsIgnoreCase('Gulfstream GIV') || strPlatformName.containsIgnoreCase('GulfStream GIVSP')))
                            {
                              objSPEXDTO = lstStockOutSpexDto.get(i);
                              objSPEXDTO.bolAOGPart = true;
                              objSPEXDTO.strCaseId = String.valueof(query.get('id'));
                              lstStockOutSpexDto.set(i,objSPEXDTO);
                             }
                      }
                    else if (lstStockOutSpexDto.get(i).strPlatform == 'GV CLASSIC')
                      {
                            if(strPartNo == lstStockOutSpexDto.get(i).strPartNo && strPlatformName.containsIgnoreCase('Gulfstream GV'))
                            {
                              objSPEXDTO = lstStockOutSpexDto.get(i);
                              objSPEXDTO.bolAOGPart = true;
                              objSPEXDTO.strCaseId = String.valueof(query.get('id'));
                              lstStockOutSpexDto.set(i,objSPEXDTO);
                            }
                      }
                    else if (lstStockOutSpexDto.get(i).strPlatform == 'F7X')
                      {
                            if(strPartNo == lstStockOutSpexDto.get(i).strPartNo && strPlatformName.containsIgnoreCase('Falcon 7X'))
                            {
                              objSPEXDTO = lstStockOutSpexDto.get(i);
                              objSPEXDTO.bolAOGPart = true;
                              objSPEXDTO.strCaseId = String.valueof(query.get('id'));
                              lstStockOutSpexDto.set(i,objSPEXDTO);
                            }
                      }
                    else
                      {
                           if(strPartNo == lstStockOutSpexDto.get(i).strPartNo && strPlatformName.containsIgnoreCase(lstStockOutSpexDto.get(i).strPlatform))
                           {
                             objSPEXDTO = lstStockOutSpexDto.get(i);
                             objSPEXDTO.bolAOGPart = true;
                             objSPEXDTO.strCaseId = String.valueof(query.get('id'));
                             lstStockOutSpexDto.set(i,objSPEXDTO);
                           }
                      }

                        
                   }
                }                 
            }
        }
            
        List<sObject> lstAtRiskPlatformDetails = [SELECT Part_Number__r.Part_Number__c, Part_Number__r.Part_Description__c, 
        Part_Number__r.ABC_CODE__C, PLATFORM__C, Prt_Plt_Sts_AMER__c, Prt_Plt_Sts_APAC__c, Prt_Plt_Sts_EMEA__c
        FROM SPEX_DB_Platform_Summary__c where OEM_NAME__C =:strOEMName and PLATFORM__C =: strPlatform and 
        RiskCnt__c > 0 and Part_Number__r.Part_Number__c not in :lstStockOutPartNumbers order by RiskGreyCnt__c desc, RiskCnt__c desc, GreyCnt__c asc, Part_Number__r.Part_Number__c asc];        
        
        for (sObject query: lstAtRiskPlatformDetails)
        {            
            objSPEXDTO = new SPEXDTO_cls();         
            SPEX_DB_PLATFORM_SUMMARY__C objSpexPlatform = (SPEX_DB_PLATFORM_SUMMARY__C)query;
            SPEX_DB_PART_SUMMARY__C objSpexPart = objSpexPlatform.PART_NUMBER__r;
            String strPartNumber = objSpexPart.PART_NUMBER__c;
            objSPEXDTO.strPlatform = String.valueOf(query.get('PLATFORM__C'));
            objSPEXDTO.strPartNo = strPartNumber;
            objSPEXDTO.strABCCode = objSpexPart.ABC_CODE__C;
            
            if(null!=objSpexPart.Part_Description__c)
            {
                objSPEXDTO.strPartDesc = objSpexPart.Part_Description__c.toLowerCase();
            }   
            objSPEXDTO.strAmerStatus = SPEX_Status_ColorCode_cls.getColorCode(String.valueof(query.get('Prt_Plt_Sts_AMER__c')));
            objSPEXDTO.strApacStatus = SPEX_Status_ColorCode_cls.getColorCode(String.valueof(query.get('Prt_Plt_Sts_APAC__c')));
            objSPEXDTO.strEmeaStatus = SPEX_Status_ColorCode_cls.getColorCode(String.valueof(query.get('Prt_Plt_Sts_EMEA__c')));  
            lstAtRiskPartNumbers.add(strPartNumber);

            
            objSPEXDTO.bolAOGPart = false;
            lstAtRiskSpexDto.add(objSPEXDTO);
        }
        List<sObject> lstAtRiskCases = [Select Id, Aircraft_Type__r.name, Product_Part__c From Case where RecordTypeId =: label.Case_AOG_RecordType and isClosed = false 
        and  Product_Part__c in :lstAtRiskPartNumbers and SPEX_EXCHANGE__C = TRUE and status !='Re-Open'];
        objSPEXDTO = new SPEXDTO_cls(); 
        Integer intlstAtRiskSpexDto = lstAtRiskSpexDto.size();
        for(Integer i=0; i<intlstAtRiskSpexDto; i++)
        {     
            for (sObject query: lstAtRiskCases)
            {
                strPartNo = String.valueof(query.get('Product_Part__c'));
                Case objCase = (Case)query;
                Platform__c objPlatform = objCase.Aircraft_Type__r;
                if(objPlatform != null)
                {
                    strPlatformName = objPlatform.name;
                    
                    if(strPlatformName != null && strPlatformName != '')
                    {      
                    System.debug('AtRisk Case1: ');  
                    System.debug('strPartNo: ' + strPartNo);           
                    System.debug('lstAtRiskSpexDto.get(i).strPartNo: ' + lstAtRiskSpexDto.get(i).strPartNo);
                    System.debug('strPlatformName.toLowerCase(): ' + strPlatformName.toLowerCase());
                    System.debug('lstAtRiskSpexDto.get(i).strPlatform.toLowerCase(): ' + lstAtRiskSpexDto.get(i).strPlatform.toLowerCase());  
                  /*      if(strPartNo == lstAtRiskSpexDto.get(i).strPartNo && lstAtRiskSpexDto.get(i).strPlatform.toLowerCase().contains(strPlatformName.toLowerCase()))
                        {
                        System.debug('AtRisk Case2: ');
                            objSPEXDTO = lstAtRiskSpexDto.get(i);
                            objSPEXDTO.bolAOGPart = true;
                            System.debug('At Risk Case: ' + objSPEXDTO.bolAOGPart);
                            objSPEXDTO.strCaseId = String.valueof(query.get('id'));
                            lstAtRiskSpexDto.set(i,objSPEXDTO);
                        } */
                   if (lstAtRiskSpexDto.get(i).strPlatform == 'G350, G450, G500, G550')  
                      {
                          if(strPartNo == lstAtRiskSpexDto.get(i).strPartNo && (strPlatformName.containsIgnoreCase(' Gulfstream 350') || strPlatformName.containsIgnoreCase('Gulfstream 450') || strPlatformName.containsIgnoreCase('Gulfstream 500') || strPlatformName.containsIgnoreCase('Gulfstream 550')))
                            {
                              objSPEXDTO = lstAtRiskSpexDto.get(i);
                              objSPEXDTO.bolAOGPart = true;
                              objSPEXDTO.strCaseId = String.valueof(query.get('id'));
                              lstAtRiskSpexDto.set(i,objSPEXDTO);
                             }
                      }
                    else if (lstAtRiskSpexDto.get(i).strPlatform == 'GIV CLASSIC (G300,G400,GIV,GIVSP)')
                      {  
                           if(strPartNo == lstAtRiskSpexDto.get(i).strPartNo && (strPlatformName.containsIgnoreCase('Gulfstream 300') || strPlatformName.containsIgnoreCase('Gulfstream 400') || strPlatformName.containsIgnoreCase('Gulfstream GIV') || strPlatformName.containsIgnoreCase('Gulfstream GIVSP')))
                            {
                              objSPEXDTO = lstAtRiskSpexDto.get(i);
                              objSPEXDTO.bolAOGPart = true;
                              objSPEXDTO.strCaseId = String.valueof(query.get('id'));
                              lstAtRiskSpexDto.set(i,objSPEXDTO);
                             }
                      }
                  else if (lstAtRiskSpexDto.get(i).strPlatform == 'GV CLASSIC')
                      {
                          if(strPartNo == lstAtRiskSpexDto.get(i).strPartNo && strPlatformName.containsIgnoreCase('Gulfstream GV'))
                            {
                              objSPEXDTO = lstAtRiskSpexDto.get(i);
                              objSPEXDTO.bolAOGPart = true;
                              objSPEXDTO.strCaseId = String.valueof(query.get('id'));
                              lstAtRiskSpexDto.set(i,objSPEXDTO);
                            }
                      }
                  else if (lstAtRiskSpexDto.get(i).strPlatform == 'F7X')
                      {
                          if(strPartNo == lstAtRiskSpexDto.get(i).strPartNo && strPlatformName.containsIgnoreCase('Falcon 7X'))
                            {
                              objSPEXDTO = lstAtRiskSpexDto.get(i);
                              objSPEXDTO.bolAOGPart = true;
                              objSPEXDTO.strCaseId = String.valueof(query.get('id'));
                              lstAtRiskSpexDto.set(i,objSPEXDTO);
                            }
                      }
                  else
                      {
                          if(strPartNo == lstAtRiskSpexDto.get(i).strPartNo && strPlatformName.containsIgnoreCase(lstAtRiskSpexDto.get(i).strPlatform))
                             {
                              objSPEXDTO = lstAtRiskSpexDto.get(i);
                              objSPEXDTO.bolAOGPart = true;
                              objSPEXDTO.strCaseId = String.valueof(query.get('id'));
                              lstAtRiskSpexDto.set(i,objSPEXDTO);
                             }
                      }    
                   }
                }                
            }
        }        
    }        
}