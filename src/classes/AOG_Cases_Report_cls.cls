/*******************************************************************************
Name            :   AOG_Cases_Report_cls
Created By      :   NTT DATA
Company Name    :   NTT DATA
Project         :   <CSO Bundle Project - Req No 16 - D&S AOG MICAPS identification> 
Created Date    :   22-June-2017
Usages          :   Retreivng AOG MiCAP Cases and retruning to VF Page
Modified By     :   NTT DATA
*******************************************************************************/
public class AOG_Cases_Report_cls { 
    List<case> AOGRedOutcases = new List<case>(); 
    string serverUrl; string hora;    
    List<case> MICAPAOGCasesList  =new List<case>();     
    List<case> MICAPAOGCases  =new List<case>();
    public AOG_Cases_Report_cls(ApexPages.StandardController controller) {  
        MICAPAOGCasesList = [select ID,Age_in_Hours__c,Type,OwnerId__r.name,X4_Hour_AOG__c,CP_CSM__c,Operator__c,Additional_Web_Form_Info__c,Hardware_Ship_From_Address__c,Sub_Status__c,Product_Number__r.name,Product_Number__r.Description,Product_Part__c ,CSM_Senior_Escalation__c,AOG_Service_level__c,CaseNumber,Account_Name__c,Product_Part_Number__c,Status,Aircraft_Type__r.name, SPEX_Exchange__c,SBU__c from Case where (lastmodifieddate = LAST_WEEK OR lastmodifieddate = THIS_WEEK ) and ((Case_Record_Type__c = 'AOG'or Case_Record_Type__c = 'Exchange')  and ( Status ='In Progress' or Status ='On Hold' or Status ='Open')) and(Type = 'MICAP')  ORDER BY  Age_in_Hours__c DESC]; //added for AOG/Spex Case Record Type Split            
        if(MICAPAOGCasesList.size()>0){
        for(case cas:MICAPAOGCasesList){
            if(cas.Type == 'MICAP')
                MICAPAOGCases.add(cas);
        }    
       } 
    }   
 
    public List<Case> getMICAPAOGCasesRecords()
    {
        return MICAPAOGCases;
    }  
       
    public String getserverUrl()
    {
        serverUrl = URL.getSalesforceBaseUrl().toExternalForm() +'/';
        return serverUrl;
    }
    public String gethora()
    {
        Datetime myDT = Datetime.now();
        hora = myDT.format('h:mm a');
        return hora;
    }
    public boolean getshowMICAPcases()
    {
        if(MICAPAOGCases.size()>0) 
        {
            return true;
        }
        else
        {
            return false;
        }
    }    
}