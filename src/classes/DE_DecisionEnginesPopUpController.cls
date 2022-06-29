public class DE_DecisionEnginesPopUpController {
  public string Error {get; set;}
	public string Url{get ;set;}
	public string DocumentVersionId{get ;set;}
	public string callfunc{get;set;} 
	public boolean displayPopup {get; set;}   
	   
	public DE_DecisionEnginesPopUpController() {
		 if(string.isBlank(DE_DataStorage.token)){
			DE_Token_Creation.acquire();
		}
		displayPopUp = true;
		system.debug(' url test ');
		DocumentVersionId = apexpages.currentpage().getparameters().get('id');  
		Url = apexpages.currentpage().getparameters().get('docu');
		system.debug(Url);
		string deReview =System.Label.DE_App_reviewURL;
		//Url = 'https://cso30.dev.decisionengines.ai/#/app/review/' + apexpages.currentpage().getparameters().get('docu') + ';whitelabel=true?jwt='+ DataStorage.token;  
		Url =  deReview+'?jwt='+ DE_DataStorage.token+'#/app/review/' + apexpages.currentpage().getparameters().get('docu') + ';whitelabel=true';
		system.debug(Url);
		//displayPopup = false;
	}
	public void OpenIframe() { 
	   displayPopup = false;	
		
	} 
	public PageReference redirectAgreement(){	
	Pagereference ref = new Pagereference('/lightning/r/DE_Document_Version__c/'+DocumentVersionId +'/view');
	ref.setRedirect(true);
	return ref;
	}
}