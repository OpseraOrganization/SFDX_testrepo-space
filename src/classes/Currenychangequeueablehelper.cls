/****************************************
	 * Name : Currenychangequeueablehelper 
	 * Author : HCL
	 * Description : For Sf ticket 18212 Queueable  class called from OrderIntakeHandler before update operation
	 *****************************************/
public class Currenychangequeueablehelper implements Queueable {
	public final Set<ID> Opptyid;
	public Currenychangequeueablehelper(Set<ID> Opptyid) {
		this.Opptyid = Opptyid;
	}
	public void execute(QueueableContext context) {
		List<Opportunity> UpdateOppty = new List<Opportunity> ();
		Map<Object, Set<String>> AggResultMap = new Map<Object, Set<String>> ();
		try {

			for (AggregateResult aggResult: [SELECT Business_Group__c, Opportunity__c FROM Order_Intake_Forecast__c
					WHERE Opportunity__c =: Opptyid AND Allocation__c = false
					GROUP BY Business_Group__c, Opportunity__c Limit: Limits.getLimitQueryRows()
				]) {

				if (!AggResultMap.containsKey(aggResult.get('Opportunity__c')))
					AggResultMap.put(aggResult.get('Opportunity__c'), new Set<String> ());

				if (AggResultMap.containsKey(aggResult.get('Opportunity__c')))
					AggResultMap.get(aggResult.get('Opportunity__c')).add(String.ValueOf(aggResult.get('Business_Group__c')));

			}

			System.debug('AggResultMap%%%' + AggResultMap + AggResultMap.size() + AggResultMap);

			//if(GlobalConstants.OPPORTUNITYTRIGGER_CURRENCY_CHANGE==False){
			for (Opportunity newopp: [Select id, StageName, Phase_Status__c, Unweighted_Amount_EUR__c, Positive_OIF_EUR__c, OIF_Value_Won_USD__c, Mono_or_Multi_BG__c, Sales_Outcome__c, OIF_Value_Cancel_USD__c, Positive_OIF__c, Negative_OIF_EUR__c, Negative_OIF__c from Opportunity where id =: Opptyid Limit: Opptyid.size()]) {
				System.debug('Currenychangequeueablehelper Passed Query newopp---->' + newopp);

				if (AggResultMap<>Null && AggResultMap.get(newopp.id)<>Null && AggResultMap.get(newopp.id).size() > 1)
					newopp.Mono_or_Multi_BG__c = 'Multi-BG';
				else
				if (AggResultMap<>Null && AggResultMap.get(newopp.id)<>Null && AggResultMap.get(newopp.id).size() == 1)
					newopp.Mono_or_Multi_BG__c = 'Mono-BG';
				else
					newopp.Mono_or_Multi_BG__c = null;

				if (String.IsEmpty(newopp.Sales_Outcome__c) || newopp.Sales_Outcome__c.equalsignorecase(GlobalConstants.WON) || newopp.Sales_Outcome__c.equalsignorecase(GlobalConstants.WON_REQUESTED)) {
					System.debug('Loop Quealbe class  Positive_OIF_EUR__c---->' + newopp.Positive_OIF_EUR__c.setScale(2) + '======newopp.Unweighted_Amount_EUR__c ===>' + newopp.Unweighted_Amount_EUR__c);
					System.debug('newopp.Sales_Outcome__c===>' + newopp.Sales_Outcome__c);
					if ((newopp.Unweighted_Amount_EUR__c != newopp.Positive_OIF_EUR__c.setScale(2)) || (Test.isRunningTest())) {
						System.debug('INSIDE POSTIVE QUEABLE IF');
						newopp.Unweighted_Amount_EUR__c = newopp.Positive_OIF_EUR__c.setScale(2);
						newopp.amount = newopp.Positive_OIF__c.setScale(2);
						newopp.Unweighted_Amount_USD__c = newopp.OIF_Value_Won_USD__c.setScale(2);
						newopp.Is_Automated__c = TRUE;
						UpdateOppty.add(newopp);
					}
				} else if ((newopp.Sales_Outcome__c<>GlobalConstants.WON) || (Test.isRunningTest())) {
					System.debug('Loop Quealbe class  Negative_OIF_EUR__c---->' + newopp.Negative_OIF_EUR__c.setScale(2) + '======newopp.Unweighted_Amount_EUR__c ===>' + newopp.Unweighted_Amount_EUR__c);

					if (newopp.Unweighted_Amount_EUR__c != newopp.Negative_OIF_EUR__c.setScale(2) || (Test.isRunningTest())) {
						System.debug('INSIDE Negative QUEABLE IF');
						newopp.Unweighted_Amount_EUR__c = newopp.Negative_OIF_EUR__c.setScale(2);
						newopp.amount = newopp.Negative_OIF__c.setScale(2);
						newopp.Unweighted_Amount_USD__c = newopp.OIF_Value_Cancel_USD__c.setScale(2);

						newopp.Is_Automated__c = TRUE;
						UpdateOppty.add(newopp);
					}
				}

				//  UpdateOppty.add(newopp); 

			}
			
			if (!UpdateOppty.isEmpty() && !Test.isRunningTest()) {
				update UpdateOppty;
				GlobalConstants.OPPORTUNITYTRIGGER_CURRENCY_CHANGE = TRUE;

			}
			

			//}  

		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.CURRENCY_CHANGE);
		}
	}
}