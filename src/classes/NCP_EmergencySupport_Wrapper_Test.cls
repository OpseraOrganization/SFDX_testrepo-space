@isTest
	private class NCP_EmergencySupport_Wrapper_Test {
	 @isTest
	 static void TestEmergencySupport_Wrapper(){
		 Test.startTest();		 
		 List<NCP_EmergencySupport_Wrapper> records = new List<NCP_EmergencySupport_Wrapper>();
		 NCP_EmergencySupport_Wrapper defaultView = new NCP_EmergencySupport_Wrapper();
		 defaultView.value = 'exemple';
		 defaultView.label = 'exemple';
		 defaultView.contact_Label = 'exemple';
		 defaultView.contact_email_telephone = 'ex@gl.com';
		 records.add(defaultView);
		 System.assertEquals(records.size(),1);
		 Test.stopTest();   
	 }  
	}