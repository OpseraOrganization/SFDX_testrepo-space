/**
*  This is the scheduler class for CreateTaskForContractCase.
**/

global Class CreateTaskForContractCaseScheduler implements Schedulable{
    global void execute(SchedulableContext SC) {
      CreateTaskForContractCase ct = new CreateTaskForContractCase();
      database.executebatch(ct,200);
    }
}