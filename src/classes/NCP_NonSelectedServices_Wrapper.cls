public with sharing class NCP_NonSelectedServices_Wrapper {
	
	@AuraEnabled
	public NCP_Service_Tile__mdt service {get;set;}
	@AuraEnabled
	public Boolean isChecked {get;set;}
 
	public NCP_NonSelectedServices_Wrapper(NCP_Service_Tile__mdt l ,Boolean b){
		this.service = l;
		this.isChecked = b;
	}
}