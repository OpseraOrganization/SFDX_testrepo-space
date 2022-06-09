public class CH_ProductProblemCreationController_COE {
	
	public static String getRecordProblemTypeID(){
		string  recordTypeIdCaseProblem = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Problem').getRecordTypeId();
		return recordTypeIdCaseProblem;
	}
	@Auraenabled
	public static string validatePermissionSet(){
		//profile oProfile = [select id , name from profile  where name ='System Administrator'];
		// Updated the Query to add OR condition with CH_Engineer permission set for NOKIASC-27183 to allow Engineer to create Problem from Product
		List<PermissionSetAssignment> lstcurrentUserPerSet =	[SELECT Id, PermissionSet.Name,AssigneeId
				 FROM PermissionSetAssignment
				 WHERE AssigneeId = :Userinfo.getUserId() 
				 and (PermissionSet.Name ='CH_Expert' OR PermissionSet.Name ='CH_Engineer') ];
		if(userinfo.getProfileId() == CH_Integration_Profiles__c.getInstance('System Administrator').CH_ProfileId__c ||( !lstcurrentUserPerSet.isempty() && lstcurrentUserPerSet.size() >0)){
			return getRecordProblemTypeID(); 
		}
		return null;
	} 
	@Auraenabled
	public static string getProductDataUsageForStandAloneProblem(String productId){
		set<id> pid = new set<id>();
		pid.add(productId);
		map<string, string> productDataUsageMap = getProductDataUsage(pid);
		string dataUsage = productDataUsageMap.get(productId);
		return dataUsage;
	}
	public static map<string, string> getProductDataUsage(set<Id> productId){
		map<string, string> productDataUsageMap = new map<string, string> ();
		for(Product2 productQuery : [select id, name, DataUsage__c from product2 where id in : productId]){
			if(productQuery!=null && productQuery.DataUsage__c !=null && productQuery.DataUsage__c !=''){
	String[] splitDataUsageString = productQuery.DataUsage__c.toUppercase().split(' ');
	String productDataUsage = null;
	for(string duStr : splitDataUsageString){
		if((productDataUsage == null ||  productDataUsage == 'Other' ) && duStr.contains('JIRA')){
			productDataUsage = 'JIRA';
		}else if((productDataUsage == null ||  productDataUsage == 'Other' )  && duStr.contains('PRONTO')){
			productDataUsage = 'PRONTO';
		}else if(productDataUsage == null){
			productDataUsage = 'Other';
		}
	}
	 productDataUsageMap.put(productQuery.Id, productDataUsage);
			}else{
	productDataUsageMap.put(productQuery.Id, 'Other');
			}
			
		}
		return productDataUsageMap;
	}
/*   Code Commented as part of Code Optimization US# 27621
	@AuraEnabled
	public static Case updateWorkGroupOnProblem(Id problemId){  //Method to be commented as not being used now
		// Get all passive workgroup members that can be assigned to the problem 
		CH_CA_Service service = new CH_CA_Service(problemId);
		Case problemRecord = [Select Id,OwnerId from Case where Id =: problemId];
		List<CH_CA_DTO.WorkgroupMemberDTO> foundWorkgroupMembers = service.getPassiveCaseAssignmentWorkgroupMembers();
		Id oldOwnerId = problemRecord.OwnerId;
		////Added as part of Code Optimization US 27621
		Set<Id> WgmIds = new Set<Id>();
		for(CH_CA_DTO.WorkgroupMemberDTO workgroupMember : foundWorkgroupMembers)
		{
			if (workgroupMember.type == 'Queue'){
	   WgmIds.add(workgroupMember.Id);		  
			}
		}
	 Map<id,CH_Workgroup_Member__c> assignments = new Map<id,CH_Workgroup_Member__c>();
		if(!WgmIds.isEmpty())
		{
			for (CH_Workgroup_Member__c workgroupMember : ([SELECT Id, CH_Workgroup__c, CH_User__c, Name, 
		CH_Workgroup_Member_Type__c, CH_Queue_Email__c,CH_Workgroup__r.Name
			 FROM CH_Workgroup_Member__c WHERE Id IN :WgmIds])){
			CH_Workgroup_Member__c validWorkgroupMember=workgroupMember;   
					  assignments.put(problemRecord.Id, validWorkgroupMember);	  
	}
		}
		if(!assignments.isEmpty())
		{
			service.assignUser(assignments);
		}
		// Code to log a message when no queue was found. 
		Id newOwnerId = problemRecord.OwnerId;
		if (oldOwnerId == newOwnerId){
		system.debug('CH_CA: No Queue found to Assign the problem to. Problem assigned to creator: ' + problemRecord.OwnerId);	
		}
		return problemRecord;
	}   */
}