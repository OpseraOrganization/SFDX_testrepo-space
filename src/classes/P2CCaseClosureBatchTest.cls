@isTest
public class P2CCaseClosureBatchTest {
    
    @TestSetup
    public static void testSetup(){
        account testAccount = (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account Energy',
                    account.type => 'Energy',
                    account.Customer_Status__c =>'Active',
                    account.Strategic_Business_Unit__c => 'BGA',
                    account.CBT__c => 'Airbus',
                    account.Region_Name__c => 'Americas',
                    account.Sub_Region_Name__c => 'Canada',
                    account.Service_Level__c => 'Refer to Network', 
                    account.Type => 'OEM',
                    account.REPORT_ACCOUNT_NAME__c => 'Test Account',
                    account.Market_Name__c => 'Marine',
                    account.CBT_Team__c=>'Americas'         
                    });  
        contact testContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.LastName => 'test',
                    contact.FirstName => 'Contact',
                    contact.AccountId => testAccount.Id,
                    contact.Primary_Email_Address__c => 'test.contact@nttdata.com',
                    contact.Address_Line_1__c=>'Address 1',
                    contact.Address_Line_2__c=>'Address 1',
                    contact.Address_Line_3__c=>'Address 1',
                    contact.City_Name__c=>'MN',
                    contact.State_Code__c=>'55667',
                    contact.Country_Name__c=>'USA',
                    contact.Email=>'test.contact@HONEYWELL.COM'
                    });         
        Case testCase = (Case)SObjectFactory.create(
            Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => UserInfo.getUserId(), 
                    Case.recordtypeid => schema.sobjectType.case.getRecordTypeInfosByName().get('AOG').getRecordTypeId(), 
                    Case.Iscompliance__c => false,
                    Case.Export_Compliance_Content_ITAR_EAR__c => 'No',
                    Case.Government_Compliance_SM_M_Content__c => 'No',
                    case.status=>'Propose to Close',
                    case.p2c_sent__c=>1,
                    Case.contactId=>testcontact.id,
                    case.AccountId=>testAccount.Id
                    }
        );
    }
    
    @isTest
    public static void testP2CCaseClosurMethod(){
        test.startTest();
        P2CCaseClosureBatch batch=new P2CCaseClosureBatch();
        String sch = '0 0 23 * * ?'; 
        system.schedule('P2CCaseClosureBatch', sch, batch); 
        database.executeBatch(new P2CCaseClosureBatch(),1);
        test.stopTest();
        system.assertEquals(1,([select id from case where status='Closed-No Response']).size());
    }
}