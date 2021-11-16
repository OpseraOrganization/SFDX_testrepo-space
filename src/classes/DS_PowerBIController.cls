/*******************************
Class Name: DS_PowerBIController
Created by: Accenture
Last modified by: Accenture
Description: This class containd the logic for interconnecting the 
			 Salesforce with Power BI
*******************************/

public class DS_PowerBIController extends DS_OAuthController {
	@TestVisible private static String APPLICATION_NAME = CSWXGlobalConstant.POWERBI_APP_NAME; // This field stores the Application Name.
	
	private static final String base64Chars = CSWXGlobalConstant.EMPTY_STRING  +
	CSWXGlobalConstant.upper_case +
	CSWXGlobalConstant.lower_case +
	CSWXGlobalConstant.digits;
	
	
	public List<SelectOption> technologySelectOption {get;set;} //This field wil store the list of technology option.
	public String selectedTechnology  {get;set;}//This field is used for storing the selected technology.
	
	public List<SelectOption> usecaseSelectOption {get;set;} // This field is used for storing the select option assosictaed to usecase 
	public String selectedUseCase {get;set;} // This field store the selected usecase.
	public String isReportExist {get;set;} // This field is used to indicate whether report exist or not.
	
	public string ReportURL {get;set;} // This field is used for storing the Report URL.
	
	public String reportId {get;set;} // This field is used for storing the reportId from the report URL.
	
	public String statusMessage {get;set;}
	
	public string PBIAccessTokenCode {get;set;}
	
	public User objUser {get;set;} //This will store the current logged in user.
	
	public DS_PowerBIController() {
		
		 this.application_name = APPLICATION_NAME;
		statusMessage = ''; 
		
	   
		technologySelectOption =  new List<SelectOption>();
		technologySelectOption.add(new SelectOption(CSWXGlobalConstant.NONE_OPTION_VALUE,CSWXGlobalConstant.NONE_OPTION_VALUE));
		// below code load the Technologies.
		loadTechnologies();
		
		//Below code will check for the previously selected value from Cookie.
		//If value exists then will load the value from cookie.
		
	   
		String techCachaeValue = 'local.PBICachae.techValue'+userInfo.getUserId(); 
		String techValue ='';
		if(Cache.Session.contains(techCachaeValue))
			techValue = String.valueOf(Cache.Session.get(techCachaeValue));
		String techCacheValue;
			if(String.isEmpty(techValue))
			   techCacheValue = CSWXGlobalConstant.NONE_OPTION_VALUE ;
			else
			   techCacheValue = techValue;
		
		//Below code will check for the previously selected value from Cookie.
		//If value exists then will load the value from cookie.   
	   
		String usecaseCachaeValue = 'local.PBICachae.usecaseValue'+userInfo.getUserId(); 
		String usecaseValue = '';
		if(Cache.Session.contains(usecaseCachaeValue))
			usecaseValue = String.valueOf(Cache.Session.get(usecaseCachaeValue));
		String useCaseCacheValue;
		if(String.isEmpty(usecaseValue))
		   useCaseCacheValue = CSWXGlobalConstant.NONE_OPTION_VALUE ;
		else
		   useCaseCacheValue = usecaseValue;
		
		// Below code will check for the existence of value for Technology and Usecase.
		if( !String.isEmpty(techCacheValue) && !String.isEmpty(useCaseCacheValue) ) {
			//Below code will be executed when technology is not null. If technology is not null 
			// then loads the dependent usecaes. 
			if(!String.isEmpty(techCacheValue)) {
				selectedTechnology = techCacheValue;
				loadDependentUsecases();
			}
			
			//If Usecase has the selected value from cookie then will load the selected usecase.
			if(!String.isEmpty(useCaseCacheValue)) {
				selectedUseCase = useCaseCacheValue;
				
			}
			//Below method is responsible for getting the PBI RL from custom setting if Technology and usecaes exist.
			getPBIReportURL();
			
			//If we ge the Report URL then will filter the report id from it.
			if(!String.isEmpty(ReportURL)) {
				getReportIdFromReportURL();
			}
		}
		
		 objUser =   getCurrentUserData(); 
	}
	
	
	public void getAccessToken() {
	
		System.debug('*************inside getAccessToken************************');
		System.debug('*************ApexPages.currentPage().getParameters().************************'+ApexPages.currentPage().getParameters());
		System.debug('*************ApexPages.currentPage().getParameters().code************************'+PBIAccessTokenCode);
				
		String client_id = OAuthApp_pbi__c.getOrgDefaults().Client_Id__c;
		String client_secret = OAuthApp_pbi__c.getOrgDefaults().Client_Secret__c;
		String access_token_url = OAuthApp_pbi__c.getOrgDefaults().Access_Token_URL__c;
		String resource_URI = OAuthApp_pbi__c.getOrgDefaults().Resource_URI__c;

		String redirect_uri = Label.DS_URL_For_Community_Portal;
		System.debug('redirect_uri>>>>>>'+redirect_uri);
		String code = PBIAccessTokenCode;
		OAuthResult result = validateCode(PBIAccessTokenCode,redirect_uri);
		System.debug('**************result.access_token***********************'+result.access_token);
		PBIaccess_token = result.access_token;
			
 
		String accessTokenKeyCachaeValue = 'local.PBICachae.accessToken'+userInfo.getUserId();
		String refreshTokenCachaeValue = 'local.PBICachae.refreshToken'+userInfo.getUserId();
		String expiresOnKeyCachaeValue = 'local.PBICachae.expiresOn'+userInfo.getUserId();

		Cache.Session.put(accessTokenKeyCachaeValue, result.access_token);
		Cache.Session.put(refreshTokenCachaeValue, result.refresh_token);
		Cache.Session.put(expiresOnKeyCachaeValue, result.expires_on);
			
		  
			
   
	}
	
