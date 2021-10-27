/* Type:  Apex Controller
 * Name - CH_CA_WorkgroupMember_Hotline_controller
 * Description - This class is used to add Hotline member in worgoup member
 * Date: 27-02-2019
 * */
public class CH_CA_WorkgroupMember_Hotline_controller {
	@AuraEnabled
	public static CH_Workgroup_Member__c saveHotlineMember (CH_Workgroup_Member__c hotlineMember) {
		system.debug('Data '+hotlineMember);
		try{
			insert hotlineMember;
			//to Cover catch block in Unit test below line is added.
			//throw new DmlException();
		}catch(DmlException e) {
			throw new AuraHandledException('The following exception has occurred:' + e.getMessage());
		}
		return hotlineMember;	
	}
}