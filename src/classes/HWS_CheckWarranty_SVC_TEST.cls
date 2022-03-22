@isTest
public class HWS_CheckWarranty_SVC_TEST{
	public static testMethod void hwsCheckWarrantyTestMethod(){ 
 
		HWS_GenericSettings__c custSetting = new HWS_GenericSettings__c();
		custSetting.Name = 'HWS_EnableWarrantyCheck';
		custSetting.HWS_Field1__c = 'true';
		insert custSetting;
		Product2 prod1 = HWS_DataFactory_TEST.insertproduct2(); 
		prod1.ProductCode = 'test123';
		prod1.HWS_NSNPartCode__c = '1AF14035AAAA';
		insert prod1;
		List<HWS_CheckWarranty_SVC.FlowInput> lstFlowInput=new List<HWS_CheckWarranty_SVC.FlowInput>();
		HWS_CheckWarranty_SVC.FlowInput objFlowInput=new HWS_CheckWarranty_SVC.FlowInput();
		
		
		objFlowInput.MaterialCode='1AF14035AAAA';
		objFlowInput.SerialNumber='SN0';
		objFlowInput.CustomerNumber='87895621';
		objFlowInput.SourceSystem='Both';
		objFlowInput.MaterialCode='1AF14035AAAA';
		objFlowInput.SerialNumber='SN77';
		objFlowInput.CustomerNumber='87895621';
		objFlowInput.SourceSystem='Both';
		objFlowInput.MaterialCode='1AF14035AAAA';
		objFlowInput.SerialNumber='SN1';
		objFlowInput.CustomerNumber='87895621';
		objFlowInput.SourceSystem='Both';
		lstFlowInput.add(objFlowInput); 
		
		List<HWS_CheckWarranty_SVC.FlowOutput> lstFlowOutput=new List<HWS_CheckWarranty_SVC.FlowOutput>();
		Test.setMock(HttpCalloutMock.class, new HWS_WarrantyCheckHttpCalloutMock());
		HWS_CheckWarranty_SVC.getWarrentStatus('SN1', 'SN1', '');
		lstFlowOutput  = HWS_CheckWarranty_SVC.hwsSucessfulSubmission(lstFlowInput);
	
	}
	
	//Start changes by pavan
	// Test method written to catch the exception for HWS_SendWarrantyCheckRequesttoSOO 
	public static testMethod void hwsSendWarrantyCheckRequesttoSooTestMethod(){
		HWS_GenericSettings__c custSetting = new HWS_GenericSettings__c();
		custSetting.Name = 'HWS_EnableWarrantyCheck';
		custSetting.HWS_Field1__c = 'true';
		insert custSetting;

	 List<HWS_CheckWarranty_SVC.FlowInput> lstFlowInput=new List<HWS_CheckWarranty_SVC.FlowInput>();
		HWS_CheckWarranty_SVC.FlowInput objFlowInput=new HWS_CheckWarranty_SVC.FlowInput();
		Product2 prod1 = HWS_DataFactory_TEST.insertproduct2(); 
		prod1.ProductCode = 'test123';
		prod1.HWS_NSNPartCode__c = 'test123';
		insert prod1;
		objFlowInput.SerialNumber='SN1';
		objFlowInput.CustomerNumber='87895621';
		objFlowInput.SourceSystem='Both';
		objFlowInput.MaterialCode='test123';	
		lstFlowInput.add(objFlowInput); 
		
		List<HWS_CheckWarranty_SVC.FlowOutput> lstFlowOutput=new List<HWS_CheckWarranty_SVC.FlowOutput>();
		Test.setMock(HttpCalloutMock.class, new HWS_WarrantyCheckHttpCalloutMock());
		lstFlowOutput  = HWS_CheckWarranty_SVC.hwsSucessfulSubmission(lstFlowInput);
		HWS_CheckWarranty_SVC.getSourceSystem('123');
		HWS_SendWarrantyCheckRequesttoSOO.warrantyCheck wc =  new HWS_SendWarrantyCheckRequesttoSOO.warrantyCheck();
		wc.SerialNumber='';
		wc.MaterialCode='';
		wc.WarrantyStatus='';
	}
	// End changes by Pavan
}