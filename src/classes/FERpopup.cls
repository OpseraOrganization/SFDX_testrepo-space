public class FERpopup {
public boolean displayPopup {get; set;} 
public boolean bol1 {get; set;} 
public boolean bol2 {get; set;} 
public Case c; 
public String redirectUrl {public get; private set;}
public Boolean shouldRedirect {public get; private set;}
private ApexPages.StandardController stdController;
 public FERpopup(ApexPages.StandardController stdController) {
 this.stdController = stdController;
        this.c = (Case)stdController.getRecord();
       this.c = [SELECT Id, FER__c,CaseNumber,Ownerid,Description,AccountId,Account_Name__c,Field_Event__c,SBU_w2c__c,
       Product_Part__c,ContactId,Contact_Name__c,SBU__c,Supported_Products__c,Supported_Products__r.name,
       Aircraft_Type__c,Aircraft_Type__r.name,Engine_Model__c,Product_Part_Number__C,Part_Number__c,Product_Model__c,
       Engine_APU_Reported_Serial_Number__c,(select id from Field_Events__r), Contact.Email,
       ownerid__r.DTS_Check__c,status FROM Case  WHERE Id = :ApexPages.currentPage().getParameters().get('id')];   
                  shouldRedirect = false;
    }
    public void showPopup() { 
    if(c.Field_Events__r.size()>0){   
        displayPopup = false; }
       else if(c.FER__c==true){
       displayPopup= true;}
    if(c.Contact.Email==null && c.status == 'Propose to Close'){     
            bol1=true;}
    if(c.ownerid__r.DTS_Check__c == true && c.status == 'Propose to Close'){
            bol2 = true;}
           }
    public Case getc() {
        return c;
    }
    public pagereference redirect() {
        shouldRedirect = true;
        string baseurl = URL.getSalesforceBaseUrl().toExternalForm();
        redirectUrl = baseurl+'/a1W/e?&CF00N30000004rczo='+c.CaseNumber+'&00Na000000B6uhv='+c.Description+'&CF00N30000004rcze='+c.Account_Name__c+'&CF00N30000004rczx='+c.Contact_Name__c+'&00N18000000Vcmo='+c.SBU_w2c__c+'&CF00N30000009OwBT='+c.Supported_Products__r.name+'&CF00N30000009OwBT_lkid='+c.Supported_Products__r.id+'&CF00N30000004rczj='+c.Aircraft_Type__r.name+'&CF00N30000004rczj_lkid='+c.Aircraft_Type__c+'&00N30000004rd0P='+c.Engine_Model__c+'&00N18000000Vcmt='+c.Product_Part_Number__c+'&00N30000004rd03='+c.Engine_APU_Reported_Serial_Number__c;
        //PageReference page = new Pagereference('/a1W/e?&CF00N30000004rczo='+c.CaseNumber+'&00Na000000B6uhv='+c.Description+'&CF00N30000004rcze='+c.Account_Name__c+'&CF00N30000004rczx='+c.Contact_Name__c+'&00N18000000Vcmo='+c.SBU_w2c__c+'&CF00N30000009OwBT='+c.Supported_Products__r.name+'&CF00N30000009OwBT_lkid='+c.Supported_Products__r.id+'&CF00N30000004rczj='+c.Aircraft_Type__r.name+'&CF00N30000004rczj_lkid='+c.Aircraft_Type__c+'&00N30000004rd0P='+c.Engine_Model__c+'&00N18000000Vcmt='+c.Product_Part_Number__c+'&00N30000004rd03='+c.Engine_APU_Reported_Serial_Number__c);
      // page.setRedirect(true);
       // system.debug('New Page'+page);
       // return page;
        return null;
                 
    }
    
}