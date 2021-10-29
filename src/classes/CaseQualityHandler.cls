/*
Created By : Puvaneswari
Created Date : 10-March-2020
Usages : CaseQualityHandler to Update First_Contact_SLA__c based on Customer_Update_Frequency__c    
*/
public class CaseQualityHandler {
    
    public static Integer calcCUFMins(string CUFrequency){
        Integer cufVal = Integer.valueOf(CUFrequency.replaceAll('[^0-9]', ''));
        cufVal = (CUFrequency.endsWithIgnoreCase('hour') || CUFrequency.endsWithIgnoreCase('hours')) ? cufVal*60 : (CUFrequency.endsWithIgnoreCase('days') ? cufVal*24*60 : cufVal) ;
        return cufVal;
    }
    
}