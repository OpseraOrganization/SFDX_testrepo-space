public with sharing class InterfaceLogTriggerHandler{
	public static void afterupdate(List<Interface_Log__c> list_interface){
	System.debug('InterfaceLogTriggerHandler');
		List<Interface_Log__c> list_needupdate  = new List<Interface_Log__c>();
		List<ID> list_accountid = new list<ID>(); 

		//判断是否需要重新发送
		for (Interface_Log__c lg : list_interface) {
			if (lg.resend__c == true && lg.Interface_Type__c == 'Prospect Creation Interface' 
	) {
	list_needupdate.add(lg);
System.debug('list_needupdate====='+list_needupdate+'lg==='+lg);
			}
		}

		//解析interface__log name上的Account 
		if (list_needupdate.size()>0) {
			for (Interface_Log__c lg : list_needupdate) {
			String name = lg.Name;
			name= name.substring(name.length()-18,name.length());
			list_accountid.add(name);
System.debug('name===='+name+'list_accountid'+list_accountid);
			}
		}

		//获取需要重新发送的account，并重新提交http请求。
		if (list_accountid.size()>0) {
 System.debug('0000--------------------------');
			Resend_prospectCreationCallout.Resend_createbulkProspect(list_accountid); 
		}
	}
}