public with sharing class IdeaExchIdeas_Cntrl {
    //Get All Ideas--------------------------
    @RemoteAction
    public static List<idea> getIdeas(integer LimitSize,integer OffsetSize ){
    string datest = label.IdeaExchIdeas_Cntrl_Date;
    date mydate = date.parse(datest);
        //List<Idea> listAllIdeas = [select id, Title, Body, CreatorName, NumComments, Status, VoteTotal, VoteScore, Categories, CreatedDate from Idea ORDER BY CreatedDate DESC LIMIT :LimitSize OFFSET :OffsetSize];
        //return listAllIdeas;
        system.debug('Limit Size---->'+LimitSize);
        Id loggedInUserId = UserInfo.getUserId();
        List<Idea> listAllIdeas = Database.Query('select id, Title, Body, CreatorName, NumComments, Status, VoteTotal, VoteScore, Categories, CreatedDate,(select id from Votes where CreatedById =: loggedInUserId) from Idea where CreatedDate >:mydate ORDER BY CreatedDate DESC LIMIT :LimitSize OFFSET :OffsetSize');       
        return listAllIdeas;
    }
    
    //Get All Ideas--------------------------
    @RemoteAction
    public static List<idea> getPopularIdeas(integer LimitSize,integer OffsetSize ){
        //List<Idea> listAllIdeas = [select id, Title, Body, CreatorName, NumComments, Status, VoteTotal, VoteScore, Categories, CreatedDate from Idea ORDER BY CreatedDate DESC LIMIT :LimitSize OFFSET :OffsetSize];
        //return listAllIdeas;
        string datest = label.IdeaExchIdeas_Cntrl_Date;
        date mydate = date.parse(datest);
        system.debug('Limit Size---->'+LimitSize);
        Id loggedInUserId = UserInfo.getUserId();
        List<Idea> listAllIdeas = Database.Query('select id, Title, Body, CreatorName, NumComments, Status, VoteTotal, VoteScore, Categories, CreatedDate,(select id from Votes where CreatedById =: loggedInUserId) from Idea where CreatedDate >:mydate ORDER BY VoteScore DESC LIMIT :LimitSize OFFSET :OffsetSize');       
        return listAllIdeas;
    }
    
    
    //Get My Ideas--------------------------
    @RemoteAction
    public static List<idea> getMyIdeas(integer LimitSize,integer OffsetSize ){
        string datest = label.IdeaExchIdeas_Cntrl_Date;
        date mydate = date.parse(datest);
        system.debug('Limit Size---->'+LimitSize);
        Id loggedInUserId = UserInfo.getUserId();
        List<Idea> listAllIdeas = Database.Query('select id, Title, Body, CreatorName, NumComments, Status, VoteTotal, VoteScore, Categories, CreatedDate,(select id from Votes where CreatedById =: loggedInUserId) from Idea where CreatedById =: loggedInUserId and CreatedDate >:mydate ORDER BY CreatedDate DESC LIMIT :LimitSize OFFSET :OffsetSize');       
        return listAllIdeas;
    }
    
    //Get an Idea--------------------------
    @RemoteAction
    public static Idea getIdea(Id idIdea){
        
        Idea ideaDetails = null;
        Id loggedInUserId = UserInfo.getUserId();
        try{
            ideaDetails = [select id, Title, Body, CreatorName, NumComments, Status, VoteTotal, VoteScore, Categories, CreatedDate, (select id, CommentBody, CreatorName, IdeaId, UpVotes, CreatedDate from Comments),(select id from Votes where CreatedById =: loggedInUserId) from Idea where id =: idIdea];
        }catch(Exception ex){
            system.debug('No Idea found with that Id, Error:' + ex.getMessage());
            
        }
        return ideaDetails;
    }
    
    @RemoteAction
    public static integer getIdeasCount( ){
            string datest1 = label.IdeaExchIdeas_Cntrl_Date;
            date mydate1 = date.parse(datest1);
        Integer ideasCount = [select count() from Idea where CreatedDate >:mydate1];       
        return ideasCount;
    }
    
    //Promote an Idea---------------------------------
    @RemoteAction
    public static Idea promoteIdea(id ideaId){
        
        Vote voteForIdea = new Vote();
        voteForIdea.ParentId = ideaId;
        voteForIdea.Type = 'Up';
        
        
        Database.SaveResult voteResult = Database.insert(voteForIdea, true);
        
        if (voteResult.isSuccess()) {
            Idea ideaVote= [select id, voteTotal from Idea where id =: ideaId];
            return ideaVote;
        }else{
            system.debug(voteResult.getErrors()[0].getMessage());
            return null;
        }
        
    }
    @RemoteAction
    public static Idea addcomments(string id, string comments){
       //idea i=[select id,name,comments from idea where id=:id];
       //i.comments=comments;
       IdeaComment comm = new IdeaComment ();
       comm.IdeaId=id;
       comm.CommentBody=comments;
       insert comm;
       return null;
    }
    
}