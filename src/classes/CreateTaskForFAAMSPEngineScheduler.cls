/**
*  This is the scheduler class for CreateTaskForFAAMSPEngine.
**/

global Class CreateTaskForFAAMSPEngineScheduler implements Schedulable{
    global void execute(SchedulableContext SC) {
      CreateTaskForFAAMSPEngine ct = new CreateTaskForFAAMSPEngine();
      database.executebatch(ct,200);
    }
}