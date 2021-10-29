/**************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : CaseValidationForReturnRecordTypeTest
* Description           : Test Class for Case Validation For Return RecordType
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* Nov-08-2013      1.0            Anusuy Murugiah       Wrapping the testmethod with Start and Stop
**************************************************************************************************/
@isTest
private class CaseValidationForReturnRecordTypeTest{
static testMethod void myUniTest(){
Test.startTest();	
Account acc = new Account();
acc.Name = 'Honeywell Test';
acc.Customer_Status__c = 'Active';
acc.Strategic_Business_Unit__c = 'ATR';
acc.CBT__c = 'Airbus';
acc.Region_Name__c = 'Americas';
acc.Sub_Region_Name__c = 'Canada';
acc.Service_Level__c = 'Standard';
acc.Type = 'OEM';
acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';

insert acc;

Contact con = new Contact();
con.LastName = 'Singh';
con.FirstName = 'Kapil';
con.AccountId = acc.Id;
con.Primary_Email_Address__c = 'kapil.nowhere@gmail.com';
con.Email='kapil.nowhere@gmail.com';
insert con;
RecordType rt= [select id,name from recordtype where sobjecttype='Case' and name='Returns'];
List<QueueSobject> caseQueueObjs=[Select QueueId, Queue.Name from QueueSobject  where Queue.Name like 'Web%']; 

Case cs = new Case();
cs.Origin = 'Phone';
cs.Status = 'Open';
cs.ContactId = con.Id;
cs.Classification__c = 'GTO Field Service';
cs.HON_Commit_Date__c = System.now() + 1;
cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
cs.Government_Compliance_SM_M_Content__c = 'NO';
cs.recordtypeid=rt.id;
cs.ownerId=caseQueueObjs.get(0).QueueId;
try{
    insert cs;
}catch(Exception e){
System.debug(e.getMessage());
}
Test.stopTest();
}
}