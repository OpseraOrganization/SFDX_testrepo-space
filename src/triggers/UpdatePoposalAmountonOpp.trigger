trigger UpdatePoposalAmountonOpp on Opportunity_Proposal__c (after insert,after Update) {
    set<id> opprid = new set<id>();
    List<Opportunity_Proposal__c> opprlist = new List<Opportunity_Proposal__c>();
    List<Opportunity> opplist = new List<Opportunity>();
    Opportunity[] opplistupdate = new Opportunity[]{};
    for(Opportunity_Proposal__c op:trigger.new){
        opprid.add(op.Opportunity__c);
    }
    if(opprid.size()>0){
        opprlist = [Select id,Total_Contract_Value_BAFO__c,Proposal_Status__c,Request_Type__c,Opportunity__c from Opportunity_Proposal__c where Opportunity__c=:opprid];
        opplist = [select id,Win_Loss_Proposal_Amount__c,Win_Loss_Amount__c,Parent_Opportunity__c,Total_Win_Loss_Proposal_Amount__c,Total_Win_Loss_Amount__c from Opportunity where id =:opprid];
    }
    if(opprlist.size()>0){
        for(Opportunity opp:opplist){
            Decimal Temp = 0; Decimal Temp1 = 0; Decimal Temp2 = 0; 
            for(Opportunity_Proposal__c oppr:opprlist){
                if(oppr.Opportunity__c == opp.id && oppr.Total_Contract_Value_BAFO__c !=null 
                        && oppr.Request_Type__c == 'RFP / RFQ' 
                        && (oppr.Proposal_Status__c!='Pre-Solicitation/Pre-Work' && oppr.Proposal_Status__c!='Cancelled' && oppr.Proposal_Status__c!='Superseded')){
                    temp = temp + oppr.Total_Contract_Value_BAFO__c;
                }
            }
            opp.Win_Loss_Proposal_Amount__c = temp;
            opplistupdate.add(opp);
        }
        if(opplistupdate.size()>0){
            try{
                update opplistupdate;
            }catch(DMLException e){}
        }
    }
}