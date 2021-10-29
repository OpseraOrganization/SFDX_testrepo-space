/** * File Name: Opportunity_Prod_Update_RevenueSchedule
* Description Trigger to Update the service date
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger Opportunity_Prod_Update_RevenueSchedule on OpportunityLineItem (after update) {
   if(AvoidRecursion1.isFirstRun_Opportunity_Prod_Update_RevenueSchedule()){
   List<OpportunityLineItem> OppLineItem=Trigger.new;
   List<OpportunityLineItemSchedule> Olis=new List<OpportunityLineItemSchedule>();
   
 //  Map <Id,Id> oppProdId =new Map<Id,Id>();
   Map<Id,Integer> diffdays=new map<Id,Integer>();
   Integer daysbet;
   List<OpportunityLineItem> OppLineItemUpdate=new List<OpportunityLineItem>();
   
   
   for(Integer i=0;i<OppLineItem.size();i++){            
           if(OppLineItem[i].ServiceDate!=Trigger.old[i].ServiceDate   && trigger.old[i].ServiceDate!=NULL ){
               daysbet=Trigger.old[i].ServiceDate.daysbetween(OppLineItem[i].ServiceDate);
               diffdays.put(OppLineItem[i].id,daysbet);
               //System.Debug('daysbet'+daysbet);
              // oppProdId.put(OppLineItem[i].id,OppLineItem[i].id);
               
            }
       
   }
   //System.Debug('OppLineItemUpdate'+OppLineItemUpdate);
   /* if(OppLineItemUpdate.size()>0)
    {
        try{
        Update OppLineItemUpdate;
        }
        catch(Exception e){
        System.Debug('Exception e'+e);
        }
    }*/

//List<OpportunityLineItemSchedule> scheduleList=new List<OpportunityLineItemSchedule>();
   if (diffdays.size()>0)
   {
 //scheduleList=  [Select Id,Quantity,ScheduleDate,Type,OpportunityLineItemId from OpportunityLineItemSchedule where OpportunityLineItemId in :diffdays.keySet() and  ScheduleDate!=NULL  Limit 10];
     //Integer scheduleListsize=scheduleList.size();


    for (OpportunityLineItemSchedule  oppLineItemSchedule:[Select Id,Quantity,ScheduleDate,Type,OpportunityLineItemId from OpportunityLineItemSchedule where OpportunityLineItemId in  :diffdays.keySet() Limit 100])
    {
        //if (oppLineItemSchedule.OpportunityLineItemId  == oppProdId.get(oppLineItemSchedule.OpportunityLineItemId  ))
       // {     
            //OpportunityLineItemSchedule oppLineUpdateLst=new OpportunityLineItemSchedule(ID=oppLineItemSchedule.Id);                               
            //if(scheduleList[i].ScheduleDate!=NULL  ){         
              /// scheduleList[i].ScheduleDate=scheduleList[i].ScheduleDate+diffdays.get(scheduleList[i].OpportunityLineItemId );
               //Olis.add(scheduleList[i]);
            //}
            
        OpportunityLineItemSchedule oppLineUpdateLst=new OpportunityLineItemSchedule(ID=oppLineItemSchedule.Id);
          
            
            
            if(oppLineItemSchedule.ScheduleDate!=NULL){
      
                oppLineUpdateLst.ScheduleDate=oppLineItemSchedule.ScheduleDate+diffdays.get(oppLineItemSchedule.OpportunityLineItemId );
                Olis.add(oppLineUpdateLst);
            }

            
            
            
            
      //  }
 
    }
    
    }
 
    
    try {
        if ( Olis.size()>0)
        {
            update  Olis; 
            //System.Debug('Updated : '+Olis); 
        }
    }
    catch (Exception e )
    {
        System.debug('Exception -- > '+e);
    }
    
  }   
}