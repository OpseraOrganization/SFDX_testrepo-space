/*********************************************
    Class Name       : RDF_CaseCreationController_Test
    Visualforce Page : RDF_CaseCreationPage
    Created On       : 19th July 2018
    Project          : RDF - One - Off Discount process
    Created By       : NTTDATA INC
    Purpose          : This extenstion controller is used to handle the Selection and Creation on Addresses in RMA Creation    
*********************************************/
@isTest
public class RDF_CaseCreationController_Test {
    static testmethod void validateCaseInsert(){
        Id devRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('One-Off Discount').getRecordTypeId();
         date testdate = date.parse('11/23/2017');
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Method Opportunity';
        opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'AM Complex'].Id;
        opp.SBU__c = 'ATR';
        opp.CBT_Tier_2__c = 'Airbus';       
        opp.Prime_Sub__c = 'Prime';
        opp.StageName = 'Cultivate';
        opp.CloseDate = testdate;
        opp.Revenue_Type__c = 'ENG';
        opp.Bid_Type_Name__c = 'LTA';
        opp.International_Code__c = 'FMS';
        opp.Incumbent__c = 'Incumbent';
        opp.RMU__c = 'YES';
        opp.IC_Scorecard_Opportunity__c = false;
        insert opp;
        
        Case newcase = new Case();
        newcase.status = 'Open';
        newcase.recordtypeid = devRecordTypeId;
        insert newcase;
        
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().put('id',opp.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(newcase);
        RDF_CaseCreationController obj = new RDF_CaseCreationController(controller);
        obj.save();
    }
}