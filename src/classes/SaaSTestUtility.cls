/** 
 *  Author : Accenture 
 *  Description : Test Utility Class
 *  Created Date : 11\06\2015
 * 
 *  Version History :
 *  Date			  Changes 
 *  08\06\2015		created 
 *
 */
@isTest
public class SaaSTestUtility
 
{

  public static Release__c rel; 
  public static User_Story__c us; 
  public static Capability__c fel;
  
	public static User userCreation(){
		 Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		Id sp = [SELECT Id FROM profile WHERE name = 'System Administrator' limit 1].id;
		//Id role = [select userroleid from User where UserRole.name =: roleName limit 1].id;

			User user = new User(alias = 'abc', email = 'Email' + Math.floor(Math.random()*1000) + '@test.com', emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
			languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = sp,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
			timezonesidkey = 'America/Los_Angeles', Username = 'User' + Math.floor(Math.random()*1000) + '@test.com',Restriction_Level__c = 'Confidential', Nokia_ID__c = randomInt + '0' );
			insert user;
		return user;
	}
  
	public static Issues_Risks__c createIssue()
	{
		  
		 RecordType recordTypeObj = [SELECT id,DeveloperName,Name,SobjectType FROM RecordType where SobjectType = 'Issues_Risks__c' and DeveloperName = 'Issue' LIMIT 1]; 
		 Issues_Risks__c issue = new Issues_Risks__c();
		 issue.Priority__c = 'High';
		 issue.Status__c ='Open';
		 issue.Description__c ='Test Description';
		 issue.Target_Resolution_Date__c = System.today()+7;
		 issue.recordTypeid = recordTypeObj.id;
		 issue.release__c=createRelease().id;
		 insert issue;
		 return issue;
	}
	
	public static Question_Log__c createSaaSQuestion()
	{
		Question_Log__c questLog = new Question_Log__c();
		questLog.Submitter__c = Userinfo.getUserId();
		questLog.Question__c = 'Test description ';
		insert questLog;
		return questLog;
	}
	public static Question_Log__c createValueDeliveryQuestion()
	{
		Question_Log__c questLog = new Question_Log__c();
		questLog.Submitter__c = Userinfo.getUserId();
		questLog.Question__c = 'Test description ';
		questLog.Scope__c = 'Scope Phase';											  
		questLog.Domain__c = 'Account Management';
		questLog.recordTypeID =SaaSUtility.getRecordTypeID('Question_Log__c','Value_Delivery_Question_Log')  ;
		insert questLog;
		return questLog;
	}
	public static Request__c createRequest()
	{
		Request__c req = new Request__c();
		req.Request_Title__c= 'test';
		req.Technical_Description__c= 'abc';
		req.Request_Description__c ='Desc';
		req.Request_Type__c= 'Custom Code';
		req.Status__c = 'Red';
		req.User_Story__c= createUserStory().ID;
		req.DeveloperAssigned__c=userCreation().ID;
		insert req;
		return req;
	
	}
	
	public static Release__c  createRelease()
	{
		rel = new Release__c();
		rel.Name = 'Test Release ';
		rel.Release__c = 24;
		rel.Plan_Start_Date__c = System.today();
		rel.Release_Planned_End_Date__c = System.today() + 10;
		rel.Status__c = 'Red';
		rel.Description__c = 'Test description ';
		rel.Status_Update__c = 'Test Comments';
		insert rel;
		return rel;
	}
	
	
	 public static  Capability__c createFeature()
	{
		rel = new Release__c();
		rel.Name = 'Test Release ';
		rel.Release__c = 24;
		rel.Plan_Start_Date__c = System.today();
		rel.Release_Planned_End_Date__c = System.today() + 10;
		rel.Status__c = 'Red';
		rel.Description__c = 'Test description ';
		rel.Status_Update__c = 'Test Comments';
		insert rel;
		
	   fel = new Capability__c();
	   fel.Name='Competitors Management';
	   fel.Release__c=rel.id;
	   fel.Feature_Category__c='Lead Management';
	   fel.Workstream__c='3-Sales Process';
	   fel.Team__c='Sales Process';
	   fel.CurrencyIsoCode='EUR';
		insert fel;
		return fel;
	}
	
	
	
	
	
	
	
	
	public static Key_Action_Decision__c createKeyAction()
	{
		Key_Action_Decision__c key = new Key_Action_Decision__c();
		key.Name = 'Test Clone';
		key.Priority__c = 'High';
		key.Due_Date__c = System.today() + 10;
		//key.RecordType.Name= 'Action Item';
		key.Status__c = 'Completed';
		key.Description__c = 'Test description ';
		key.Decision_Outcome__c= 'Test Comments';
		insert key;
		return key;		
	} 
	public static User_Story__c createUserStory()	
	{
		us = new User_Story__c();
		us.name = 'Test Story';		
		us.Release__c = createRelease().id;
		us.User_Story_Description__c = 'Test Description';
		us.Capability__c = createFeature().id;		
		insert us;
		return us;
	}
	public static Value_Delivery_Session__c  createValueDeliverySession ()	
	{
		Value_Delivery_Session__c  tus = new Value_Delivery_Session__c();
		tus.name = 'Test Story';
		tus.Releases__c = rel.id;

		insert tus;
		return tus;
	}
	
	
	
  /*  public static Response__c  createQuestionResponse()
	{
		Question_Log__c questionLogObj = createSaaSQuestion();
		Response__c resp = new  Response__c ();
		resp.Response__c  = 'Test Response';
		resp.user__c = userInfo.getUserId();
		questionLogObj.Question__c = 'sample question'; 
		resp.Question_Log__c = questionLogObj.Id;   
		insert resp;
		return resp;
	}
	
	public static Ratings__c createRating()
	{
		Response__c resp =  createQuestionResponse();
		Ratings__c rating = new  Ratings__c();
		rating.Rating__c = '3';
		resp.Response__c = 'test';
		rating.user__c = userInfo.getUserId();
		rating.Response__c = resp.Id;
		insert rating;
		return rating;
	}*/
	
}