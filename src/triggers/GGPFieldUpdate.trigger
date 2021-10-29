trigger GGPFieldUpdate on Associated_VOC_Card_Number__c (after insert, after update, after delete) {
id ggpid;id feeid; id feeid1;
list<go_green_plan__c> ggplist= new list<go_green_plan__c>();
list<go_green_plan__c> ggplist1= new list<go_green_plan__c>();
list<feedback__c> feedlist= new list<feedback__c>();
list<feedback__c> feedlist1= new list<feedback__c>();
list<feedback__c> feedlist2= new list<feedback__c>();
feeid = null;
If (trigger.isinsert || trigger.isupdate){
for( Associated_VOC_Card_Number__c  Afc:Trigger.new){
ggpid = afc.go_green_plan__c;

} 
}
else if (trigger.isdelete){
for( Associated_VOC_Card_Number__c  Afc1:Trigger.old){
ggpid = afc1.go_green_plan__c;
feeid = afc1.feedback_number__c;

}
}
ggplist = [select id from go_green_plan__c where id =: ggpid];
 feedlist = [select Year__c, Overall_Satisfaction_VOCSurvey__c,Locked__c,
             Interviewer_Name__c, SBU__c, Prod_LN_Prgm_Product_LIne__c,
             // Site__c, 
             Supplier_Rating_Syst__c, Contact__c, Contact_Status__c, CBT__c, 
             Market_Name__c,Account__c, SR_S__c, SR_CBT__c, CBT_Team__c,
             Account_SBU__c,Account_CBT__c,Quarter__c,Go_Green_Yr_Qtr__c,
             Go_Green_Status__c,Type_Formula__c,Date_of_Interview__c,
             Report_Flag__c,Overall_Satisfaction_Value__c 
             from Feedback__c where id !=: feeid and ggp_number__c =:ggpId order by Date_of_Interview__c DESC];
 if (feedlist.size()>0)
 {
  for(Go_Green_plan__c gogreen:ggplist)
 {
  system.debug('PPPPPP'+feedlist);
   gogreen.Year__c = feedlist[0].Year__c;
            gogreen.Interviewer_Name__c = feedlist[0].Interviewer_Name__c;
            gogreen.Prod_LN_Prgm_Product_LIne__c = feedlist[0].Prod_LN_Prgm_Product_LIne__c;
            //gogreen.Site__c = feedlist[0].Site__c;
            gogreen.Supplier_Rating_Syst__c = feedlist[0].Supplier_Rating_Syst__c;
            gogreen.Contact__c = feedlist[0].Contact__c;
            gogreen.Account__c = feedlist[0].Account__c;
            gogreen.SR_SBU__c = feedlist[0].SR_S__c;
            gogreen.SR_CBT__c = feedlist[0].SR_CBT__c;
            gogreen.CBT_Team__c = feedlist[0].CBT_Team__c;
            gogreen.Account_SBU1__c = feedlist[0].Account_SBU__c;
            gogreen.Account_CBT1__c = feedlist[0].Account_CBT__c;
            gogreen.Quarter__c = feedlist[0].Quarter__c;
                //    gogreen.Legacy_VOC_Number__c = feedlist[0].Legacy_VOC_Number__c;
            gogreen.Go_Green_Yr_Qtr__c = feedlist[0].Go_Green_Yr_Qtr__c;
            gogreen.Go_Green_Status__c = feedlist[0].Go_Green_Status__c;
            gogreen.Type__c = feedlist[0].Type_Formula__c;
            gogreen.Date_of_Interview__c = feedlist[0].Date_of_Interview__c;
            gogreen.Report_Flag__c = feedlist[0].Report_Flag__c;
             gogreen.Locked__c = feedlist[0].Locked__c;
            gogreen.Overall_Calculated_Satisfaction__c = feedlist[0].Overall_Satisfaction_VOCSurvey__c;
            gogreen.Overall_Calculated_Satisfaction_Value__c = feedlist[0].Overall_Satisfaction_Value__c;
    ggplist1.add(gogreen);
  }
   Update ggplist1;
  }
  if (feeid != null){
  feedlist2 = [SELECT Id,Value_Customer_Expectations__c,Value_Customer_Rating__c,
                                     Delivery_Customer_Expectations__c,Delivery_Customer_Rating__c,
                                     Development_Customer_Expectations__c,Development_Customer_Rating__c,
                                     Quality_Customer_Expectations__c,Quality_Customer_Rating__c,
                                     Service_Support_Customer_Expectations__c,Service_Support_Customer_Rating__c,
                                     Reliability_Customer_Expectations__c,Reliability_Customer_Rating__c,
                                     Responsiveness_Customer_Expectations__c,Responsiveness_Customer_Rating__c,
                                     Value_summary__c,Delivery_Summary__c,Quality_Summary__c,Reliability_summary__c,
                                     Service_Support_Summary__c,Development_summary__c,responsiveness_summary__c
                                      FROM Feedback__c  where id =: feeid];
   for(feedback__c feedback:feedlist2)
 {
  if (feedback.id == feeid)
  { 
  // if (((feedback.Value_Customer_Expectations__c == null || feedback.Value_summary__c == null )&& 
   // (feedback.Value_Customer_Rating__c == 'Yellow - Somewhat Dissatisfied'|| feedback.Value_Customer_Rating__c == 'Red - Very Dissatisfied')) ||
   // ((feedback.Delivery_Customer_Expectations__c == null || feedback.Delivery_Summary__c == null) && 
   // (feedback.Delivery_Customer_Rating__c == 'Yellow - Somewhat Dissatisfied' || feedback.Delivery_Customer_Rating__c == 'Red - Very Dissatisfied')) ||
    // ((feedback.Development_Customer_Expectations__c == null || feedback.Development_Summary__c == null) && 
  //   (feedback.Development_Customer_Rating__c == 'Yellow - Somewhat Dissatisfied'|| feedback.Development_Customer_Rating__c == 'Red - Very Dissatisfied')) ||
    // ((feedback.Quality_Customer_Expectations__c == null || feedback.Quality_Summary__c == null) && 
   //  (feedback.Quality_Customer_Rating__c == 'Yellow - Somewhat Dissatisfied' || feedback.Quality_Customer_Rating__c == 'Red - Very Dissatisfied')) ||
   //  ((feedback.Reliability_Customer_Expectations__c == null || feedback.Reliability_summary__c == null) && 
   //  (feedback.Reliability_Customer_Rating__c == 'Yellow - Somewhat Dissatisfied'|| feedback.Reliability_Customer_Rating__c == 'Red - Very Dissatisfied')) ||
   //  ((feedback.Responsiveness_Customer_Expectations__c == null || feedback.Responsiveness_Summary__c == null) && 
   //  (feedback.Responsiveness_Customer_Rating__c == 'Yellow - Somewhat Dissatisfied' || feedback.Responsiveness_Customer_Rating__c == 'Red - Very Dissatisfied')) ||
   //  ((feedback.Service_Support_Customer_Expectations__c == null || feedback.Service_Support_Summary__c == null) && 
   //  (feedback.Service_Support_Customer_Rating__c == 'Yellow - Somewhat Dissatisfied'|| feedback.Service_Support_Customer_Rating__c == 'Red - Very Dissatisfied')))
   //  {
    // Trigger.old[0].addError('Plese update Customer Expectations and Delivery Summary attributes in related Feedback before removing it from GGP.');
    // }
   //  else {
  feedback.GGP_Number__c = null;
 // feedback.trigger_edit__c = true;
  feedlist1.add(feedback);
 // }
  }
  update feedlist1;
 }
  }
}