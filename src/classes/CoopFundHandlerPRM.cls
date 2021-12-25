/* description: Trigger helper to perform functions before and after Fund creation
* *author:	Accenture IDC.
* ============================================================================
* VERSION	 AUTHOR	DATE	 DETAIL	 FEATURES/CSR/TTP
* 1.0	Pooja Kurkute			08/05/2018	Release 4.1 PRM	  CO-OP
* ============================================================================ 
*/
public without sharing class CoopFundHandlerPRM {
/**********************************************************************************************************************
* author: Accenture
* Description: Method to process Funds after Insert
**********************************************************************************************************************/	
	public static void afterInsertOperation(List<Fund__c> fundList) { 
		try{ 
			CoopFundHelperPRM.shareFundOnCreation(fundList);
			CoopFundHelperPRM.fundShareToAccMember(fundList);
		}
		catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.CoopFundHandlerPRM,PRMGlobalConstants.afterInsertOperation);}
	}
	public static void beforeInsertOperation(List<Fund__c> fundList) { 
		try{ 
			CoopFundHelperPRM.checkMainFund(fundList);
		}
		catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.CoopFundHandlerPRM,PRMGlobalConstants.afterUpdateOperation);}
	}
	public static void beforeUpdateOperation(List<Fund__c> fundList) { 
		try{ 
			CoopFundHelperPRM.checkMainFund(fundList);
		}
		catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.CoopFundHandlerPRM,PRMGlobalConstants.afterUpdateOperation);}
	}
}