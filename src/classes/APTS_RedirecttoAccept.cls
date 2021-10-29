public with sharing class APTS_RedirecttoAccept {
    
    public id proposalId;
    public boolean isRestrict;
    public APTS_RedirecttoAccept(ApexPages.StandardController controller) {
        proposalId= ApexPages.currentPage().getParameters().get('Id');
        isRestrict=false;
    }

    
    public pagereference ProoposalDetails(){
    
        Set<id> ProposalErrorAccountid = New Set<id>();
            
        list<Apttus_Proposal__Proposal__c> lstProposal=[select id,Apttus_Proposal__Approval_Stage__c,LastModifiedBy.Name,Apttus_Proposal__Account__r.ICAO_Code__c,Apttus_QPConfig__BillToAccountId__r.ICAO_Code__c,Apttus_QPConfig__ShipToAccountId__r.ICAO_Code__c,
                                                        Apttus_Proposal__Account__r.BillingStreet,Apttus_QPConfig__BillToAccountId__r.BillingStreet,Apttus_QPConfig__ShipToAccountId__r.BillingStreet,
                                                        Apttus_Proposal__Account__r.BillingCity,Apttus_QPConfig__BillToAccountId__r.BillingCity,Apttus_QPConfig__ShipToAccountId__r.BillingCity,
                                                        Apttus_Proposal__Account__r.BillingCountry,Apttus_QPConfig__BillToAccountId__r.BillingCountry,Apttus_QPConfig__ShipToAccountId__r.BillingCountry,
                                                        Apttus_QPConfig__BillToAccountId__c,Apttus_QPConfig__ShipToAccountId__c,Apttus_Proposal__Account__c from Apttus_Proposal__Proposal__c where id=:proposalId];
     
    
    for(Apttus_Proposal__Proposal__c proposal : lstProposal)
    {
               
        IF(proposal.Apttus_QPConfig__BillToAccountId__c != Null)
        {
        ProposalErrorAccountid.Add(proposal.Apttus_QPConfig__BillToAccountId__c);
        }
        IF(proposal.Apttus_QPConfig__ShipToAccountId__c != Null)
        {
        ProposalErrorAccountid.Add(proposal.Apttus_QPConfig__ShipToAccountId__c);
        }
        IF(proposal.Apttus_Proposal__Account__c != Null)
        {
        ProposalErrorAccountid.Add(proposal.Apttus_Proposal__Account__c);
        }       
    } 
       
     IF(ProposalErrorAccountid.Size()>0)
     {
     List<Account> lstAccount = [Select id,Name,ICAO_Code__c,BillingCity,BillingCountry,BillingStreet from Account where Id IN:ProposalErrorAccountid];
     System.debug('lstAccount'+lstAccount );
     For(Apttus_Proposal__Proposal__c proposal : lstProposal)
     {
       For(Account Acc :lstAccount)
       {
         IF( Acc.ICAO_Code__c == Null ) 
         { 
           IF(proposal.Apttus_Proposal__Account__c == Acc.Id && Proposal.Apttus_Proposal__Account__r.ICAO_Code__c == Null  )
           { 
           proposal.AddError( 'Missing SoldTo ICAO code for the Account - "'+ Acc.Name +'" !!' );
           return null;
           }
           Else IF(proposal.Apttus_QPConfig__BillToAccountId__c == Acc.Id && Proposal.Apttus_QPConfig__BillToAccountId__r.ICAO_Code__c == Null )
           {
           proposal.AddError( 'Missing BillTo ICAO code for the Account  - "'+ Acc.Name + '" !!' );
           return null;
           }
           Else IF(proposal.Apttus_QPConfig__ShipToAccountId__c == Acc.Id && Proposal.Apttus_QPConfig__ShipToAccountId__r.ICAO_Code__c == Null )
           { 
           proposal.AddError( 'Missing ShipTo ICAO code for the Account - "'+ Acc.Name + '" !!' );
           return null;
           }
         }
         Else IF(Acc.BillingStreet == Null)
         {
          
           IF(proposal.Apttus_Proposal__Account__c == Acc.Id && Proposal.Apttus_Proposal__Account__r.BillingStreet == Null)
           {
            proposal.AddError( 'Missing SoldTo Billing Street for the Account - "'+ Acc.Name + '" !!' );
            return null;
           }
           Else IF(proposal.Apttus_QPConfig__BillToAccountId__c == Acc.Id && Proposal.Apttus_QPConfig__BillToAccountId__r.BillingStreet == Null)
           {
            proposal.AddError( 'Missing BillTo Billing Street for the Account - "'+ Acc.Name + '" !!' );
            return null;
           }
           Else IF(proposal.Apttus_QPConfig__ShipToAccountId__c == Acc.Id && Proposal.Apttus_QPConfig__ShipToAccountId__r.BillingStreet == Null)
           {
            proposal.AddError( 'Missing ShipTo Billing Street for the Account - "'+ Acc.Name + '" !!' );
            return null;
           }
         }
         Else IF(Acc.BillingCity== Null)
         {
          
           IF(proposal.Apttus_Proposal__Account__c == Acc.Id && Proposal.Apttus_Proposal__Account__r.BillingCity== Null)
           {
            proposal.AddError( 'Missing SoldTo Billing City for the Account - "'+ Acc.Name + '" !!' );
            return null;
           }
           Else IF(proposal.Apttus_QPConfig__BillToAccountId__c == Acc.Id && Proposal.Apttus_QPConfig__BillToAccountId__r.BillingCity == Null)
           {
            proposal.AddError( 'Missing BillTo Billing City for the Account - "'+ Acc.Name + '" !!' );
            return null;
           }
           Else IF(proposal.Apttus_QPConfig__ShipToAccountId__c == Acc.Id && Proposal.Apttus_QPConfig__ShipToAccountId__r.BillingCity == Null)
           {
            proposal.AddError( 'Missing ShipTo Billing City for the Account - "'+ Acc.Name + '" !!' );
            return null;
           }
         }
         Else IF(Acc.BillingCountry == Null)
         {
          
           IF(proposal.Apttus_Proposal__Account__c == Acc.Id && Proposal.Apttus_Proposal__Account__r.BillingCountry == Null)
           {
            proposal.AddError( 'Missing SoldTo Billing Country for the Account - "'+ Acc.Name + '" !!');
            return null;
           }
           Else IF(proposal.Apttus_QPConfig__BillToAccountId__c == Acc.Id && Proposal.Apttus_QPConfig__BillToAccountId__r.BillingCountry == Null)
           {
            proposal.AddError( 'Missing BillTo Billing Country for the Account - "'+ Acc.Name + '" !!' );
            return null;
           }
           Else IF(proposal.Apttus_QPConfig__ShipToAccountId__c == Acc.Id && Proposal.Apttus_QPConfig__ShipToAccountId__r.BillingCountry == Null)
           {
            proposal.AddError( 'Missing ShipTo Billing Country for the Account - "'+ Acc.Name + '" !!' );
            return null;
           }
         }
       }
     }
     }
       
       list<APTS_User_Session_Proposal__c> lstUp=[select id,Proposal_Record_id__c,LastModifiedBy.Name from APTS_User_Session_Proposal__c where Proposal_Record_id__c=:proposalId];
       APTS_User_Session_Proposal__c objp1= new APTS_User_Session_Proposal__c();
       objp1.Proposal_Record_id__c=proposalId;
       objp1.User_Session_id__c=userinfo.getuserid();
       upsert objp1 Proposal_Record_id__c; 
       list<APTS_User_Session_Proposal__c> objpDelete = [select id from APTS_User_Session_Proposal__c where id=:objp1.id]; 
       list<Apttus_Proposal__Proposal__c> lstProposal1=[select id,Apttus_Proposal__Approval_Stage__c,LastModifiedBy.Name from Apttus_Proposal__Proposal__c where id=:proposalId];
       if(lstProposal1!=null && !lstProposal1.isempty())
        {
            for(Apttus_Proposal__Proposal__c objp:lstProposal1)
            {
                if(objp.Apttus_Proposal__Approval_Stage__c=='Accepted')
                {
                    delete objpDelete;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'This proposal is being modified by '+objp.LastModifiedBy.Name));
                    return null;
                }
                else if(lstUp!=null && !lstUp.isempty())
                {
                    delete objpDelete;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'This proposal is being modified by '+lstUp[0].LastModifiedBy.Name));
                    return null;
                }
                else
                {   
                    delete objpDelete;
                    return new PageReference('/apex/Apttus_QPConfig__ProposalAccept?id='+objp.Id);
                }
                    
            }
        }
        return null;
    }  
   
     
}