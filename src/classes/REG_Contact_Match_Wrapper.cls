public class REG_Contact_Match_Wrapper {
    Public String accountId;
    Public Boolean isHolding;
    Public String contactId;
    Public String accountName;
    Public String firstName;
    Public String lastName;
    Public String addressLine1;
    Public String addressLine2;
    Public String addressLine3;
    Public String addressType;
    Public String city;
    Public String country;
    Public String countryCode;
    Public Boolean isPrimary;
    Public String postalCode;
    Public String stateCode;
    Public String emailId;
    Public String employeeNumber;
    Public String companyName;
    Public String function;
    Public String jobTitle;
    Public String orgLevel;
    Public String phone;
    Public String phoneExt;
    Public String mobile;
    Public string fax;
    Public string honId;
    Public string seibelAccountId;
     
  
    Public REG_Contact_Match_Wrapper(contact Contacts){
        
        this.accountId = Contacts.AccountId;
        this.isHolding = (Contacts.AccountId !=Null && Contacts.Account.ATR_Portal_Access_Template__c == system.label.REG_IS_HOLDING_ACCOUNTID)? true : false;
        this.seibelAccountId = Contacts.Account.Sbl_Account_Row_Id__c;
        this.accountName = Contacts.Account.Name;
        this.contactId = Contacts.Id;
        this.firstName = Contacts.FirstName;
        this.lastName = Contacts.LastName;
        this.emailId = Contacts.Primary_Email_Address__c;
        this.employeeNumber = Contacts.Employee_Number__c;
        this.companyName = Contacts.Portal_Company_Name__c;
        this.function = Contacts.Contact_Function__c;
        this.jobTitle = Contacts.Job_Title__c;
        this.orgLevel = Contacts.Organizational_Level__c;
        this.phone = Contacts.Phone_1__c;
        this.phoneExt = Contacts.Phone_1_Ext__c;
        this.mobile = Contacts.MobilePhone; 
        this.honId= Contacts.Honeywell_ID__c;
        this.fax = Contacts.fax;
        If(Contacts.Contact_Addresses__r.size() > 0){
            this.addressLine1 = Contacts.Contact_Addresses__r[0].Reporting_Street_Address_Line_1__c;
            this.addressLine2 = Contacts.Contact_Addresses__r[0].Reporting_Street_Address_Line_2__c;
            this.addressLine3 = Contacts.Contact_Addresses__r[0].Reporting_Street_Address_Line_3__c;
            this.addressType = Contacts.Contact_Addresses__r[0].Address_Type__c;
            this.city = Contacts.Contact_Addresses__r[0].Reporting_City_Name__c;
            this.country = Contacts.Contact_Addresses__r[0].Reporting_Country_Name__c;
            this.countryCode = Contacts.Contact_Addresses__r[0].Report_Country_Codes__c;
            this.isPrimary = Contacts.Contact_Addresses__r[0].Is_Primary_Address__c;
            this.postalCode = Contacts.Contact_Addresses__r[0].Reporting_Address_Postal_Code__c;
            this.stateCode = Contacts.Contact_Addresses__r[0].Reporting_Address_State_Code__c;
        }
        
    } 
    
    Public REG_Contact_Match_Wrapper(contact Contacts,list<account> accAdd){
        
        this.accountId = Contacts.AccountId;
        this.isHolding = (Contacts.AccountId !=Null && Contacts.Account.ATR_Portal_Access_Template__c == system.label.REG_IS_HOLDING_ACCOUNTID)? true : false;
        this.seibelAccountId = Contacts.Account.Sbl_Account_Row_Id__c;
        this.accountName = Contacts.Account.Name;
        this.contactId = Contacts.Id;
        this.firstName = Contacts.FirstName;
        this.lastName = Contacts.LastName;
        this.emailId = Contacts.Primary_Email_Address__c;
        this.employeeNumber = Contacts.Employee_Number__c;
        this.companyName = Contacts.Portal_Company_Name__c;
        this.function = Contacts.Contact_Function__c;
        this.jobTitle = Contacts.Job_Title__c;
        this.orgLevel = Contacts.Organizational_Level__c;
        this.phone = Contacts.Phone_1__c;
        this.phoneExt = Contacts.Phone_1_Ext__c;
        this.mobile = Contacts.MobilePhone; 
        this.honId= Contacts.Honeywell_ID__c;
        this.fax = Contacts.fax;
        If(accAdd.size() > 0){
            this.addressLine1 = accAdd[0].Account_Address__r[0].Report_Address_Line_1__c;
            this.addressLine2 = accAdd[0].Account_Address__r[0].Report_Address_Line_2__c;
            this.addressLine3 = accAdd[0].Account_Address__r[0].Report_Address_Line_3__c;
            this.addressType = accAdd[0].Account_Address__r[0].Address_Type__c;
            this.city = accAdd[0].Account_Address__r[0].Report_City_Name__c;
            this.country = accAdd[0].Account_Address__r[0].Report_Country_Name__c;
            this.countryCode = accAdd[0].Account_Address__r[0].Report_Country_Codes__c;
            this.isPrimary = accAdd[0].Account_Address__r[0].Is_Primary_Address__c;
            this.postalCode = accAdd[0].Account_Address__r[0].Report_Postal_Code__c;
            this.stateCode = accAdd[0].Account_Address__r[0].Report_State_Code__c;
        }
        
    }
    
     
         
}