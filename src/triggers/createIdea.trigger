trigger createIdea on Idea (before insert, before update){
    /*set<id> ttow = new set<id>();
    for(idea i :Trigger.new){
        if(i.id!=null)
        {
            ttow.add(i.Id);
        }
    }
    list<ideacomment> newcomment = new list<ideacomment>();
    
    if(ttow.size() > 0)
    {
        newcomment = [select id,CommentBody, IdeaId from ideacomment where IdeaId=:ttow order by createddate desc];
    }
    for(idea ii :Trigger.new)
    {
        if(newcomment.size() > 0)
        {
            for(integer i=0; i<newcomment.size(); i++)
            {
                system.debug('----------idea comments--------->'+newcomment[i].CommentBody);
            }
            
            ii.Comments__c = string.valueof(newcomment[0].CommentBody);
        }   
    }*/
}