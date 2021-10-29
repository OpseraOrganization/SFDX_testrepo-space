/** 
* File Name: CustomizeApproval_egreensheetTest
* Description: Test Method
* Test Method for  CustomizeApproval_egreensheet
* Copyright : Wipro Technologies Limited Copyright (c) 2010 * 
* @author : Wipro
* Modification Log 
* =============================================================== 
* Ver   Date        Author      Modification 
* --- ---- ------ ------------- ---------------------------------
* 1.0  Wipro  Created 
*/ 
@isTest
public class CustomizeApproval_egreensheetTest
{
    //Test method for CustomizeApproval_egreensheet
    static testMethod void testCustomizeApproval_egreensheetTest(){
        
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(LastName = 'Test UserEgreen',Username = 'tu1egreen@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,
                            CommunityNickname= 'tu1cso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
                            ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr;
        // Creating workflow and history object
        Workflow_details__c wf= new Workflow_details__c(ATR__c=true,Exposed_Cost__c=5000,Exposed_Cost_Max_Year_K__c=10000,
                                                        Front_End_Loss__c=5000,Front_End_Loss_Max_Year__c=10000,X5_Year_Revenue_K__c=5000);
        insert wf;
        
        
        WorkFlow_Approval_History__c wfHistory= new WorkFlow_Approval_History__c(Workflow_details__c=wf.Id,
                                                                                 Approval_Status__c='Approved');
        insert wfHistory;
        
        PageReference pageRef = Page.Approval_comment_vf; 
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardController con = new ApexPages.StandardController(new WorkFlow_Approval_History__c());  
        pageRef.getParameters().put('WFAppRec',wfHistory.Id);   
        pageRef.getParameters().put('WFAccepted','True'); 
        test.startTest();
        CustomizeApproval_egreensheet wrkDetails=new CustomizeApproval_egreensheet(con);   
        wrkDetails.getWFAppRec1();
        wrkDetails.setWFAppRec1();
        wrkDetails.ok();
        pageRef.getParameters().put('WFRejected','True');  
        wrkDetails.ok();
        
        test.stopTest();        
        
    }
    
    static testMethod void testCustomizeApproval_egreensheetTest1(){
        
        Profile pf1= [select id from Profile where name = 'System Administrator'];
        User usr1 = new User(LastName = 'Test UserEgreen',Username = 'tu1egreen@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,
                             CommunityNickname= 'tu1cso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
                             ProfileId = pf1.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr1;
        // Creating workflow and history object
        Workflow_details__c wf1= new Workflow_details__c(ATR__c=true,Exposed_Cost__c=5000,Exposed_Cost_Max_Year_K__c=10000,
                                                         Front_End_Loss__c=5000,Front_End_Loss_Max_Year__c=10000,X5_Year_Revenue_K__c=5000);
        insert wf1;        
        
        WorkFlow_Approval_History__c wfHistory1= new WorkFlow_Approval_History__c(Workflow_details__c=wf1.Id,
                                                                                  Approval_Status__c='Rejected');
        insert wfHistory1;
        
        PageReference pageRef1 = Page.Approval_comment_vf; 
        Test.setCurrentPage(pageRef1); 
        ApexPages.StandardController con = new ApexPages.StandardController(new WorkFlow_Approval_History__c());  
        pageRef1.getParameters().put('WFAppRec',wfHistory1.Id);   
        pageRef1.getParameters().put('WFRejected','True'); 
        test.startTest();
        CustomizeApproval_egreensheet wrkDetails=new CustomizeApproval_egreensheet(con);   
        wrkDetails.getWFAppRec1();
        wrkDetails.setWFAppRec1();
        wrkDetails.ok();
        test.stopTest();        
        
    }
}