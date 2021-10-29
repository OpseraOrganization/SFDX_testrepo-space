public class WebPortalCopyEmailDomains{
public String accId{get;set;}
public String actMsg{get;set;}
public String accNameToSearch{get;set;}
public List<Account> searchResults{get;set;}
public List<Account_Email_Domains__c> emailDomains{get;set;}
public List<EmailDomains> emailDomainsList{get;set;}
public Set<String> selectedEmailDomains{
    get {
        if(selectedEmailDomains == null) selectedEmailDomains= new Set<String>();
            return selectedEmailDomains;
    }
    set;
}
public WebPortalCopyEmailDomains(){
    accId=Apexpages.currentpage().getParameters().get('accId');
    actMsg ='Search for email domains by providing Account Name';
}
public void search(){
    emailDomainsList=new List<EmailDomains>();
    String accNameToSearchWthWld=accNameToSearch+'%';
    searchResults=[Select Name, (Select Account_Email_Domain__c, Name From Account_Email_Domains__r) from Account where Name like :accNameToSearchWthWld];
    integer i=0;
    actMsg = '';
    for(Account acc:searchResults){
        for(Account_Email_Domains__c emailDomain:acc.Account_Email_Domains__r){
            EmailDomains ed=new EmailDomains();
            ed.accName=acc.name;
            ed.emailDomain=emailDomain.Account_Email_Domain__c;
            ed.checked=false;
            emailDomainsList.add(ed);
        }
        i=i+1;
     }
     if(emailDomainsList!=null && emailDomainsList.size()==0){
         emailDomainsList=null;
         actMsg ='No Data Found';
     }
    }
public PageReference addToAccount(){
    selectedEmailDomains.clear();
    for(EmailDomains val:emailDomainsList){
        if(val.checked){
            selectedEmailDomains.add(val.emailDomain);
        }
    }
    System.debug('selectedEmailDomains list '+selectedEmailDomains);
    List<Account_Email_Domains__c> lstEmailDomains=new List<Account_Email_Domains__c>();
    List<Account_Email_Domains__c> lstExistingEDForThisAcct = [Select Account__c, Account_Email_Domain__c, Name from Account_Email_Domains__c where Account__c = :accId]; 
    Set<String> setEDs=new Set<String>();
    Set<String> setSelectedEds=new Set<String>();
    for(Account_Email_Domains__c val:lstExistingEDForThisAcct){
        setEDs.add(val.Account_Email_Domain__c);
    }
    
    for(String curVal:selectedEmailDomains){
          if(!setEDs.contains(curVal)){                                                                                                                                    
                Account_Email_Domains__c accEmailDomain=new Account_Email_Domains__c();
                accEmailDomain.Account__c=accId;
                accEmailDomain.Account_Email_Domain__c=curVal;
                accEmailDomain.name=curVal;
                lstEmailDomains.add(accEmailDomain);
          }  
         
       
    }
    if(lstEmailDomains!=null && lstEmailDomains.size()>0){
        try{
            insert lstEmailDomains;
            }catch(Exception e){
                System.debug(e);
                return new PageReference('/apex/copyEmailDomains');
            }
    }
    return new PageReference('/'+accId);
    }
    public class EmailDomains{
    public Boolean checked{get;set;}
    public String accName{get;set;}
    public String emailDomain{get;set;}
    }
}