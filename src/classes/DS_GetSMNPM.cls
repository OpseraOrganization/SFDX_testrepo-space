/******************************************************************************************************
	Name : DS_GetSMNPM
	Created Date: 1 Aug 2019
	Created by: Accenture
	Description : This class will fetch SM,PM from opty team on quote insertion
*********************************************************************************************************/
Public without sharing class DS_GetSMNPM {

Public static integer limitRows=Limits.getLimitQueryRows()- Limits.getQueryRows(); 

/******************************************************************************************************
	Name : afterInsert
	Created Date: 1 Aug 2019
	Created by: Accenture
	Description : This Method will fetch SM,PM from opty team on quote insertion
*********************************************************************************************************/
	public static void getOptyTeamMember(Map<Id,Apttus_Proposal__Proposal__c> DS_newMap){
		try{
			Map<Id,Id> quoteNoptyMap = new Map<Id,Id>();
			List<Apttus_Proposal__Proposal__c> quoteList = new List<Apttus_Proposal__Proposal__c>();
		
			   if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
					System.debug('DS_newMap.values()---->'+DS_newMap.values());
					for(Apttus_Proposal__Proposal__c Quote:DS_newMap.values())
					{
						System.debug('Quote type>>>>'+Quote.Quote_Type__c);
						if(Quote.Quote_Type__c != null && Quote.Quote_Type__c =='Direct DS' ){
							quoteNoptyMap.put(Quote.id,Quote.Apttus_Proposal__Opportunity__c);
						}
					}
				
					System.debug('quoteNoptyMap--->'+quoteNoptyMap);
				
				
					map<id,id> mOtmsPM = new map<id,id>();
					  list<OpportunityTeamMember> otmsPM = new list<OpportunityTeamMember>([
					  SELECT id,opportunityId,TeamMemberRole,UserId 
					  FROM OpportunityTeamMember
					  WHERE opportunityId IN :quoteNoptyMap.values()
						AND  TeamMemberRole = 'Pricing Manager'] );
					  
					  
					   map<id,id> mOtmsSM = new map<id,id>();
					  list<OpportunityTeamMember> otmsSM = new list<OpportunityTeamMember>([
					  SELECT id,opportunityId,TeamMemberRole,UserId 
					  FROM OpportunityTeamMember
					  WHERE opportunityId IN :quoteNoptyMap.values()
						AND TeamMemberRole = 'Solution Manager'  ] );
					  
					  
				
					For(OpportunityTeamMember otm :otmsPM) {
				  
						mOtmsPM.put(otm.OpportunityId,otm.UserId);
					
					}
				  
					System.debug('mOtmsPM--->'+mOtmsPM);
				  
				  
					For(OpportunityTeamMember otm :otmsSM) {
				  
						mOtmsSM.put(otm.OpportunityId,otm.UserId);
					
					}
				  
					System.debug('mOtmsSM--->'+mOtmsSM);
				  
					Map<Id,Id> quoteNSM = new Map<Id,Id>();  
					Map<Id,Id> quoteNPM = new Map<Id,Id>(); 
			  
					for(Id Quote:quoteNoptyMap.keySet()){
				  
					   
					   Id optyId = quoteNoptyMap.get(Quote);
					   quoteNSM.put(Quote,mOtmsSM.get(optyId));
					   quoteNPM.put(Quote,mOtmsPM.get(optyId));
					
					}
				
					for(Apttus_Proposal__Proposal__c Quote:DS_newMap.values())
					{
						Apttus_Proposal__Proposal__c quoteRec  = new Apttus_Proposal__Proposal__c(Id = Quote.Id, Apttus_Proposal__Opportunity__c = Quote.Apttus_Proposal__Opportunity__c );
						System.debug('quoteRec--->'+quoteRec);
						System.debug('opty--->'+quoteRec.Apttus_Proposal__Opportunity__c); 
						System.debug('SM---->'+mOtmsSM.get(quoteRec.Apttus_Proposal__Opportunity__c)); 
						
						if(mOtmsSM.get(quoteRec.Apttus_Proposal__Opportunity__c) != null){
							quoteRec.DSSolutionManager__c = mOtmsSM.get(quoteRec.Apttus_Proposal__Opportunity__c);
						}
						if(mOtmsPM.get(quoteRec.Apttus_Proposal__Opportunity__c) != null){
						quoteRec.DSPricingManager__c = mOtmsPM.get(quoteRec.Apttus_Proposal__Opportunity__c);
						}
						quoteList.add(quoteRec);
						
						
					
					
					}
				
			 
					System.debug('quoteList--->'+quoteList);
					if(!quoteList.isEmpty()){
						update quoteList;
					}
			   }
		
		}catch(Exception e){
			ExceptionHandler.addException(e,'DS_GetSMNPM' ,'getOptyTeamMember');
		}
	}





}