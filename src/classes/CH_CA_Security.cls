public without sharing class CH_CA_Security {
	// Get valid workgroup members with matching security group as that of case
	public List<CH_CA_DTO.WorkgroupMemberDTO> checkWGMembersSecurity(Case currentCase, List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMemberDTO){
		List<CH_CA_DTO.WorkgroupMemberDTO> authorizedWorkgroupMembers = new List<CH_CA_DTO.WorkgroupMemberDTO>();
		if (workgroupMemberDTO.size() == 0){
			System.debug('CH_CA: Security approved for 0 of the ' + workgroupMemberDTO.size() + ' workgroup members');
			return authorizedWorkgroupMembers;
		}
		
		// Get the sec groups based on the case fields
		Set<Id> groupIds = new Set<Id>();
		// Changes added for 29404
		List<Id> getMemberIds=new  List<Id>();
		for (CH_CA_DTO.WorkgroupMemberDTO workGpMember : workgroupMemberDTO){
			{
	getMemberIds.add(workGpMember.userId);
			}
		}
		List<Group> lstPublicGroup = [SELECT Id FROM Group WHERE Name=:currentCase.CH_GWC_SecurityGroup__c OR Name=:currentCase.CH_SecurityGroup__c OR Name=:currentCase.CH_3rdPartySecurityGroup__c ];
		for (Group grp : lstPublicGroup){
			groupIds.add(grp.Id);
		}
		
		// Get all members of the found sec groups
		List<GroupMember> lstGroupMember = [SELECT Id, UserOrGroupId FROM GroupMember 
					WHERE GroupId IN:groupIds AND UserOrGroupId IN :getMemberIds];
		system.debug('CH_CA: Records returned for Group Members : '+lstGroupMember.Size());
		Set<Id> groupMemberIds = new Set<Id>();
		for (GroupMember grpM : lstGroupMember){
			groupMemberIds.add(grpM.UserOrGroupId);
		}

		for (CH_CA_DTO.WorkgroupMemberDTO workGMember : workgroupMemberDTO){
			if(groupMemberIds.contains(workGMember.userId)){
	authorizedWorkgroupMembers.add(workGMember);
			}
		}
		System.debug('CH_CA: Security approved for ' + authorizedWorkgroupMembers.size() + ' of the ' + workgroupMemberDTO.size() + ' workgroup members');
		return authorizedWorkgroupMembers;
	}

	// At the moment there are 3 workgroup member types. User, Queue and Hotline
	// User and Queues(Users) are assigned to security groups.
	// Hotlines are not but they still need to be added to result.	
	public List<CH_CA_DTO.WorkgroupMemberDTO> getSpecialWorkgroupMembers(List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMemberDTO){
		List<CH_CA_DTO.WorkgroupMemberDTO> specialWorkgroupMembers = new List<CH_CA_DTO.WorkgroupMemberDTO>();
		for (CH_CA_DTO.WorkgroupMemberDTO workGMember : workgroupMemberDTO){
			if (workGMember.type == 'Hotline'){
	specialWorkgroupMembers.add(workGMember);
			}
		}
		System.debug('CH_CA: Special WorkgroupMembers for ' + specialWorkgroupMembers.size() + ' of ' + workgroupMemberDTO.size() + ' workgroup members');
		return specialWorkgroupMembers;
	}
	
	// Validate Add Case Team Member 
	// Based on validation Member Will add to case team
	public boolean IsCaseUpdatable(Case currentCase,String userId)
	{
		String workgroupId  =currentCase.CH_Workgroup__c;
		Id loginUserId =Userinfo.getUserId(); 
		boolean returnValue = false ;	 
		List<CH_CA_DTO.WorkgroupMemberDTO> isAuthorizedMember=checkWGMembersSecurity(currentCase,getWorkgroupMemberDetails(userId, workgroupId));
		if (isAuthorizedMember.size()==0){
			AuraHandledException auraExp = new AuraHandledException('');
			auraExp.setMessage('This user does not have the right security permission to be added to the case team.');	
			throw auraExp;
		} 
		//Check if login user is Case Owner			
		System.debug('CH_CA: OwnerId - '+ currentCase.OwnerId +' - loginID - '+ loginUserId);	
		if (currentCase.OwnerId ==loginUserID){	
			return true;
		} 
		//Check if login user is in valid Security group 
		List<GroupMember> grpNameList   = [select Group.Name from groupmember where userorgroupid = :loginUserId ];
		for (GroupMember grpName : grpNameList){	 
			system.debug('CH_CA: Group Name'+ grpName.Group.Name);
			if (grpName.Group.Name =='SEC_GWC|ALL' || grpName.Group.Name =='SEC_GWC|NSB'){
	return true;
			}
		}
		
		//Check if login user is a part of Case Team
		Integer caseTeamMembercount= [SELECT count()
			  FROM CaseTeamMember 
			  WHERE ParentId =: currentCase.Id AND MemberId= : loginUserID limit 1 ];
		if (caseTeamMemberCount == 0 && userId!=loginUserID ){	 
			AuraHandledException auraExp = new AuraHandledException('');
			auraExp.setMessage('Login User is not part of the Case Team and cannot add others to the Case Team.');	
			throw auraExp;		  
		}
		if(caseTeamMemberCount > 0 && userId!=loginUserID ){	
					return true;
			}
		//Check workgroup assignment for currentcase
		if (String.isBlank(workgroupId)){		
			AuraHandledException auraExp = new AuraHandledException('');
			auraExp.setMessage('You are not part of the workgroup and cannot be added to the case team.');	
			throw auraExp;
		}					
		else{
			Integer  workgroupMemberCount= [SELECT count() FROM CH_Workgroup_Member__c where CH_User__c=:loginUserID and CH_Workgroup__c=:workgroupId ];
			if (workgroupMemberCount==0){	
	CH_Workgroup__c workgroup = [SELECT CH_Workgroup_Instructions__c, Name 
			FROM CH_Workgroup__c 
			WHERE Id =:workgroupId LIMIT 1];				
	String workGroupName =workgroup.Name;				
	AuraHandledException auraExp = new AuraHandledException('');
	auraExp.setMessage('You are not part of the workgroup '+ workGroupName +' and cannot be added to the case team.');	
	throw auraExp;
			}	
		}	
		
		
		
		
		return returnValue;	
	}
	// Get members Details add to the case team
	private List<CH_CA_DTO.WorkgroupMemberDTO> getWorkgroupMemberDetails(String userId, Id workgroupId){	 
		List<CH_CA_DTO.WorkgroupMemberDTO> caseTeamMembersDTO = new List<CH_CA_DTO.WorkgroupMemberDTO>();		
		CH_CA_DTO.WorkgroupMemberDTO caseTeamMemberDTO = new CH_CA_DTO.WorkgroupMemberDTO();
		caseTeamMemberDTO.userId = userId;
		caseTeamMembersDTO.add(caseTeamMemberDTO);
		system.debug('CH_CA: CaseTeam Members Details found ' + caseTeamMembersDTO.size());
		return caseTeamMembersDTO;
	}
   
}