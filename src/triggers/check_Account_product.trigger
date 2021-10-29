trigger check_Account_product on Associated_VOC_Card_Number__c (Before Insert, Before Update){

   for(Associated_VOC_Card_Number__c voc : trigger.new){
     
        if((voc.Feedback_Account__c != voc.Go_Green_Plan_Account__c)||
      (  voc.Go_Green_Plan_Product__c!=voc.Feedback_Product__c) )
        voc.adderror('The Feedback account and Product Line should be same as Go Green Plan!');
      
      
   }
   
}