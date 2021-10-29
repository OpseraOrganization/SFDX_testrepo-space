/**
*  This is the scheduler class for TaskLogic.
**/

global Class TaskLogicScheduler implements Schedulable{
    global void execute(SchedulableContext SC) {
      TaskLogic tl = new TaskLogic();
      tl.createTask();
   }    
}