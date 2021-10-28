public class DS_PBI_ReportServerController {
	
	@AuraEnabled
	public static tokenInfo genarateAccessToken(String authCode) {
		
		System.debug('**************inside genarateAccessToken**************');
		String client_id = OAuthApp_pbi__c.getOrgDefaults().Client_Id__c;
		String client_secret = OAuthApp_pbi__c.getOrgDefaults().Client_Secret__c;
		String access_token_url = OAuthApp_pbi__c.getOrgDefaults().Access_Token_URL__c;
		String resource_URI = OAuthApp_pbi__c.getOrgDefaults().Resource_URI__c;
		String redirect_uri= Label.DS_URL_For_Community_Portal;
		System.debug('redirect_uri>>>>>>'+redirect_uri);
		
		List<String> urlParams = new List<String> {
			'grant_type=authorization_code',
			'code=' + EncodingUtil.urlEncode(authCode, 'UTF-8'),
			'client_id=' + EncodingUtil.urlEncode(client_id, 'UTF-8'),
			'client_secret=' + EncodingUtil.urlEncode(client_secret, 'UTF-8'),
			'redirect_uri=' + EncodingUtil.urlEncode(redirect_uri, 'UTF-8')
		};

		Http h = new Http();

		HttpRequest req = new HttpRequest();
		req.setEndpoint(access_token_url);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
		req.setHeader('Accept', 'application/json');
		String body = String.join(urlParams, '&');
		req.setBody(body);

		HttpResponse res = h.send(req);
		System.debug('********response body***********'+res.getBody()) ;
		System.debug('********response status code***********'+res.getStatuscode()) ;
		OAuthResult objResult =  (OAuthResult)(JSON.deserialize(res.getBody(), OAuthResult.class));
		tokenInfo objTokenInformation =  new tokenInfo();
		
		if(objResult.access_token != null) {
			
			objTokenInformation.oAuthInfo = objResult;
			objTokenInformation.isTokenFound = true;
			objTokenInformation.isRequestSucceed = true;
			
		}else {
			objTokenInformation.isTokenFound = false;
			objTokenInformation.isRequestSucceed = false;
		}
		return  objTokenInformation;
	}
	
	@AuraEnabled
	public static String getOAuthURL() {
		Map<String, String> urlParams = new Map<String, String> {
			'client_id' => OAuthApp_pbi__c.getOrgDefaults().Client_Id__c,
				'redirect_uri' =>  Label.DS_URL_For_Community_Portal,
				'resource' => OAuthApp_pbi__c.getOrgDefaults().Resource_URI__c,
				'response_type' => 'code'
				};
		String auth_url = OAuthApp_pbi__c.getOrgDefaults().Authorization_URL__c;
		PageReference ref = new PageReference(auth_url);
		ref.getParameters().putAll(urlParams);
		
		return ref.getUrl();
	}
	
	 public class OAuthResult {
		 
		 @AuraEnabled  public String access_token;
		 @AuraEnabled public String refresh_token;
		 @AuraEnabled public String expires_on;
		 
	 }
	 
	 public class tokenInfo {
		 @AuraEnabled public  OAuthResult oAuthInfo;
		 @AuraEnabled public Boolean isTokenFound;
		 @AuraEnabled public Boolean isRequestSucceed;
		 @AuraEnabled public Boolean isNeedRequestForAccesToken;
	 }
	
	
	@AuraEnabled
	public static tokenInfo genarateAccessTokenFromRefreshToken(String refreshToken) {
		
		String client_id = OAuthApp_pbi__c.getOrgDefaults().Client_Id__c;
		String client_secret = OAuthApp_pbi__c.getOrgDefaults().Client_Secret__c;
		String resource_URI = OAuthApp_pbi__c.getOrgDefaults().Resource_URI__c;
		
		String access_token_url = OAuthApp_pbi__c.getOrgDefaults().Access_Token_URL__c;
		
		List<String> urlParams = new List<String> {
			'grant_type=refresh_token',
				'refresh_token=' + EncodingUtil.urlEncode(refreshToken, 'UTF-8'),
				'client_id=' + EncodingUtil.urlEncode(client_id, 'UTF-8'),
				'client_secret=' + EncodingUtil.urlEncode(client_secret, 'UTF-8'),
				'resource=' + EncodingUtil.urlEncode(resource_URI, 'UTF-8')
		};
					
		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint(access_token_url);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
		req.setHeader('Accept', 'application/json');
		String body = String.join(urlParams, '&');
		req.setBody(body);
		
		HttpResponse res = h.send(req);
		OAuthResult objResult;
		if(res.getStatusCode() == 200)
			objResult = (OAuthResult)(JSON.deserialize(res.getBody(), OAuthResult.class));
		
		tokenInfo objTokenInformation =  new tokenInfo();
		if(res.getStatusCode() == 200) {
			if(objResult.access_token != null) {
			
				objTokenInformation.oAuthInfo = objResult;
				objTokenInformation.isTokenFound = true;
				objTokenInformation.isRequestSucceed = true;
			
			}else {
				objTokenInformation.isTokenFound = false;
				objTokenInformation.isRequestSucceed = false;
			}
			
		}
		else {
			objTokenInformation.isTokenFound = false;
			objTokenInformation.isRequestSucceed = false;
			objTokenInformation.isNeedRequestForAccesToken = true;
		}
		system.debug('********objTokenInformation*************'+objTokenInformation);
		return  objTokenInformation;  
	}
	
	
	@AuraEnabled
	public static List<techWrapper>  getUniqueTechnologies() {
		
		Set<String> techSet= new Set<String>();
		List<techWrapper> techWrapperList = new List<techWrapper>();
		for(DS_Technology_Usecase_Combination__c obj : [Select DS_Technology__c,DS_Usecase__c from DS_Technology_Usecase_Combination__c where DS_Active__c = true order by DS_Technology__c asc]) {
			techSet.add(obj.DS_Technology__c);
		   
		}
		for(String item :techSet ) {
			techWrapper objTechWrapper = new techWrapper();
			objTechWrapper.techValue = item;
			objTechWrapper.className = 'btDefault';
			techWrapperList.add(objTechWrapper);
		}
		techWrapperList[0].className ='btActivated';
		List<String> techList = new List<String>(techSet);
		return techWrapperList;
		
	}
	
	@AuraEnabled 
	public static  List<usecaseInfo> returnUseCaseOnTechnology(String technology) {
		Map<String,String> reportURLOnUsecaseMap = new Map<String,String>();
		List<usecaseInfo> usecaseInfoList = new List<usecaseInfo>();
		List<DS_PBI_Report_URL_Setting__c> reportURLSettings = [SELECT Id, Name, DS_Use_case__c, DS_Technology__c, DS_Power_BI_Report_URL__c, DS_Customer_Account_Number__c FROM DS_PBI_Report_URL_Setting__c where DS_Technology__c =:technology];
		for(DS_PBI_Report_URL_Setting__c obj: [SELECT Id, Name, DS_Use_case__c, DS_Technology__c, DS_Power_BI_Report_URL__c,DS_Customer_Account_Number__c FROM DS_PBI_Report_URL_Setting__c where DS_Technology__c =:technology]) {
			reportURLOnUsecaseMap.put(obj.DS_Use_case__c,obj.DS_Power_BI_Report_URL__c);
		}
		//List<DS_Technology_Usecase_Combination__c> techUsecaseCombinationList = [SELECT Id, Name, DS_Technology__c, DS_Usecase__c, DS_UseCase_Order_Number__c, DS_Technology_Order_Number__c, DS_Report_Description__c FROM DS_Technology_Usecase_Combination__c where DS_Technology__c =:technology];
		for(DS_Technology_Usecase_Combination__c obj : [SELECT Id,DS_Tile_Image_URL__c, Name, DS_Technology__c, DS_Usecase__c, DS_UseCase_Order_Number__c, DS_Technology_Order_Number__c, DS_Report_Description__c FROM DS_Technology_Usecase_Combination__c where DS_Technology__c =:technology and DS_Active__c = true ORDER BY DS_Technology_Order_Number__c ASC,DS_UseCase_Order_Number__c ASC]) {
			usecaseInfo objuseCase = new usecaseInfo();
			objuseCase.UsecaseName =	obj.DS_Usecase__c;
			if(reportURLOnUsecaseMap.containsKey(obj.DS_Usecase__c)) {
				objuseCase.reportLink = reportURLOnUsecaseMap.get(obj.DS_Usecase__c);
				objuseCase.isReportExist = true;
			}
			else {
				objuseCase.reportLink = '';
				objuseCase.isReportExist = false;
			}
			objuseCase.staticResourceURLLink = obj.DS_Tile_Image_URL__c;
			objuseCase.reportDescription = obj.DS_Report_Description__c;
			usecaseInfoList.add(objuseCase);
		}
		
		return usecaseInfoList;
	}
	
	public class usecaseInfo {
		
		@AuraEnabled public  String UsecaseName;
		@AuraEnabled public String reportLink;
		@AuraEnabled public String staticResourceURLLink;
		@AuraEnabled public String reportDescription;
		@AuraEnabled public Boolean isReportExist;
		
	}
	
	public class techWrapper {
		@AuraEnabled public String techValue;
		@AuraEnabled public String className;
	}
	
	
}