public without sharing class PreApprovedProductsXAEController {
	public boolean hasAccess{get;set;}
	public boolean hasNotAccess{get;set;}
	public PreApprovedProductsXAEController(ApexPages.StandardController controller) {
		sTRING currentuserNaME=[Select Id,Name,Email,UserName from User where Id=:userinfo.getuserId()].UserName;
		List<PermissionSetAssignment> psas = [ select Id from PermissionSetAssignment where PermissionSetId IN ( select Id from PermissionSet where Name =: System.Label.Permission_Set_Access_Pre_Approved) and AssigneeId IN (select Id from User where UserName =:currentuserNaME ) ];
		system.debug('list size==>' +psas.size());
		if(psas.size()>0){
			hasAccess=true;
		   
			
		}else{
			hasNotAccess=true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You are not authorized to open this App'));
		}
	}
}