trigger UpdateYearFieldOnFeedback on Feedback__c (After Insert) {
    set<id> fbid = new set<id>();
    List<Feedback__c> fblist = new List<Feedback__c>();
    List<Feedback__c> fbupdtlist = new List<Feedback__c>();
    for(Feedback__c fb:Trigger.new){
        fbid.add(fb.id);
    }
    if(fbid!=null)
        fblist = [select id,CreatedDate, Year__c from Feedback__c where id IN:fbid];
    if(fblist.size()>0 && fblist!=null){
        for(Feedback__c fb : fblist){
            if(fb.CreatedDate != null){
                fb.Year__c = String.valueOf(fb.CreatedDate.Year());
                fbupdtlist.add(fb);
            }
        }
    }
    if(fbupdtlist.size()>0)
        update fbupdtlist;
}