public class DS_ProposalUtil {

	public static Integer limitRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
	public static Set<String> DSQuoteTypes = new Set<String>{CSWXGlobalConstant.Direct_DS, CSWXGlobalConstant.InDirect_DS};

	/**
	* @description This function retrieves the Account Id and Profile Name of the Logged In User
	* @return User containing Account Id and Profile Name related to the Logged In User
	*/
	public static User getCurrentUser() {
		return [SELECT AccountId, Profile.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
	}

	/**
	* @description This function collects all the needed Approval Stages from CSWXGlobalConstant
	* @return Set<String> The set of Approval Stages
	*/
	public static Set<String> loadApprovalStages() {
		Set<String> approvalStages = new Set<String>();
		approvalStages.add(CSWXGlobalConstant.Approval_stage_approved);
		approvalStages.add(CSWXGlobalConstant.Approval_stage_publishedInProgress);
		approvalStages.add(CSWXGlobalConstant.Approval_stage_publishedReady);
		approvalStages.add(CSWXGlobalConstant.Approval_stage_callofReady);
		approvalStages.add(CSWXGlobalConstant.Approval_stage_accepted);
		approvalStages.add(CSWXGlobalConstant.Approval_stage_rejected);
		approvalStages.add(CSWXGlobalConstant.Approval_stage_withdrawn);
		return approvalStages;
	}
}