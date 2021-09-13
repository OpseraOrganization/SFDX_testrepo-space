public class DocumentWrapper {

	@AuraEnabled
	public String strDocumentName { get; set;}
	@AuraEnabled
	public String strDocumentType { get; set; }
	@AuraEnabled
	public String strLastModifiedBy { get; set; }	
	@AuraEnabled
	public String strLastModifiedDate { get; set; }
	@AuraEnabled
	public String strContentDocumentID { get; set; }
	
 
}