/**
* @description	   : 
* @author			: Yashdeep Prajapati
* @group			 : 
* @last modified on  : 06-16-2021
* @last modified by  : Yashdeep Prajapati
* Modifications Log 
* Ver   Date		 Author			   Modification
* 1.0   06-16-2021   Yashdeep Prajapati   Initial Version
**/
public inherited sharing class NokiaCPQ_CloneSitePhase implements Queueable {
	Map<Id,Apttus_Proposal__Proposal__c> mProposal = new Map<Id,Apttus_Proposal__Proposal__c>();
	public NokiaCPQ_CloneSitePhase(Map<Id,Apttus_Proposal__Proposal__c> mProposal){
		this.mProposal = mProposal;
	}
	public void execute(QueueableContext context) {
		//cloneQuote(mProposal);
		for(String QuoteId :mProposal.keyset()){
			cloneSitePhaseQuanity(mProposal.get(QuoteId).NokiaCPQ_Orignal_Quote_Id__c,QuoteId);
		}
	}
	
	public static void cloneSitePhaseQuanity(Id oldQuote, Id clonedQuote){
		List<CPQ_Site_Phase_and_Quantity__c> listToInsert= new List<CPQ_Site_Phase_and_Quantity__c>();
		list<Apttus_Config2__LineItem__c> listLineItems= new list<Apttus_Config2__LineItem__c>();
		list<Apttus_Config2__LineItem__c> listLineItemsCloned= new list<Apttus_Config2__LineItem__c>();
		Set<Id> configIDsCloned= new Set<Id>();
		Map<String,list<CPQ_Site_Phase_and_Quantity__c>> lineWithSitePhase= new Map<String,list<CPQ_Site_Phase_and_Quantity__c>>();
		Map<String,list<CPQ_Site_Phase_and_Quantity__c>> lineIdWithSitePhase= new Map<String,list<CPQ_Site_Phase_and_Quantity__c>>();
			listLineItems=[SELECT id,Apttus_Config2__LineNumber__c,Apttus_Config2__ProductId__c,Apttus_Config2__ProductOptionId__c,Name, (SELECT id,Name,Line_Item__c,NCPQ_Phase__c,NCPQ_Quantity__c,NCPQ_Site__c FROM Site_Phase_and_Quantity__r ORDER BY NCPQ_Site__r.Name,NCPQ_Phase__r.Name) FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c = :oldQuote AND Apttus_Config2__LineType__c = :Nokia_CPQ_Constants.NOKIA_PRODUCT_SERVICES];  
		system.debug('listLineItems-->'+listLineItems);
		if(listLineItems != null && !listLineItems.isEmpty()){
			for(Apttus_Config2__LineItem__c line:listLineItems){
				if(line.Site_Phase_and_Quantity__r != null && !line.Site_Phase_and_Quantity__r.isEmpty()){
					for (CPQ_Site_Phase_and_Quantity__c rec : line.Site_Phase_and_Quantity__r) {
						if(!lineIdWithSitePhase.containsKey(rec.Line_Item__c)){
							lineIdWithSitePhase.put(rec.Line_Item__c, new list<CPQ_Site_Phase_and_Quantity__c>{rec});
						}else{
							List<CPQ_Site_Phase_and_Quantity__c> lSitePhase = lineIdWithSitePhase.get(rec.Line_Item__c);
							lSitePhase.add(rec);
							lineIdWithSitePhase.put(rec.Line_Item__c, lSitePhase);
						}  
					}
				}
			}
			
		}
		if(!lineIdWithSitePhase.isEmpty()){
			system.debug('lineIdWithSitePhase-->'+lineIdWithSitePhase);
			for(Apttus_Config2__LineItem__c obj:listLineItems){
				String key= obj.Apttus_Config2__LineNumber__c +'-'+ obj.Apttus_Config2__ProductId__c +'-'+ obj.Apttus_Config2__ProductOptionId__c;
				lineWithSitePhase.put(key,lineIdWithSitePhase.get(obj.id));
			}	   
			// cloned quote
			listLineItemsCloned=[SELECT id,Apttus_Config2__LineNumber__c,Apttus_Config2__ProductId__c,Apttus_Config2__ProductOptionId__c,Name FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c = :clonedQuote]; 
			
			system.debug('listLineItemsCloned--'+listLineItemsCloned);
			system.debug('lineWithSitePhase--'+lineWithSitePhase);
			try{
				if(listLineItemsCloned!=null){
					for(Apttus_Config2__LineItem__c obj1:listLineItemsCloned){
						String cloneKey=obj1.Apttus_Config2__LineNumber__c +'-'+ obj1.Apttus_Config2__ProductId__c +'-'+ obj1.Apttus_Config2__ProductOptionId__c;
						if(lineWithSitePhase.get(cloneKey)!=null){
							for(CPQ_Site_Phase_and_Quantity__c obj2:lineWithSitePhase.get(cloneKey)){
								CPQ_Site_Phase_and_Quantity__c copyRec =obj2.clone(false,true);// new CPQ_Site_Phase_and_Quantity__c();
								copyRec.Line_Item__c = obj1.Id;
								listToInsert.add(copyRec);
							}
						}
						
					}
				}
				if(!listToInsert.isEmpty()){
					Database.insert(listToInsert,false);
					system.debug('system--'+listToInsert);
				}
			}
			Catch(Exception ex){  
				ExceptionHandler.addException(ex, 'NokiaCPQ_CloneSitePhase', 'cloneSitePhaseQuanity');
			}
		}
	}
}