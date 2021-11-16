public with Sharing class NokiaCPQ_dirQtMailController { 
 
	public Id quoteId {get;set;}
	public String QuoteApprovalDetails = '';
	public NokiaCPQ_dirQtMailController()
	{
	}
	public String getQuoteAppvlDtls(){
	Boolean itemFloorPrice = false;
	Boolean isFloorPrice = false;
	Boolean itemContractedPL = false;
	Boolean customProd = false;
	Boolean itemCLPInPDC = false;

	List<Apttus_Proposal__Proposal__c> QuoteProposal = new List<Apttus_Proposal__Proposal__c>();	
	QuoteProposal = [Select id,CurrencyIsoCode,Maintenance_Y1__c,Maintenance_Y2__c,SRS__c,SSP__c from Apttus_Proposal__Proposal__c where id =:quoteId];
	  if(QuoteProposal.size() > 0)
	  {
		if(QuoteProposal[0].Maintenance_Y1__c > 0 || QuoteProposal[0].Maintenance_Y2__c > 0 || QuoteProposal[0].SRS__c > 0 || QuoteProposal[0].SSP__c > 0)
		{   
		QuoteApprovalDetails += '- Maintenance price override \n';
		}
		}
	List<Apttus_Config2__LineItem__c> lineItem = new List<Apttus_Config2__LineItem__c>();
	lineItem = [Select id,is_Custom_Product__c,NokiaCPQ_Light_Color__c,NokiaCPQ_Is_CLP_in_PDC__c, NokiaCPQ_Is_Contracted_PLI__c,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__NetAdjustmentPercent__c, Apttus_Config2__Quantity__c, NokiaCPQ_ExtendedPrice_CUP__c, NokiaCPQ_Extended_CNP_Without_LSD__c, NokiaCPQ_Floor_Price__c , Custom_Product_Name__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c =:quoteId and Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c =:GlobalConstants.FINALIZED and Apttus_Config2__ChargeType__c = :Nokia_CPQ_Constants.STANDARD_PRICE] ;
	if(lineItem.size() > 0)
	{
	for(Apttus_Config2__LineItem__c itemRec : lineItem)
	{
		if(itemrec.NokiaCPQ_Light_Color__c == Nokia_CPQ_Constants.RED && itemRec.NokiaCPQ_Is_Contracted_PLI__c == true && (itemRec.NokiaCPQ_Extended_CNP_Without_LSD__c != itemRec.NokiaCPQ_ExtendedPrice_CUP__c || itemRec.Apttus_Config2__AdjustmentAmount__c != 0 || itemRec.Apttus_Config2__AdjustmentAmount__c != null))
		{
			itemContractedPL = true;
		}
		else if(itemrec.NokiaCPQ_Light_Color__c == Nokia_CPQ_Constants.RED && itemRec.NokiaCPQ_Is_CLP_in_PDC__c == true && (itemRec.NokiaCPQ_Extended_CNP_Without_LSD__c != itemRec.NokiaCPQ_ExtendedPrice_CUP__c || itemRec.Apttus_Config2__AdjustmentAmount__c != 0 || itemRec.Apttus_Config2__AdjustmentAmount__c != null))
		{
			itemCLPInPDC = true;
		}
		else if(itemRec.is_Custom_Product__c == true)
		{
			customProd = true;
		}
		else if(itemrec.NokiaCPQ_Light_Color__c == Nokia_CPQ_Constants.RED && itemRec.NokiaCPQ_Floor_Price__c ==null)
		{
			isfloorPrice = true;
		}
		else if(itemrec.NokiaCPQ_Light_Color__c == Nokia_CPQ_Constants.RED && itemRec.NokiaCPQ_Floor_Price__c !=null && (itemRec.NokiaCPQ_Extended_CNP_Without_LSD__c < (itemRec.Apttus_Config2__Quantity__c * itemRec.NokiaCPQ_Floor_Price__c)))
		{
			itemFloorPrice = true;
		}
	}
	}
	List<Apttus_Config2__ProductConfiguration__c> prodConfig  =new  List<Apttus_Config2__ProductConfiguration__c>();
	prodConfig = [Select id, NokiaCPQ_Count_Of_Red_Lights__c, NokiaCPQ_ContractedPL_Count__c,NokiaCPQ_CLP_in_PDC_Count__c, NokiaCPQ_Total_Extended_Floor_Price__c from Apttus_Config2__ProductConfiguration__c
	where Apttus_QPConfig__Proposald__c = :quoteId and Apttus_Config2__Status__c =:GlobalConstants.FINALIZED order by CreatedDate desc];
	system.debug('prodConfig'+prodConfig);
	If(prodConfig.size() > 0)
	{
		Apttus_Config2__ProductConfiguration__c configRec = new Apttus_Config2__ProductConfiguration__c();
		configRec = prodConfig.get(0);
		List<Apttus_Config2__SummaryGroup__c> summaryRec =new  List<Apttus_Config2__SummaryGroup__c>();
		summaryRec = [Select id, Apttus_Config2__NetPrice__c,Apttus_Config2__AdjustmentAmount__c from Apttus_Config2__SummaryGroup__c where Apttus_Config2__ConfigurationId__c= :configRec.Id and Name = 'Subtotal - Standard Price (One Time)' Limit 1];		
		system.debug('summaryRec'+summaryRec);
		if(summaryRec.size() > 0)
		{
		system.debug('summaryRec'+summaryRec.size());
			If(configRec.NokiaCPQ_Count_Of_Red_Lights__c > 0)
			{
			if(itemContractedPL == true)// || (summaryRec[0].Apttus_Config2__AdjustmentAmount__c != null && summaryRec[0].Apttus_Config2__AdjustmentAmount__c > 0 && configRec.NokiaCPQ_ContractedPL_Count__c > 0 ))
			{
			QuoteApprovalDetails += '- Discount on Contracted Price\n';
			}
			if(itemCLPInPDC == true)// || (summaryRec[0].Apttus_Config2__AdjustmentAmount__c != null && summaryRec[0].Apttus_Config2__AdjustmentAmount__c > 0 && configRec.NokiaCPQ_CLP_in_PDC_Count__c  > 0 ))
			{
			QuoteApprovalDetails += '- Discount applied on item which has same Product Discount Category as existing in customer price book\n';		 
			}
			if(customProd == true)
			{
			QuoteApprovalDetails += '- Custom Product\n' ; 
			}
			if(isFloorPrice == true)
			{
			QuoteApprovalDetails +=  '- Floor price error in CPQ. Please raise a smartCPQ support ticket\n'; 
			}
			if(itemFloorPrice == true)
			{
			QuoteApprovalDetails += '- Price below floor price\n' ; 
			}
			}
			else if(configRec.NokiaCPQ_Total_Extended_Floor_Price__c != null && summaryRec[0].Apttus_Config2__NetPrice__c < configRec.NokiaCPQ_Total_Extended_Floor_Price__c)
			{
	QuoteApprovalDetails +=  '- Extended CNP afer LSD at summary level is below the sum of Extended Floor Price\n';
			}
		}
	} 
	System.debug('QuoteApprovalDetails-->'+QuoteApprovalDetails);
	If( QuoteApprovalDetails != '')
	{
		QuoteApprovalDetails = QuoteApprovalDetails.removeEnd('\n');
	}
	return QuoteApprovalDetails;

	}

}