global class CountNumberOfOpenActivities implements Database.Batchable<SObject> 
{

    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        // Getting child records (Contact)
        return Database.getQueryLocator([Select id, (SELECT id From Tasks where IsClosed = False) from Case 
        where Recordtypeid =:label.Dynamic_record_type]);
        /*label.OEM_Spares
        or Recordtypeid =:label.Repair_Overhaul_RT_ID or Recordtypeid =:label.Engine_Rentals 
        or Recordtypeid =:label.MSP_Contract or RecordTypeID=:label.FSS_Tech_Issue_RT_ID or RecordTypeID=:label.Orders_Rec_ID 
        or RecordTypeID=:label.QuotesRecordID or RecordTypeID=:label.OEM_Quotes_Orders_ID or RecordTypeID=:label.Internal_Escalations_RecordId 
        or RecordTypeID=:label.AOG_Record_Type]);*/
    }

    global void execute(Database.BatchableContext bc, List<case> scope )
    {   
        system.debug ('>>>>> Scope Size >>>>>' + scope.size());

        for(Case c : scope)
        {
            
                system.debug ('>>>>> Scope Contact size Size >>>>>' + c.Tasks.size());
                c.OF_OPEN_ACTIVITY__C  = c.Tasks.size();
            
        }
        update scope;
    }

    global void finish(Database.BatchableContext bc)
    {

    }
}