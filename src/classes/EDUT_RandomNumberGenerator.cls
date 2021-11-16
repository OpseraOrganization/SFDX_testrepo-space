/****************************************
* Class Name : EDUT_RandomNumberGenerator
* Created Date: 16 May 2019
* Created By : CoE Team
* Last Modified by: CoE Team
* Last Modified Date: 16 May 2019
* Description : Random Number Generator for EDU Ticketing Support Tickets
* Comments: This class is invoked in "EDUT - Processes" process
* Test Class: EDUT_RandomNumberGeneratorTest
*****************************************/
public class EDUT_RandomNumberGenerator
{
	@InvocableMethod
	public static void EDUT_RandomNumberGenerator(List<Id> CaseIds)
	{
		List<Case> CaseList = [Select id, EDUT_Random__c from Case where id in: CaseIds];
		if(!CaseList.isEmpty()){
			for(Case c : CaseList){
				c.EDUT_Random__c = Math.random();
			}
			update CaseList;
		}
	}
}