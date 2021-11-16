@isTest
private class TPMaintenancecontrollerTest{
	 @isTest static void myTest() {
		 Apttus_Config2__ConfigLineItemCustomFields__c objLineItemCustomFields = new Apttus_Config2__ConfigLineItemCustomFields__c();
		 objLineItemCustomFields.Name = 'Criteria set 1';
		 objLineItemCustomFields.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.NokiaCPQ_Maintenance_Accreditation__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.NokiaCPQ_Maintenance_Level__c';
		 insert objLineItemCustomFields;
		 TP_Maintenance_controller objctr = new TP_Maintenance_controller();
		 objctr.run();
	 }

}