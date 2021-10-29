// This class is created as part of the incident - INC000009657671
public class CaseOnHoldLogController {
    public Boolean disabl {get;set;}
    public string cohl {get;set;}
    public Boolean refreshPage {get; set;}
    public Case_On_Hold_Log__c COL;
    public user currentuser{get;set;}
    
 public CaseOnHoldLogController(ApexPages.StandardController stdController) {
       refreshPage=false;
       this.col = (Case_On_Hold_Log__c)stdController.getRecord();
       this.col = [SELECT Id, Functional_Team_Completed_By__c,LastModifiedById,Functional_Team_Completion_Date__c,LastModifiedDate FROM Case_On_Hold_Log__c 
                   WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
     currentuser=new User();
     currentuser=[Select Id,Name,Email from User where Id=:userinfo.getuserId()];
           
    }
    public PageReference dis()
    {
       if(col.Functional_Team_Completed_By__c==null && col.Functional_Team_Completion_Date__c==null )        
        {
            system.debug('inside if');
           col.Functional_Team_Completed_By__c=userinfo.getuserId();
           col.Functional_Team_Completion_Date__c=System.now();
           //col.Functional_Team_Completion__c= currentuser.Name +' '+ System.now();
        update col;
            
        }
        system.debug('col.Functional_Team_Completed_By__c'+col.Functional_Team_Completed_By__c);
        system.debug('col.Functional_Team_Completion_Date__c'+col.Functional_Team_Completion_Date__c);
          //PageReference pageRef = new PageReference('/'+col.id);
        refreshPage=true;  
        return null ;    
    }  
      
        
   /* public Case_On_Hold_Log__c getCOL() {
        system.debug('col.LastModifiedById'+col.LastModifiedById);
        system.debug('col.LastModifiedDate'+col.LastModifiedDate);
        COL.Functional_Team_Completed_By__c=col.LastModifiedById;
        COL.Functional_Team_Completion_Date__c=col.LastModifiedDate;
        //return col.Functional_Team_Completed_By__c;
        //return col.Functional_Team_Completion_Date__c;
    return COL;
    }*/
    
}