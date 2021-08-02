@isTest
public class HWS_CheckWarranty_SVC_TEST{
	public static testMethod void hwsCheckWarrantyTestMethod(){
		List<HWS_CheckWarranty_SVC.FlowInput> lstFlowInput=new List<HWS_CheckWarranty_SVC.FlowInput>();
		HWS_CheckWarranty_SVC.FlowInput objFlowInput=new HWS_CheckWarranty_SVC.FlowInput();
		HWS_SendWarrantyCheckRequesttoSOO warrantyReq=new HWS_SendWarrantyCheckRequesttoSOO();
		
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
		lstFlowOutput  = HWS_CheckWarranty_SVC.hwsSucessfulSubmission(lstFlowInput);
		system.debug('Values of flowoutput:'+lstFlowOutput);
		 System.assertEquals('Is the part covered under warranty?: Yes',lstFlowOutput[0].isWarranty); 
	   }
	
	//Start changes by pavan
	// Test method written to catch the exception for HWS_SendWarrantyCheckRequesttoSOO 
	public static testMethod void hwsSendWarrantyCheckRequesttoSooTestMethod(){
	   List<HWS_CheckWarranty_SVC.FlowInput> lstFlowInput=new List<HWS_CheckWarranty_SVC.FlowInput>();
		HWS_CheckWarranty_SVC.FlowInput objFlowInput=new HWS_CheckWarranty_SVC.FlowInput();
		HWS_SendWarrantyCheckRequesttoSOO warrantyReq=new HWS_SendWarrantyCheckRequesttoSOO();
	   // objFlowInput.SerialNumber='SN1';
	   // objFlowInput.CustomerNumber='87895621';
	   // objFlowInput.SourceSystem='Both';
	   // objFlowInput.MaterialCode='1AF14035AAAA';
		objFlowInput.SerialNumber='SN0';
		objFlowInput.CustomerNumber='87895621';
		objFlowInput.SourceSystem='Both';
		objFlowInput.MaterialCode='1AF14035AAAA';
	   // objFlowInput.SerialNumber='SN77';
		//objFlowInput.CustomerNumber='87895621';
	   // objFlowInput.SourceSystem='Both';
		//objFlowInput.MaterialCode='1AF14035AAAA';
		lstFlowInput.add(objFlowInput); 
		
		List<HWS_CheckWarranty_SVC.FlowOutput> lstFlowOutput=new List<HWS_CheckWarranty_SVC.FlowOutput>();
		Test.setMock(HttpCalloutMock.class, new HWS_WarrantyCheckHttpCalloutMock());
		lstFlowOutput  = HWS_CheckWarranty_SVC.hwsSucessfulSubmission(lstFlowInput);
		system.debug('Values of flowoutput:'+lstFlowOutput);
		 System.assertEquals('Is the part covered under warranty?: Facing issues in the response. please try again later',lstFlowOutput[0].isWarranty); 
	   }
	// End changes by Pavan
}