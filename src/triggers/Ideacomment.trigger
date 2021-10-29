trigger Ideacomment on IdeaComment (Before insert, Before update) 
{
    set<id> ttow = new set<id>();
    for(IdeaComment i :Trigger.new)
    {
        
        
            ttow.add(i.IdeaId);
        
    }
    list<idea> commentidea = new list<idea>();
    if(ttow.size()>0)
    {
        commentidea = [select id, Comments__c from idea where id=:ttow];
    }
    for(IdeaComment ii :Trigger.new)
    {
        if(commentidea.size()>0)
        {
            commentidea[0].Comments__c = ii.commentbody;
        }
    }
    if(commentidea.size()>0)
    {
        update commentidea;
    }
}