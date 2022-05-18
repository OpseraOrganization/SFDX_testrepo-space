/**
 * @description	   :
 * @author			: Yashdeep Prajapati
 * @group			 :
 * @last modified on  : 08-27-2021
 * @last modified by  : Yashdeep Prajapati
 * Modifications Log
 * Ver   Date		 Author			   Modification
 * 1.0   05-13-2021   Yashdeep Prajapati   Initial Version
 **/
public with sharing class NokiaCPQ_SitePhaseWrapper {
public with sharing class NokiaCPQ_LineItems {
@AuraEnabled public string lineItemId {get; set;}
@AuraEnabled public string productName {get; set;}
@AuraEnabled public string productCode {get; set;}
@AuraEnabled public string productDesc {get; set;}
@AuraEnabled public string prodId {get; set;}
@AuraEnabled public string spares {get; set;}
@AuraEnabled public Integer quantity {get; set;}
// added by surinder
@AuraEnabled public string alias {get; set;}
@AuraEnabled public List<NokiaCPQ_SitePhaseQuantites> sites {get; set;}
}
public with sharing class NokiaCPQ_SitePhaseQuantites {
@AuraEnabled public string recordId {get; set;}
@AuraEnabled public Integer quantity {get; set;}
@AuraEnabled public string siteId {get; set;}
@AuraEnabled public string siteName {get; set;}
@AuraEnabled public List<NokiaCPQ_Phase> phases {get; set;}
}
public with sharing class NokiaCPQ_SitePhaseDetails {
@AuraEnabled public Boolean quoteUsesPhases {get; set;}
@AuraEnabled public string oppId {get; set;}
@AuraEnabled public List<NokiaCPQ_IdName> sites {get; set;}
@AuraEnabled public List<NokiaCPQ_IdName> phases {get; set;}
@AuraEnabled public List<string> siteOrder {get; set;}
@AuraEnabled public List<string> phaseOrder {get; set;}
@AuraEnabled public List<NokiaCPQ_LineItems> lines {get; set;}
//Surinder ITPC:1125
@AuraEnabled public boolean hasAggregation{get;set;}
}
public with sharing class NokiaCPQ_IdName {
@AuraEnabled public string id {get; set;}
@AuraEnabled public string name {get; set;}
}
public with sharing class NokiaCPQ_Phase {
@AuraEnabled public string recordId {get; set;}
@AuraEnabled public Integer quantity {get; set;}
@AuraEnabled public string phaseId {get; set;}
@AuraEnabled public string phaseName {get; set;}
}
}