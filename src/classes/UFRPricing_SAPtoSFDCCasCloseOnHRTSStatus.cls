/**********************************************************************
Name            :   UFRPricing_SAPtoSFDCCasCloseOnHRTSStatus
Created By      :   Harikishore V
Company Name    :   NTT Data
Project         :   <Phase-II>, <UFR Pricing> 
Created Date    :   28-August-2015
Usages          :   To Close the Case based on SAP Field HRTS Status           
**********************************************************************/

global class UFRPricing_SAPtoSFDCCasCloseOnHRTSStatus{
    global class SAPData{
        webservice string SALES_ORDER_NUM;
        webservice string CASE_NUM;
        webservice String HRTS_STATUS;
    }
    webservice static void closeCase(SAPData cs){
        String casnum = cs.CASE_NUM;
        String SONum = cs.SALES_ORDER_NUM;
        String updateResult;
        Case cas = new Case();
        List<Case> casList = new List<Case>();
        //if(cs.HRTS_STATUS!=null && cs.HRTS_STATUS == 'No'){
        if(cs.HRTS_STATUS!=null){
            if(casnum!=null && SONum!=null){
                system.debug('------->inside');
                try{
                    cas = [SELECT id,Origin,RecordTypeId,Description,CaseNumber,Sales_Order_Number__c,Quote_Number__c,Status,Type,OwnerId from Case where CaseNumber=:casnum and (Sales_Order_Number__c=:SONum or Quote_Number__c=:SONum)];
                    system.debug('------->inside'+cas);
                }catch(Exception e){
                    system.debug('UFR Pricing:No matches found for the given Case Number '+e.getMessage());
                    updateResult = 'UFR Pricing:No matches found for the given Case Number '+e.getMessage();
                }
            }
        }
        if(cas!=null){
            if(cas.Origin == 'UFR Pricing' && cas.RecordtypeId == Label.Repair_Overhaul_RT_ID){
                system.debug('------->inside 2');
                if(cs.HRTS_STATUS == 'No'){
                    cas.OwnerId = Userinfo.getUserId();
                    cas.Status = 'Closed';
                    if(cas.Resolution__c == null)
                        cas.Resolution__c = 'None';
                    casList.add(cas);
                    system.debug('&&&&&&&&& No'+casList);
                }
                else if(cs.HRTS_STATUS.toUpperCase() == 'YES'){
                    cas.OwnerId = Label.CSO_R_O_Team;
                    cas.Status = 'Open';
                    cas.Description = cas.Description + ' HRTS CSR to action Z7 process';
                    if(cas.Resolution__c == null)
                        cas.Resolution__c = 'None';
                    casList.add(cas);
                    system.debug('&&&&&&&&& yes'+casList);
                }
            } 
        }
        if(casList.size()>0){
            try{
                system.debug('%%%%%%%%'+casList);
                update casList;                
            }catch(DMLException ee){
                system.debug('UFR Pricing: Error updating Case '+ee.getMessage());
                updateResult = 'UFR Pricing: Error updating Case '+ee.getMessage();
            }
        }
        if(updateResult!=null){
            RnO_Automation_Transaction_Log__c tlog = new RnO_Automation_Transaction_Log__c();
            tlog.Status__c = 'Failed!';
            tlog.Description__c = updateResult;
            tlog.Case_Num__c = casnum;
            tlog.Sales_Order_Num__c = SONum;
            insert tlog;
        }
    }    
}