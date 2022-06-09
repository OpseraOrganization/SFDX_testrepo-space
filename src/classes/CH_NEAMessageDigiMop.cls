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
		String chatterpost = 'Failed to send Case Information to DigiMop using NG NAIP';
		String logName = 'Automatic Log Collection';
		String requestType = 'AutoLog Request';
		List<Case> caseNEAList = new List<Case>();
		Map<Id, String> userandNokiaIdMap = new Map<Id,String>();
		Map<Id, CH_AutomatedLogCollection__c> automatedLogCollectionMap = new Map<Id, CH_AutomatedLogCollection__c>();
		Map<Id, CH_ProductLogType__c> productLogTypeMap = new Map<Id, CH_ProductLogType__c>();
		Map<String,String> attachmentPriorityMap = CAPS_MultiFileUploadController.getAttachmentPriority();
		Set<Id> caseOwnerIdSet = New Set<Id>();
		Set<Id> caseAccountId = New Set<Id>();
		Set<Id> caseProductId = New Set<Id>();
		String Priority;
		caseNEAList = [SELECT Id, OwnerId, Severity__c, CH_Outage__c, Status, CaseNumber, CH_LawfullIntercept_CALEA__c, CH_Site__c, Product.Id, Product.ProductCode, Product.CH_Business_Group__c, Product.Name,Country__c, CH_NetworkElementAsset__r.Name, CH_NetworkElementAsset__r.CH_NetworkManagementSystemID__c, Account.Id, Account.AccountNumber, CH_Product_Release__c, CH_Product_Release__r.CH_NSNLegacyCode__c, CH_Product_Release__r.Name, Entitlement.ServiceContract.CH_CDB_CustomerId__c FROM Case WHERE Id IN :caseNEASet];
		for(Case cs:caseNEAList){
			caseOwnerIdSet.add(cs.OwnerId);
			caseAccountId.add(cs.Account.Id);
			caseProductId.add(cs.Product.Id);
		}
		if(!caseOwnerIdSet.isEmpty()){
			for(User us: [SELECT Id, Nokia_ID__c FROM User WHERE Id IN :caseOwnerIdSet]){
				userandNokiaIdMap.put(us.Id,us.Nokia_ID__c);
			}
		}
		if(!caseAccountId.isEmpty() && !caseProductId.isEmpty()){
			for(CH_AutomatedLogCollection__c alc : [SELECT Id, CH_AccountName__c, CH_AccountName__r.Id, CH_Product__c, CH_Product__r.Id FROM CH_AutomatedLogCollection__c WHERE CH_Status__c = TRUE AND CH_AccountName__r.Id IN :caseAccountId AND CH_Product__r.Id IN :caseProductId]){
				automatedLogCollectionMap.put(alc.Id, alc);
			}
		}
		if(!automatedLogCollectionMap.isEmpty()){
			for(CH_ProductLogType__c plt : [SELECT Id, CH_Category__c, CH_LogType__c, CH_AutoLogCollection__c, CH_Product__c, CH_Product__r.Id,CH_CollectorLogType__c FROM CH_ProductLogType__c WHERE CH_Status__c = TRUE AND CH_AutoLogCollection__c = TRUE AND CH_Product__r.Id IN :caseProductId]){
				productLogTypeMap.put(plt.CH_Product__c, plt);
			}
		}
		if(!productLogTypeMap.isEmpty()){
			
			for(CH_AutomatedLogCollection__c iterateALC : automatedLogCollectionMap.values()){
				if(productLogTypeMap.ContainsKey(iterateALC.CH_Product__r.Id)) {
					for(Case cs:caseNEAList){
						if(iterateALC.CH_Product__r.Id == cs.Product.Id && iterateALC.CH_AccountName__r.Id == cs.Account.Id){
							String priorityString = (cs.Severity__c+cs.CH_Outage__c+cs.Status).toLowerCase();
							Priority = (!attachmentPriorityMap.isEmpty() && attachmentPriorityMap.containsKey(priorityString))?attachmentPriorityMap.get(priorityString):System.Label.CAPS_Default_Priority;
							String ownerId = userandNokiaIdMap.containsKey(cs.OwnerId)?userandNokiaIdMap.get(cs.OwnerId):'';
							CH_ProductLogType__c pLogs = productLogTypeMap.get(cs.Product.Id);
							
							List<ProductLogType> logTypeList = New List<ProductLogType>();
							logcollection wrap = new logcollection();
							ProductLogType logTypes = new ProductLogType();
							logTypes.LogType = pLogs.CH_LogType__c!=NULL?pLogs.CH_LogType__c:'';
							logTypes.LogCategory = pLogs.CH_Category__c!=NULL?pLogs.CH_Category__c:'';
							logTypes.CollectorLogType = pLogs.CH_CollectorLogType__c!=NULL?pLogs.CH_CollectorLogType__c:'';
							logTypeList.add(logTypes);
							
							wrap.CaseNumber = cs.CaseNumber!=NULL?cs.CaseNumber:'';
							wrap.CaseId = cs.Id!=NULL?cs.Id:'';
							wrap.NokiaID = ownerId!=NULL?ownerId:'';
							wrap.BG = cs.Product.CH_Business_Group__c!=NULL?cs.Product.CH_Business_Group__c:'';
							wrap.ProductId = cs.Product.ProductCode!=NULL?cs.Product.ProductCode:'';
							wrap.ProductName = cs.Product.Name!=NULL?cs.Product.Name:'';
							wrap.ProductVersion = cs.CH_Product_Release__r.CH_NSNLegacyCode__c!=NULL?cs.CH_Product_Release__r.CH_NSNLegacyCode__c:'';
							wrap.ProductVersionName = cs.CH_Product_Release__r.Name!=NULL?cs.CH_Product_Release__r.Name:'';
							wrap.NetworkElementAsset = cs.CH_NetworkElementAsset__c!=NULL?cs.CH_NetworkElementAsset__r.Name:cs.CH_Site__c!=NULL?cs.CH_Site__c:'';
							wrap.Country = cs.Country__c!=NULL?cs.Country__c:'';
							wrap.Customer = cs.Entitlement.ServiceContract.CH_CDB_CustomerId__c!=NULL?cs.Entitlement.ServiceContract.CH_CDB_CustomerId__c:'';
							wrap.Ticketpriority = Priority!=NULL?Priority:'';
							wrap.AutoLogCollection = pLogs.CH_AutoLogCollection__c;
							wrap.NetworkManagementSystemId = cs.CH_NetworkElementAsset__r.CH_NetworkManagementSystemID__c!=NULL?cs.CH_NetworkElementAsset__r.CH_NetworkManagementSystemID__c:'';
							wrap.LawfulInterceptCALEA = cs.CH_LawfullIntercept_CALEA__c;
							wrap.Logs=logTypeList;
							
							logCollect.add(wrap);
						}
					}
				}
			}
			
			finalWrap.logCollection = logCollect;
			String jsontoSent = JSON.serialize(finalWrap, true);
			sendNGNAIPRequest(jsontoSent, caseNEASet,chatterpost,logName,requestType);
		}
	}
	/********************************************************************************
* Method Name : sendCaseToNDA
* Created Date:  15 Jun 2021
* Created By : TCS 
* Description : Collects the required information to send the request.
NOKIASC-35885
****************************************************************************************/
	public static void sendCaseToNDA(String ndaKey, Case oCase, String federationId){
		NdaWrapper ndaWrap = new NdaWrapper();
		String chatterPost = 'Failed to send Case Information to NDA using NG NAIP';
		String logName = 'NDA Case Creation Request';
		String requestType = 'NDA Case Creation';
		ndaWrap.NDAConversationId = ndaKey!=NULL?ndaKey:'';
		ndaWrap.CaseNumber = oCase.CaseNumber!=NULL?oCase.CaseNumber:'';
		ndaWrap.ProblemTitle= oCase.CH_CustomerDescription__c!=NULL?oCase.CH_CustomerDescription__c:'';
		ndaWrap.Subject = oCase.Subject!=NULL?oCase.Subject:'';
		ndaWrap.ProductId = oCase.product.ProductCode!=NULL?oCase.product.ProductCode:'';
		ndaWrap.ProductReleaseId = oCase.CH_Product_Release__r.CH_NSNLegacyCode__c!=NULL?oCase.CH_Product_Release__r.CH_NSNLegacyCode__c:'';
		ndaWrap.NetworkElementAsset= oCase.CH_NetworkElementAsset__r.Name!=NULL?oCase.CH_NetworkElementAsset__r.Name:'';
		ndaWrap.FederationId = federationId!=NULL?federationId:'';
		String requestToSent = JSON.serialize(ndaWrap, true);
		sendNGNAIPRequest(requestToSent,new Set<Id>{oCase.Id},chatterPost,logName,requestType);
	}
	/********************************************************************************
* Method Name : sendOneTouchLogInformation
* Created Date:  07 Jul 2021
* Created By : TCS 
* Description : Collects the required information to send the one touch log request.
NOKIASC-36825
****************************************************************************************/
	public static String sendOneTouchLogInformation(Id caseId, SObject selectedNEA, String manualNEA, List<CH_ProductLogType__c> selectedLogs){
		HTTP http = new HTTP();
		HTTPRequest req = new HTTPRequest();
		HTTPResponse res = new HTTPResponse();
		Interface_Log__c newInterfaceLog;
		List<FeedItem> chatterPostList = new List<FeedItem>();
		List<Interface_Log__c> logList = new List<Interface_Log__c>();
		List<logcollection> logCollect = new List<logcollection>();
		logcollection wrap = new logcollection();
		logCollectionWrapper finalWrap = new logCollectionWrapper();
		List<ProductLogType> logTypeList = New List<ProductLogType>();
		String chatterpost = 'Failed to send log collection request to DigiMop using NG NAIP';
		Map<String,String> attachmentPriorityMap = CAPS_MultiFileUploadController.getAttachmentPriority();
		String logName = 'Onetouchlog Collection Request';
		String Priority;
		String networkElementAssetId=NULL;
		Asset selectedAsset;
		if(selectedNEA!=NULL){
			selectedAsset = [SELECT Id, Name,CH_NetworkManagementSystemID__c from Asset WHERE Id =: selectedNEA.Id];
			networkElementAssetId = selectedAsset.Name;
		}else{
			networkElementAssetId = manualNEA;
		}
		Case oCase = [SELECT Id, OwnerId, CreatedById, CH_CustomerDescription__c, CH_LawfullIntercept_CALEA__c, Subject, Severity__c, CH_Outage__c, Status, CaseNumber, Product.Id, Product.ProductCode, Product.CH_Business_Group__c, Product.Name,Country__c, CH_NetworkElementAsset__r.Name, CH_NetworkElementAsset__r.CH_NetworkManagementSystemID__c, Account.Id, Account.AccountNumber, CH_Product_Release__c, CH_Product_Release__r.CH_NSNLegacyCode__c, CH_Product_Release__r.Name, Entitlement.ServiceContract.CH_CDB_CustomerId__c FROM Case WHERE Id =:caseId];
		User caseOwner = [SELECT Nokia_ID__c FROM User WHERE Id =: oCase.OwnerId];
		String priorityString = (oCase.Severity__c+oCase.CH_Outage__c+oCase.Status).toLowerCase();
		Priority = (!attachmentPriorityMap.isEmpty() && attachmentPriorityMap.containsKey(priorityString))?attachmentPriorityMap.get(priorityString):System.Label.CAPS_Default_Priority;
		wrap.CaseNumber = oCase.CaseNumber!=NULL?oCase.CaseNumber:'';
		wrap.CaseId = oCase.Id!=NULL?oCase.Id:'';
		wrap.NokiaID = caseOwner.Nokia_ID__c!=NULL?caseOwner.Nokia_ID__c:'';
		wrap.BG = oCase.Product.CH_Business_Group__c!=NULL?oCase.Product.CH_Business_Group__c:'';
		wrap.ProductId = oCase.Product.ProductCode!=NULL?oCase.Product.ProductCode:'';
		wrap.ProductName = oCase.Product.Name!=NULL?oCase.Product.Name:'';
		wrap.ProductVersion = oCase.CH_Product_Release__r.CH_NSNLegacyCode__c!=NULL?oCase.CH_Product_Release__r.CH_NSNLegacyCode__c:'';
		wrap.ProductVersionName = oCase.CH_Product_Release__r.Name!=NULL?oCase.CH_Product_Release__r.Name:'';
		wrap.NetworkElementAsset = networkElementAssetId!=NULL?networkElementAssetId:'';
		wrap.Country = oCase.Country__c!=NULL?oCase.Country__c:'';
		wrap.Customer = oCase.Entitlement.ServiceContract.CH_CDB_CustomerId__c!=NULL?oCase.Entitlement.ServiceContract.CH_CDB_CustomerId__c:'';
		wrap.Ticketpriority = Priority!=NULL?Priority:'';
		wrap.AutoLogCollection = false;//For one touch log collection this will always false
		wrap.NetworkManagementSystemId = selectedAsset!=NULL && selectedAsset.CH_NetworkManagementSystemID__c!=NULL?selectedAsset.CH_NetworkManagementSystemID__c:'';//oCase.CH_NetworkElementAsset__r.CH_NetworkManagementSystemID__c
		wrap.LawfulInterceptCALEA = oCase.CH_LawfullIntercept_CALEA__c;
		for(CH_ProductLogType__c pLogs:selectedLogs){
			ProductLogType logTypes = new ProductLogType();
			logTypes.LogType = pLogs.CH_LogType__c!=NULL?pLogs.CH_LogType__c:'';
			logTypes.LogCategory = pLogs.CH_Category__c!=NULL?pLogs.CH_Category__c:'';
			logTypes.CollectorLogType = pLogs.CH_CollectorLogType__c!=NULL?pLogs.CH_CollectorLogType__c:'';
			logTypeList.add(logTypes);
		}
		wrap.Logs=logTypeList;
		
		logCollect.add(wrap);
		finalWrap.logCollection = logCollect;
		String requestToSent = JSON.serialize(finalWrap, true);
		try{
			req.setEndpoint('callout:NG_NAIP');
			req.setHeader('Content-Type','application/json');
			req.setBody(requestToSent);
			req.setMethod('POST');
			req.setTimeout(120000);
			res = http.send(req);
			if(res!=null && res.getStatusCode()==200){
				newInterfaceLog = createOutboundLog(requestToSent,res.getStatus(),'Success',logName);
				logList.add(newInterfaceLog);
			}else{
				newInterfaceLog = createOutboundLog(requestToSent,res.getStatus(),'Failure',logName);
				logList.add(newInterfaceLog);
				FeedItem post = new FeedItem(ParentId = oCase.Id,Body = chatterPost);
				chatterPostList.add(post); 
			}
		}Catch(CalloutException Ex){
			newInterfaceLog = createOutboundLog(requestToSent,Ex.getMessage(),'Failure',logName);
			logList.add(newInterfaceLog);
			FeedItem post = new FeedItem(ParentId = oCase.Id,Body = chatterPost);
			chatterPostList.add(post);
			throw new AuraHandledException(Ex.getMessage());
		}Catch(Exception Ex){
			newInterfaceLog = createOutboundLog(requestToSent,Ex.getMessage(),'Failure',logName);
			logList.add(newInterfaceLog);
			FeedItem post = new FeedItem(ParentId = oCase.Id,Body = chatterPost);
			chatterPostList.add(post);
			throw new AuraHandledException(Ex.getMessage());
		}
		Database.insert(logList,false);
		Database.insert(chatterPostList,false);
		return String.ValueOf(res.getStatusCode());
	}
	/********************************************************************************
* Method Name : sendNGNAIPRequest
* Created Date:  23 Sept 2020
* Created By : TCS 
* Description : Invokes Rest API to NG NAIP.
NOKIASC-31310
****************************************************************************************/
	@future(callout=true)
	public static void sendNGNAIPRequest(String requestString, Set<Id> caseIds, String chatterPost, String logName, String requestType){
		Interface_Log__c newInterfaceLog;
		List<Interface_Log__c> logList = new List<Interface_Log__c>();
		List<FeedItem> chatterPostList = new List<FeedItem>();
		HTTP http = new HTTP();
		HTTPRequest req = new HTTPRequest();
		HTTPResponse res = new HTTPResponse();
		try{
			if(requestType == 'AutoLog Request'){
			  req.setEndpoint('callout:NG_NAIP');  
			}
			else if(requestType == 'NDA Case Creation'){
			  req.setEndpoint('callout:NDA_Case_Creation');  
			}
			req.setHeader('Content-Type','application/json');
			req.setBody(requestString);
			req.setMethod('POST');
			req.setTimeout(120000);
			res = http.send(req);
			if(res!=null && res.getStatusCode()==200){
				newInterfaceLog = createOutboundLog(requestString,res.getStatus(),'Success',logName);
				logList.add(newInterfaceLog);
			}else{
				newInterfaceLog = createOutboundLog(requestString,res.getStatus(),'Failure',logName);
				logList.add(newInterfaceLog);
				for(Id caseId:caseIds){
					FeedItem post = new FeedItem(ParentId = caseId,Body = chatterPost);
					chatterPostList.add(post); 
				}
			}
		}Catch(CalloutException Ex){
			newInterfaceLog = createOutboundLog(requestString,Ex.getMessage(),'Failure',logName);
			logList.add(newInterfaceLog);
		}Catch(Exception Ex){
			newInterfaceLog = createOutboundLog(requestString,Ex.getMessage(),'Failure',logName);
			logList.add(newInterfaceLog);
		}
		Database.insert(logList,false);
		Database.insert(chatterPostList,false);
	}
	/********************************************************************************
* Method Name : createOutboundLog
* Created Date:  23 Sept 2020
* Created By : TCS 
* Description : creates Interface_Log__c record for successful and failure comunications.
NOKIASC-31310
****************************************************************************************/
	public static Interface_Log__c createOutboundLog(String requestSent, String responseMessage, String Status, String logName){
		Interface_Log__c iLog = new Interface_Log__c();
		iLog.Name = logName;
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
		Boolean AutoLogCollection;
		String NetworkManagementSystemId;
		Boolean LawfulInterceptCALEA;
		List<ProductLogType> Logs;
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
	/********************************************************************************
* class Name : ProductLogType
* Created Date:  15 Jun 2021
* Created By : TCS 
* Description : inner class used to construct the JSON.
NOKIASC-35927
****************************************************************************************/
	public class ProductLogType{
		String LogType;
		String LogCategory;
		Boolean AutoLogCollection;
		String CollectorLogType;
	}
	/********************************************************************************
* class Name : NdaWrapper
* Created Date:  15 Jun 2021
* Created By : TCS 
* Description : inner class used to construct the JSON for NDA log collection.
NOKIASC-35885
****************************************************************************************/
	public class NdaWrapper{
		String NDAConversationId;
		String CaseNumber;
		String ProblemTitle;
		String Subject;
		String ProductId;
		String ProductReleaseId;
		String NetworkElementAsset;
		String FederationId;
	}
}