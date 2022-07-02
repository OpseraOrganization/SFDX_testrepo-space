global class EinsteinDiscoveryScheduler implements Schedulable {
	
	public final static String labelL2WPrediction = 'Opportunity LTW Scoring CRM';
	
	global void execute(SchedulableContext SC){
		//Likelihood to Win model
		EinsteinDiscoveryPredictions.makeDailyPrediction(labelL2WPrediction);
	}
}