public with sharing class ViewQueueMemberController {
		public static String oId {get;set;}
		public List<User> queueMembers {get;set;}
	public ViewQueueMemberController() {
	}

	public ViewQueueMemberController(ApexPages.StandardController con){
		String queueId;
		oId = ApexPages.currentPage().getParameters().get('id');
		if(oId!=null){
				queueId = [SELECT Queue_Id__c FROM Opportunity WHERE Id=:oId][0].Queue_Id__c;
		}
		
		if(queueId == null){
				ApexPages.addMessage(
				  //new ApexPages.Message(ApexPages.Severity.INFO,'当前Opportunity没有分配G3 Facilitator Queue!'));
				  new ApexPages.Message(ApexPages.Severity.INFO,'There is no G3 Facilitator Queue in this Opportunity!'));
			return;
		}
		else{
				queueMembers = queryQueueMember(queueId);
		}
	}

		public static List<User> queryQueueMember(String Id){
				List<GroupMember> members = new List<GroupMember>();
				List<String> idList = new List<String>();
				members = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId=:Id];
				if(members.size()>0){
						for(GroupMember m: members){
								idList.add(m.UserOrGroupId);
						}
						List<user> groupmembers = [SELECT Id,Name,Email FROM User WHERE Id in:idList];
						return groupmembers;
				}
				else{
						ApexPages.addMessage(
				  //new ApexPages.Message(ApexPages.Severity.INFO,'当前G3 Facilitator Queue没有分配成员!'));
				  new ApexPages.Message(ApexPages.Severity.INFO,'There is no Member assign to the G3 Facilitator Queue in this Opportunity!'));
			return null;
				}
				
		}
		public static Pagereference cancel(){
			oId = ApexPages.currentPage().getParameters().get('id');
			Opportunity o = [SELECT Id FROM Opportunity WHERE Id=:oId][0];
			PageReference opptyPage = new ApexPages.StandardController(o).view();
			return opptyPage;
	}
}