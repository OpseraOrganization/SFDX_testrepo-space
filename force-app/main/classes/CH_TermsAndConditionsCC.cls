/***************************************************************** 
Description:  This class acts as a controller for a VF page CH_TermsAndConditions which shows 
the Terms of Use & Privacy when the user login.														 
 
History																														 
DATE		 AUTHOR			   Change 
19/06/2018   TCS				  Created 
*****************************************************************/

public class CH_TermsAndConditionsCC {

  public String Annoucementtxt{get;set;}   
  public boolean hideTermCond{get;set;}
  public boolean hideAnnoucment{get;set;}
  user userRec = getUserRecord();	
  CH_DontShowAgain__c dntShow = CH_DontShowAgain__c.getInstance(userRec.Alias);
  CH_DontShowAgain__c dontShow = CH_DontShowAgain__c.getInstance(userRec.Alias);
  UserLoginLockSetting__c objGame = UserLoginLockSetting__c.getValues('UserLoginLock'); 
  
  public CH_TermsAndConditionsCC (){
	  system.debug('contsructor Executed first');
	  //UserLoginLockSetting__c objGame = UserLoginLockSetting__c.getValues('UserLoginLock');	 
	  if(objGame != null && objGame.IsAnnounce__c == true){
		  List<string> str = objGame.Announcement_Message__c.split('\r\n');
		  String Combinedstring = string.join(str,'<br>');
		   Annoucementtxt = Combinedstring;
		   
	  }
	  
	  system.debug('Annoucementtxt first'+Annoucementtxt );
	 
  }
  
	
 /***************************************************************** 
  Description:  Checks if the custom setting contains the logged in user details if yes 
  return to Home page   
  Parameters: N/A 
  Returns: PageReference 
  History															 
  DATE		   AUTHOR			   Change 
  20/06/2018	 TCS				  Created 
 *****************************************************************/   
	public PageReference CH_vfLoginFlowAction(){
		hideTermCond = true;
		system.debug('Executed page action');
		system.debug('dont show '+dntShow);
		  if(dntShow != null){
			if(dntShow.CH_DontShowPage__c == true && objGame.IsAnnounce__c == true){ 
			 hideTermCond = false;
			 hideAnnoucment = true;
			 }
			}
	   
		 if(dntShow != null && dntShow.CH_DontShowPage__c == true && objGame.IsAnnounce__c == false){
			 system.debug('entered into false annoucment');
			   hideAnnoucment = false;
			   hideTermCond = false;
			   return Auth.SessionManagement.finishLoginFlow();
			}
		   
			return null;
	}
   
  /***************************************************************** 
  Description:  checks the custom setting and and save the user details in custom setting														
  Parameters: N/A 
  Returns: PageReference														   
 
  History															 
  DATE		   AUTHOR			   Change 
  20/06/2018	 TCS				  Created 
 *****************************************************************/
  public PageReference CH_doNotShowAgain() {
		
		 if(dontShow != null){
			CH_DontShowAgain__c dntShow = new CH_DontShowAgain__c(Name = userRec.Alias);			
			dntShow.CH_DontShowPage__c = true;
			insert dntShow;
		}
		else{
			CH_DontShowAgain__c dontShowRec = new CH_DontShowAgain__c ();
			dontShowRec.Name = userRec.Alias;
			dontShowRec.CH_UserName__c = userInfo.getUserName();
			dontShowRec.CH_DontShowPage__c = true;
			insert dontShowRec;
		}
	  
		return Auth.SessionManagement.finishLoginFlow();
	}
	
/***************************************************************** 
  Description:  This method returns to the Home page														
  Parameters: N/A 
  Returns: PageReference														   
 
  History															 
  DATE		   AUTHOR			   Change 
  19/06/2018	 TCS				  Created 
*****************************************************************/
	public PageReference CH_finishLoginFlowHome() {
		return Auth.SessionManagement.finishLoginFlow();
	}
	
	public user getuserRecord(){
		System.debug('## getUserRecord method is called');
		return [select name, alias, Nokia_ID__c from user where id =: UserInfo.getUserId()];
	
	}

}