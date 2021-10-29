/*******************************************************************************
Name            :   CaseNumberfromSAPtoSFDC
Created By      :   Harikishore V
Company Name    :   NTTData 
Created Date    :   09-Dec-2014
Usages          :   This Class is to send case details to SAP based on SO Number/Quote Number
Test Class      :   TestClass_CaseNumberfromSAPtoSFDC
Modification History    :
Date        Version No.     Modified by     Brief Description of Modification
09-Dec-14   Initial Version NTTData         Sending Case details to SAP         
*******************************************************************************/
global class CaseNumberfromSAPtoSFDC{
    global class CaseFieldsToRetrieve{
        webservice string SalesOrderNum;
    }
    global class CaseNumSFDCtoSAP{
        webservice string caseNumbers;
        webservice string salesordernum;
        webservice string quotenum;
        webservice string caserefid;
        webservice string cassub;
    }
    webservice static List<CaseNumSFDCtoSAP> getCaseNumbers(CaseFieldsToRetrieve casenum){
        
        List<CaseNumSFDCtoSAP> casdetails = new List<CaseNumSFDCtoSAP>();
        String sonsplit = casenum.SalesOrderNum;
        List<String> sonval = sonsplit.split(',');
        List<Case> caslist = new List<Case>();
        List<Case> caslist1 = new List<Case>();
        /* Added for RAPD - 3343 */
         SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();  
        string truncateIP = '';
        truncateIP = string.valueOf(casenum);
         if(truncateIP.length() > 131072){
        truncateIP = truncateIP.subString(0,131072);
        }
	   /* Ended */
        if(sonval != null){
            caslist = [SELECT Subject,CaseNumber,Sales_Order_Number__c,Quote_Number__c,Case_Ref_ID__c from Case where Sales_Order_Number__c IN:sonval OR Quote_Number__c IN:sonval ORDER BY CreatedDate DESC];
        }
        else
        {
            /* Added for RAPD - 3343 */
             SApInterface.sapException= SApInterface.sapException='No Case found for give sales order number';
                     SApInterface.Name = 'CaseNumberfromSAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          SApInterface.caseNumber = 'NA';
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
            
        }
        
       for(String st :sonval){
            integer k = 0;
            
            
            for(case cs : caslist){
                if((st==cs.Sales_Order_Number__c || st==cs.Quote_Number__c) && k<1){
                   caslist1.add(cs);
                   k=k+1;
                }
            }
            
        }
        List<CaseNumSFDCtoSAP> cs = new List<CaseNumSFDCtoSAP>();   
       
        if(caslist.size()>0){
            for(Case c:caslist1){
                CaseNumSFDCtoSAP casdetails1 = new CaseNumSFDCtoSAP();
                casdetails1.caseNumbers = c.CaseNumber;
                casdetails1.salesordernum = c.Sales_Order_Number__c;
                casdetails1.quotenum = c.Quote_Number__c;
                casdetails1.caserefid = c.Case_Ref_ID__c;
                casdetails1.cassub = c.Subject;
                casdetails.add(casdetails1);
            }
        }

else
{
   /* Added for RAPD - 3343 */
      SApInterface.sapException= SApInterface.sapException='No Case found for give sales order number';
                     SApInterface.Name = 'CaseNumberfromSAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          SApInterface.caseNumber = 'NA';
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
    /* Ended */
}
        return casdetails;
    }
}