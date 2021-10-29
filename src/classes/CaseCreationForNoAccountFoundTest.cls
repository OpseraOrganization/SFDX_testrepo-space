/**************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : CaseCreationForNoAccountFoundTest
* Description           : Test Class for Case Creation where account is No Account
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* Nov-08-2013      1.0            Anusuy Murugiah       Wrapping the testmethod with Start and Stop
**************************************************************************************************/
@isTest
private class CaseCreationForNoAccountFoundTest{

    static testMethod void myUniTest(){
        Test.startTest();
        Integer eCount = 0;
        List<Case> cases=new List<Case>();
        List<Task> task1=new List<Task>();
        List<Case> casetoUpdate= new List<Case>();
        
        Account acc = new Account();
        acc.Name = 'No Account Found';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'NO ACCOUNT FOUND';
        acc.Market_Name__c = 'Marine';
        
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Singh';
        con.FirstName = 'Kapil';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'kapil.nowhere@gmail.com';
        con.Email='kapil.nowhere@gmail.com';
        insert con;
        
        Id rt = [Select Id from recordType where Name = 'Customer Master Data'].Id;
        List<Contact> lstContacts = new List<Contact>();
        lstContacts.add(con);
        List<Case> cs = new List<Case>();
        if(lstContacts.size() > 0){
        for(integer i=0;i<lstContacts.size();i++){
            if(lstContacts[i].Account_Name__c == 'NO ACCOUNT FOUND'){
            Case cse = new Case();
                cse.Origin = 'Fax';
                cse.Status = 'New';
                cse.RecordTypeId = rt;
                cse.Classification__c = 'Customer Master Team / eBusiness';
                cse.ContactId = lstContacts[i].Id;
                cse.Type_of_Change__c = 'New Account';
                cse.Type = 'Other';
                cse.Export_Compliance_Content_ITAR_EAR__c = 'NO';
                cse.Government_Compliance_SM_M_Content__c = 'NO';
                cs.add(cse);
        
            }
        }
        try {
            if(cs.size() > 0){
            insert cs;
        }
        }catch(Exception ex){}
        }
        Test.stopTest();
    
    }
}