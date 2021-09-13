/***************************************
* Class Name : EDUT_MarkGarbageEDUTicketToInvalid
* Created Date: 14 Feb 2020
* Created By : HCL IT Support Team
* Last Modified by: HCL IT Support Team
* Last Modified Date: 14 Feb 2020
* Description : Change garbage support ticket status to Invalid for EDU Ticketing Support Tickets
* Comments: This class is invoked in "EDUT - Processes" process
* Test Class: EDUT_MarkGarbageEDUTicketToInvalidTest
*****************************************/
public class EDUT_MarkGarbageEDUTicketToInvalid {
	@InvocableMethod
	public static void updateStatusInvalid(List<Id> caseIds) {
		List<Case> caseList = [Select Id,Status,Subject,SuppliedName from Case where Id IN:caseIds];
		List<String> invalidSubjects = System.Label.EDUT_Invalid_Subjects.Split(',');
		List<Case> casesListToUpdate = new List<Case>();
		if(!CaseList.isEmpty()){
			for(Case c: caseList){
	for(String i: invalidSubjects){
		if(c.Subject.Contains(i) || c.SuppliedName == 'HR Connections Americas Mailbox'){
			c.Status = 'Invalid';
			casesListToUpdate.add(c);
		}
	}
			}
		}
		Map<Id,Case> caseMap = new Map<Id,Case>();
 		caseMap.putall(casesListToUpdate);
 		if(caseMap.size() > 0){
			update caseMap.values();
		}
	}
}