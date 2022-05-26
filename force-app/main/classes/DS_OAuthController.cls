/**
	*
	OAuth controller borrow heavily from http://blog.deadlypenguin.com/blog/2016/07/05/oauth-flow-for-service-users-in-salesforce/
	*/
public virtual class DS_OAuthController {
	@TestVisible public String access_token;
	@TestVisible public String refresh_token;
	@TestVisible public String expires_on;
	
	@TestVisible private Boolean isCallback;

	public String validateResult;

	public String application_name;
   
	public String PBIaccess_token { 
		get {
			
			String accessTokenKeyCachaeValue = 'local.PBICachae.accessToken'+userInfo.getUserId();
			String AccessTokenValue = '';
			if(Cache.Session.contains(accessTokenKeyCachaeValue))
				AccessTokenValue = String.valueOf(Cache.Session.get(accessTokenKeyCachaeValue));
			
			if(String.isEmpty(AccessTokenValue))
				this.access_token = '';
				
			else {
				 this.access_token = AccessTokenValue;
				}
		   
		   
			System.debug('this.access_token>>>>>>'+this.access_token);
			return this.access_token;
		} 
		set;
		}
		
	public String PBIrefresh_token { 
		get { 
			String refreshTokenCachaeValue = 'local.PBICachae.refreshToken'+userInfo.getUserId();
			String refreshTokenVal = '';
			if(Cache.Session.contains(refreshTokenCachaeValue))
				refreshTokenVal = String.valueOf(Cache.Session.get(refreshTokenCachaeValue));
			
			if(String.isEmpty(refreshTokenVal)) {
				this.refresh_token= '';
			}
			else {
				this.refresh_token=  refreshTokenVal;
			}
			return this.refresh_token;
		} 
		set;
		}
		
	public String PBIexpires_on { 
	
		get {
		   
			String expiresOnKeyCachaeValue = 'local.PBICachae.expiresOn'+userInfo.getUserId();
			
			String expiresOnValue = '';
			if(Cache.Session.contains(expiresOnKeyCachaeValue))
				expiresOnValue = String.valueOf(Cache.Session.get(expiresOnKeyCachaeValue));
			
			
				if(String.isEmpty(expiresOnValue)) {
					this.expires_on= '';
				}
				else {
					this.expires_on= expiresOnValue;
				}
		   
		   
			
			
			return this.expires_on;
		} 
		set;
		}

	/**
	* If the access token is set
	*
	* @return If the access token is set
	*/
	public Boolean getHasToken() {
		  Boolean check;
		 if(PBIaccess_token== null)
			  check = false;
		   else 
			  check = PBIaccess_token.length()>0;
		System.debug('PBIaccess_token>>>>>'+PBIaccess_token);
		  return check;
	}


	/** The JSON result from a successful oauth call */
	public class OAuthResult {
		/** The access token */
		public String access_token {get; set;}

		/** The refresh token */
		public String refresh_token {get; set;}
		
		/** The token expiry date*/
		public String expires_on {get;set;}
	}

	/**
	* Validates the oauth code
	*
	* @param code The code to validate
	* @param redirect_uri The URL to redirect to after successful validation
	* @return The oauth result
	*/
	public OAuthResult validateCode(String code, String redirect_uri) {
		try
		{
			String client_id = OAuthApp_pbi__c.getOrgDefaults().Client_Id__c;
			String client_secret = OAuthApp_pbi__c.getOrgDefaults().Client_Secret__c;
			String access_token_url = OAuthApp_pbi__c.getOrgDefaults().Access_Token_URL__c;
			String resource_URI = OAuthApp_pbi__c.getOrgDefaults().Resource_URI__c;
			
			System.debug('redirect_uri>>>>>>'+redirect_uri);
			List<String> urlParams = new List<String> {
				'grant_type=authorization_code',
				'code=' + EncodingUtil.urlEncode(code, 'UTF-8'),
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
			validateResult = res.getBody();
			
			return (OAuthResult)(JSON.deserialize(res.getBody(), OAuthResult.class));
		}
		catch(Exception ex) { ExceptionHandler.addException(ex,'DS_OAuthController','validateCode'); }
		return null;
	}
	
	/** 
	* Gets new access token through refresh token
	*
	* @param refreshToken The refresh token
	* @return The oauth result
	*/
	public PageReference refreshAccessToken(PageReference location){
		
		try{

			String accessTokenKeyCachaeValue = 'local.PBICachae.accessToken'+userInfo.getUserId();
			String refreshTokenCachaeValue = 'local.PBICachae.refreshToken'+userInfo.getUserId();
			String expiresOnKeyCachaeValue = 'local.PBICachae.expiresOn'+userInfo.getUserId();
			
			Cache.Session.put(accessTokenKeyCachaeValue, '');
			Cache.Session.put(refreshTokenCachaeValue, '');
			Cache.Session.put(expiresOnKeyCachaeValue, '');
				
			
				
			String client_id = OAuthApp_pbi__c.getOrgDefaults().Client_Id__c;
			String client_secret = OAuthApp_pbi__c.getOrgDefaults().Client_Secret__c;
			String resource_URI = OAuthApp_pbi__c.getOrgDefaults().Resource_URI__c;
			String refreshToken = this.PBIrefresh_token;
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

			OAuthResult result = (OAuthResult)(JSON.deserialize(res.getBody(), OAuthResult.class));
			
			
			
			Cache.Session.put(accessTokenKeyCachaeValue, result.access_token);
			Cache.Session.put(refreshTokenCachaeValue, result.refresh_token);
			Cache.Session.put(expiresOnKeyCachaeValue, result.expires_on);
				 
			return location;
		}
		catch(Exception ex) {  ExceptionHandler.addException(ex,'DS_OAuthController','validateCode');}
		return null;
	}

	/**
	* Generic constructor
	*/
	public DS_OAuthController() {
	this.isCallback = ApexPages.currentPage().getParameters().containsKey('code'); 
	
			String accessTokenKeyCachaeValue = 'local.PBICachae.accessToken'+userInfo.getUserId();
			String refreshTokenCachaeValue = 'local.PBICachae.refreshToken'+userInfo.getUserId();
			String expiresOnKeyCachaeValue = 'local.PBICachae.expiresOn'+userInfo.getUserId();
			String AccessTokenValue ='';
			if(Cache.Session.Contains(accessTokenKeyCachaeValue))
				AccessTokenValue = String.valueOf(Cache.Session.get(accessTokenKeyCachaeValue));
			
			String refreshTokenValue = '';
			if(Cache.Session.contains(refreshTokenCachaeValue))
				refreshTokenValue = String.valueOf(Cache.Session.get(refreshTokenCachaeValue));
			
			String expiresOnValue = '';
			if(Cache.Session.contains(expiresOnKeyCachaeValue))
				expiresOnValue = String.valueOf(Cache.Session.get(expiresOnKeyCachaeValue));
		
			
				if(String.isEmpty(AccessTokenValue)) {
					  this.access_token = '';
				}
				else {
					  this.access_token = AccessTokenValue;
				}
				
				if(String.isEmpty(refreshTokenValue)) {
					  this.refresh_token = '';
				}
				else {
					  this.refresh_token  = refreshTokenValue;
				}
				
				if(String.isEmpty(expiresOnValue)) {
					  this.expires_on = '';
				}
				else {
					  this.expires_on = expiresOnValue;
				}
			
						 

		
		System.debug('isCallback>>>>>>>>>>'+isCallback);
		
		System.debug('access_token>>>>>>>Controller wala'+access_token);
		System.debug('refresh_token>>>>>>>Controller wala'+refresh_token);
		System.debug('expires_on>>>>>>>Controller wala'+expires_on);
		
	}

	/**
	* Gets the authroization URL
	*
	* @return The authorization url
	*/
	public String getAuthUrl() {
		try {
			Map<String, String> urlParams = new Map<String, String> {
				'client_id' => OAuthApp_pbi__c.getOrgDefaults().Client_Id__c,
				'redirect_uri' => getPageUrl(),
				'resource' => OAuthApp_pbi__c.getOrgDefaults().Resource_URI__c,
				'response_type' => 'code'
			};
			String auth_url = OAuthApp_pbi__c.getOrgDefaults().Authorization_URL__c;

			PageReference ref = new PageReference(auth_url);
			ref.getParameters().putAll(urlParams);

			return ref.getUrl();
		}
		catch(Exception ex) { ExceptionHandler.addException(ex,'DS_OAuthController','validateCode');}
		return null;
	}

	/**
	* Gets the page url
	*
	* @return The page url
	*/
	@testVisible
	private String getPageUrl() {
		try{
		   /*  String host = ApexPages.currentPage().getHeaders().get('Host');
			String path = ApexPages.currentPage().getUrl().split('\\?').get(0);
			System.debug('host>>>>>'+host);
			System.debug('path>>>>>'+path); */
			//return 'https://' + host + path;
			return Label.DS_URL_For_Community_Portal;
		}
		catch(EXception ex) {ExceptionHandler.addException(ex,'DS_OAuthController','validateCode');}
		return null;
	}

	/**
	* Validates the callback code and generates the access and refresh tokens
	*
	* @param location Where to redirect to after success
	* @return null to refresh the page
	*/
	   public PageReference redirectOnCallback(PageReference location) {
		try{
			if (this.isCallback)  {
				String code = ApexPages.currentPage().getParameters().get('code');
				OAuthResult result = validateCode(code, this.getPageUrl());
									   
			   
				
				String accessTokenKeyCachaeValue = 'local.PBICachae.accessToken'+userInfo.getUserId();
				String refreshTokenCachaeValue = 'local.PBICachae.refreshToken'+userInfo.getUserId();
				String expiresOnKeyCachaeValue = 'local.PBICachae.expiresOn'+userInfo.getUserId();
			
				Cache.Session.put(accessTokenKeyCachaeValue, result.access_token);
				Cache.Session.put(refreshTokenCachaeValue, result.refresh_token);
				Cache.Session.put(expiresOnKeyCachaeValue, result.expires_on);
				
			   // ApexPages.currentPage().setCookies(new Cookie[]{accessToken,refreshToken,expiresOn}); 
				System.debug('location>>>>>>>>>>redirectOnCallback'+location); 
				return location;
			}
			
		}
		catch(Exception ex) {ExceptionHandler.addException(ex,'DS_OAuthController','validateCode'); }
		return null;
	}
}