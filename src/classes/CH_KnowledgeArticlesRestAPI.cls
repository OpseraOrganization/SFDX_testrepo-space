/****************************************
* Class Name : CH_KnowledgeArticlesRestAPI 
* Created Date: 17 July 2020
* Created By : TCS
* Description : To make custom rest API call for Knowledge Articles
************/
@RestResource(urlMapping='/api/KnowledgeArticle/*')
global without sharing class CH_KnowledgeArticlesRestAPI {
	public static String type { get; set;}
	@HttpGet
	global static List<KnowledgeArticleWrapper> doGet() {
		System.debug('PROFILE:'+userinfo.getProfileId());
		RestRequest request = RestContext.request;			
		String fedId = request.params.get('FederationId');
		String searchText = request.params.get('SearchText'); 
		String lastModDate = request.params.get('LastModifiedDate'); 
		String productCode = request.params.get('ProductCode');
		String productRelease = request.params.get('ProductRelease');
		String category = request.params.get('Category');
		Url baseUrl = URL.getSalesforceBaseUrl();  
		String url = String.valueOf(baseUrl);
		String lang = 'en_US';
		Set<Id> kaIdSet = new Set<Id>();
		Boolean recordTypeCheck = true;
		String publishStatus = 'Online';
		String validationStatus = 'External Approved';
		List<List<sObject>> kaList = new List<List<sObject>>();
		Datetime lastModifiedDate;
		Integer size;
		List<KnowledgeArticleWrapper> wrap = new List<KnowledgeArticleWrapper>();
		if(lastModDate != null){
			if(lastModDate == 'Today')
				lastModifiedDate = Date.today();
			else 
				lastModifiedDate = Datetime.valueOf(lastModDate.replace('T',' '));
		}
		if(request.params.get('Size') != null)
			size = Integer.valueOf(request.params.get('Size'));		 
		String prodRel;
		System.debug('articleNumber ID:'+fedId+'searchText:'+searchText+'URL:'+String.valueOf(baseUrl));//FI1234567
		if (productCode != null || productRelease != null){ 
			 prodRel = 'SELECT CH_Parent_Product__r.Id, CH_Parent_Product__r.Name, CH_Parent_Release__r.Name, CH_Knowledge__r.Id, CH_Knowledge__r.ArticleNumber, CH_Knowledge__r.Title FROM CH_ProductRelation__c';
		
			if(productCode != null && productRelease != null){
				prodRel = prodRel + ' WHERE CH_Parent_Product__r.ProductCode LIKE :productCode and CH_Parent_Release__r.Name LIKE :productRelease';
			}else if(productCode != null && productRelease == null){
				prodRel = prodRel +' WHERE CH_Parent_Product__r.ProductCode LIKE :productCode';
			}else if(productCode == null && productRelease != null){
				prodRel = prodRel +' WHERE CH_Parent_Release__r.Name LIKE :productRelease';
			}	 
			List<CH_ProductRelation__c> prList1 = Database.query(prodRel);
			for(CH_ProductRelation__c pr : prList1){
				kaIdSet.add(pr.CH_Knowledge__r.Id);
			}
		}
		
		if(url.contains('partners')){
			System.debug('CUSTOMERS');  
			type = 'Customers';
			if(productCode != null){
				try{
					User u = [SELECT ContactId FROM User WHERE id=:UserInfo.getUserId()];
					List<ContractLineItem> cliList = [SELECT ServiceContract.id FROM ContractLineItem WHERE ServiceContract.RecordType.DeveloperName = 'CH_ServiceContract' and ServiceContract.NCP_External_Status__c = 'Active' and Product2.ProductCode = :productCode];
					Set<Id> scIdSet = new Set<Id>(); 
					for(ContractLineItem c : cliList){
						scIdSet.add(c.ServiceContract.Id);
					}
					List<EntitlementContact> entCont = [select Id FROM EntitlementContact where Entitlement.ServiceContract.RecordType.DeveloperName = 'CH_ServiceContract' and Entitlement.ServiceContract.NCP_External_Status__c = 'Active' and contact.id = :u.ContactId and Entitlement.ServiceContract.id in:scIdSet];							
					String query;
					if(entCont.size() > 0){
						query = 'FIND \'' + searchText + '\' IN ALL FIELDS returning Knowledge__kav';
						query = query +'(ArticleNumber,PublishStatus,CreatedDate,LastModifiedDate,Title,UrlName';
						query = query + ',CH_Solution__c,CH_WorkAround__c,CH_QuestionOrProductDescription__c,CH_ProcedureRequired__c,CH_PurposeRequired__c';						
						query = query +' where CH_KnowledgeRecordTypeCheck__c=:recordTypeCheck AND language=:lang AND ValidationStatus =:validationStatus';
						if(lastModifiedDate != null){
							query = query + ' AND LastModifiedDate > :lastModifiedDate';
						}
						if(productCode != null){
							query = query + ' AND Id IN:kaIdSet';
						}
						query = query + '  AND PublishStatus = :publishStatus ORDER BY LastModifiedDate DESC)';
						if(size != null){
							query = query + ' LIMIT :size';
						}						
						kaList=search.query(query); 
						List<Knowledge__kav> newList = (List<Knowledge__kav>)kaList[0];
						for(Knowledge__kav record : newList)
						{									
							wrap.add(new KnowledgeArticleWrapper(record,new List<Product2>(),new List<CH_ProductRelease__c>(),type));
						} 
					}
				}
				catch(exception e){
					System.debug('EXCEPTION:'+e.getMessage());
				}
			}			
			return wrap;	 
		}
		else{
			System.debug('FOR INTERNAL USERS'+url);
			List<String> sourceList = new List<String>{'Internal','PSP'};
			type = 'Internal';
			String query = 'FIND \'' + searchText + '\' IN ALL FIELDS returning Knowledge__kav';
			query = query +'(ArticleNumber,Source__c,PublishStatus,CreatedDate,LastModifiedDate,Title,UrlName,CH_Category__c,CH_ProductId__r.ProductCode,CH_ProductId__r.Name,';
			query = query +'CH_Solution__c,CH_WorkAround__c,CH_QuestionOrProductDescription__c,CH_ProcedureRequired__c,CH_PurposeRequired__c,CH_Product_Release_1_1__c';
			query = query + ' where CH_KnowledgeRecordTypeCheck__c=:recordTypeCheck';
			query = query + ' AND Source__c IN :sourceList';
			
			if(productCode != null){				
				query = query + ' AND Id IN:kaIdSet';					
			}
			if(lastModifiedDate != null){
				query = query + ' AND LastModifiedDate > :lastModifiedDate';
			}
			if(category != null){
				query = query + ' AND CH_Category__c = :category';
			}
			query = query + ' AND language=:lang AND PublishStatus = :publishStatus ORDER BY LastModifiedDate DESC)';
			if(size != null){
				query = query + ' LIMIT :size';
			}
			kaList=search.query(query); 
			List<sObject> kavList = new List<sObject>();
			Set<Id> knowIdSet = new Set<Id>();
			List<String> ls = new List<String>();
			List<Knowledge__kav> newList = (List<Knowledge__kav>)kaList[0];
			for(Knowledge__kav record : newList)
			{					
				knowIdSet.add(record.Id);				
			}			   
			List<CH_ProductRelation__c> prList = [SELECT CH_Knowledge__c,
												  CH_Parent_Product__r.ProductCode,CH_Parent_Product__r.Name,CH_Parent_Release__r.Name FROM CH_ProductRelation__c WHERE CH_Knowledge__r.Id IN :knowIdSet];
			Map<Id,List<Product2>> kaIdPRMap = new Map<Id,List<Product2>>();
			Map<Id,List<CH_ProductRelease__c>> kaIdProductRelMap = new Map<Id,List<CH_ProductRelease__c>>();
			for(CH_ProductRelation__c pr : prList){
				if(pr.CH_Parent_Product__c != null){
					if(kaIdPRMap.containsKey(pr.CH_Knowledge__c)){
						List<Product2> proList = kaIdPRMap.get(pr.CH_Knowledge__c);
						proList.add(pr.CH_Parent_Product__r);			   
						kaIdPRMap.put(pr.CH_Knowledge__c,proList);
					}else{
						List<Product2> pl = new List<Product2>();
						pl.add(pr.CH_Parent_Product__r);				
						kaIdPRMap.put(pr.CH_Knowledge__c,pl );
					}
				}
				if(pr.CH_Parent_Release__c != null){
					if(kaIdProductRelMap.containsKey(pr.CH_Knowledge__c)){
						List<CH_ProductRelease__c> proRelList = kaIdProductRelMap.get(pr.CH_Knowledge__c);
						proRelList.add(pr.CH_Parent_Release__r);				
						kaIdProductRelMap.put(pr.CH_Knowledge__c,proRelList);
					}else{
						List<CH_ProductRelease__c> proReleaseList = new List<CH_ProductRelease__c>();
						proReleaseList.add(pr.CH_Parent_Release__r);				
						kaIdProductRelMap.put(pr.CH_Knowledge__c,proReleaseList);
					}			   
				}				
			}
			for(Knowledge__kav record : newList)
			{									
				kavList.add(record);				
				wrap.add(new KnowledgeArticleWrapper(record,kaIdPRMap.get(record.Id),kaIdProductRelMap.get(record.Id),type));
			}			
			return wrap;
		}
	}
	
	global Class KnowledgeArticleWrapper{		
		String ArticleNumber {get; set;}
		String PublishStatus {get; set;}
		Datetime CreatedDate {get; set;}
		Datetime LastModifiedDate {get; set;}
		String Title {get; set;}
		String ArticleURL {get; set;}
		String Solution {get; set;}
		String Workaround {get; set;}
		String Question {get; set;}
		String Procedure {get; set;}
		String Purpose {get; set;}
		String Source {get; set;}
		String Category {get; set;}
		String Id {get; set;}
		List<Product2> Product {get; set;}
		List<CH_ProductRelease__c> ProductRelease {get; set;}
		public KnowledgeArticleWrapper(Knowledge__kav k,List<Product2> kaIdPRList,List<CH_ProductRelease__c> ProductRelList,String type){			
			this.Id = k.Id;
			this.ArticleNumber = k.ArticleNumber;
			this.PublishStatus = k.PublishStatus;
			this.CreatedDate = k.CreatedDate;
			this.LastModifiedDate = k.LastModifiedDate;
			this.Title = k.Title;
			this.ArticleURL = k.UrlName;
			this.Solution = k.CH_Solution__c;
			this.Workaround = k.CH_WorkAround__c;
			this.Question = k.CH_QuestionOrProductDescription__c;
			this.Procedure = k.CH_ProcedureRequired__c;
			this.Purpose = k.CH_PurposeRequired__c;
			if(type != 'Customers'){
				this.Source = k.Source__c;
				this.Category = k.CH_Category__c;
				this.Product = kaIdPRList;
				this.ProductRelease = ProductRelList;   
			}
		}
	}
}