Public without sharing Class HWS_BulkChildCases_WRAPPER{
	Public String CustomerNumber;
	Public String ParentRefid;
	Public String ChildRefId;
	Public String SerialNumber;
	Public String MaterialCode;
	Public String SourceSystem;
	 
	Public HWS_BulkChildCases_WRAPPER(Case childcase) {
		this.CustomerNumber = childcase.HWS_Customer_ID__c;
		this.ParentRefid = childcase.parentId;
		this.ChildRefId = childcase.id;
		
		if(childcase.HWS_Faulty_Serial_Number__c != Null && childcase.HWS_Faulty_Serial_Number__c != ''){
			this.SerialNumber = (childcase.HWS_Faulty_Serial_Number__c).toUpperCase();
		}
		
		this.MaterialCode = childcase.HWS_Stockable_Product__r.Name;
		
		if(childcase.NCP_Service_Contract__r.CH_ERPSystem__c.contains('P20')){
			this.MaterialCode = childcase.HWS_Stockable_Product__r.Name;
		} else {
			this.MaterialCode = childcase.HWS_Stockable_Product__r.RES_ID__c;
		}
		
		if(childcase.Asset.HWS_SourceSystem__c == 'PUMA1'){
			this.SourceSystem = 'P20';
		} else if(childcase.Asset.HWS_SourceSystem__c == 'PUMA2'){
			this.SourceSystem = 'WES';			
		} else {
			this.SourceSystem = 'Both';	
		}
	}
}