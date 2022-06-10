@isTest
public class HWS_EntitlementReset_Test { 
	public static testmethod void resetEntitlementExceptionTest(){ 
		
		Case childCase = new Case();		
		childCase.HWS_WarrantyStatus__c  =HWS_Constants.WS_UKWarranty;
		childCase.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase.CH_EntitlementStatus__c = HWS_Constants.ESIWVM;
		HWS_EntitlementReset.resetEntitlementException(HWS_Constants.WStatusCheckFailed , HWS_Constants.UC1, childCase);
		
		Case childCase1 = new Case();
		childCase1.HWS_WarrantyStatus__c  =HWS_Constants.OUT_OF_WARRANTY;
		childCase1.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase1.CH_EntitlementStatus__c = HWS_Constants.ESOOWVM;
		HWS_EntitlementReset.resetEntitlementException(HWS_Constants.WStatusCheckFailed , HWS_Constants.UC1, childCase1);
		
		Case childCase2 = new Case();
		childCase2.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase2.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase2.CH_EntitlementStatus__c = HWS_Constants.ESMOFOC;
		HWS_EntitlementReset.resetEntitlementException(HWS_Constants.WStatusCheckFailed , HWS_Constants.UC1, childCase2);
		
	}
	
	public static testmethod void resetUKCasesTest(){
		Case childCase = new Case();		
		childCase.HWS_WarrantyStatus__c  =HWS_Constants.WS_UKWarranty;
		childCase.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase.CH_EntitlementStatus__c = HWS_Constants.ESIWVM;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.WStatusCheckFailed , childCase, HWS_Constants.UC1);
		HWS_EntitlementReset.resetUKCases(HWS_Constants.WStatusCheckFailed , childCase, HWS_Constants.UC2B);
		