	public static User getCurrentUserData()
	{   
		try{

			return [SELECT Accountid,Account.AccountNumber,Contactid,FirstName,Name, LastName from User where id=:UserInfo.getUserId() limit 1] ;
		}
		catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_TabRendering, CSWXGlobalConstant.getCurrentUserData);
			return NULL;  
		}
	}
	
	/*******************************
	Class Name: getPBIReportURL
	Created by: Accenture
	Last modified by: Accenture
	Description: This method is responsible for getting the PBI URL for custom setting.
	*******************************/
	
	public void getPBIReportURL() {
		try{
			//Below code will load the PBI URL from custom settig based on the Technology and Usecase.
			System.debug('*******selectedTechnology***********'+selectedTechnology);
			 System.debug('*******selectedUseCase***********'+selectedUseCase);
			 
			 
			List<String> onlyTechValueList =Label.DS_Only_Technology_Filtered_values.split(';');
			if(selectedUseCase == CSWXGlobalConstant.NONE_OPTION_VALUE  ||(selectedTechnology != CSWXGlobalConstant.NONE_OPTION_VALUE  && selectedUseCase != CSWXGlobalConstant.NONE_OPTION_VALUE) ) {
				List<DS_PBI_Report_URL_Setting__c> PBIReportURLSettingList;
			   

				
				if(onlyTechValueList.contains(selectedTechnology) && selectedUseCase == CSWXGlobalConstant.NONE_OPTION_VALUE ) {
					PBIReportURLSettingList = [SELECT Id, Name, DS_Technology__c, DS_Use_case__c, DS_Power_BI_Report_URL__c,DS_Customer_Account_Number__c FROM DS_PBI_Report_URL_Setting__c 
					where DS_Technology__c =:selectedTechnology ];
				}
				else {
					PBIReportURLSettingList = [SELECT Id, Name, DS_Technology__c, DS_Use_case__c, DS_Power_BI_Report_URL__c,DS_Customer_Account_Number__c FROM DS_PBI_Report_URL_Setting__c 
					where DS_Technology__c =:selectedTechnology and DS_Use_case__c =:selectedUseCase];
				}
				
				if(PBIReportURLSettingList.isEmpty()) {
					//If the custom setting does not exist then  below code will be executed. 
					isReportExist = CSWXGlobalConstant.REPORT_DOES_NOT_EXIST_VALUE ;
					statusMessage =  Label.DS_Report_Does_not_Exist;
					ReportURL = null;
					reportId = null;
				}
				else {
					// If the Custom setting does not contains the Report URL then below code will be executed.
   
					
						//If we founds the value from custom setting based on the technology and usecase below code will be executed.
						isReportExist = CSWXGlobalConstant.REPORT_DOES_EXIST_VALUE  ;
						ReportURL = getPBIURLBasedOnCustomer(PBIReportURLSettingList);
						System.debug('****ReportURL obtained frm new fn*******'+ReportURL );
						if(String.isEmpty(ReportURL)) {
							
							isReportExist = CSWXGlobalConstant.REPORT_DOES_NOT_EXIST_VALUE ; 
							statusMessage = Label.DS_Report_Does_not_Exist;
							ReportURL = null;
							reportId = null;
							
						}
						 
					
				}
				 
				
				//Below code responsible filtering the report id from the report url.
				if(!String.isEmpty(ReportURL)) {
						getReportIdFromReportURL();
				}
			}
			if(selectedTechnology.equalsIgnoreCase(CSWXGlobalConstant.NONE_OPTION_VALUE)) {
				System.debug('*******This is True********');
				statusMessage = Label.DS_Technology_and_Usecase_Missing;
				isReportExist = CSWXGlobalConstant.REPORT_DOES_NOT_EXIST_VALUE ;
				ReportURL = null;
				reportId = null;
					   
			}
			else if(selectedUseCase.equalsIgnoreCase(CSWXGlobalConstant.NONE_OPTION_VALUE) && !onlyTechValueList.contains(selectedTechnology)  ) {
				System.debug('*******This is True********');
				statusMessage = Label.DS_Usecase_Missing;
				isReportExist = CSWXGlobalConstant.REPORT_DOES_NOT_EXIST_VALUE ;
				ReportURL = null;
				reportId = null;
				
			}
			
			//Below code will load the current Technology and usecase selection into session.
			String techCachaeValue = 'local.PBICachae.techValue'+userInfo.getUserId();
			String usecaseCachaeValue = 'local.PBICachae.usecaseValue'+userInfo.getUserId(); 
			Cache.Session.put(usecaseCachaeValue, selectedUseCase);
			Cache.Session.put(techCachaeValue, selectedTechnology);
			//ApexPages.currentPage().setCookies(new Cookie[]{techCookie,usecaseCookie}); 
		}
		catch(Exception ex) { System.debug('**********Exception Occurred*'); }
		 
	}
	
	public String getPBIURLBasedOnCustomer(List<DS_PBI_Report_URL_Setting__c> urlSettingList ) {
		String retURL = '';
		if(urlSettingList.size() == 1) {
			return  urlSettingList[0].DS_Power_BI_Report_URL__c;
		}
		else 
		{
			System.debug('*********urlSettingList.size()*************'+urlSettingList.size());
			System.debug('*********objUser.Account.AccountNumber*************'+objUser.Account.AccountNumber);
			for( DS_PBI_Report_URL_Setting__c objItem : urlSettingList ) {
				System.debug('**************objItem.DS_Customer_Account_Number__c********************'+objItem.DS_Customer_Account_Number__c);
				
				if(!String.isEmpty(objItem.DS_Customer_Account_Number__c)) {
					if(objItem.DS_Customer_Account_Number__c  == objUser.Account.AccountNumber) {
						retURL =   objItem.DS_Power_BI_Report_URL__c;
						break;
					}
				}
			}
		}
		return retURL;
	}
	
	
	 /*******************************
	Method Name: getReportURLBasedOnCustomer
	Created by: Accenture
	Last modified by: Accenture
	Description: This method will filter the reportId from Report URL.
	*******************************/
	
  /*  public String getReportURLBasedOnCustomer(DS_PBI_Report_URL_Setting__c objReportURL) {
		//below code will check for the if the URL configured for specific customer. 
		//If it is empty then return the Configured URL.
		System.debug('*********getReportURLBasedOnCustomer*************'+objReportURL.DS_Customer_Account_Number__c);
		if(String.isEmpty(objReportURL.DS_Customer_Account_Number__c)) {
			
			return objReportURL.DS_Power_BI_Report_URL__c;
		}
		//If the Account Number Exist then returns the customer specific URL based on logged in user.
		
		List<User> userList = [SELECT Account.AccountNumber, Accountid,Contactid,FirstName,Name, LastName from User where id=:UserInfo.getUserId() limit 1];
		if(!userList.isEmpty()) {
			System.debug('*********userList[0].Account.AccountNumber*************'+userList[0].Account.AccountNumber);
			System.debug('*******userList[0].Id*********'+userList[0].Id);
			List<DS_PBI_Report_URL_Setting__c> reportURLSetting = [SELECT Id, Name, DS_Technology__c, DS_Use_case__c, DS_Power_BI_Report_URL__c,DS_Customer_Account_Number__c FROM DS_PBI_Report_URL_Setting__c 
				where DS_Technology__c =:objReportURL.DS_Technology__c and  DS_Customer_Account_Number__c =:userList[0].Account.AccountNumber];
				if(!reportURLSetting.isEmpty()) {
					return reportURLSetting[0].DS_Power_BI_Report_URL__c;
				}
				return '';
		}
		return '';  
	} */
		
	
	/*******************************
	Method Name: getReportIdFromReportURL
	Created by: Accenture
	Last modified by: Accenture
	Description: This method will filter the reportId from Report URL.
	*******************************/
	
	public void getReportIdFromReportURL() {
		
		try{
		
			if(!String.isEmpty(ReportURL)) {
				String url = ReportURL;
				if(url.contains('&groupId')) {
					String[] urlPart = url.split('&groupId');
					if(urlPart.size() > 0) {
						string[] subURL =  urlPart[0].split('=');
						if(subURL.size() == 2) {
							reportId = subURL[1];
						}
						else {
							isReportExist = CSWXGlobalConstant.REPORT_DOES_NOT_EXIST_VALUE ;
							 statusMessage = Label.DS_Invalid_PBI_Report_URL_Configuration;
							ReportURL = null;
							reportId = null;
						}
						
					}
				   /* else{
						isReportExist = CSWXGlobalConstant.REPORT_DOES_NOT_EXIST_VALUE ; 
						 statusMessage = Label.DS_Invalid_PBI_Report_URL_Configuration;
						ReportURL = null;
						reportId = null;
					} */
					
				}
				
			}
		}
		catch(Exception e) {
		}
	}
	
	/*******************************
	Method Name: getReportIdFromReportURL
	Created by: Accenture
	Last modified by: Accenture
	Description: This method is responsible for loading the Dependent Usecase based on technologies.
	*******************************/
	
	public void loadDependentUsecases() {
		try {
			
			usecaseSelectOption = new List<SelectOption>();
			selectedUseCase = CSWXGlobalConstant.NONE_OPTION_VALUE;
			usecaseSelectOption.add(new SelectOption(CSWXGlobalConstant.NONE_OPTION_VALUE ,CSWXGlobalConstant.NONE_OPTION_VALUE));
			usecaseSelectOption = getUseCaseOnTechnology(selectedTechnology); 
		}
		catch(Exception ex) {}
	}
	
	/*******************************
	Method Name: loadTechnologies
	Created by: Accenture
	Last modified by: Accenture
	Description: This method is responsible for loading the technologies values.
	*******************************/
	
	public void loadTechnologies() {
		try{
			technologySelectOption = getTechnologies();
		}
		catch(Exception ex) {}
 
	}
	
	public String getValidateResult()
	{
		
		return validateResult;
		
	}

	/**
	* Validates the callback code and generates the access and refresh tokens
	*
	* @return null to refresh the page
	*/
	public PageReference redirectOnCallback() {
		return super.redirectOnCallback(null);
	}
	
	public PageReference refreshAccessToken() {
		return super.refreshAccessToken(ApexPages.currentPage());
	}
	
	/*******************************
	Function Name: getTechnologies
	Created by: Accenture
	Last modified by: Accenture
	Description: This method is responsible for getting All technology configured from 
				 Technology usecase custom setting.
				 
	*******************************/
	
	public  List<SelectOption>  getTechnologies() {
		
		set<String> techSet = new Set<String>();
		
		List<selectOption>technologySelectOption = new List<SelectOption>();
		technologySelectOption.add(new SelectOption(CSWXGlobalConstant.NONE_OPTION_VALUE ,CSWXGlobalConstant.NONE_OPTION_VALUE));
		for( DS_Technology_Usecase_Combination__c obj : [Select Id,Name,DS_Technology__c,DS_Usecase__c from DS_Technology_Usecase_Combination__c order by  DS_Technology_Order_Number__c  ]) {
			techSet.add(obj.DS_Technology__c);
		}
		if(!techSet.isEmpty()) {
			for(String item : techSet) {
				 technologySelectOption.add(new SelectOption(item,item));
			}
		}
		
		return technologySelectOption;
	}
	
		/*******************************
	Function Name: getUseCaseOnTechnology
	Created by: Accenture
	Last modified by: Accenture
	Description: This method is responsible for getting All Usecase based on TEchnology selected from configured from 
				 Technology usecase custom setting.
				 
	*******************************/
	
	public  List<selectOption> getUseCaseOnTechnology(String selectedTechnology) {
		
		List<selectOption>useCaseSelectOption = new List<SelectOption>();
		usecaseSelectOption.add(new SelectOption(CSWXGlobalConstant.NONE_OPTION_VALUE ,CSWXGlobalConstant.NONE_OPTION_VALUE));
		for( DS_Technology_Usecase_Combination__c obj : [Select Id,Name,DS_Technology__c,DS_Usecase__c from DS_Technology_Usecase_Combination__c where DS_Technology__c =:selectedTechnology order by DS_UseCase_Order_Number__c  ]) {
			useCaseSelectOption.add(new SelectOption(obj.DS_Usecase__c,obj.DS_Usecase__c));
		}
		
		return useCaseSelectOption;
		
	}
	
   
}