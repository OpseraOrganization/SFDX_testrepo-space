@isTest
private class NotifyWST_EmailChangedTest {

    static testMethod void myUnitTest() {
        Test.startTest();
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        
        insert acc;
        
        Contact cont = new Contact();
        cont.LastName = 'Singh';
        cont.FirstName = 'Kapil';
        cont.AccountId = acc.Id;
        cont.Email = 'kapil.singh@honeywell.com';
        cont.employee_number__C = 'E123123';
        cont.Primary_Email_Address__c = 'kapil.singh@honeywell.com';
        List<String> oldEmail = new List<String>();
        List<String> newEmail = new List<String>();
        insert cont;
        
        Portal_Honeywell_ID__c phid = new Portal_Honeywell_ID__c();
        phid.Contact__c = cont.Id;
        phid.Email_Address__c = 'kapil.singh@honeywell.com';
        phid.Name = 'Test portal honeywell id name';
        
        insert phid;
        
        List<ID> contactId = new List<ID>();
        contactId.add(cont.Id);
        
        Contact contact = [Select Id, Email from Contact where Id in : contactId];
        contact.Email = 'kapil.singh@honeywell.com';
        contact.Primary_Email_Address__c = 'kapil.singh@honeywell.com.com123';
        
        try {
            update contact;
        
        
        if(contactId.size()>0)
        {
            List <Portal_Honeywell_ID__c> portalHID = [select Id from Portal_Honeywell_ID__c where Contact__c in : contactId ];
            sendEmail se = new sendEmail();
            oldEmail.add(cont.Email);
            newEmail.add(cont.Primary_Email_Address__c);
            integer flag = 0;
            if(portalHID.size()>0){
                if(cont.Email != '' || cont.Primary_Email_Address__c != '' || cont.Alternate_Email_Address__c != ''){
                    //for(Integer j=0;j<contact.size();j++){
                        if((contact.Email != cont.Email || contact.Primary_Email_Address__c != cont.Primary_Email_Address__c) &&  portalHID.size()>0 ){
                            //flag = 1;
                            se.sendMail(contactId,oldEmail,newEmail);
                        }
                    //}
                }
             }
        }
        
        }catch(Exception ex){
            System.debug('No Email Found for Contact');
        }
        
        Test.stopTest();
    }
}