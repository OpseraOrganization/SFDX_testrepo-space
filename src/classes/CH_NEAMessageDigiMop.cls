/********************************************************************************
* Class Name : CH_NEAMessageDigiMop
* Created Date:  23 Sept 2020
* Created By : TCS - Gourisankar Patra
* Last Modified by: TCS Gourisankar Patra
* Last Modified Date: 23 Sept 2020
* Description : Invoke Rest API to pass message to DigiMop.
	Its called from CH_caseTriggerHelper - checkCriteriaForNGNAIPMessage ()
	US: 31109
* Test Class: CH_NEAMessageDigiMop_Test
****************************************************************************************/
public without sharing class CH_NEAMessageDigiMop {
	
	public static void invokeNGNAIP(Set<Id> caseNEASet)
	{
		List<logcollection> logCollect = new List<logcollection>();
		logCollectionWrapper finalWrap = new logCollectionWrapper();
		List<Case> caseNEAList = new List<Case>();
		Map<Id, String> userandNokiaIdMap = new Map<Id,String>();
		Map<String,String> attachmentPriorityMap = new Map<String,String>();
		Set<Id> caseOwnerIdSet = New Set<Id>();
		String Priority;
		caseNEAList = [SELECT Id, OwnerId,Severity__c,CH_Outage__c,Status,CaseNumber,Product.ProductCode,Product.CH_Business_Group__c,Product.Name,Country__c,CH_NetworkElementAsset__r.Name,Account.AccountNumber,CH_Product_Release__c,CH_Product_Release__r.CH_NSNLegacyCode__c,CH_Product_Release__r.Name, Entitlement.ServiceContract.CH_CDB_CustomerId__c from Case WHERE Id IN:caseNEASet];
		for(Case cs:caseNEAList){
			caseOwnerIdSet.add(cs.OwnerId);
		}
		if(!caseOwnerIdSet.isEmpty()){
			for(User us: [SELECT Id, Nokia_ID__c from User WHERE ID IN:caseOwnerIdSet]){
				userandNokiaIdMap.put(us.Id,us.Nokia_ID__c);
			}
		}
		attachmentPriorityMap = CAPS_MultiFileUploadController.getAttachmentPriority();
		for(Case cs:caseNEAList){
			String priorityString = (cs.Severity__c+cs.CH_Outage__c+cs.Status).toLowerCase();
			Priority = (!attachmentPriorityMap.isEmpty() && attachmentPriorityMap.containsKey(priorityString))?attachmentPriorityMap.get(priorityString):System.Label.CAPS_Default_Priority;
			String ownerId = userandNokiaIdMap.containsKey(cs.OwnerId)?userandNokiaIdMap.get(cs.OwnerId):'';
			logcollection wrap = new logcollection();
			wrap.CaseNumber = cs.CaseNumber;
			wrap.CaseId = cs.Id;
			wrap.NokiaID = ownerId;
			wrap.BG = cs.Product.CH_Business_Group__c;
			wrap.ProductId = cs.Product.ProductCode;
			wrap.ProductName = cs.Product.Name;
			wrap.ProductVersion = cs.CH_Product_Release__r.CH_NSNLegacyCode__c;
			wrap.ProductVersionName = cs.CH_Product_Release__r.Name;
			wrap.NetworkElementAsset = cs.CH_NetworkElementAsset__r.Name;
			wrap.Country = cs.Country__c;
			wrap.Customer = cs.Entitlement.ServiceContract.CH_CDB_CustomerId__c;
			wrap.Ticketpriority = Priority;
			logCollect.add(wrap);
		}
		finalWrap.logCollection = logCollect;
		String jsontoSent = JSON.serialize(finalWrap,true);
		system.debug('Here introduce logic ===  '+jsontoSent);
		sendLogCollectionRequest(jsontoSent,caseNEASet);
	}
	/********************************************************************************
	* Method Name : sendLogCollectionRequest
	* Created Date:  23 Sept 2020
	* Created By : TCS 
	* Description : Invokes Rest API to NG NAIP.
					NOKIASC-31310
	****************************************************************************************/
	@future(callout=true)
	public static void sendLogCollectionRequest(String jsonString, Set<Id> caseIds){
		Interface_Log__c newInterfaceLog;
		List<Interface_Log__c> logList = new List<Interface_Log__c>();
		List<FeedItem> chatterPostList = new List<FeedItem>();
		HTTP http = new HTTP();
		HTTPRequest req = new HTTPRequest();
		HTTPResponse res = new HTTPResponse();
		try{
			req.setEndpoint('callout:NG_NAIP');
			req.setHeader('Content-Type','application/json');
			req.setBody(jsonString);
			req.setMethod('POST');
			req.setTimeout(12000);
			res = http.send(req);
			system.debug('response staus ===  '+res.getStatusCode());
			if(res!=null && res.getStatusCode()==200){
				newInterfaceLog = createOutboundLog(jsonString,res.getStatus(),'Success');
				logList.add(newInterfaceLog);
			}else{
				newInterfaceLog = createOutboundLog(jsonString,res.getStatus(),'Failure');
				logList.add(newInterfaceLog);
				for(Id caseId:caseIds){
					FeedItem post = new FeedItem();
					post.ParentId = caseId; 
					post.Body = 'Failed to send log collection request to NG NAIP';
					chatterPostList.add(post); 
				}
			}
			system.debug('chatter feed list ===  '+chatterPostList);
			system.debug('log list ===  '+logList);
			Database.insert(chatterPostList,true);
			Database.insert(logList,true);
		}catch(Exception Ex){
			System.debug('exception occured' +Ex.getMessage());
		}		 
	}
	/********************************************************************************
	* Method Name : createOutboundLog
	* Created Date:  23 Sept 2020
	* Created By : TCS 
	* Description : creates Interface_Log__c record for successful and failure comunications.
					NOKIASC-31310
	****************************************************************************************/
	public static Interface_Log__c createOutboundLog(String requestSent, String responseMessage, String Status){
		Interface_Log__c iLog = new Interface_Log__c();
		iLog.Name = 'Automatic Log Collection';
		iLog.Interface_Request_Sent__c = requestSent;
		iLog.Comment__c = responseMessage;
		iLog.Status__c = Status;
		iLog.Message_Type__c = 'Outbound';
	
		return iLog;
	}
	/********************************************************************************
	* class Name : logcollection
	* Created Date:  23 Sept 2020
	* Created By : TCS 
	* Description : inner class used to construct the JSON.
					NOKIASC-31310
	****************************************************************************************/
	Public class logcollection
	{
		String CaseNumber;
		String CaseId;
		String NokiaID;
		String BG;
		String ProductId;
		String ProductName;
		String ProductVersion;
		String ProductVersionName;
		String NetworkElementAsset;
		String Country;
		String Customer;
		String Ticketpriority;
	}
	/********************************************************************************
	* class Name : logCollectionWrapper
	* Created Date:  23 Sept 2020
	* Created By : TCS 
	* Description : inner class used to construct the JSON.
					NOKIASC-31310
	****************************************************************************************/
	public class logCollectionWrapper{
		public List<logcollection> logCollection;
	}
}