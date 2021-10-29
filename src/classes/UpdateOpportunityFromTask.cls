global class UpdateOpportunityFromTask {
    
    public static boolean flag = true;
    @future 
    public static void UpdateOpportunityFromTask(Map<Id,id> updateOppTaskIds){
    
        Map<id,Task> task1=new Map<id,Task>();
        Map<id,Opportunity> opptoUpdate= new Map<id,Opportunity>();
        Opportunity opp = new Opportunity();
        List<Opportunity> listOpp= new List<Opportunity>();
        if(updateOppTaskIds.size()>0){
            task1 = new Map<id,Task>([Select createddate,id from Task where id in : updateOppTaskIds.values() ]);
            opptoUpdate = new Map<id,Opportunity>([Select createddate,id from Opportunity where id in : updateOppTaskIds.keySet() ]);    
        }
        for(Id ids: updateOppTaskIds.keySet())
        {
            DateTime oppDate= opptoUpdate.get(ids).createddate;
            DateTime taskDate= task1.get(updateOppTaskIds.get(ids)).createddate;
            Decimal daysBetween;
            decimal Hours = decimal.valueOf((taskDate.getTime() - oppDate.getTime()))/(1000.0*60.0*60.0);               
            System.debug('HOURS::'+Hours.setScale(1));  
            opp=new Opportunity(id=ids);
            opp.First_Call_Activity_Diff__c  = Hours.setScale(1);
            listOpp.add(opp);
        }
        if(listOpp.size()>0)
            update listOpp;
    }
}