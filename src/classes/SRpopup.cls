//The class is created for the SR INC000005480183 to show a warning message when the CSPM field is blank.
public class SRpopup {     
public boolean displayPopup {get; set;}  
public string srm  {get; set;}
public Service_Request__c SR; 
 
 public SRpopup(ApexPages.StandardController stdController) {
       this.sr = (Service_Request__c)stdController.getRecord();
       this.sr = [SELECT Id, Service_Request_Manager__c FROM Service_Request__c 
                   WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
           
    }
    public String getSrm() {
        return sr.Service_Request_Manager__c;
    }
    public Service_Request__c getSR() {
        return SR;
    }
  
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true;    
    }
 }