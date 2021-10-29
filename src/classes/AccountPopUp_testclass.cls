@isTest
public class AccountPopUp_testclass {
    static testmethod void AccountPopUptest(){
        Account acc= new Account(name='test dhiv Acc',US_Govt_Sanctioned__c=true);
        insert acc;
                       
        PageReference pageRef = Page.AccountPopUp;
        pageRef.getParameters().put('id',acc.id);
        Test.setCurrentPage(pageRef); 
        
        Account srp= new Account();         
        ApexPages.StandardController con = new ApexPages.StandardController(srp);
        
        AccountPopup pop= new AccountPopup(con);       
            
    
}
     static testmethod void AccountPopUptest1(){
        Account acc= new Account(name='test dhiv Acc',US_Govt_Sanctioned__c=false);
        insert acc;
                       
        PageReference pageRef = Page.AccountPopUp;
        pageRef.getParameters().put('id',acc.id);
        Test.setCurrentPage(pageRef); 
        
        Account srp= new Account();         
        ApexPages.StandardController con = new ApexPages.StandardController(srp);
        
        AccountPopup pop= new AccountPopup(con);            
    
}
}