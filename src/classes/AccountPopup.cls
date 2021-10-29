public class AccountPopup {

public Boolean showpopup {get; set;}
public ApexPages.StandardController stdCtrl {get; set;}
public Account acc {get;set;}

public Accountpopup(ApexPages.StandardController controller) {
    acc= [SELECT Id, US_Govt_Sanctioned__c FROM Account
    WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
    //refreshPage=false;
    stdCtrl=controller;
     if (acc.US_Govt_Sanctioned__c == True){
           showpopup=true;
           }else{showpopup=false;}
    system.debug('**********'+acc.US_Govt_Sanctioned__c);    
}
}