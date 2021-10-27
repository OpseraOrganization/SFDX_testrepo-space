/* Type:  Apex Class
* Name - CH_CA_Workgroup_Weight
* Description - This class is used to combine the weight given to a schedule in the search.
* Developer: Sónia Reis
* 23 September 2019
* */
public class CH_CA_Workgroup_Weight {
	
	@AuraEnabled
	public CH_Workgroup_Schedule__c wGSchedule{get;set;}
	@AuraEnabled
	public Integer weight{get;set;}
	
	public CH_CA_Workgroup_Weight(CH_Workgroup_Schedule__c wGSchedule, Integer weight){
		this.wGSchedule=wGSchedule;
		this.weight= weight;
	}

}