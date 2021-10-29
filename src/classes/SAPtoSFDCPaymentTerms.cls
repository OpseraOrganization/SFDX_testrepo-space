/*****************************************************************
Name            :   SAPtoSFDCPaymentTerms
Created By      :   Harikishore V
Company Name    :   NTTData
Created Date    :   04-April-2017
Usages          :   To Update SAP payment details in Account
******************************************************************/
global class SAPtoSFDCPaymentTerms{
    global class PaymentInfoSAPtoSFDC{
        webservice string System_Date;
        webservice string Customer_Num;
        webservice string PaymentTerm_Newvalue;
        webservice string PaymentTerm_Desc;
        webservice string Sales_Org;
        webservice string Distribution_Channel;
        webservice string Division;
        webservice string CRM_ID;
    }
    global class ResponsetoSAP{
        webservice string status;
        webservice string message;
    }
    
    /* Added for RAPD 3601 */
    global class SapExceptionCapture{
        webservice String outputValue;
        webservice String inputValue;
        webservice String sapException;
        webservice String name;
        webservice String notification;
        webservice String createdDate;
        webservice String createdBy;
        webservice String caseNumber;     
    }
     /* Ended */
    webservice static ResponseToSAP updateAccount(PaymentInfoSAPtoSFDC details){
        List<Account_Cross_Ref__c> accName = new List<Account_Cross_Ref__c>();
        List<Account> accList = new List<Account>();
        List<Account> accListUpdate = new List<Account>();
        ResponsetoSAP res = new ResponsetoSAP();
        String sitecode;
        /** Added for RAPD-3343 **/
        string truncateIP = '';
        truncateIP = string.valueOf(details);
         if(truncateIP.length() > 131072){
        truncateIP = truncateIP.subString(0,131072);
        }
        SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();
        /** Ended */
        if(details!=null){
          try{
            if(details.Customer_Num!=null){
                sitecode = '\'%' + details.Customer_Num + '%\'';
                system.debug('SiteCode--->: '+sitecode);
                if(sitecode!=null)
                    accName = Database.Query('Select id,Account_Name__c,XREF_Type__c,External_Account_ID__c from Account_Cross_Ref__c where XREF_Type__c = \'SAP_SOLD_TO\' and External_Account_ID__c LIKE '+sitecode);
                if(accName.size()>0){
                    system.debug('accName---> '+accName);
                    accList = [SELECT id,Payment_Term_New_Value__c,Payment_Term_Description__c,Name,SalesOrg_Distribution_Channel_Division__c,Payment_System_Date__c from Account where id=:accName[0].Account_Name__c];
                    if(accList.size()>0){
                      
                        system.debug('accList---> '+accList);
                        accList[0].Payment_Term_New_Value__c = details.PaymentTerm_Newvalue;
                        accList[0].Payment_Term_Description__c = details.PaymentTerm_Desc;
                        if(accList[0].SalesOrg_Distribution_Channel_Division__c!=null)
                            accList[0].SalesOrg_Distribution_Channel_Division__c = accList[0].SalesOrg_Distribution_Channel_Division__c+'\n'+details.Sales_Org+' : '+details.Distribution_Channel+' : '+details.Division;
                        else
                            accList[0].SalesOrg_Distribution_Channel_Division__c = details.Sales_Org+' : '+details.Distribution_Channel+' : '+details.Division;
                        accList[0].Payment_System_Date__c = stringToDate(details.System_Date);
                        accListUpdate.add(accList[0]);
                        
                    }
                }else{
                 system.debug('Exception Captured else ....!');
                    res.status = 'Failed!';
                    res.message = 'No data found for the given input Customer Number!';
                    /* Added for RAPD - 3343 */
                     SApInterface.sapException=res.message;
                     SApInterface.Name = 'SAPtoSFDCPaymentTerms';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          //To maintain case number consistency adding CASE
                          SApInterface.caseNumber = 'CASE-'+string.valueOf(details.Customer_Num);
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                    /* Ended */
                }
            }
        
        if(accListUpdate.size()>0){
       
            update accListUpdate;
            res.status = 'Success!';
            res.message = 'Successfully updated the details in Account!';
        }
        }
        catch(exception sapException){
                system.debug('Exception Captured....!'+sapException);
            /* Added for RAPD - 3343 */
                SApInterface.sapException=sapException.getmessage();
                  SApInterface.Name = 'SAPtoSFDCPaymentTerms';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          //To maintain case number consistency adding CASE
                          SApInterface.caseNumber = 'CASE'+string.valueOf(details.Customer_Num);
                          SApInterface.inputValue = truncateIP;
                          SApInterface.createdBy = UserInfo.getName();
                SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
            }
        }
        return res;
    }
    public static Date stringToDate(string dateString){
      
        Date dt = date.parse(dateString);        
        if(null!=dt)
            return dt;
         else
            return null;
    }
}