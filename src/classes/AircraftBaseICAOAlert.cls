public class AircraftBaseICAOAlert {
    public List<opportunity> oList{get;set;}
    String oppIds;
    public AircraftBaseICAOAlert(ApexPages.StandardController controller) {
         oppIds = ApexPages.CurrentPage().getparameters().get('id');
         oList = [SELECT Id, Aircraft_Base_ICAO__c, Aircraft_Ref__c, SBU__c FROM Opportunity WHERE SBU__c = 'BGA' AND Aircraft_Base_ICAO__c IN ('KASE','KLGA','KSAN','KMMH','KDCA','KTEX','KCOD','KIFP','KBTM','PAJN') AND StageName != 'Closed Cancelled ' AND StageName != 'Closed Lost' and id =:oppIds];
    }

}