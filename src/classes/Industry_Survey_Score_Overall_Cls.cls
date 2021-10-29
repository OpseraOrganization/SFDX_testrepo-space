/** * File Name: Industry_Survey_Score_Overall_Cls 
* Description :To show the comparision survey result
* Copyright : NTTDATA 2015 *
 * @author : NTTDATA
 * Modification Log =============================================================== Ver Date Author Modification --- ---- ------ -------------*
**/ 
public with sharing class Industry_Survey_Score_Overall_Cls {
public Account acc;
public String posId;
public List<Feedback__c> fed{get; set;} 

public Integer roundedvalueCYR{get; set;} 
public Integer roundedvaluePYR{get; set;} 

public Industry_Survey_Score_Overall_Cls (ApexPages.StandardController controller) {
       
        this.acc= (Account)controller.getRecord();
        posId= this.acc.Id; 
        //posId= '0013000000bFxi9';
        String strQ='select Consolidated_score__c,Consolidated_score_Rating__c,Customer_Overall_Satisfaction_Metric_IND__c,Product_Category__c,ATR_Survey_Group__c,Year__c,Quarter__c,id,name,'
           +'Reliability_Metric_IND__c,Service_Support_Metric_IND__c,Repair_Performance_IND__c,Spares_Performance_IND__c,Communication_IND__c '
           +'from Feedback__c  where recordtypeid=\'';
           strQ=strQ+label.ATR_VOC_Record_Type;
           strQ=strQ+'\' and account__c=\''+posId+'\' order by createddate desc';
         fed=Database.Query(strQ);
           Decimal conScoreCYR=0;
           Integer countCYR=0;
           
           Decimal conScorePYR=0;
           Integer countPYR=0;
           Integer Year = Date.Today().Year();
           for(feedback__c fi:fed)
           {
               if(fi.Consolidated_score__c!=null){
                   if(Integer.valueOf(fi.year__c)==year){
                       conScoreCYR=conScoreCYR+ fi.Consolidated_score__c;
                       countCYR++;
                   }
                  
                   if(Integer.valueOf(fi.year__c)==(year-1)){
                   
                       conScorePYR=conScorePYR+ fi.Consolidated_score__c;
                       countPYR++;
                   }
               }
           }
           
           Decimal consolidatedCYR = 0;
           if(countCYR>0)
            consolidatedCYR  = conScoreCYR/countCYR;
           
           Decimal consolidatedPYR =0;
           if(countPYR>0)
               consolidatedPYR =consolidatedPYR = conScorePYR/countPYR;
           
           roundedvalueCYR =  integer.valueOf(consolidatedCYR.setscale(0, roundingMode.DOWN)); 
           roundedvaluePYR =  integer.valueOf(consolidatedPYR.setscale(0, roundingMode.DOWN)); 
           
           
        }
}