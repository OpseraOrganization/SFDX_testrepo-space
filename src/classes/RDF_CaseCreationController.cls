/*********************************************
    Class Name       : RDF_CaseCreationController
    Visualforce Page : RDF_CaseCreationPage
    Test Class       : RDF_CaseCreationController_Test
    Created On       : August 2018
    Project          : RDF - One - Off Discount process
    Created By       : NTTDATA INC
    Purpose          : This extenstion controller is used to Insert Records created from the RDF_CaseCreationPage to "One-Off Discount" Recordtype.
*********************************************/
public class RDF_CaseCreationController {
    public case newcase {set;get;}
    public Opportunity opps {set;get;}
       
    public RDF_CaseCreationController(ApexPages.StandardController controller){
        newcase = new Case();
        opps = new Opportunity();
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        Id devRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('One-Off Discount').getRecordTypeId();
        newcase.recordtypeid = devRecordTypeId;
        Opportunity opp = [select Accountid,Id, name,Description,Account.Type from Opportunity where id=: currentRecordId];
        
        newcase.AccountId = opp.accountid;
        newcase.Subject = opp.name;
        newcase.Description = opp.Description;
        newcase.Type = opp.Account.Type;   
        newcase.Opportunity__c = opp.id;       
    }
    public PageReference save(){
        if(newcase != null)
        {
            insert newcase;
            PageReference page = new PageReference('/'+newcase.id);
            page.setRedirect(true);
            return page;
        }
        return null;
    }  
}