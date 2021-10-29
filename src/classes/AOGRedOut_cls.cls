public class AOGRedOut_cls{
    
    List<Id> caseids = new List<Id>();
    List<case> AOGRedOutcases = new List<case>(); 
    string serverUrl; 
    string hora;
    
    List<Id> caseidsAR = new List<Id>();
    
    List<case> AOGRedOutcasesAerospace = new List<case>();    
    List<case> AOGRedOutcasesAPACAM = new List<case>();
    List<case> AOGRedOutcasesDivest = new List<case>();
    List<case> AOGRedOutcasesElectronicSolutionsOE = new List<case>();
    List<case> AOGRedOutcasesEMEAIAM = new List<case>();
    List<case> AOGRedOutcasesEnginesPowerSystemsOE = new List<case>();
    List<case> AOGRedOutcasesMechanicalSystemsComponentsOE = new List<case>();
    List<case> AOGRedOutcasesServicesConnectivityOE = new List<case>();
    List<case> AOGRedOutcasesAmericasAM = new List<case>();
    
    public AOGRedOut_cls(ApexPages.StandardController controller) {
        
        AOGRedOutcases = [SELECT ID,Age_in_Hours__c,OwnerId__r.name,X4_Hour_AOG__c,CP_CSM__c,Operator__c,Additional_Web_Form_Info__c,
                            Hardware_Ship_From_Address__c,Sub_Status__c,Product_Number__r.name,Product_Number__r.Description,
                            Product_Part__c,CSM_Senior_Escalation__c,AOG_Service_level__c,CaseNumber,Account_Name__c,Product_Part_Number__c,
                            Status,Aircraft_Type__r.name, SPEX_Exchange__c,SBU__c,Next_Flight_Out_Date__c, Account.Sales_Channel__c FROM Case
                            WHERE (lastmodifieddate = LAST_WEEK OR lastmodifieddate = THIS_WEEK ) AND ((Case_Record_Type__c = 'AOG' or Case_Record_Type__c = 'Exchange')  AND ( Status ='In Progress' or Status ='On Hold' or Status ='Open') ) AND
                            AOG_Service_level_Value__c != 1 AND Next_Flight_Out_Date__c < TODAY ORDER BY AOG_Service_level_Value__c DESC, Age_in_Hours__c DESC];// added for AOG/Spex Case Record Type Split

        
        for(integer i=0;i<AOGRedOutcases.size();i++){
            caseids.add(AOGRedOutcases[i].Id);
        }        
        
        for(case cas:AOGRedOutcases){
            if(cas.X4_Hour_AOG__c== '4-hour')
            AOGRedOutcasesAerospace.add(cas);
            if(cas.X4_Hour_AOG__c== '24-hour')
            AOGRedOutcasesAPACAM.add(cas);
            if(cas.X4_Hour_AOG__c== '48-hour')
            AOGRedOutcasesDivest.add(cas);
            if(cas.X4_Hour_AOG__c== 'N/A')
            AOGRedOutcasesElectronicSolutionsOE.add(cas);
            }          
    }
  
    public List<Case> getAOGRedOutAerospace()
    {
        return AOGRedOutcasesAerospace;
    }
    
    public List<Case> getAOGRedOutAPACAM()
    {
        return AOGRedOutcasesAPACAM;
    }
    
    public List<Case> getAOGRedOutDivest()
    {
        return AOGRedOutcasesDivest;
    }
    
    public List<Case> getAOGRedOutElectronicSolutionsOE()
    {
        return AOGRedOutcasesElectronicSolutionsOE;
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
    
    public boolean getshowAerospace()
    {
        if(AOGRedOutcasesAerospace.size()>0) 
        {
            return true;
        }
        else
        {
            return false;
        }
    }
   
    public boolean getshowAPACAM()
    {
        if(AOGRedOutcasesAPACAM.size()>0) 
        {
            return true;
        }
        else
        {
            return false;
        }
    }
   
    public boolean getshowDivest()
    {
        if(AOGRedOutcasesDivest.size()>0) 
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
     public boolean getshowElectronicSolutionsOE()
    {
        if(AOGRedOutcasesElectronicSolutionsOE.size()>0) 
        {
            return true;
        }
        else
        {
            return false;
        }
    }  
    
}