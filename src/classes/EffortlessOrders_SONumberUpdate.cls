/*******************************************************************************
Name         : EffortlessOrders_SONumberUpdate
Created By   : Harikishore V
Company Name : NTT Data
Project      : <Phase-I>, <EfforlessOrders> 
Created Date : 25 September 2014
Usages       : Updating Sales Order Number, Order Entered By fields on case based on SAP input.           
*******************************************************************************/

global class EffortlessOrders_SONumberUpdate{
    global class SOnCasNumberSAPtoSFDC{
        webservice string SalesOrderNum;
        webservice string CaseeNumber;
        webservice string OrderEntBy;
    }
    webservice static void updateCase(SOnCasNumberSAPtoSFDC casenum){
        String msg,successmsg;
        String son = casenum.SalesOrderNum;
        String csnum = casenum.CaseeNumber;
        String OEBy = casenum.OrderEntBy;
        Case cas = new Case();
        List<Case> caslist = new List<Case>();
        if(csnum != null){
            try{
                cas = [SELECT CaseNumber,Sales_Order_Number__c,Order_Entered_By__c from Case where CaseNumber=:csnum];
            }catch(Exception e){
                msg = 'Effortless Orders:No Matches found for Case Number!';
            }
        }
        if(cas!=null){
            if (cas.Sales_Order_Number__c != null){
                cas.Sales_Order_Number__c = cas.Sales_Order_Number__c+','+son;
            }else{
                cas.Sales_Order_Number__c = son;
            }
            if (cas.Order_Entered_By__c != null){
                cas.Order_Entered_By__c = cas.Order_Entered_By__c+','+OEBy;
            }else{
                cas.Order_Entered_By__c = OEBy;
            }
            caslist.add(cas);
        }
        if(caslist.size()>0){
            try{
                update caslist;
                successmsg = 'Effortless Orders:Successfully Updated SO Number & Order Entered By!';
            }catch(Exception ee){
                msg = 'Effortless Orders:'+ee;
            }
        }
        if(msg!=null){
            RnO_Automation_Transaction_Log__c tlog = new RnO_Automation_Transaction_Log__c();
            tlog.Status__c = 'failed';
            tlog.Description__c = msg;
            tlog.Case_Num__c = csnum;
            tlog.Sales_Order_Num__c = son;
            tlog.Order_Entered_By__c = OEBy;
            insert tlog;
        }else if(successmsg!=null){
            RnO_Automation_Transaction_Log__c tlog = new RnO_Automation_Transaction_Log__c();
            tlog.Status__c = 'Success';
            tlog.Description__c = successmsg;
            tlog.Case_Num__c = csnum;
            tlog.Sales_Order_Num__c = son;
            tlog.Order_Entered_By__c = OEBy;
            insert tlog;
        }
    }
}