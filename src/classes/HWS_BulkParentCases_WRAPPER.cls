public class HWS_BulkParentCases_WRAPPER {
	Public String BulkReferenceid;
	Public String RequestType;
	Public List<HWS_BulkChildCases_WRAPPER> Requestitems;	

	Public HWS_BulkParentCases_WRAPPER(String parentCaseNumber, String requestType) {
		this.BulkReferenceid = parentCaseNumber;
		this.RequestType = requestType;
	 
		this.Requestitems= new List<HWS_BulkChildCases_WRAPPER>();	
	}
}