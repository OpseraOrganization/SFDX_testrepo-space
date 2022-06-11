/****************************************
* Class Name : BusinessPlanTriggerHelper
* Created Date: 1 Sep 2017
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 
* Description : Business Plan Trigger Helper

* Test Class: 
*****************************************/
public without sharing class BusinessPlanTriggerHelper {
	/********************
*Method Name: validateApprovalProcessCriteria
*Parameter: 
*Description: Used to handle After Update activities
1. Throw Error Before Submission of Approval
*******************/
	public static void validateApprovalProcessCriteria(Business_Plan__c bp , Map<ID, Business_Plan__c> bpOldMap ){
		Boolean noChange = false;
		Boolean yy_ION = false;
		Boolean yy_FN = false;
		Boolean yy_MN = false;
		Boolean yy_AA = false;
		Boolean yy_GS = false;
		//Boolean checkIONSection = false;
		String errMsg ;
		List<String> errorMessageList = new List<String>();
		try{
			if(bp.Business_Plan_Status__c.equals(PRMGlobalConstants.BPApprovalStatus)
			   && bpOldMap.get(bp.Id).Business_Plan_Status__c != bp.Business_Plan_Status__c) {
				   if(bp.Expected_Amount_A_A_Product_Revenue__c == null && bp.Expected_Amount_A_A_Services_Revenue__c == null 
					  && bp.Expected_Amount_FN_Product_Revenue__c == null && bp.Expected_Amount_FN_Services_Revenue__c == null 
					  && bp.Expected_Amount_GS_Product_Revenue__c == null && bp.Expected_Amount_GS_Services_Revenue__c == null 
					  && bp.Expected_Amount_ION_Product_Revenue__c == null && bp.Expected_Amount_ION_Services_Revenue__c == null 
					  && bp.Expected_Amount_MN_Product_Revenue__c == null && bp.Expected_Amount_MN_Services_Revenue__c == null 
					  && bp.Expected_YY_Growth_by_A_A__c == null && bp.Expected_YY_Growth_by_FN__c == null 
					  && bp.Expected_YY_Growth_by_GS__c == null && bp.Expected_YY_Growth_by_ION__c == null 
					  && bp.Expected_YY_Growth_by_MN__c == null 
					  && (bp.A_A_product_s_you_intend_to_sell__c == PRMGlobalConstants.ProductDefaultVal || bp.A_A_product_s_you_intend_to_sell__c == null) && (bp.A_A_service_s_you_intend_to_sell__c == PRMGlobalConstants.ServiceDefaultVal || bp.A_A_service_s_you_intend_to_sell__c == null )
					  && (bp.FN_product_s_you_intend_to_sell__c == PRMGlobalConstants.ProductDefaultVal || bp.FN_product_s_you_intend_to_sell__c == null )&& (bp.FN_service_s_you_intend_to_sell__c == PRMGlobalConstants.ServiceDefaultVal || bp.FN_service_s_you_intend_to_sell__c == null )
					  && (bp.GS_product_s_you_intend_to_sell__c == PRMGlobalConstants.ProductDefaultVal || bp.GS_product_s_you_intend_to_sell__c == null)&& (bp.GS_service_s_you_intend_to_sell__c == PRMGlobalConstants.ServiceDefaultVal || bp.GS_service_s_you_intend_to_sell__c == null )
					  && (bp.ION_product_s_you_intend_to_sell__c == PRMGlobalConstants.ProductDefaultVal || bp.ION_product_s_you_intend_to_sell__c == null)&& (bp.ION_service_s_you_intend_to_sell__c == PRMGlobalConstants.ServiceDefaultVal || bp.ION_service_s_you_intend_to_sell__c == null  )
					  && (bp.MN_product_s_you_intend_to_sell__c == PRMGlobalConstants.ProductDefaultVal || bp.MN_product_s_you_intend_to_sell__c == null)&& (bp.MN_service_s_you_intend_to_sell__c == PRMGlobalConstants.ServiceDefaultVal || bp.MN_service_s_you_intend_to_sell__c == null )){
						  noChange = true;
					  }
				   else{
					   if(bp.Expected_YY_Growth_by_ION__c != null ){
						   if((bp.Expected_Amount_ION_Product_Revenue__c != null && (bp.ION_product_s_you_intend_to_sell__c != PRMGlobalConstants.ProductDefaultVal && bp.ION_product_s_you_intend_to_sell__c != null)) || (bp.Expected_Amount_ION_Services_Revenue__c != null && (bp.ION_service_s_you_intend_to_sell__c != PRMGlobalConstants.ServiceDefaultVal && bp.ION_service_s_you_intend_to_sell__c != null))){
							   if((bp.Expected_Amount_ION_Product_Revenue__c != null && (bp.ION_product_s_you_intend_to_sell__c != PRMGlobalConstants.ProductDefaultVal && bp.ION_product_s_you_intend_to_sell__c != null))){
								   if(bp.Expected_Amount_ION_Services_Revenue__c != null && (bp.ION_service_s_you_intend_to_sell__c.equals(PRMGlobalConstants.ServiceDefaultVal) || bp.ION_service_s_you_intend_to_sell__c == null)){
									   errMsg = PRMGlobalConstants.sellIONs;
									   errorMessageList.add(errMsg);
								   }else if(bp.Expected_Amount_ION_Services_Revenue__c == null && (bp.ION_service_s_you_intend_to_sell__c != PRMGlobalConstants.ServiceDefaultVal && bp.ION_service_s_you_intend_to_sell__c != null)){
									   errMsg = PRMGlobalConstants.exIONs;
									   errorMessageList.add(errMsg);
								   }else {}
							   }else{
								   if((bp.Expected_Amount_ION_Product_Revenue__c != null && (bp.ION_product_s_you_intend_to_sell__c.equals(PRMGlobalConstants.ProductDefaultVal) || bp.ION_product_s_you_intend_to_sell__c == null))){
									   errMsg = PRMGlobalConstants.sellIONp;
									   errorMessageList.add(errMsg);
								   }else if(bp.Expected_Amount_ION_Product_Revenue__c == null && (bp.ION_product_s_you_intend_to_sell__c != PRMGlobalConstants.ProductDefaultVal && bp.ION_product_s_you_intend_to_sell__c != null)){
									   errMsg = PRMGlobalConstants.exIONp;
									   errorMessageList.add(errMsg);
								   }else {}
							   }							
						   }					   
						   else{
							   errMsg = PRMGlobalConstants.onlyYYION;
							   errorMessageList.add(errMsg);
						   }
					   }
					   else{
						   if(bp.Expected_Amount_ION_Product_Revenue__c != null){
							   yy_ION = true;
							   if(bp.ION_product_s_you_intend_to_sell__c.equals(PRMGlobalConstants.ProductDefaultVal) || bp.ION_product_s_you_intend_to_sell__c == null){
								   errMsg = PRMGlobalConstants.sellIONp;
								   errorMessageList.add(errMsg);
							   }							
						   }else{
							   if(bp.ION_product_s_you_intend_to_sell__c != PRMGlobalConstants.ProductDefaultVal && bp.ION_product_s_you_intend_to_sell__c !=null){
								   errMsg = PRMGlobalConstants.exIONp;
								   errorMessageList.add(errMsg);
								   yy_ION = true;
							   }								
						   }
						   if(bp.Expected_Amount_ION_Services_Revenue__c != null){
							   yy_ION = true;
							   if(bp.ION_service_s_you_intend_to_sell__c.equals(PRMGlobalConstants.ServiceDefaultVal) || bp.ION_service_s_you_intend_to_sell__c == null){
								   errMsg = PRMGlobalConstants.sellIONs;
								   errorMessageList.add(errMsg);
							   }							
						   }else{
							   if((bp.ION_service_s_you_intend_to_sell__c != PRMGlobalConstants.ServiceDefaultVal && bp.ION_service_s_you_intend_to_sell__c != null)){
								   errMsg = PRMGlobalConstants.exIONs;
								   errorMessageList.add(errMsg);
								   yy_ION = true;						   
							   }
						   }
						   if(yy_ION){
							   errMsg = PRMGlobalConstants.noYYION;
							   errorMessageList.add(errMsg);
						   }				
					   }
					   if(bp.Expected_YY_Growth_by_FN__c != null ){
						   if((bp.Expected_Amount_FN_Product_Revenue__c != null && (bp.FN_product_s_you_intend_to_sell__c != PRMGlobalConstants.ProductDefaultVal && bp.FN_product_s_you_intend_to_sell__c !=null)) || (bp.Expected_Amount_FN_Services_Revenue__c != null && (bp.FN_service_s_you_intend_to_sell__c != PRMGlobalConstants.ServiceDefaultVal && bp.FN_service_s_you_intend_to_sell__c !=null))){
							   if((bp.Expected_Amount_FN_Product_Revenue__c != null && (bp.FN_product_s_you_intend_to_sell__c != PRMGlobalConstants.ProductDefaultVal && bp.FN_product_s_you_intend_to_sell__c !=null))){
								   if(bp.Expected_Amount_FN_Services_Revenue__c != null && (bp.FN_service_s_you_intend_to_sell__c.equals(PRMGlobalConstants.ServiceDefaultVal) || bp.FN_service_s_you_intend_to_sell__c == null)){
									   errMsg = PRMGlobalConstants.sellFNs;
									   errorMessageList.add(errMsg);
								   }else if(bp.Expected_Amount_FN_Services_Revenue__c == null && (bp.FN_service_s_you_intend_to_sell__c != PRMGlobalConstants.ServiceDefaultVal && bp.FN_service_s_you_intend_to_sell__c !=null)){
									   errMsg = PRMGlobalConstants.exFNs;
									   errorMessageList.add(errMsg);
								   }else {}
							   }else{
								   if((bp.Expected_Amount_FN_Product_Revenue__c != null && (bp.FN_product_s_you_intend_to_sell__c.equals(PRMGlobalConstants.ProductDefaultVal) ||  bp.FN_product_s_you_intend_to_sell__c ==null))){
									   errMsg =  PRMGlobalConstants.sellFNp;
									   errorMessageList.add(errMsg);
								   }else if(bp.Expected_Amount_FN_Product_Revenue__c == null && (bp.FN_product_s_you_intend_to_sell__c != PRMGlobalConstants.ProductDefaultVal && bp.FN_product_s_you_intend_to_sell__c !=null)){
									   errMsg = PRMGlobalConstants.exFNp;
									   errorMessageList.add(errMsg);
								   }else {}
							   }
						   }
						   else{
							   errMsg = PRMGlobalConstants.onlyYYFN;
							   errorMessageList.add(errMsg);
						   }
					   }else{
						   if(bp.Expected_Amount_FN_Product_Revenue__c != null){
							   yy_FN = true;
							   if(bp.FN_product_s_you_intend_to_sell__c.equals(PRMGlobalConstants.ProductDefaultVal) || bp.FN_product_s_you_intend_to_sell__c ==null){
								   errMsg = PRMGlobalConstants.sellFNp;
								   errorMessageList.add(errMsg);
							   }							
						   }else{
							   if((bp.FN_product_s_you_intend_to_sell__c != PRMGlobalConstants.ProductDefaultVal && bp.FN_product_s_you_intend_to_sell__c !=null)){
								   errMsg = PRMGlobalConstants.exFNp;
								   errorMessageList.add(errMsg);
								   yy_FN = true;
							   }								
						   }
						   if(bp.Expected_Amount_FN_Services_Revenue__c != null){
							   yy_FN = true;
							   if(bp.FN_service_s_you_intend_to_sell__c.equals(PRMGlobalConstants.ServiceDefaultVal) || bp.FN_service_s_you_intend_to_sell__c == null){
								   errMsg = PRMGlobalConstants.sellFNs;
								   errorMessageList.add(errMsg);
							   }							
						   }else{
							   if((bp.FN_service_s_you_intend_to_sell__c != PRMGlobalConstants.ServiceDefaultVal && bp.FN_service_s_you_intend_to_sell__c !=null)){
								   errMsg = PRMGlobalConstants.exFNs;
								   errorMessageList.add(errMsg);
								   yy_FN = true;
							   }							
						   }
						   if(yy_FN){
							   errMsg = PRMGlobalConstants.noYYFN;
							   errorMessageList.add(errMsg);
						   }				
					   }
					   if(bp.Expected_YY_Growth_by_MN__c != null ){
						   if((bp.Expected_Amount_MN_Product_Revenue__c != null && (bp.MN_product_s_you_intend_to_sell__c != PRMGlobalConstants.ProductDefaultVal && bp.MN_product_s_you_intend_to_sell__c != null)) || (bp.Expected_Amount_MN_Services_Revenue__c != null && (bp.MN_service_s_you_intend_to_sell__c != PRMGlobalConstants.ServiceDefaultVal && bp.MN_service_s_you_intend_to_sell__c != null))){
							   if((bp.Expected_Amount_MN_Product_Revenue__c != null && (bp.MN_product_s_you_intend_to_sell__c != PRMGlobalConstants.ProductDefaultVal && bp.MN_product_s_you_intend_to_sell__c != null))){
								   if(bp.Expected_Amount_MN_Services_Revenue__c != null && (bp.MN_service_s_you_intend_to_sell__c.equals(PRMGlobalConstants.ServiceDefaultVal) || bp.MN_service_s_you_intend_to_sell__c == null)){
									   errMsg = PRMGlobalConstants.sellMNs;
									   errorMessageList.add(errMsg);
								   }else if(bp.Expected_Amount_MN_Services_Revenue__c == null && (bp.MN_service_s_you_intend_to_sell__c != PRMGlobalConstants.ServiceDefaultVal && bp.MN_service_s_you_intend_to_sell__c != null)){
									   errMsg = PRMGlobalConstants.exMNs;
									   errorMessageList.add(errMsg);
								   }else {}
							   }else{
								   if((bp.Expected_Amount_MN_Product_Revenue__c != null && (bp.MN_product_s_you_intend_to_sell__c.equals(PRMGlobalConstants.ProductDefaultVal) || bp.MN_product_s_you_intend_to_sell__c == null))){
									   errMsg = PRMGlobalConstants.sellMNp;
									   errorMessageList.add(errMsg);
								   }else if(bp.Expected_Amount_MN_Product_Revenue__c == null && (bp.MN_product_s_you_intend_to_sell__c != PRMGlobalConstants.ProductDefaultVal && bp.MN_product_s_you_intend_to_sell__c != null)){
									   errMsg = PRMGlobalConstants.exMNp;
									   errorMessageList.add(errMsg);
								   }else {}
							   }
						   }
						   else{
							   errMsg = PRMGlobalConstants.onlyYYMN;
							   errorMessageList.add(errMsg);
						   }
					   }else{
						   if(bp.Expected_Amount_MN_Product_Revenue__c != null){
							   yy_MN = true;
							   if(bp.MN_product_s_you_intend_to_sell__c.equals(PRMGlobalConstants.ProductDefaultVal) || bp.MN_product_s_you_intend_to_sell__c == null){
								   errMsg = PRMGlobalConstants.sellMNp;
								   errorMessageList.add(errMsg);
							   }							
						   }else{
							   if(bp.MN_product_s_you_intend_to_sell__c != PRMGlobalConstants.ProductDefaultVal && bp.MN_product_s_you_intend_to_sell__c != null){
								   errMsg = PRMGlobalConstants.exMNp;
								   errorMessageList.add(errMsg);
								   yy_MN = true;
							   }								
						   }
						   if(bp.Expected_Amount_MN_Services_Revenue__c != null){
							   yy_MN = true;
							   if(bp.MN_service_s_you_intend_to_sell__c.equals(PRMGlobalConstants.ServiceDefaultVal) || bp.MN_service_s_you_intend_to_sell__c == null){
								   errMsg = PRMGlobalConstants.sellMNs;
								   errorMessageList.add(errMsg);
							   }							
						   }else{
							   if((bp.MN_service_s_you_intend_to_sell__c != PRMGlobalConstants.ServiceDefaultVal && bp.MN_service_s_you_intend_to_sell__c != null)){
								   errMsg = PRMGlobalConstants.exMNs;
								   errorMessageList.add(errMsg);
								   yy_MN = true;							
							   }							
						   }
						   if(yy_MN){
							   errMsg = PRMGlobalConstants.noYYMN;
							   errorMessageList.add(errMsg);
						   }				
					   }
					   if(bp.Expected_YY_Growth_by_A_A__c != null ){
						   if((bp.Expected_Amount_A_A_Product_Revenue__c != null && (bp.A_A_product_s_you_intend_to_sell__c != PRMGlobalConstants.ProductDefaultVal && bp.A_A_product_s_you_intend_to_sell__c != null)) || (bp.Expected_Amount_A_A_Services_Revenue__c != null && (bp.A_A_service_s_you_intend_to_sell__c != PRMGlobalConstants.ServiceDefaultVal && bp.A_A_service_s_you_intend_to_sell__c != null))){
							   if((bp.Expected_Amount_A_A_Product_Revenue__c != null && (bp.A_A_product_s_you_intend_to_sell__c != PRMGlobalConstants.ProductDefaultVal && bp.A_A_product_s_you_intend_to_sell__c != null))){
								   if(bp.Expected_Amount_A_A_Services_Revenue__c != null && (bp.A_A_service_s_you_intend_to_sell__c.equals(PRMGlobalConstants.ServiceDefaultVal) || bp.A_A_service_s_you_intend_to_sell__c == null)){
									   errMsg = PRMGlobalConstants.sellAAs;
									   errorMessageList.add(errMsg);
								   }else if(bp.Expected_Amount_A_A_Services_Revenue__c == null && (bp.A_A_service_s_you_intend_to_sell__c != PRMGlobalConstants.ServiceDefaultVal && bp.A_A_service_s_you_intend_to_sell__c != null)){
									   errMsg = PRMGlobalConstants.exAAs;
									   errorMessageList.add(errMsg);
								   }else {}
							   }else{
								   if((bp.Expected_Amount_A_A_Product_Revenue__c != null && (bp.A_A_product_s_you_intend_to_sell__c.equals(PRMGlobalConstants.ProductDefaultVal) || bp.A_A_product_s_you_intend_to_sell__c == null ))){
									   errMsg = PRMGlobalConstants.sellAAp;
									   errorMessageList.add(errMsg);
								   }else if(bp.Expected_Amount_A_A_Product_Revenue__c == null && (bp.A_A_product_s_you_intend_to_sell__c != PRMGlobalConstants.ProductDefaultVal && bp.A_A_product_s_you_intend_to_sell__c != null)){
									   errMsg = PRMGlobalConstants.exAAp;
									   errorMessageList.add(errMsg);
								   }else {}
							   }
						   }
						   else{
							   errMsg = PRMGlobalConstants.onlyYYAA;
							   errorMessageList.add(errMsg);
						   }
					   }else{
						   if(bp.Expected_Amount_A_A_Product_Revenue__c != null){
							   yy_AA = true;
							   if(bp.A_A_product_s_you_intend_to_sell__c.equals(PRMGlobalConstants.ProductDefaultVal) || bp.A_A_product_s_you_intend_to_sell__c == null){
								   errMsg = PRMGlobalConstants.sellAAp;
								   errorMessageList.add(errMsg);
							   }							
						   }else{
							   if(bp.A_A_product_s_you_intend_to_sell__c != PRMGlobalConstants.ProductDefaultVal && bp.A_A_product_s_you_intend_to_sell__c != null){
								   errMsg = PRMGlobalConstants.exAAp;
								   errorMessageList.add(errMsg);
								   yy_AA = true;
							   }								
						   }
						   if(bp.Expected_Amount_A_A_Services_Revenue__c != null){
							   yy_AA = true;
							   if(bp.A_A_service_s_you_intend_to_sell__c.equals(PRMGlobalConstants.ServiceDefaultVal) || bp.A_A_service_s_you_intend_to_sell__c == null){
								   errMsg = PRMGlobalConstants.sellAAs;
								   errorMessageList.add(errMsg);
							   }							
						   }else{
							   if((bp.A_A_service_s_you_intend_to_sell__c != PRMGlobalConstants.ServiceDefaultVal && bp.A_A_service_s_you_intend_to_sell__c != null)){
								   errMsg = PRMGlobalConstants.exAAs;
								   errorMessageList.add(errMsg);
								   yy_AA = true;
							   }							
						   }
						   if(yy_AA){
							   errMsg = PRMGlobalConstants.noYYAA;
							   errorMessageList.add(errMsg);
						   }				
					   }
					   if(bp.Expected_YY_Growth_by_GS__c != null ){
						   if((bp.Expected_Amount_GS_Product_Revenue__c != null && (bp.GS_product_s_you_intend_to_sell__c != PRMGlobalConstants.ProductDefaultVal && bp.GS_product_s_you_intend_to_sell__c != null)) || (bp.Expected_Amount_GS_Services_Revenue__c != null && (bp.GS_service_s_you_intend_to_sell__c != PRMGlobalConstants.ServiceDefaultVal && bp.GS_service_s_you_intend_to_sell__c != null))){
							   if((bp.Expected_Amount_GS_Product_Revenue__c != null && (bp.GS_product_s_you_intend_to_sell__c != PRMGlobalConstants.ProductDefaultVal && bp.GS_product_s_you_intend_to_sell__c != null))){
								   if(bp.Expected_Amount_GS_Services_Revenue__c != null && (bp.GS_service_s_you_intend_to_sell__c.equals(PRMGlobalConstants.ServiceDefaultVal) || bp.GS_service_s_you_intend_to_sell__c ==null)){
									   errMsg = PRMGlobalConstants.sellGSs;
									   errorMessageList.add(errMsg);
								   }else if(bp.Expected_Amount_GS_Services_Revenue__c == null && (bp.GS_service_s_you_intend_to_sell__c != PRMGlobalConstants.ServiceDefaultVal && bp.GS_service_s_you_intend_to_sell__c != null)){
									   errMsg = PRMGlobalConstants.exGSs;
									   errorMessageList.add(errMsg);
								   }else {}
							   }else{
								   if((bp.Expected_Amount_GS_Product_Revenue__c != null && (bp.GS_product_s_you_intend_to_sell__c.equals(PRMGlobalConstants.ProductDefaultVal) || bp.GS_product_s_you_intend_to_sell__c == null))){
									   errMsg = PRMGlobalConstants.sellGSp;
									   errorMessageList.add(errMsg);
								   }else if(bp.Expected_Amount_GS_Product_Revenue__c == null && (bp.GS_product_s_you_intend_to_sell__c != PRMGlobalConstants.ProductDefaultVal && bp.GS_product_s_you_intend_to_sell__c != null)){
									   errMsg = PRMGlobalConstants.exGSp;
									   errorMessageList.add(errMsg);
								   }else {}
							   }
						   }
						   else{
							   errMsg = PRMGlobalConstants.onlyYYGS;
							   errorMessageList.add(errMsg);
						   }
					   }else{
						   if(bp.Expected_Amount_GS_Product_Revenue__c != null){
							   yy_GS = true;
							   if(bp.GS_product_s_you_intend_to_sell__c.equals(PRMGlobalConstants.ProductDefaultVal) || bp.GS_product_s_you_intend_to_sell__c == null){
								   errMsg = PRMGlobalConstants.sellGSp;
								   errorMessageList.add(errMsg);
							   }							
						   }else{
							   if(bp.GS_product_s_you_intend_to_sell__c != PRMGlobalConstants.ProductDefaultVal && bp.GS_product_s_you_intend_to_sell__c != null){
								   errMsg = PRMGlobalConstants.exGSp;
								   errorMessageList.add(errMsg);
								   yy_GS = true;
							   }								
						   }
						   if(bp.Expected_Amount_GS_Services_Revenue__c != null){
							   yy_GS = true;
							   if(bp.GS_service_s_you_intend_to_sell__c.equals(PRMGlobalConstants.ServiceDefaultVal) || bp.GS_service_s_you_intend_to_sell__c ==null){
								   errMsg = PRMGlobalConstants.sellGSs;
								   errorMessageList.add(errMsg);
							   }							
						   }else{
							   if((bp.GS_service_s_you_intend_to_sell__c != PRMGlobalConstants.ServiceDefaultVal && bp.GS_service_s_you_intend_to_sell__c != null)){
								   errMsg = PRMGlobalConstants.exGSs;
								   errorMessageList.add(errMsg);
								   yy_GS = true;
							   }						   
						   }
						   if(yy_GS){
							   errMsg = PRMGlobalConstants.noYYGS;
							   errorMessageList.add(errMsg);
						   }				
					   }	
				   }
				   if(bp.Territory_Covered_in_Business_Plan__c == null || bp.Nokia_Product_Portfolio_represented__c == null){
					   errMsg = PRMGlobalConstants.noBPI;
					   errorMessageList.add(errMsg);					
				   }
				   if(bp.Is_the_company_Public_or_Private__c == null || bp.Company_Annual_Revenue_attributed_to_IT__c == null){
					   errMsg = PRMGlobalConstants.noPSS;
					   errorMessageList.add(errMsg);					
				   }
				   if(bp.Joint_Business_Objectives_by_Industry__c == null || bp.Which_Business_Segments_do_you_serve__c == null ||
					  bp.Competitive_Portfolio_you_represent__c == null||  bp.Complementary_Portfolio_you_represent__c == null){
						  errMsg = PRMGlobalConstants.noGIS;
						  errorMessageList.add(errMsg);				 
					  } 
					  //SFPRM-212 - Removing this check from if statement  bp.Investment_Number__c == 0 ||)
				   if(bp.Marketing_Plan_and_Industry_Events_Count__c == 0 
					  || bp.Training_Certification_Plan_Count__c == 0){
						  errMsg = PRMGlobalConstants.noMTI;
						  errorMessageList.add(errMsg);
					  }			 
			   }
			if(noChange){
				errMsg = System.Label.User_did_not_filled_in_any_Business_Objectives_Product_and_or_service_section;
				errorMessageList.add(errMsg);
			}
			if(!errorMessageList.IsEmpty()){
				bp.addError(String.join(errorMessageList, PRMGlobalConstants.NewLineChar));
			}
		}catch(Exception e) {ExceptionHandler.addException(e,PRMGlobalConstants.BPTRiggerHelper ,PRMGlobalConstants.ValidateApprovalProcessCriteria);}
	}
	
	/********************
*Method Name: validateApprovalProcessCriteria
*Parameter: 
*Description: Used to handle After Update activities
1. Throw Error Before Submission of Approval
*******************/
	public static void updateAccNAccreditation(list<Business_Plan__c> newBP){
		try{		   
			list<Accreditation__c> accredToUpdate = new list<Accreditation__c>();
			set<ID> accId = new set<ID>();
			map<ID, String> accountBPStatus = new Map<ID, String>();			
			for(Business_Plan__c bP : newBP){
				accId.add(bP.Account_BP__c);
				accountBPStatus.put(bP.Account_BP__c, bP.Business_Plan_Status__c);
			}		   
			for(Accreditation__c Accred : [select id, name, Evaluated_Accreditation__c, Partner__c from Accreditation__c where Partner__c in: accId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
				Accred.Evaluated_Accreditation__c = true;
				Accred.Partner_Business_Plan_Status__c = accountBPStatus.get(Accred.Partner__c);
				accredToUpdate.add(Accred);
			}		   
			Database.update(accredToUpdate);	   
		}catch(Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.BPTRiggerHelper ,PRMGlobalConstants.updateAccNAccreditation );}
	}
	   /********************
*Method Name: createTaskForReviewEmail
*Parameter: 
*Description: 
*******************/
	public static void createTaskForReviewEmail(list<Business_Plan__c> newBPList, Map<Id, Business_Plan__c>oldBPMap) {
		List<Business_Plan__c> bpList = new List<Business_Plan__c>();
		Set<Id> psmSetIds = new Set<Id>();
		try{		   
			for(Business_Plan__c bp : newBPList) {
				if(bp.Send_Review_Email__c && bp.Send_Review_Email__c != oldBPMap.get(bp.Id).Send_Review_Email__c) {
					bpLIst.add(bp);
					psmSetIds.add(bp.Nokia_Partner_Primary_Partner__c);
				}
			}
			List<Task> taskPRM = new List<Task>();
			/*for(Business_Plan__c bp : bpLIst) {
				Task tsk = new Task();
				tsk.Subject = PRMGlobalConstants.REVIEW_PRM_SUBJECT;
				tsk.WhatId = bp.Account_BP__c;
				tsk.OwnerId = bp.Primary_Partner_Program_Contact_s_PRM__c;
				taskPRM.add(tsk);
			}*/
			for(Id pId : psmSetIds) {
				Task tsk = new Task();
				tsk.Subject = PRMGlobalConstants.REVIEW_PSM_SUBJECT;
				tsk.OwnerId = pId;
				tsk.Description = PRMGlobalConstants.REVIEW_PSM_COMMENT;
				taskPRM.add(tsk);
			}
			database.insert(taskPRM);
		}catch(Exception e){
			system.debug('messges:::'+e.getMessage());
			ExceptionHandler.addException(e,PRMGlobalConstants.BPTRiggerHelper ,PRMGlobalConstants.createTaskForReviewEmail );}
	}
	
}