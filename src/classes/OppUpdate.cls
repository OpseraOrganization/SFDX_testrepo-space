Public class OppUpdate {
    @future
    public static void opportunityfieldupdate(String oppId) {
        Opportunity[] opplist = new Opportunity[]{};
        List<Opportunity> opp = [select id, Opp_Update__c, Parent_Opportunity__c, Name from Opportunity where id=:oppId];
        if(opp!=null && opp.size()>0){
            for(Integer i=0;i<opp.size();i++){
                if(opp[i].Opp_Update__c == false)
                    opp[i].Opp_Update__c = true;
                else
                    opp[i].Opp_Update__c = false;
                opplist.add(opp[i]);
            }
        }
        if(opplist.size()>0 && opplist!=null){
            try{
                update opplist;
            }Catch(DMLException ee){}
        }
    }
}