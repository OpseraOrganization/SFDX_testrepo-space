/** 
 *  Author : Accenture 
 *  Description : Test Class for Controller class for SaaSRequestListView  
 *  Created Date : 11\06\2015
 * 
 *  Version History :
 *  Date			  Changes 
 *  08\06\2015		created 
 *
 */
 
@isTest 
public class SaaSRequestListViewCtrlTest
{
	static testMethod void validateRequest() 
	{
		Boolean bool;
		Capability__c objCap = SaaSTestUtility.createFeature();
		
		Release__c rel1 = new Release__c();
		rel1.Name = 'Test Release ';
		rel1.Release__c = 24;
		rel1.Plan_Start_Date__c = System.today();
		rel1.Release_Planned_End_Date__c = System.today() + 10;
		rel1.Status__c = 'Red';
		rel1.Description__c = 'Test description ';
		rel1.Status_Update__c = 'Test Comments';
		insert rel1;
		
	   Capability__c cap = new Capability__c();
	   cap.Name='Competitors Management';
	   cap.Release__c=rel1.id;
	   cap.Feature_Category__c='Lead Management';
	   cap.Workstream__c='3-Sales Process';
	   cap.Team__c='Sales Process';
	   cap.CurrencyIsoCode='EUR';
		insert cap;
		
		User_Story__c objU = new User_Story__c();
		objU.name = 'Test Story';
		objU.Release__c = objCap.Release__c;
		objU.User_Story_Description__c = 'Test Description';
		objU.Capability__c=cap.id;
		insert objU;
		
		Request__c req = new Request__c();
		req.Request_Title__c= 'test';
		req.Technical_Description__c= 'abc';
		req.Request_Description__c ='Desc';
		req.Request_Type__c= 'Custom Code';
		req.Status__c = 'Red';
		req.User_Story__c=objU.ID;
		insert req;
		
		//SaaSTestUtility.createUserStory();
		//SaaSTestUtility.createRequest();
		//SaaSTestUtility.createRequest();
		//SaaSTestUtility.createRequest();
		
		SaaSRequestListViewCtrl ctrlObj = new SaaSRequestListViewCtrl();
		List<SaaSRequestListViewCtrl.RequestWrapper> wraplst = ctrlObj.getrequestWrapLst();
		ctrlObj.first();
		ctrlObj.last();
		ctrlObj.previous();
		ctrlObj.next();
		ctrlObj.updateRequest();
		ctrlObj.cloneRequest();
		ctrlObj.searchtxt = 'test';
		ctrlObj.search();
		bool  =ctrlObj.hasNext;
		bool = ctrlObj.hasPrevious;
		//wraplst.get(0).checked = true ;
		//wraplst.get(1).checked = true ;
		ctrlObj.updateRequest();
		ctrlObj.cloneRequest();
		ctrlObj.deleteRequest();
		
		//wraplst.get(1).checked = false;
		ctrlObj.updateRequest();
		ctrlObj.cloneRequest();
		ctrlObj.deleteRequest();
	}
}