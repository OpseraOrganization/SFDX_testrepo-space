/**
 * Created by tweinberger on 2019-01-09.
 */

global class NCP_Import_Product_Schedule implements Schedulable {
	global void execute(SchedulableContext ctx) {
		Database.executeBatch(new NCP_Import_Product_BATCH());
	}
}