@isTest(seealldata=true)
public class SIP_getWrapData_Test
{
    public static testmethod void WrapperMethod()
	{
        test.startTest();
        
		Profile ProfRec = [select name from Profile where name = 'D&S Sales API User'];
		User userRec = new User(LastName = 'Test User',Username = 'testuser@test3.com.honeywell',Email = 'testuser@test.com',Alias = 't3user' ,CommunityNickname= 't3user' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = ProfRec.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testrole');
		insert userRec;
      
		SIP_Tickets__c sipObj = new SIP_Tickets__c(Reason_for_Request__c = 'Requesting Xactly Access',Ticket_on_behalf_of__c=userRec.id);
		insert sipObj;
		ApexPages.StandardController sc = new ApexPages.StandardController(sipObj);
		SIP_getWrapData controller = new SIP_getWrapData(sc);
		// SIP_getWrapData s = new SIP_getWrapData();
		SIP_getWrapData.wrapperclass w = new SIP_getWrapData.wrapperclass();
		//if(w.RecordObject  == 'SIP_Tickets'){
		set<id> targetid=new set<id>();
		map<id,SIP_Tickets__c> sipticket=new map<id,SIP_Tickets__c>();
		ProcessInstance pi = new ProcessInstance();
		ProcessInstanceHistory pih = new ProcessInstanceHistory();
		user u = new user();
		if(pi.TargetObjectId == 'SIP_Tickets')
		targetid.add(pi.TargetObjectId);
		for(SIP_Tickets__c obj:[select id,Ticket_on_behalf_of__c,Ticket_on_behalf_of__r.name,createddate from SIP_Tickets__c where id =:targetid])
		{
		sipticket.put(obj.id,obj);
		} 
		w.Status = 'Pending';
		w.RecordName = String.valueOf(pi.TargetObject.Name);
		w.RecordId = String.valueOf(pi.TargetObjectId); 
		w.RecordObject = 'SIP_Tickets'; 
		w.AssignedToName = String.valueOf(pih.OriginalActor.Name);
		w.ApproverName = pih.Actor.Name;
		w.CreatedDate = String.valueOf(pih.CreatedDate);                                     
		w.TicketonBehalfof= u.id;
		w.sipCreatedDate= '10/10/2017';
		// insert w;
		List<SIP_getWrapData.wrapperclass> wrapList = controller.getWrapList();
		//new List<SIP_getWrapData.wrapperclass.wrapperclass>(); 
		// wrapList.add(w);
		//  }
		//SIP_getWrapData sip = new SIP_getWrapData();
		//wrapList = sip.getWrapList();
   
        test.stopTest();

    }
}