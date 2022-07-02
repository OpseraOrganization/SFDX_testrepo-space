/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:			ShareSupportAsset 
Description:	 ShareSupportAsset  class to share assets 
Date			 Version		 Author							 Summary of Changes 
-----------	  ----------	  -----------------	---------------------------------------------------------------------------------------------------
05/10/2017		 1.0			Supriyam			   Initial Release for sahre document

----------------------------------------------------------------------------------------------------------------------------------------------------------*/
public with sharing class ShareSupportAsset {
	/**
* Description : Method to getContentDetails
* @param Id to get document details
* @return String to with conDetails
* @throws NA
**/
	@AuraEnabled  
	public static contentdocument getContentDetails(Id parentId) {
		contentdocument conDetails;
		conDetails=[SELECT Id,ContentSize,Description,FileExtension,FileType,Owner.Name,Title,LastModifiedDate FROM ContentDocument WHERE Id =:parentId LIMIT 1];
		return conDetails;
	}
	/**
* Description : Method to getuserDetail from DocumentShare__c
* @param Id to get User details
* @return List to with recordList
* @throws NA
**/
	@AuraEnabled  
	public static List<DocumentShare__c> getuserDetail(id UserId,String DocumentId) {
		List<DocumentShare__c> recordList=new  List<DocumentShare__c>();
	   // DocumentShare__c record;
		try{
			recordList=[SELECT id, Document_Id__c,Like__c,SharingUser__c,Liked_By__c,Shared_WIth__c FROM DocumentShare__c WHERE SharingUser__c =:UserId AND Document_Id__c =:DocumentId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	  }catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.ShareSupportAsset,PRMGlobalConstants.getuserDetail);   
		} 
		system.debug('recordList creation '+recordList);
		return recordList;
		
	   
	}
	
	/**
* Description : Method to setLikeRecord
* @param Id to get User setLikeRecord
* 
* @throws NA
**/
	@AuraEnabled  
	public static void setLikeRecord(Id UserId,contentdocument documentDetails,Boolean flag,String DocumentId,String artiURL,String usertype,User senderData) {
		DocumentShare__c docRecord=new DocumentShare__c();
		try{
			docRecord.Liked_By__c=UserId;
			system.debug('UserId'+ docRecord.Liked_By__c);
			docRecord.Like__c=flag;
			docRecord.Document_Id__c=DocumentId;
			docRecord.Article_URL__c=artiURL;
			docRecord.User__c = usertype;
			docRecord.Liked_By__c = senderData.id;
			docRecord.SharingUser__c = senderData.id;
			docRecord.Support_Asset_Last_Modified_Date__c=documentDetails.LastModifiedDate;
			system.debug('Support_Asset_Last_Modified_Date__c'+docRecord.Support_Asset_Last_Modified_Date__c);
			Integer i1 = artiURL.lastIndexOf(PRMGlobalConstants.Slash)+1;
			system.debug('i1'+i1);
			docRecord.Article_Name__c=artiURL.substring(i1);
		  /*  Integer i1 = artiURL.lastIndexOf(PRMGlobalConstants.Slash)+1;
			if(artiURL.indexOf(PRMGlobalConstants.UrlID)>-1)
			{
				Integer i2 = artiURL.lastIndexOf(PRMGlobalConstants.QuestionMark);
				docRecord.Article_Name__c=artiURL.substring(i1,i2);
			}
			else{
				docRecord.Article_Name__c=artiURL.substring(i1);
			}*/
		   
			system.debug('Article_Name__c::'+ docRecord.Article_Name__c);
		}catch(System.Exception e){ ExceptionHandler.addException(e,PRMGlobalConstants.ShareSupportAsset,PRMGlobalConstants.setLikeRecord);	
		}
		insert docRecord;
		system.debug('docRecord'+docRecord); 
	}
	/**
* Description : Method to getuserDetail as current logged in
* @param Id to get User details
* @return User  with toReturn
* @throws NA
**/
	@AuraEnabled  
	public static User getCurrentUser(){
		User toReturn;
		String sProfile = PRMGlobalConstants.uProfile;
		try{
			toReturn = [SELECT Id, Name, FirstName,Email,Contact.Account.Name, MobilePhone,IsPortalEnabled,LastName, Profile.Name ,
						Phone FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
		}
		Catch(System.Exception e) {ExceptionHandler.addException(e,PRMGlobalConstants.ShareSupportAsset,PRMGlobalConstants.getCurrentUser); 
		}
		return toReturn;
	}
	// get all emails of partner user's account
	// based on object name and field api name
	@AuraEnabled
	public static List<String> getDatavalues(sObject objName, String field_apiname){
		List<String> optionlist = new List<String>();
		try{
			List<User> acc=[SELECT AccountId FROM User WHERE Id =:UserInfo.getUserId() LIMIT 1];
			LIST<User> UserDetails = new LIST<User>();
			Set<id> contactId=new Set<id>();
			if(acc[0].AccountId != null)
			{
				Account conid=[SELECT Id,Name,(SELECT Id FROM Contacts) FROM Account where id =:acc[0].AccountId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
				for(Contact c:conid.Contacts){
					contactId.add(c.Id);
				}
			   if(contactId.size() >0)
			   {
				for(User uData : [Select id,Email from user where contactid in: contactId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
					optionlist.add(uData.Email);
				} }
			}else{
				
			}
		}catch(System.Exception e){ ExceptionHandler.addException(e,PRMGlobalConstants.ShareSupportAsset,PRMGlobalConstants.getDatavalues);   
		}
		return optionlist;
	}
	// mthod to share document link with users.
	// also create record for the document which have been shared with user
	@AuraEnabled  
	public static void sendMailToUser(List<string> mMail ,String mSubject ,String mbody,contentdocument documentDetails,User senderData, String artiURL){
		List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>(); 
		LIST<DocumentShare__c> DCData = new LIST<DocumentShare__c>();
		try{
			// Step 1: Create a new Email
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			// Step 2: Set list of people who should get the email
			mail.setToAddresses(mMail);
			// Step 3: Set who the email is sent from
			mail.setReplyTo(senderData.Email); // change it with your mail address.
			mail.setSenderDisplayName(senderData.Name); 
			// Step 4. Set email contents - you can use variables!
			mail.setSubject(PRMGlobalConstants.MailSubject);
			String Url=System.Label.Share_Support_Label+PRMGlobalConstants.Slash+documentDetails.Id;
			
			if(senderData.IsPortalEnabled != true){
			mail.setHtmlBody(mail.plainTextBody=senderData.Name+PRMGlobalConstants.Has_recommended+PRMGlobalConstants.LineBreak+PRMGlobalConstants.DocName+
						' <a href='+Url+'>'+documentDetails.Title+'</a>'+ PRMGlobalConstants.LineBreak
				+PRMGlobalConstants.LineBreak+
				PRMGlobalConstants.Thanks +PRMGlobalConstants.LineBreak  
				+PRMGlobalConstants.NokiaTeam);	
			
			}else{
				  mail.setHtmlBody(mail.plainTextBody=senderData.Name+PRMGlobalConstants.OfValue+senderData.Contact.Account.Name+PRMGlobalConstants.Has_recommended+PRMGlobalConstants.LineBreak+
									+PRMGlobalConstants.LineBreak+
								   PRMGlobalConstants.DocName+
						' <a href='+Url+'>'+documentDetails.Title+'</a> '+PRMGlobalConstants.LineBreak+
								   +PRMGlobalConstants.LineBreak+
				PRMGlobalConstants.Thanks +PRMGlobalConstants.LineBreak  
				+PRMGlobalConstants.NokiaTeam); 
			}
			// Step 5. Add your email to the master list
			mails.add(mail);
			// Step 6: Send all emails in the master list
			Messaging.sendEmail(mails);
			
			for(Integer i=0; i<mMail.size();i++){
				DocumentShare__c docRecord=new DocumentShare__c(); 
				docRecord.SharingUser__c=senderData.Id;
				docRecord.Document_Id__c=documentDetails.Title;
				docRecord.Shared_WIth__c=mMail[i];
				docRecord.Time_When_Shared__c=System.now(); 
				docRecord.Support_Asset_Last_Modified_Date__c=documentDetails.LastModifiedDate;
				docRecord.Content_Document_ID__c=documentDetails.Id;
				docRecord.Article_URL__c=artiURL; 
		  Integer i1 = artiURL.lastIndexOf(PRMGlobalConstants.Slash)+1;
			  //  system.debug('Article_Name__c'+i1);
			   if(artiURL.indexOf(PRMGlobalConstants.UrlID)>-1)
			   {
				  Integer i2 = artiURL.lastIndexOf(PRMGlobalConstants.QuestionMark);
				  docRecord.Article_Name__c=artiURL.substring(i1,i2);
			   }
				else{
				docRecord.Article_Name__c=artiURL.substring(i1);
				}
				DCData.add(docRecord);
				}
		}catch(System.Exception e){ ExceptionHandler.addException(e,PRMGlobalConstants.ShareSupportAsset,PRMGlobalConstants.sendMailToUser);   
		}
		insert DCData;
	}
	
}