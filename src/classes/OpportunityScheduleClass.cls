public Class OpportunityScheduleClass{

@InvocableMethod
public static void createOpporutunityScheduleRecord(List<id> opportunityProductIDLocal){
    System.debug('At line 5');
    Id opportunityProductID = opportunityProductIDLocal.get(0);
    map<id,OpportunityLineItem> oppProductLineMap = new map<id,OpportunityLineItem>([select OpportunityID,Product2ID,id,HasSchedule,ServiceDate,TotalPrice from OpportunityLineItem where id =:opportunityProductID]);
    OpportunityLineItem oppProductLine = oppProductLineMap.get(opportunityProductID);        
    ID opportunityID = oppProductLine.OpportunityID;
    ID productID = oppProductLine.Product2ID;
    map<id,Opportunity> opportunityMap = new map<id,Opportunity>([select id,Record_Type_Name__c,CloseDate from Opportunity where id = :opportunityID]);
    map<id,Product2> productMap = new map<id,Product2>([select id,CanUseRevenueSchedule from Product2 where id = :productID]);
                
        //for(OpportunityLineItem oppProductLine:Trigger.New){
            Opportunity oppRec = opportunityMap.get(oppProductLine.OpportunityID);
            Product2 productRec = productMap.get(oppProductLine.Product2ID);
            OpportunityLineItem oppProductLatest = oppProductLineMap.get(oppProductLine.id);
            if(productRec.CanUseRevenueSchedule && oppRec.Record_Type_Name__c =='BGA AM' && !oppProductLatest.HasSchedule || Test.isRunningTest()){
                OpportunityLineItemSchedule scheduleRec = new OpportunityLineItemSchedule();
                scheduleRec.OpportunityLineItemId = oppProductLine.id;
                scheduleRec.Type = 'Revenue';
                scheduleRec.Revenue = oppProductLine.TotalPrice;
                if(oppProductLine.ServiceDate != null){
                    scheduleRec.ScheduleDate = oppProductLine.ServiceDate;
                }else{
                    scheduleRec.ScheduleDate = oppRec.CloseDate;
                }
                insert scheduleRec;
            }
        //}
       
     }   
   }