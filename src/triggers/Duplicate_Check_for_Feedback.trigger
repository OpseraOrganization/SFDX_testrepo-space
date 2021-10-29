trigger Duplicate_Check_for_Feedback on Associated_VOC_Card_Number__c ( Before Insert, Before Update){

List<ID> greenlist = new List<ID>();
List<ID> feedlist = new List<ID>();
Map<ID,ID> mapcheck = new Map<ID,ID>();
Map<ID,ID> dupcheckmap = new Map<ID,ID>();
Map<ID,ID> GGPFEEkmap = new Map<ID,ID>();
List<Feedback__c> GGPFEE = new List<Feedback__c>();
List<Associated_VOC_Card_Number__c> dupcheck = new List<Associated_VOC_Card_Number__c>();

    for(Associated_VOC_Card_Number__c voc : trigger.new){
        if(voc.Go_Green_Plan__c != null && voc.Feedback_Number__c != null){
            greenlist.add(voc.Go_Green_Plan__c);
            feedlist.add(voc.Feedback_Number__c);
            GGPFEEkmap.put(voc.Feedback_Number__c, voc.Go_Green_Plan__c);
   //         mapcheck.put(voc.Feedback_Number__c,voc.Go_Green_Plan__c);            
        }
    }
    /* Added for certido Ticket # 355618- GGP # needs to be associated in all FEE cards */
    system.debug('$$$$$$$$'+feedlist);
     List<Feedback__c> GGPFEE1  = [SELECT Id,Value_Customer_Expectations__c,Value_Customer_Rating__c,
                                     Delivery_Customer_Expectations__c,Delivery_Customer_Rating__c,
                                     Development_Customer_Expectations__c,Development_Customer_Rating__c,
                                     Quality_Customer_Expectations__c,Quality_Customer_Rating__c,
                                     Service_Support_Customer_Expectations__c,Service_Support_Customer_Rating__c,
                                     Reliability_Customer_Expectations__c,Reliability_Customer_Rating__c,
                                     Responsiveness_Customer_Expectations__c,Responsiveness_Customer_Rating__c,
                                     Value_summary__c,Delivery_Summary__c,Quality_Summary__c,Reliability_summary__c,
                                     Service_Support_Summary__c, Development_summary__c, responsiveness_summary__c
                                      FROM Feedback__c WHERE id IN :feedlist];
            system.debug('$$$$$$$$'+GGPFEE1);
    For (Feedback__c fe:GGPFEE1)
    {
  //  if ( ((fe.Value_Customer_Expectations__c == null || fe.Value_summary__c == null )&& 
 //   (fe.Value_Customer_Rating__c == 'Yellow - Somewhat Dissatisfied'|| fe.Value_Customer_Rating__c == 'Red - Very Dissatisfied')) ||
  //  ((fe.Delivery_Customer_Expectations__c == null || fe.Delivery_Summary__c == null) && 
  //  (fe.Delivery_Customer_Rating__c == 'Yellow - Somewhat Dissatisfied' || fe.Delivery_Customer_Rating__c == 'Red - Very Dissatisfied')) ||
  //   ((fe.Development_Customer_Expectations__c == null || fe.Development_Summary__c == null) && 
  //   (fe.Development_Customer_Rating__c == 'Yellow - Somewhat Dissatisfied'|| fe.Development_Customer_Rating__c == 'Red - Very Dissatisfied')) ||
   //  ((fe.Quality_Customer_Expectations__c == null || fe.Quality_Summary__c == null) && 
  //   (fe.Quality_Customer_Rating__c == 'Yellow - Somewhat Dissatisfied' || fe.Quality_Customer_Rating__c == 'Red - Very Dissatisfied')) ||
   //  ((fe.Reliability_Customer_Expectations__c == null || fe.Reliability_summary__c == null) && 
   //  (fe.Reliability_Customer_Rating__c == 'Yellow - Somewhat Dissatisfied'|| fe.Reliability_Customer_Rating__c == 'Red - Very Dissatisfied')) ||
  //   ((fe.Responsiveness_Customer_Expectations__c == null || fe.Responsiveness_Summary__c == null) && 
  //   (fe.Responsiveness_Customer_Rating__c == 'Yellow - Somewhat Dissatisfied' || fe.Responsiveness_Customer_Rating__c == 'Red - Very Dissatisfied')) ||
   //  ((fe.Service_Support_Customer_Expectations__c == null || fe.Service_Support_Summary__c == null) && 
   //  (fe.Service_Support_Customer_Rating__c == 'Yellow - Somewhat Dissatisfied'||
    // fe.Service_Support_Customer_Rating__c == 'Red - Very Dissatisfied')))
    // {
    // Trigger.New[0].addError('Plese fill in Customer Expectations and Summary attributes in Feedback before adding it to GGP.');
    // }
   //else {
       system.debug('$$$$$$$$'+GGPFEEkmap.get(fe.id));
    fe.GGP_Number__c = GGPFEEkmap.get(fe.id);
    //fe.trigger_edit__c = true;
    GGPFEE.add(fe);
   //}
    }
    try{
            update GGPFEE;
           
        }catch(Exception e){
           
            }
    /* End of certido Ticket # 355618 */
    
    dupcheck = [select id, Feedback_Number__c, Go_Green_Plan__c from Associated_VOC_Card_Number__c where Go_Green_Plan__c in : greenlist 
    //and Feedback_Number__c in: feedlist
    ];
    if(dupcheck.size()>0){
        for(Associated_VOC_Card_Number__c cn : dupcheck){
            dupcheckmap.put(cn.Feedback_Number__c, cn.Go_Green_Plan__c);
        }
    }
    
    system.debug('TTTTTTT'+dupcheck);
  
    if(Trigger.isInsert){
        if(dupcheckmap.size()>0){
            for(Associated_VOC_Card_Number__c voc : trigger.new){
                if(dupcheckmap.containsKey(voc.Feedback_Number__c))
                voc.adderror('Go Green Plan already exists for the Feedback!');
            }
        }
    }
   
    if(Trigger.isUpdate){
        if(dupcheckmap.size()>0){
            for(Associated_VOC_Card_Number__c voc : trigger.new){
                if((System.Trigger.OldMap.get(voc.Id).Feedback_Number__c != System.Trigger.NewMap.get(voc.Id).Feedback_Number__c) || (System.Trigger.OldMap.get(voc.Id).Go_Green_Plan__c != System.Trigger.NewMap.get(voc.Id).Go_Green_Plan__c)){
                    if(dupcheckmap.containsKey(voc.Feedback_Number__c))
                    voc.adderror('Go Green Plan already exists for the Feedback!');
                }    
            }
        }
    }
}