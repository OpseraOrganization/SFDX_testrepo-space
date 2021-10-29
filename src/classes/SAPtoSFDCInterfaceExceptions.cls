/*****************************************************************
Name            :   SAPtoSFDCInterfaceExceptions
Created By      :   Shanthi
Company Name    :   NTTData
Created Date    :   23-oct-2019
Usages          :   To Capture SAP Interfaces exceptions
******************************************************************/
global class SAPtoSFDCInterfaceExceptions{    
    /* Added for RAPD 3601 */
    global class SapExceptioninput{
        webservice String outputValue;
        webservice String inputValue;
        webservice String sapException;
        webservice String name;
        webservice String notification;
        webservice String stackTrace;
        webservice DateTime createdDate;
        webservice String createdBy;
        webservice String caseNumber;  
        webservice String taskID; 
        webservice String taskType;  
    }
     /* Ended */
    webservice static void createrecord(SapExceptioninput exceinput){
        List<SAP_Interface_Exceptions__c> SAPExcetionlist = new List<SAP_Interface_Exceptions__c>();
        if(exceinput !=null){
            SAP_Interface_Exceptions__c SAPExcetionrec=new SAP_Interface_Exceptions__c();
            SAPExcetionrec.Exception__c = exceinput.sapException;
             SAPExcetionrec.Output_Value__c= exceinput.outputValue;
             SAPExcetionrec.Input_Value__c= exceinput.inputValue;
              SAPExcetionrec.Notification__c= exceinput.notification;
               SAPExcetionrec.Name__c= exceinput.name;
                SAPExcetionrec.Created_Date__c= exceinput.createdDate;
                 SAPExcetionrec.Created_By__c= exceinput.createdBy;
                  SAPExcetionrec.Case_Number__c= exceinput.caseNumber;
                  SAPExcetionrec.Task_Id__c= exceinput.taskID;
                  SAPExcetionrec.Task_Type__c= exceinput.taskType;
                 SAPExcetionrec.stack_Trace__c=exceinput.stackTrace;
              
              
            //SAPExcetionrec.=exceinput.outputValue;
            //SAPExcetionrec.=exceinput.inputValue;
            SAPExcetionlist.add(SAPExcetionrec);
        }
        if(SAPExcetionlist.size()>0){
        try{
            insert SAPExcetionlist;
        }
        catch(exception sapException){
                system.debug('Exception Captured....!'+sapException);
            }
        }
    }
}