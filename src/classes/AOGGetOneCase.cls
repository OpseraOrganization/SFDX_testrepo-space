public class AOGGetOneCase{
    
    String caseId;    
    
    Case case_one = new Case();    
       
    public AOGGetOneCase() {
        caseId = System.currentPageReference().getParameters().get('CASE');
    }
   
    public Case getCase_one(){
    
        //if(caseId != '')return null;
    
        case_one=[Select Id,AOG_Service_level__c,AOG_Service_Level_Flag__c,X4_Hour_AOG__c,CaseNumber,
        Account_Name__c, Service_Level__c, Sub_Status__c, Age_in_Hours__c, Aircraft_Type__c,
        Aircraft_Location__c,OwnerName__c, lastmodifieddate, Next_Flight_Out_Date__c,
        AOG_Service_level_Value__c,Aircraft_Type__r.Name, Last_Updated_HoursMins__c,Last_Modified_Text__c,
        Product_Part__c,Hardware_Ship_From_Address__c, Product_Name__c, SPEX_Exchange__c,
        AOG_OTTR_Miss_Detail__c, AOG_OTTR_Miss_Reason__c, Market__c, SBU__c, CBT_Team__c, Contract_Type__c,
        Order_Entered__c, Customer_Request_Date__c
        from Case 
        where isClosed=false 
            and status !='Re-Open' 
            and Id = :caseId
       ];
    
        return case_one;
    }
}