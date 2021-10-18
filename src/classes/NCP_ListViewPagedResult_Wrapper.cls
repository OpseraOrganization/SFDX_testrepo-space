public with sharing class NCP_ListViewPagedResult_Wrapper {

	@AuraEnabled
	public Integer pageSize { get;set; }
	
	@AuraEnabled
	public Integer page { get;set; }
	
	@AuraEnabled
	public Integer total { get;set; }
	
	@AuraEnabled
	public List<NCP_MyEntitledProducts_Wrapper> products { get;set; }
	
}