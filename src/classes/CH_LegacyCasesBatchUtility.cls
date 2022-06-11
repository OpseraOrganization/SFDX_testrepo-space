/****************************************
* Class Name : CH_LegacyCasesBatchUtility
* Created Date: 21 Oct 2020
* Created By : TCS
* Last Modified by: 
*Purpose:Added as part of NOKIASC-31968 removing duplicate code 
*****************************************/
public class CH_LegacyCasesBatchUtility{
 public static void caseValuesSet(Case NewCaseLegacy ){
	 //Update product details method replicated below -- NOKIASC-28485 //dp
	if(NewCaseLegacy.AssetId != null){
				NewCaseLegacy.CH_Solution__c = (NewCaseLegacy.Asset.CH_Solution__c != null) ? NewCaseLegacy.Asset.CH_Solution__c : NewCaseLegacy.CH_Solution__c;
				NewCaseLegacy.ProductId = (NewCaseLegacy.Asset.Product2Id != null) ? NewCaseLegacy.Asset.Product2Id : NewCaseLegacy.ProductId;
				NewCaseLegacy.CH_ProductName__c = (NewCaseLegacy.Asset.Product2Id != null) ? NewCaseLegacy.Asset.Product2Id : NewCaseLegacy.CH_ProductName__c;
				NewCaseLegacy.CH_Product_Release__c = (NewCaseLegacy.Asset.CH_ProductRelease__c != null) ? NewCaseLegacy.Asset.CH_ProductRelease__c : NewCaseLegacy.CH_Product_Release__c;				  
				NewCaseLegacy.CH_ProductVariant__c = (NewCaseLegacy.Asset.CH_ProductVariant__c != null) ? NewCaseLegacy.Asset.CH_ProductVariant__c : NewCaseLegacy.CH_ProductVariant__c;
	}
	
 }
  public static List<Case> newCaseListSet(List<case> NewCaseLegacyList ){
		 // Miguel Silva - Route cases to WG based on WG Rules - NOKIASC-27920   
		CH_AvoidRecursion.runBeforeUpdateOnce();// If we want to bypass the before update block	  
		CH_AvoidRecursion.runAfterUpdateOnce(); // If we want to bypass the after update block
		CH_CA_Service service = new CH_CA_Service();
		for(Case legacyCase : NewCaseLegacyList){
			service.currentCase = legacyCase;
			CH_CA_DTO.SearchCriteriaDTO caseFieldsDTO = service.getCaseDetails();
			CH_CA_Workgroup_Rule ruleHandler = new CH_CA_Workgroup_Rule();
			CH_CA_Assignment_Criteria_DTO caseDetails = ruleHandler.getWorkgroupRules(caseFieldsDTO, true);			
			legacyCase.CH_Workgroup__c = caseDetails.validWorkgroupRules[0].CH_Workgroup__c; //Here should go the logic of if legacyCase.CH_Workgroup__c = GWC then change to default WG
		}
		return NewCaseLegacyList;
  }
}