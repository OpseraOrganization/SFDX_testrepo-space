public class CaseAlertcls {
    public ApexPages.StandardController stdController;
    case cs{get;set;}
    public boolean bol{get;set;}
    public boolean bol1{get;set;}
    public case cas{get;set;} 
    public CaseAlertcls(ApexPages.StandardController stdcontroller) {    
        bol = false;
        cs= (case)stdController.getRecord();
        cas = [SELECT Id,App_Email__c,Origin ,SuppliedEmail,Contact.Email, ownerid__r.DTS_Check__c, Status
        FROM case WHERE Id = :ApexPages.currentPage().getParameters().get('id')];                     
                      
    }   
             
    public void showPopup() {        
        if(cas.App_Email__c!=null && cas.SuppliedEmail!= null && cas.App_Email__c != cas.SuppliedEmail && cas.Origin == 'BGAMobileApp'){       
          bol=false;
        }  
        if(cas.Contact.Email==null ){     
            bol1=true;} 
    }
    
        public case getcase() {
        return cs;
    }
}