/************************************
Created By : Moulshree Shrivastava
Date: 26/07/2018
Project: Aero(TCS)
Test Class: TechPubFeedbackUpdate_test
Usage: If survey is already submitted(i.e feedback record is already created) and after that user submits the form(to create case) then 
case Id should get updated in feedback record.
*************************************/

public class TechPubFeedbackUpdate{

    Id devRecordTypeId = Schema.SObjectType.Feedback__c.getRecordTypeInfosByName().get('Technical Publication Survey').getRecordTypeId();

    public void TechPubFeedbackUpdate(List<case> caseList){
        // = caseObj;
        system.debug('inside TechPubFeedbackUpdate');
        List<Feedback__c> feedbackLst = [select Id,Tech_Pub_Id__c,case__c from feedback__c where RecordTypeId =:devRecordTypeId ];
        List<Feedback__c> feedbackUpdateLst = new List<Feedback__c>();
        Map<string, feedback__c> feedbackMap = new Map<string, feedback__c>();
        for(feedback__c feed:feedbackLst ){
            feedbackMap.put(feed.Tech_Pub_Id__c, feed);    
        }  
        
        for(case cas: caseList){
            
            for(Feedback__c fback : feedbackLst){
                if(cas.subject != null){
                    String casS = cas.subject;
                    system.debug('case is' + casS);
                    system.debug('fback.Tech_Pub_Id__c' + fback);
                        if(fback.Tech_Pub_Id__c !=null && casS.contains(fback.Tech_Pub_Id__c )){
                
                            system.debug('case is' + cas);
                            fback.case__C = cas.Id;
                            feedbackUpdateLst.add(fback);
                        }
                 }
             }
         
            
            /*String casStr = cas.subject.split(':',2)[1];
            casStr = casStr.trim();
            system.debug('casStr==' +casStr );
            if(feedbackMap.containsKey(casStr)){
             feedbackMap.get(casStr).case__c = cas.Id; 
             system.debug('feedbackMap.get(casStr).case__c' +feedbackMap.get(casStr).case__c); 
             //string caseId = feedbackMap.get(casStr).case__c;
             feedbackUpdateLst.add(feedbackMap.get(casStr));  
             system.debug('feedbackUpdateLst==' +feedbackUpdateLst);
            }*/
        } 
        
        if(feedbackUpdateLst != null && !feedbackUpdateLst.isEmpty()){
        update feedbackUpdateLst;
        }          
    }

}