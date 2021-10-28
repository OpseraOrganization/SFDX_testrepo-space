/**
 * @description: 
 *
 * ============================================================================
 * History:
 * -------
 * 
 * VERSION AUTHOR		  DATE			DETAIL										  
 * 1.0	 Accenture	   March 2018	  To Check Profile permission on NSA impacting objects
 * ============================================================================ 
 */
public without sharing class CheckNSASecurity{
	/**********************************************************************************************************************
	* author: Accenture
	* Date: March-2018
	* Param:  None
	* Return: None
	* Description: Method to Check NSA voilation
	* High Level Process :
	********************************************************************************************************************* */	 
	public static void CheckNSASecurityOnProfile(){
		System.debug('In CheckNSASecurityOnProfile method -----------');			
		list<ObjectPermissions> allObjPerm = new List<ObjectPermissions>();
		list<Profile> customAppnMngUser = new List<Profile>();
		//list<String> allProfiles = new list<String>();
		Map<String, NSA_Exception_Profile__c > exceptionProfilesViewAll = new Map<String, NSA_Exception_Profile__c>();
		Map<String, NSA_Exception_Profile__c> exceptionallProfilesModifyAll = new Map<String, NSA_Exception_Profile__c>();
		Map<String, NSA_Exception_Profile__c > exceptionProfilesManageUser = new Map<String, NSA_Exception_Profile__c>();
		Map<String, NSA_Exception_Profile__c> exceptionallProfilesCustApp = new Map<String, NSA_Exception_Profile__c>();
		list<String> allProfilesViewAll = new list<String>();
		list<String> allProfilesModifyAll = new list<String>();
		list<String> allProfilesManageUsers  = new list<String>();
		list<String> allProfilesCustApp = new list<String>();
		list<String> allObj = new list<String>();
		String msgBody = '';
		String msgBodyViewAll = '';
		String msgBodyModifyAll = '';
		String msgBodyManageUser = '';
		String msgBodyCustApp = '';
		list <NSA_Exception_Profile__c> profileException = [Select id, name, View_All__c, Modify_All__c, Manage_User__c, Customize_App__c from NSA_Exception_Profile__c Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		list<NSA_Alert_Sent_To_EmailAddess__c> allSendToAddress = [Select id, name, Emailid__c from NSA_Alert_Sent_To_EmailAddess__c Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		list<String> sendTo = new List<String>();
		list<NSA_Object__c > NSAObj = [select id, name from NSA_Object__c Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		system.debug('allSendToAddress : '+ allSendToAddress);
		
		for(NSA_Exception_Profile__c prof  : profileException){
			If(prof.Modify_All__c == true){
				exceptionallProfilesModifyAll.put(prof.name, prof);
			}
			else if(prof.View_All__c == true){
				exceptionProfilesViewAll.put(prof.name, prof);
			}
			
			if(prof.Manage_User__c == true){
				exceptionProfilesManageUser.put(prof.name, prof);
			}
			
			if(prof.Customize_App__c == true){
				exceptionallProfilesCustApp.put(prof.name, prof);
			}
			
		}
		system.debug('exceptionallProfilesModifyAll : '+ exceptionallProfilesModifyAll);
		system.debug('exceptionProfilesViewAll : '+ exceptionProfilesViewAll);  
		for(NSA_Object__c Obj  : NSAObj){
			allObj.add(Obj.name);
		}
		system.debug('allObj : '+ allObj);
		
		for(NSA_Alert_Sent_To_EmailAddess__c sendtoid : allSendToAddress){
		   sendTo.add(sendtoid.Emailid__c);	
		}
		system.debug('sendTo : '+ sendTo); 
		
		Try{
			allObjPerm = [SELECT id, ParentId, Parent.profile.name, PermissionsModifyAllRecords, PermissionsViewAllRecords, SobjectType 
						 FROM ObjectPermissions 
						 Where SobjectType =: allObj AND (PermissionsViewAllRecords = true OR PermissionsModifyAllRecords = true)
						 Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
						 
			customAppnMngUser = [SELECT name, PermissionsCustomizeApplication,PermissionsManageUsers 
						FROM Profile
						where PermissionsCustomizeApplication = true OR PermissionsManageUsers = true
						Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		
			system.debug('allObjPerm : '+ allObjPerm);
			if(!(allObjPerm.isempty())){
				for(ObjectPermissions ObjPerm:allObjPerm){
					 if(!(exceptionallProfilesModifyAll.containskey(ObjPerm.Parent.profile.name)) && ObjPerm.PermissionsModifyAllRecords == TRUE && ObjPerm.Parent.profile.name != null){
							//allProfiles.add(ObjPerm.Parent.profile.name);
							//msgBody = msgBody + ObjPerm.Parent.profile.name + '\r\n';
							allProfilesModifyAll.add(ObjPerm.Parent.profile.name);
							msgBodyModifyAll = msgBodyModifyAll + ObjPerm.Parent.profile.name + ' - ' + ObjPerm.SobjectType + '\r\n';
					}
					
					if(!(exceptionProfilesViewAll.containskey(ObjPerm.Parent.profile.name)) && ObjPerm.PermissionsViewAllRecords == TRUE && ObjPerm.PermissionsModifyAllRecords == FALSE && ObjPerm.Parent.profile.name != null){
							allProfilesViewAll.add(ObjPerm.Parent.profile.name);
							msgBodyViewAll = msgBodyViewAll + ObjPerm.Parent.profile.name + ' - ' + ObjPerm.SobjectType + '\r\n';
							System.debug('msgBodyViewAll : '+ msgBodyViewAll + 'ObjPerm.Parent.profile.name :'+ ObjPerm.Parent.profile.name);
							
					}
				}
			}
			
			if(!(customAppnMngUser.isempty())){
				for(profile profilePerm:customAppnMngUser){
					 if(!(exceptionProfilesManageUser.containskey(profilePerm.name)) && profilePerm.PermissionsManageUsers == TRUE){
							//allProfiles.add(ObjPerm.Parent.profile.name);
							//msgBody = msgBody + ObjPerm.Parent.profile.name + '\r\n';
							allProfilesManageUsers.add(profilePerm.name);
							msgBodyManageUser = msgBodyManageUser + profilePerm.name + '\r\n';
					}
					
					if(!(exceptionallProfilesCustApp.containskey(profilePerm.name)) && profilePerm.PermissionsCustomizeApplication){
							allProfilesCustApp.add(profilePerm.name);
							msgBodyCustApp = msgBodyCustApp + profilePerm.name + '\r\n';
					}
				}
			}
			
			system.debug('allProfilesModifyAll : '+ allProfilesModifyAll);
			system.debug('allProfilesViewAll : '+ allProfilesViewAll);
			msgBody = 'Recent changes on profile put NSA security at risk, please check below profile permission asap and make necessary changes.' + '\r\n' + '\r\n' ;
			If(!(allProfilesModifyAll.isempty())){
				msgBody =  msgBody + 'Profiles with Modify All permissions : ' + '\r\n' + msgBodyModifyAll + '\r\n' + '\r\n';
					
			}
			If(!(allProfilesViewAll.isempty())){
				 msgBody =  msgBody + 'Profiles with View All permissions : ' + '\r\n' + msgBodyViewAll + '\r\n' + '\r\n'; 
			}  

			If(!(allProfilesManageUsers.isempty())){
				msgBody =  msgBody + 'Profiles with Manage Users permissions : ' + '\r\n' + msgBodyManageUser + '\r\n' + '\r\n';
					
			}
			If(!(allProfilesCustApp.isempty())){
				 msgBody =  msgBody + 'Profiles with Customize App permissions : ' + '\r\n' + msgBodyCustApp; 
			} 
				Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
				//message.setTemplateId('');
				//message.toAddresses = new String[] { 'sonali.j.kothaval@accenture.com', 'kothavale.sonali@gmail.com' }; 
				message.toAddresses = sendTo;
				message.optOutPolicy = 'FILTER';
				message.OrgWideEmailAddressId = Label.OrgwideEmailID;
				
				if(!(allProfilesModifyAll.isempty()) || !(allProfilesViewAll.isempty()) || !(allProfilesManageUsers.isempty()) || !(allProfilesCustApp.isempty())){
					//message.plainTextBody = 'Resent changes on profile put NSA security at risk please check below profile permission asap and make necessary changes.' + '\r\n' + '\r\n' + 
					//'Profiles with Modify All permissions : ' + '\r\n' +
					//msgBodyModifyAll + '\r\n' + '\r\n' +
					//'Profiles with View All permissions : ' + '\r\n' +
					//msgBodyViewAll 
					message.plainTextBody = msgBody;
					message.subject = 'Need Immediate Attention : NSA Security Alert';
				}
				else{
					message.plainTextBody = 'System check for NSA Security on profile permissions is successfully completed and there is no risk identified';
					message.subject = 'NSA Security Check Successfull';
				}
				Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
				Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
	
				if (results[0].success) {
					System.debug('The email was sent successfully.');
				} 
				else {
					System.debug('The email failed to send: ' + results[0].errors[0].message);
				}
			
		}
		 catch(Exception ex) {
			ExceptionHandler.addException(ex, '',  'CheckNSASecurity');
		}
	}
   }