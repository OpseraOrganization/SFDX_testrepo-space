trigger CountOpenActivity on Task (after insert, after update, after delete){
    
    //variable declaration
    integer openActivitiesCount = 0;
    List<Id> updateTaskIds1=new List<Id>();
    // Added code for UFR Pricing to avoid calling UpdateCountOpenActivities class
    List<Case> cas = new List<Case>();
    List<Case> casesnew = new List<Case>();
    List<Case> casesnewdel = new List<Case>();
    set<id> casid = new set<id>();
    List<Id> deletedList = new List<Id>();
    List<Task> delids = new List<Task>();
    
    if (trigger.isInsert || trigger.IsUpdate ){
        List<Task> taskIds=Trigger.new;
        for(Integer i=0;i<taskIds.size();i++){
            casid.add(taskIds[i].whatId);     
        }
        if(casid!=null && casid.size()>0){
            cas = [Select id,Origin,RecordTypeId, (Select Id From Tasks where IsClosed = False) from Case where (id =:casid and (Recordtypeid =:label.Repair_Overhaul_RT_ID 
or Recordtypeid =:label.OEM_Spares or Recordtypeid =:label.Engine_Rentals or Recordtypeid =:label.MSP_Contract or RecordTypeID=:label.FSS_Tech_Issue_RT_ID 
/*or RecordTypeID=:label.Orders_Rec_ID*/ or RecordTypeID=:label.QuotesRecordID or RecordTypeID=:label.OEM_Quotes_Orders_ID or RecordTypeID=:label.Internal_Escalations_RecordId or RecordTypeID=:label.AOG_Record_Type))];
        }
            for (Case cs : cas ){
            openActivitiesCount = openActivitiesCount + cs.OpenActivities.size();
            cs.OF_OPEN_ACTIVITY__C = cs.Tasks.size();
            casesnew.add(cs);
            }
            System.debug('openActivitiesCount : '+openActivitiesCount); 
            update casesnew;
        }
        
        if (trigger.isDelete){
        List<Task> taskIds=Trigger.old;
        for(Integer i=0;i<taskIds.size();i++){
            casid.add(taskIds[i].whatId);     
        }
        if(casid!=null && casid.size()>0){
            cas = [Select id,Origin,RecordTypeId, (SELECT Id FROM Tasks where IsClosed = False) from Case where (id =:casid and (Recordtypeid =:label.Repair_Overhaul_RT_ID 
or Recordtypeid =:label.OEM_Spares or Recordtypeid =:label.Engine_Rentals or Recordtypeid =:label.MSP_Contract or RecordTypeID=:label.FSS_Tech_Issue_RT_ID 
or RecordTypeID=:label.Orders_Rec_ID or RecordTypeID=:label.QuotesRecordID or RecordTypeID=:label.OEM_Quotes_Orders_ID or RecordTypeID=:label.Internal_Escalations_RecordId or RecordTypeID=:label.AOG_Record_Type))];
        
        }
            for (Case cs : cas ){
            openActivitiesCount = openActivitiesCount + cs.OpenActivities.size();
            cs.OF_OPEN_ACTIVITY__C = cs.Tasks.size();
            casesnewdel.add(cs);
            }
            System.debug('openActivitiesCount : '+openActivitiesCount); 
            update casesnewdel;
        }
}