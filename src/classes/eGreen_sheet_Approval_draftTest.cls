/** 
* File Name: eGreen_sheet_Approval_draftTest
* Description: Test Method
* Test Method for  Delegate_Confirmation_ACL
* Copyright : Wipro Technologies Limited Copyright (c) 2010 * 
* @author : Wipro
* Modification Log 
* =============================================================== 
* Ver   Date        Author      Modification 
* --- ---- ------ ------------- ---------------------------------
* 1.0  Wipro  Created 
*/ 
@isTest
public class eGreen_sheet_Approval_draftTest
{
 //Test method for eGreen_sheet_Approval_draft
  static testMethod void testeGreen_sheet_Approval_draft(){
Profile pf= [select id from Profile where name = 'System Administrator'];
User usr = new User(LastName = 'Test UserEgreen',Username = 'tu1egreen@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,
CommunityNickname= 'tu1cso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
insert usr;
// Creating workflow and history object
Workflow_details__c wf= new Workflow_details__c(ATR__c=true,Exposed_Cost__c=5000,Exposed_Cost_Max_Year_K__c=10000,
Front_End_Loss__c=5000,Front_End_Loss_Max_Year__c=10000,X5_Year_Revenue_K__c=5000);
insert wf;

Save_As_Draft__c savDr= new Save_As_Draft__c(Business_Approver1__c='test',Workflow_details__c=wf.Id);
 insert savDr;
 
 PageReference pageRef = Page.Approval_greenSheet_draft;
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController con = new ApexPages.StandardController(new Save_As_Draft__c());
  
  pageRef.getParameters().put('Id',savDr.Id);
    test.startTest();

eGreen_sheet_Approval_draft wrkDetails=new eGreen_sheet_Approval_draft(con);
  wrkDetails.getWFRec();
  wrkDetails.Cancel(); 
   wrkDetails.Edit();
 
  
    test.stoptest();
  
  }
}