/****************************************
 * Class Name : BusinessPlanningScheduler
 * Created Date: 8 Sept 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 8 Sept 2017
 * Description : Send Business Planning notifications to all PRM and PSM 
 * Test Class: BusinessPlanningBatchTest
 *****************************************/
global class BusinessPlanningScheduler implements Schedulable {
	
	private String notifyType;
	
	/********************
   *Method Name: BusinessPlanningScheduler
   *Parameter: String
   *Description: Constructor 
   *******************/
	global BusinessPlanningScheduler(String type) {
		 notifyType = type;
	}
	
	/********************
   *Method Name: execute
   *Parameter: SchedulableContext
   *Description: execute Method of Batch Class
   *******************/
	global void execute(SchedulableContext sc) {
		BusinessPlanningBatch batch = new BusinessPlanningBatch(notifyType);
		Database.executeBatch(batch);		   
	}
	
}