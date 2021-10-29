/**
*  This is the scheduler class for CreateTaskForCase.
**/

global Class CreateTaskForCaseScheduler implements Schedulable{
    global void execute(SchedulableContext SC) {
      CreateTaskForCase ct = new CreateTaskForCase();
      database.executebatch(ct,200);
    }
}