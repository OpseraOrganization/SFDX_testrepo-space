@isTest
private class TPMaintenancecontrollerTest{
	 @isTest static void myTest() {
		 Apttus_Config2__ConfigLineItemCustomFields__c objLineItemCustomFields = new Apttus_Config2__ConfigLineItemCustomFields__c();
		 objLineItemCustomFields.Name = 'Criteria set 1';
		 //Modified for FN Restructuring by Christie JJ
		 //objLineItemCustomFields.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.NokiaCPQ_Maintenance_Accreditation__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.NokiaCPQ_Maintenance_Level__c';
		 objLineItemCustomFields.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Account_Market__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Maintenance_Y1__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Maintenance_Y2__c';
		 insert objLineItemCustomFields;
		 TP_Maintenance_controller objctr = new TP_Maintenance_controller();
		 objctr.run();
	 }

}