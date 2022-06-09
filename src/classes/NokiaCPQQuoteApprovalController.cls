public without sharing class NokiaCPQQuoteApprovalController{

 public String currentquoteId {get;set;}
 public String currentOpportunityId  {get; set;}
 public Apttus_Config2__ProductConfiguration__c productConfig;
 //public Apttus_Config2__ProductConfiguration__c productConfig;
 public Apttus_Proposal__Proposal__c quote; 
 public Boolean quoteApprovalReq{get; set;} 
 public Boolean quoteNeedReprice{get; set;} 
 public List<Apttus_Config2__LineItem__c> lineItem = new List<Apttus_Config2__LineItem__c>();
 
  public NokiaCPQQuoteApprovalController(){
  
	  currentquoteId = ApexPages.currentPage().getParameters().get(GlobalConstants.QUOTEID);
	  currentOpportunityId = ApexPages.currentPage().getParameters().get(GlobalConstants.OPPID);
	   
	   quote = [Select id,Maintenance_Y1__c,Maintenance_Y2__c,NokiaCPQ_Quote_CAD__c,is_CustomProductQuote__c,SSP__c,SRS__c,NokiaCPQ_LEO_Discount__c,NokiaCPQ_Environment_Access_Type__c,Apttus_Proposal__Approval_Stage__c,NokiaCPQ_Capture_Cancel_Recall_Action__c, NokiaCPQ_Pre_Approved_Discount_Range__c,Exchange_Rate__c, NokiaCPQ_Needs_Reprice__c ,NokiaCPQ_Total_Quote_Discount__c, NokiaCPQ_Approval_Required_Flag__c,Nokia_CPQ_SW_IRP_Discount__c,Nokia_CPQ_SEET_Margin__c,NokiaCPQ_Net_Amount_Quote__c, 
				NokiaCPQ_Total_CNP__c, Quote_Type__c,Apttus_Proposal__Account__r.L4Name__c,NokiaCPQ_has_Partner_Certified__c,NokiaCPQ_Portfolio__c,Is_List_Price_Only__c,Custom_Product_Quote__c from Apttus_Proposal__Proposal__c 
				where id = :currentquoteId limit 1];
				
	   productConfig = [Select id,Apttus_Config2__Status__c from Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c = :currentquoteId and Apttus_Config2__BusinessObjectType__c =: Nokia_CPQ_Constants.NOKIA_PROPOSAL and Apttus_Config2__Status__c =: GlobalConstants.FINALIZED Order by CreatedDate DESC limit 1]; 
	   
	   lineItem = [Select Id,is_Custom_Product__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = :productConfig.id and is_Custom_Product__c = true];
	   
	   /* if(!lineItem.isEmpty() && quote.NokiaCPQ_LEO_Discount__c==true)
	   {
		   quote.is_CustomProductQuote__c = true;
	   }*/ 
  }
  
  public void init() {

		try{
			if(productConfig != null)   
			{
				if(productConfig.Apttus_Config2__Status__c != GlobalConstants.FINALIZED)
				{
				   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,GlobalConstants.ERRORHP));
				}
				if(quote.NokiaCPQ_Needs_Reprice__c){
				   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Reprice the Quote before submitting for Approval')); 
				   quoteNeedReprice = true;
				}
				
				else if(quote.NokiaCPQ_has_Partner_Certified__c==true || quote.Maintenance_Y1__c > 0 || quote.Maintenance_Y2__c > 0|| quote.SSP__c > 0 || quote.SRS__c > 0 || quote.is_CustomProductQuote__c == true ||quote.Custom_Product_Quote__c > 0|| quote.NokiaCPQ_Quote_CAD__c>0){
					System.debug('I am in Submit for approval');
					submitforApproval(quote.id);
					quoteApprovalReq = true;
				}
			}
			
		   }catch(Exception e){
		   } 
		// return new PageReference(Nokia_CPQ_Constants.SLASH+currentquoteId);
		}
	
	//@future
	public static void submitforApproval(String quoteId) {
		Apttus_Approval.ApprovalsWebService.submitForApprovals('Apttus_Proposal__Proposal__c',quoteId);		
	}
	
	 public PageReference cancel() {
		return new PageReference(Nokia_CPQ_Constants.SLASH+currentquoteId);
	}  
}