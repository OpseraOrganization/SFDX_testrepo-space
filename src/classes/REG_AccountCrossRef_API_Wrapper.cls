public class REG_AccountCrossRef_API_Wrapper {
    public String siebelRowId{get;set;}
    public String accountId{get;set;}
    public String soldToId{get;set;}
    public String accountName{get;set;}
    public String city{get;set;}
    public String country{get;set;}
    public String soldToIdUiDisplay{get;set;}
    public string contactId = '';
    public String isSelected{get;set;}
    public list<String> soldtoToolAccess;
    
    public REG_AccountCrossRef_API_Wrapper(Account_Cross_Ref__c accCrossRef, string conId,string selected,list<String> soldToToolAccess){
        this.siebelRowId = accCrossRef.Sbl_Account_Row_ID__c;
        this.accountId = accCrossRef.Account_Name__c;
        this.soldToId = accCrossRef.External_Account_ID__c;
        this.accountName = accCrossRef.External_Account_Name__c;
        this.city = accCrossRef.External_City_Name__c;
        this.country = accCrossRef.External_Country_Name__c;
        this.soldToIdUiDisplay = accCrossRef.External_Account_ID__c != null?accCrossRef.External_Account_ID__c.replace('-01',''):null;
        this.contactId = conId;
        this.isSelected= selected;
        if(!soldToToolAccess.isEmpty()){
        this.soldtoToolAccess = soldToToolAccess;
        }
    }
}