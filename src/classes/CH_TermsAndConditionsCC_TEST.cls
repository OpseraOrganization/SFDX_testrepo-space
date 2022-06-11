@isTest(SeeAllData=false)

public class CH_TermsAndConditionsCC_TEST {
	
	Public static testMethod void CH_doNotShowAgainMethod(){	   
		String Annoucementtxt;
		CH_DontShowAgain__c dnt= new CH_DontShowAgain__c();		 
		test.startTest();
		dnt.CH_DontShowPage__c= true;
		dnt.CH_UserName__c='211234';
		dnt.Name = 'Test';		
		insert dnt;
		test.stopTest();
		
		CH_DontShowAgain__c dntShow = CH_DontShowAgain__c.getInstance(dnt.Name);
		
		UserLoginLockSetting__c usrLog = new UserLoginLockSetting__c();
		usrLog.Name = 'UserLoginLock';
		usrLog.IsAnnounce__c = true;
		usrLog.Announcement_Message__c = 'Test 123 <br>';		
		insert usrLog;
		
		Profile p = [select id from Profile where name='CH_Agent'];
		user us=new user();
		us.Alias='Test';
		us.Nokia_ID__c='1241685';
		us.FirstName='Test';
		us.LastName='TestRec';
		us.Email='Testmail@tcs.com';
		us.EmailEncodingKey='UTF-8';
		us.CommunityNickname='tcs';
		us.TimeZoneSidKey='Europe/London';
		us.LocaleSidKey='en_US';
		us.LanguageLocaleKey='en_US'; 
		us.ProfileId= p.Id;
		us.Username= 'Testmail@tcs.com';
		
		insert us;
		CH_TermsAndConditionsCC ch=new CH_TermsAndConditionsCC();
		ch.CH_doNotShowAgain();
		ch.CH_finishLoginFlowHome();
		ch.CH_vfLoginFlowAction();
	}	
	
	Public static testMethod void CH_doNotShowAgainMethod1(){
		
		Profile p = [select id from Profile where name='CH_Agent'];
		
		user us=new user();
		us.Alias='Ooooo';
		us.Nokia_ID__c='12416856';
		us.FirstName='Test';
		us.LastName='ibrahim';
		us.Email='Testmail@tcs.com';
		us.EmailEncodingKey='UTF-8';
		us.CommunityNickname='tcs';
		us.TimeZoneSidKey='Europe/London';
		us.LocaleSidKey='en_US';
		us.LanguageLocaleKey='en_US'; 
		us.ProfileId= p.Id;
		us.Username= 'Testmail@tcs.com';
		
		insert us; 
		
		CH_DontShowAgain__c dnt1= new CH_DontShowAgain__c();
		dnt1.CH_DontShowPage__c= false;
		dnt1.CH_UserName__c='Testmail@tcs.com';
		dnt1.Name = '12416856';
		
		insert  dnt1;
		CH_DontShowAgain__c dntShow = CH_DontShowAgain__c.getInstance(dnt1.Name);
			
		CH_TermsAndConditionsCC ch=new CH_TermsAndConditionsCC();
		ch.CH_doNotShowAgain();
		ch.CH_vfLoginFlowAction();   
		CH_ClearDontShowCSettingData.dontShowRecsDelete();	  
	}
	
}