/**
* @Name: QTO_CDParsingWrapper
* @Author: Raj Kamdar
* @CreateDate: 11/03/2020
* @Description: Wrapper structure for the association data to be parsed to.
---------------------------------------------------------------------------------------------
* @LastModifiedBy: <LastModifiedBy>
* @LastModifiedDate: <LastModifiedDate>
* @ChangeDescription: <ChangeDescription>
**/
public class QTO_CDParsingWrapper {
	public Set<String> setHeaderAgreements = new Set<String>();
	public Set<String> setHeaderQuotes = new Set<String>();
	public Set<String> setLineItemAgreements = new Set<String>();
	public Set<String> setLineItemQuotes = new Set<String>();
	public Set<Id> setCDOLineItems = new Set<Id>();
	public Id customerDocumentId;
	// DSI-2322
	public Set<String> pdfSiteCodeRefs = new Set<String>();
	public Set<String> pdfOpportunityRefs = new Set<String>();
}