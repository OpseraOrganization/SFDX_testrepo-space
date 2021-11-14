/**
  * An apex page controller that takes the user to the right start page based on credentials or lack thereof
  * Updated by AES to manage the 2th page registration
  * Project: Nokia customer portal
  * */
  public without sharing class CommunitiesLandingController {
	// Code we will invoke on page load.
	public PageReference forwardToStartPage() {	
	  /*String profileName = NCP_CustomerCommunitySetting__c.getValues('Default').Customer_User_Profile__c;
	  String customerProfileId = [Select Id from Profile where name = :profileName].Id;
	  //User user = UserInfo.getUserId();
	  User connectedUser = [select id,AccountId,contactId,contact.Account.Name,ProfileId from user where Id =:UserInfo.getUserId()];
	  //Get dummy list Account 
	  Set<String> AccountNameSet = new Set<String>();
	  for(NCP_CustomerCommunitySetting__c acc:[SELECT id, Customer_Account__c FROM NCP_CustomerCommunitySetting__c limit 20]){
		AccountNameSet.add(acc.Customer_Account__c);
	  }
	  system.debug('### AES AccountNameSet '+AccountNameSet);
	  system.debug('### AES connectedUser '+connectedUser);
	  //Get the account for the connected user form the contact object 
	  //Contact contactConnected = [SELECT Account.Name FROM Contact WHERE Id =:connectedUser.contactId];   
	  String communityUrl = '';
	  if(!Test.isRunningTest()){
		communityUrl = Network.communitiesLanding().getUrl();
	  }		
	  system.debug('### AES connectedUser '+connectedUser.Contact.Account.Name);
	  system.debug('### AES AccountNameSet.contains(connectedUser.Contact.Account.Name) '+AccountNameSet.contains(connectedUser.Contact.Account.Name));
	  system.debug('### AES customerProfileId '+customerProfileId);
	  if(AccountNameSet.contains(connectedUser.Contact.Account.Name) && connectedUser.ProfileId == customerProfileId){
		communityUrl += 'company-registration';
		system.debug('### AES communityUrl '+communityUrl);
		return new PageReference(communityUrl);
	  }else
		*/
	  // NCP_ActAsHelper.removeActAsPermission();
	  return Network.communitiesLanding();
	}
	public CommunitiesLandingController() {}
  }