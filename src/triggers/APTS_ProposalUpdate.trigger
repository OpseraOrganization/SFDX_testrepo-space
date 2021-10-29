trigger APTS_ProposalUpdate on Apttus_Proposal__Proposal__c (before Insert,before update) 
{
    
     IF(Trigger.IsBefore && Trigger.IsInsert)
    {
     Set<id> ProposalAcoountid = New Set<id>();  
     For(Apttus_Proposal__Proposal__c proposal : Trigger.new) 
     {
        IF((proposal.Apttus_Proposal__Account__c != Null && proposal.Apttus_QPConfig__PriceListId__c == Null)||(proposal.Apttus_Proposal__Account__c != Null && proposal.Apttus_QPConfig__PaymentTermId__c == Null)||(proposal.Apttus_Proposal__Account__c != Null && proposal.Apttus_QPConfig__BillingPreferenceId__c == Null))
        {
        	ProposalAcoountid.Add(proposal.Apttus_Proposal__Account__c);
        }
        
     }
     IF(ProposalAcoountid.Size()>0)
     {
     List<Account> lstAccount = [Select id,APTS_Price_List__c,Apttus_Config2__BillingPreferenceId__c,Apttus_Config2__PaymentTermId__c from Account where Id IN:ProposalAcoountid];
     For(Apttus_Proposal__Proposal__c proposal : Trigger.new)
     {
       For(Account Acc :lstAccount)
       {
          if(proposal.Apttus_Proposal__Account__c==Acc.Id)
          {
            if(proposal.Apttus_QPConfig__PriceListId__c == Null)
            	proposal.Apttus_QPConfig__PriceListId__c =Acc.APTS_Price_List__c;
            proposal.Apttus_QPConfig__PaymentTermId__c =Acc.Apttus_Config2__PaymentTermId__c;
            proposal.Apttus_QPConfig__BillingPreferenceId__c =Acc.Apttus_Config2__BillingPreferenceId__c;
          }  
       }
     }
     }
    }
    
    IF(Trigger.IsBefore && Trigger.IsUpdate)
    {
    
    Map<ID, ID> proposalToTermMap = new Map<ID, ID>();
    for(Apttus_Proposal__Proposal__c proposal : Trigger.new){
        /*
         * copy currency from price list
         */
        proposal.CurrencyIsoCode = proposal.APTS_Price_List_Currecy__c;
        
           
        
        if(Trigger.oldMap.get(proposal.id).Apttus_Proposal__Approval_Stage__c != 'Accepted' && proposal.Apttus_Proposal__Approval_Stage__c=='Accepted' && proposal.APTS_SimulateOrderStatus__c=='Completed'){
            ID paymentTermId = null;
            /*
             * get payment term id
             */
            if(proposal.Apttus_QPConfig__PaymentTermId__c!=null){
                paymentTermId = proposal.Apttus_QPConfig__PaymentTermId__c;
            } else if(proposal.Apttus_Proposal__Account__c!=null){
                paymentTermId = [select Apttus_Config2__PaymentTermId__c from Account where id = :proposal.Apttus_Proposal__Account__c].Apttus_Config2__PaymentTermId__c;
            }
            proposalToTermMap.put(proposal.id, paymentTermId);
        }
        
        if (!proposalToTermMap.isEmpty()) {
            /*
             * set payment term for proposal line items
             */
            List<Apttus_Proposal__Proposal_Line_Item__c> proposaleLineItems = [select Id, Apttus_QPConfig__PaymentTermId__c, Apttus_Proposal__Proposal__c From Apttus_Proposal__Proposal_Line_Item__c
                                                                               where Apttus_Proposal__Proposal__c in :proposalToTermMap.keySet()];
            if(proposaleLineItems!=null && !proposaleLineItems.isEmpty()){
                for(Apttus_Proposal__Proposal_Line_Item__c proposalLineItem : proposaleLineItems){
                    proposalLineItem.Apttus_QPConfig__PaymentTermId__c = proposalToTermMap.get(proposalLineItem.Apttus_Proposal__Proposal__c);
                }
                update proposaleLineItems;
            }
        } 
     }
     
     
    }
}