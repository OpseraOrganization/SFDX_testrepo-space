global class scheduleEmaiCounterBatch implements Schedulable{
    global void execute(SchedulableContext sc) {

        EmailCounterBatch b1 = new EmailCounterBatch();
        ID batchprocessid = Database.executeBatch(b1,200);           
    }
    
    
}