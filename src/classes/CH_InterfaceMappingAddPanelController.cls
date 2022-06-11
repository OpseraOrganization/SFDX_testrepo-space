public class CH_InterfaceMappingAddPanelController {
	@AuraEnabled
	public static List<CH_Case_PA_InterfaceMapping__c> getImList() {
	return [
		SELECT Name,
		CaseOriginSystem__c,
		AccountIn__c,
		SolutionIn__c,
		ProductIn__c,
		VariantIn__c,
		ProductReleaseIn__c,
		AccountOut__c,
		SolutionOut__c,
		ProductOut__c,
		VariantOut__c,
		ProductReleaseOut__c,
		EntitlementOut__c,
		RangePrefix__c,
		RangeStart__c,
		RangeEnd__c
		FROM CH_Case_PA_InterfaceMapping__c 
		//NOKIASC-26546
		//ORDER BY CreatedDate ASC
		ORDER BY Name ASC
		];
	}
	@AuraEnabled
	public static String deleteImRecord(String imId) {
		try {
			delete [SELECT Id FROM CH_Case_PA_InterfaceMapping__c WHERE Id =: imId];
		} catch (DmlException e) {
			return e.getMessage();
		}
		return null;
	}
	@AuraEnabled
	public static String getCsvBase64() {
		String csv = 'Name,CaseOriginSystem__c,AccountIn__c,RangePrefix__c,RangeStart__c,RangeEnd__c,AccountOut__c,SolutionIn__c,SolutionOut__c,ProductIn__c,ProductOut__c,VariantIn__c,VariantOut__c,ProductReleaseIn__c,ProductReleaseOut__c,EntitlementOut__c\n';
		List<CH_Case_PA_InterfaceMapping__c> imList = getImList();
		
		for(CH_Case_PA_InterfaceMapping__c im : imList) {
			csv += im.Name != null ? im.Name : '';
			csv += ',';
			csv += im.CaseOriginSystem__c != null ? im.CaseOriginSystem__c : '';
			csv += ',';
			csv += im.AccountIn__c != null ? im.AccountIn__c : '';
			csv += ',';
			csv += im.RangePrefix__c != null ? im.RangePrefix__c : '';
			csv += ',';
			csv += im.RangeStart__c != null ? string.valueof(im.RangeStart__c) : '';
			csv += ',';
			csv += im.RangeEnd__c != null ? string.valueof(im.RangeEnd__c) : '';
			csv += ',';
			csv += im.AccountOut__c != null ? im.AccountOut__c : '';
			csv += ',';
			csv += im.SolutionIn__c != null ? im.SolutionIn__c : '';
			csv += ',';
			csv += im.SolutionOut__c != null ? im.SolutionOut__c : '';
			csv += ',';
			csv += im.ProductIn__c != null ? im.ProductIn__c : '';
			csv += ',';
			csv += im.ProductOut__c != null ? im.ProductOut__c : '';
			csv += ',';
			csv += im.VariantIn__c != null ? im.VariantIn__c : '';
			csv += ',';
			csv += im.VariantOut__c != null ? im.VariantOut__c : '';
			csv += ',';
			csv += im.ProductReleaseIn__c != null ? im.ProductReleaseIn__c : '';
			csv += ',';
			csv += im.ProductReleaseOut__c != null ? im.ProductReleaseOut__c : '';
			csv += ',';
			csv += im.EntitlementOut__c != null ? im.EntitlementOut__c : '';
			csv += '\n';
		}
		
		return EncodingUtil.base64Encode(Blob.valueOf(csv));
	}
}