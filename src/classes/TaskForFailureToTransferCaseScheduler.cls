/**
*  This is the scheduler class for TaskForFailureToTransferCase.
**/

global Class TaskForFailureToTransferCaseScheduler implements Schedulable{
    global void execute(SchedulableContext SC) {
      TaskForFailureToTransferCase tf = new TaskForFailureToTransferCase();
      database.executebatch(tf,200);
    }
}