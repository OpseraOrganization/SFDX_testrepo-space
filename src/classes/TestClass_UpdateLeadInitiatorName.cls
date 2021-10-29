/** * File Name:  TestClass_ApexTrigger_LeadTriggTest
* Description Test Method
* Class Tested: updateOtherObjectsAfterConversion , leadAircraftUpdate ,sendEmailToLead
* Copyright : Wipro Technologies Limited Copyright (c) 2011
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */
@isTest (seealldata=true)
private class TestClass_UpdateLeadInitiatorName {

    static testMethod void leadTriggTestTest() {
            
            
            string uid = label.SFDC_Admin;
                Contact tstCon =[Select id,Honeywell_ID__c from contact where (not email like '%@honeywell.com') and Honeywell_ID__c != '' and  CreatedDate > 2015-08-03T05:35:18.000+0000 limit 1];
            
                User u = [Select id from user where id =: uid];
            System.runAs(u) {
                Test.startTest();   
                Lead tstLead= new Lead(     
                    Description='Test Lead',
                    Regional_Sales_Manager__c='Andy Gill', 
                    Contact__c=tstCon.Id,
                    recordtypeid = label.ATR_Lead_Recordtype,
                    Company='Honeywell',  
                    Status='Open',
                    firstname='Test',
                    LastName='Contact Inactive' ,
                    Title='Mr.',
                    CreatedDate=system.today()-1,
                    //Opportunity_Name__c=tstOpp3.id, 
                    Primary_Fax_Number__c='112875739',
                    Email='Test@Test.com',
                    Service_Bulletins__c = 'tstlead'                    
                   
                );
                insert tstLead;
                
                Lead tstLead1= new Lead(     
                    Description='Test Lead',
                    Regional_Sales_Manager__c='Andy Gill', 
                    Honeywell_ID__c=tstCon.Honeywell_ID__c,
                    recordtypeid = label.ATR_Lead_Recordtype,
                    Company='Honeywell',  
                    Status='Sales Accepted Leads (SAL)',
                    firstname='Test',
                    LastName='Contact Inactive' ,
                    Title='Mr.',
                    LeadSource = 'Honeywell.com.cn',
                    CreatedDate=system.today()-1,
                    //Opportunity_Name__c=tstOpp3.id, 
                    Primary_Fax_Number__c='112875739',
                    Email='Test@Test.com',
                    Service_Bulletins__c = 'tstlead1'                     
                   
                );
                insert tstLead1;
                
                    Lead tstLead2= new Lead(     
                    Description='Test Lead',
                    Regional_Sales_Manager__c='Andy Gill', 
                    Honeywell_ID__c=tstCon.Honeywell_ID__c,
                    recordtypeid = label.ATR_Lead_Recordtype,
                    Company='Honeywell',  
                    Status = 'Sales Accepted Leads (SAL)',
                    firstname='Test',
                    LastName='Contact Inactive' ,
                    Title='Mr.',
                    CreatedDate=system.today()-1,
                    LeadSource = 'Gulfstream OEM',
                    //Opportunity_Name__c=tstOpp3.id, 
                    Primary_Fax_Number__c='112875739',
                    Email='Test@Test.com',
                    Service_Bulletins__c = 'tstlead1'                     
                    
                );
                insert tstLead2;
                
                Lead tstLead3= new Lead(     
                    Description='Test Lead',
                    Regional_Sales_Manager__c='Andy Gill', 
                    Honeywell_ID__c=tstCon.Honeywell_ID__c,
                    recordtypeid = label.ATR_Lead_Recordtype,
                    Company='Honeywell',  
                    Status = 'Sales Qualified Lead (SQL)',
                    firstname='Test',
                    LastName='Contact Inactive' ,
                    Title='Mr.',
                    CreatedDate=system.today()-1,
                    LeadSource = 'Gulfstream OEM',
                    //Opportunity_Name__c=tstOpp3.id, 
                    Primary_Fax_Number__c='112875739',
                    Email='Test@Test.com',
                    Service_Bulletins__c = 'tstlead1'                     
                    
                );
                insert tstLead3;
                
                Test.stopTest();
         }       
    }
}