/*******************************
	*Class name: fileFieldHistoryWrapper
	*Description: To create relation between "File Report" & "File Report History" Object
	*******************************/  
public class fileFieldHistoryWrapper {
	@AuraEnabled
	public String version { get; set; }
	@AuraEnabled
	public String uploader { get; set; }
	@AuraEnabled
	public String field { get; set; }
	@AuraEnabled
	public String user { get; set; }
	@AuraEnabled
	public Object  oldValue { get; set; }
	@AuraEnabled
	public Object  newValue { get; set; }
	@AuraEnabled
	public Datetime  dateValue { get; set; }
}