		Case childCase1 = new Case();
		childCase1.HWS_WarrantyStatus__c  =HWS_Constants.OUT_OF_WARRANTY;
		childCase1.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase1.CH_EntitlementStatus__c = HWS_Constants.ESOOWVM;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.WStatusCheckFailed , childCase1, HWS_Constants.UC67);
		HWS_EntitlementReset.resetUKCases(HWS_Constants.WStatusCheckFailed , childCase1, HWS_Constants.UC5);
		HWS_EntitlementReset.resetUKCases(HWS_Constants.WStatusCheckFailed , childCase1, HWS_Constants.UC1);
		
		Case childCase2 = new Case();
		childCase2.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase2.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase2.CH_EntitlementStatus__c = HWS_Constants.ESMOFOC;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.WStatusCheckFailed , childCase2, HWS_Constants.UC1);
		
		Case childCase3 = new Case();
		childCase3.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase3.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase3.CH_EntitlementStatus__c = HWS_Constants.ESMOB;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.WStatusCheckFailed , childCase3, HWS_Constants.UC1);
		HWS_EntitlementReset.resetUKCases(HWS_Constants.WStatusCheckFailed , childCase3, HWS_Constants.UC67);
		
		Case childCase4 = new Case();
		childCase4.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase4.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase4.CH_EntitlementStatus__c = HWS_Constants.Service_Declined;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.WStatusCheckFailed , childCase4, HWS_Constants.UC1);
		HWS_EntitlementReset.resetUKCases(HWS_Constants.WStatusCheckFailed , childCase4, HWS_Constants.UC3);
	}
	
	public static testmethod void resetUKCasesIWQRTest(){
		Case childCase = new Case();		
		childCase.HWS_WarrantyStatus__c  =HWS_Constants.WS_UKWarranty;
		childCase.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase.CH_EntitlementStatus__c = HWS_Constants.ESQAPR;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.IW_QuotRequired , childCase, HWS_Constants.UC2B);
		
		Case childCase1 = new Case();
		childCase1.HWS_WarrantyStatus__c  =HWS_Constants.OUT_OF_WARRANTY;
		childCase1.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase1.CH_EntitlementStatus__c = HWS_Constants.QR;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.IW_QuotRequired , childCase1, HWS_Constants.UC2B);
		
		
		Case childCase2 = new Case();
		childCase2.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase2.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase2.CH_EntitlementStatus__c = HWS_Constants.ESMOFOC;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.IW_QuotRequired , childCase2, HWS_Constants.UC2B);
		
		Case childCase3 = new Case();
		childCase3.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase3.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase3.CH_EntitlementStatus__c = HWS_Constants.ESMOB;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.IW_QuotRequired , childCase3, HWS_Constants.UC2B);
		
		Case childCase4 = new Case();
		childCase4.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase4.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase4.CH_EntitlementStatus__c = HWS_Constants.Service_Declined;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.IW_QuotRequired , childCase4, HWS_Constants.UC2B);
		
		Case childCase5 = new Case();
		childCase5.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase5.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase5.CH_EntitlementStatus__c = 'test';
		HWS_EntitlementReset.resetUKCases(HWS_Constants.IW_QuotRequired , childCase5, HWS_Constants.UC2B);
		
	}
	
	public static testmethod void resetUKCasesOOWQRTest(){
		Case childCase = new Case();		
		childCase.HWS_WarrantyStatus__c  =HWS_Constants.WS_UKWarranty;
		childCase.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase.CH_EntitlementStatus__c = HWS_Constants.ESIWVM;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.OOW_QuotRequired, childCase, HWS_Constants.UC3);
		
		Case childCase1 = new Case();
		childCase1.HWS_WarrantyStatus__c  =HWS_Constants.OUT_OF_WARRANTY;
		childCase1.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase1.CH_EntitlementStatus__c = HWS_Constants.PendingQuotCreation;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.OOW_QuotRequired, childCase1, HWS_Constants.UC3);
		
		
		Case childCase2 = new Case();
		childCase2.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase2.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase2.CH_EntitlementStatus__c = HWS_Constants.ESQAPR;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.OOW_QuotRequired, childCase2, HWS_Constants.UC3);
		
		Case childCase3 = new Case();
		childCase3.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase3.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase3.CH_EntitlementStatus__c = HWS_Constants.QR;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.OOW_QuotRequired, childCase3, HWS_Constants.UC3);
		
		Case childCase4 = new Case();
		childCase4.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase4.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase4.CH_EntitlementStatus__c = HWS_Constants.ESMOFOC;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.OOW_QuotRequired, childCase4, HWS_Constants.UC3);
		
		Case childCase6 = new Case();
		childCase6.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase6.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase6.CH_EntitlementStatus__c = HWS_Constants.Service_Declined;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.OOW_QuotRequired, childCase6, HWS_Constants.UC3);
		
		Case childCase5 = new Case();
		childCase5.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase5.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase5.CH_EntitlementStatus__c = 'test';
		HWS_EntitlementReset.resetUKCases(HWS_Constants.OOW_QuotRequired, childCase5, HWS_Constants.UC3);
		
	}
	
	public static testmethod void resetUKCasesNAQRTest(){
		Case childCase = new Case();		
		childCase.HWS_WarrantyStatus__c  =HWS_Constants.WS_UKWarranty;
		childCase.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase.CH_EntitlementStatus__c = HWS_Constants.ESIWVM;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.NA_QuotRequired, childCase, HWS_Constants.UC3);
		HWS_EntitlementReset.resetUKCases(HWS_Constants.NA_QuotRequired, childCase, HWS_Constants.UC4);
		HWS_EntitlementReset.resetUKCases(HWS_Constants.NA_QuotRequired, childCase, HWS_Constants.UC2A);
		
		Case childCase1 = new Case();
		childCase1.HWS_WarrantyStatus__c  =HWS_Constants.OUT_OF_WARRANTY;
		childCase1.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase1.CH_EntitlementStatus__c = HWS_Constants.PendingQuotCreation;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.NA_QuotRequired, childCase1, HWS_Constants.UC3);
		
		Case childCase2 = new Case();
		childCase2.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase2.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase2.CH_EntitlementStatus__c = HWS_Constants.ESQAPR;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.NA_QuotRequired, childCase2, HWS_Constants.UC3);
		
		Case childCase3 = new Case();
		childCase3.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase3.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase3.CH_EntitlementStatus__c = HWS_Constants.QR;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.NA_QuotRequired, childCase3, HWS_Constants.UC3);
		
		Case childCase4 = new Case();
		childCase4.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase4.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase4.CH_EntitlementStatus__c = HWS_Constants.ESMOFOC;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.NA_QuotRequired, childCase4, HWS_Constants.UC3);
		
		Case childCase6 = new Case();
		childCase6.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase6.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase6.CH_EntitlementStatus__c = HWS_Constants.Service_Declined;
		HWS_EntitlementReset.resetUKCases(HWS_Constants.NA_QuotRequired, childCase6, HWS_Constants.UC3);
		
		Case childCase5 = new Case();
		childCase5.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase5.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase5.CH_EntitlementStatus__c = 'test';
		HWS_EntitlementReset.resetUKCases(HWS_Constants.NA_QuotRequired, childCase5, HWS_Constants.UC3);
		HWS_EntitlementReset.resetUKCases('test', childCase5, HWS_Constants.UC3);
		
	}
	
	public static testmethod void resetOOWCasesOOWDTest(){
		Case childCase = new Case();		
		childCase.HWS_WarrantyStatus__c  =HWS_Constants.WS_UKWarranty;
		childCase.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase.CH_EntitlementStatus__c = HWS_Constants.ESIWVM;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.EE_OOWD, childCase, HWS_Constants.UC1);
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.EE_OOWD, childCase, HWS_Constants.UC2B);
		
		
		Case childCase1 = new Case();
		childCase1.HWS_WarrantyStatus__c  =HWS_Constants.OUT_OF_WARRANTY;
		childCase1.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase1.CH_EntitlementStatus__c = HWS_Constants.ESOOWVM;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.EE_OOWD, childCase1, HWS_Constants.UC67);
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.EE_OOWD, childCase1, HWS_Constants.UC5);
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.EE_OOWD, childCase1, HWS_Constants.UC1);
		
		Case childCase2 = new Case();
		childCase2.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase2.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase2.CH_EntitlementStatus__c = HWS_Constants.ESMOFOC;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.EE_OOWD, childCase2, HWS_Constants.UC3);
		
		Case childCase3 = new Case();
		childCase3.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase3.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase3.CH_EntitlementStatus__c = HWS_Constants.ESMOB;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.EE_OOWD, childCase3, HWS_Constants.UC1);
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.EE_OOWD, childCase3, HWS_Constants.UC67);
		
		Case childCase6 = new Case();
		childCase6.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase6.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase6.CH_EntitlementStatus__c = HWS_Constants.Service_Declined;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.EE_OOWD, childCase6, HWS_Constants.UC1);
	}
	
	public static testmethod void resetOOWCasesIWQRTest(){
		Case childCase = new Case();		
		childCase.HWS_WarrantyStatus__c  =HWS_Constants.WS_UKWarranty;
		childCase.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase.CH_EntitlementStatus__c = HWS_Constants.PendingCAPMR;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.IW_QuotRequired, childCase, HWS_Constants.UC5);
		
		Case childCase1 = new Case();
		childCase1.HWS_WarrantyStatus__c  =HWS_Constants.OUT_OF_WARRANTY;
		childCase1.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase1.CH_EntitlementStatus__c = HWS_Constants.ESQAPR;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.IW_QuotRequired, childCase1, HWS_Constants.UC5);
		
		Case childCase2 = new Case();
		childCase2.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase2.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase2.CH_EntitlementStatus__c = HWS_Constants.QR;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.IW_QuotRequired, childCase2, HWS_Constants.UC5);
		
		Case childCase3 = new Case();
		childCase3.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase3.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase3.CH_EntitlementStatus__c = HWS_Constants.ESMOFOC;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.IW_QuotRequired, childCase3, HWS_Constants.UC5);
		
		Case childCase6 = new Case();
		childCase6.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase6.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase6.CH_EntitlementStatus__c = HWS_Constants.Service_Declined;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.IW_QuotRequired, childCase6, HWS_Constants.UC5);
		
		Case childCase4 = new Case();
		childCase4.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase4.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase4.CH_EntitlementStatus__c = 'test';
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.IW_QuotRequired, childCase4, HWS_Constants.UC5);
	}
	
	public static testmethod void resetOOWCasesOOWQRTest(){
		Case childCase = new Case();		
		childCase.HWS_WarrantyStatus__c  =HWS_Constants.WS_UKWarranty;
		childCase.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase.CH_EntitlementStatus__c = HWS_Constants.PendingCAPMR;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.OOW_QuotRequired, childCase, HWS_Constants.UC5);
		
		Case childCase1 = new Case();
		childCase1.HWS_WarrantyStatus__c  =HWS_Constants.OUT_OF_WARRANTY;
		childCase1.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase1.CH_EntitlementStatus__c = HWS_Constants.ESQAPR;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.OOW_QuotRequired, childCase1, HWS_Constants.UC5);
		
		Case childCase2 = new Case();
		childCase2.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase2.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase2.CH_EntitlementStatus__c = HWS_Constants.ESIWVM;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.OOW_QuotRequired, childCase2, HWS_Constants.UC3);
		
		Case childCase5 = new Case();
		childCase5.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase5.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase5.CH_EntitlementStatus__c = HWS_Constants.QR;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.OOW_QuotRequired, childCase5, HWS_Constants.UC5);
		
		Case childCase3 = new Case();
		childCase3.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase3.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase3.CH_EntitlementStatus__c = HWS_Constants.ESMOFOC;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.OOW_QuotRequired, childCase3, HWS_Constants.UC5);
		
		Case childCase6 = new Case();
		childCase6.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase6.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase6.CH_EntitlementStatus__c = HWS_Constants.Service_Declined;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.OOW_QuotRequired, childCase6, HWS_Constants.UC5);
		
		Case childCase4 = new Case();
		childCase4.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase4.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase4.CH_EntitlementStatus__c = 'test';
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.OOW_QuotRequired, childCase4, HWS_Constants.UC5);
	}
	
	public static testmethod void resetOOWCasesNAQRTest(){
		Case childCase = new Case();		
		childCase.HWS_WarrantyStatus__c  =HWS_Constants.WS_UKWarranty;
		childCase.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase.CH_EntitlementStatus__c = HWS_Constants.PendingCAPMR;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.NA_QuotRequired, childCase, HWS_Constants.UC5);
		
		Case childCase1 = new Case();
		childCase1.HWS_WarrantyStatus__c  =HWS_Constants.OUT_OF_WARRANTY;
		childCase1.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase1.CH_EntitlementStatus__c = HWS_Constants.ESQAPR;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.NA_QuotRequired, childCase1, HWS_Constants.UC5);
		
		Case childCase2 = new Case();
		childCase2.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase2.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase2.CH_EntitlementStatus__c = HWS_Constants.ESIWVM;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.NA_QuotRequired, childCase2, HWS_Constants.UC4);
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.NA_QuotRequired, childCase2, HWS_Constants.UC3);
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.NA_QuotRequired, childCase2, HWS_Constants.UC8);
		
		Case childCase5 = new Case();
		childCase5.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase5.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase5.CH_EntitlementStatus__c = HWS_Constants.QR;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.NA_QuotRequired, childCase5, HWS_Constants.UC5);
		
		Case childCase3 = new Case();
		childCase3.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase3.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase3.CH_EntitlementStatus__c = HWS_Constants.ESMOFOC;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.NA_QuotRequired, childCase3, HWS_Constants.UC5);
		
		Case childCase6 = new Case();
		childCase6.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase6.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase6.CH_EntitlementStatus__c = HWS_Constants.Service_Declined;
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.NA_QuotRequired, childCase6, HWS_Constants.UC5);
		
		Case childCase4 = new Case();
		childCase4.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase4.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase4.CH_EntitlementStatus__c = 'test';
		HWS_EntitlementReset.resetOOWCases(HWS_Constants.NA_QuotRequired, childCase4, HWS_Constants.UC5);
	}
	
	public static testmethod void resetIWCasesIWQRTest(){
		Case childCase = new Case();		
		childCase.HWS_WarrantyStatus__c  =HWS_Constants.WS_UKWarranty;
		childCase.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase.CH_EntitlementStatus__c = HWS_Constants.PendingCAPMR;
		HWS_EntitlementReset.resetIWCases(HWS_Constants.IW_QuotRequired, childCase, HWS_Constants.UC5);
		
		Case childCase1 = new Case();
		childCase1.HWS_WarrantyStatus__c  =HWS_Constants.OUT_OF_WARRANTY;
		childCase1.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase1.CH_EntitlementStatus__c = HWS_Constants.ESQAPR;
		HWS_EntitlementReset.resetIWCases(HWS_Constants.IW_QuotRequired, childCase1, HWS_Constants.UC5);
		
		Case childCase2 = new Case();
		childCase2.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase2.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase2.CH_EntitlementStatus__c = HWS_Constants.QR;
		HWS_EntitlementReset.resetIWCases(HWS_Constants.IW_QuotRequired, childCase2, HWS_Constants.UC5);
		
		Case childCase3 = new Case();
		childCase3.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase3.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase3.CH_EntitlementStatus__c = HWS_Constants.ESMOFOC;
		HWS_EntitlementReset.resetIWCases(HWS_Constants.IW_QuotRequired, childCase3, HWS_Constants.UC5);
		
		Case childCase6 = new Case();
		childCase6.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase6.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase6.CH_EntitlementStatus__c = HWS_Constants.Service_Declined;
		HWS_EntitlementReset.resetIWCases(HWS_Constants.IW_QuotRequired, childCase6, HWS_Constants.UC5);
		
		Case childCase4 = new Case();
		childCase4.HWS_WarrantyStatus__c  =HWS_Constants.WS_InWarranty;
		childCase4.CH_EntitlementException__c =HWS_Constants.WStatusCheckFailed;
		childCase4.CH_EntitlementStatus__c = 'test';
		HWS_EntitlementReset.resetIWCases(HWS_Constants.IW_QuotRequired, childCase4, HWS_Constants.UC5);
	}
}