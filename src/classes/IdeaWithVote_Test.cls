@isTest (seeAllData = true)
public class IdeaWithVote_Test {
    static testMethod void IdeaWithVote_Method1(){
        IdeaTestUtil.setupTest();
       
        List<ID> lstIdeaId = new List<Id>();
        IdeaTestUtil.setupTest();
        String communityId = IdeaTestUtil.getCommunityId();
        User currentUser = IdeaTestUtil.getCurrentUser();
        
        String title = 'test idea';
         Datetime now = DateTime.now();
        String nickname = 'currentUser';
        String userId = currentUser.id;
        date today = system.today();
        Idea idea1 = IdeaTestUtil.makeIdea(title, communityId);
        
        Vote vt =[SELECT id,type, ParentId FROM Vote where ParentId =: idea1.Id];
       
        
        IdeaWithVote iwv = new IdeaWithVote(idea1,vt);
        iwv.getHowUserVoted();
        
        List<Idea> ideaList = new List<Idea>();
        ideaList.add(idea1);
        IdeaWithVote.getIdeasWithVotes(ideaList);
        
        List<Vote> voteList = new List<Vote>();
        voteList.add(vt);
        IdeaWithVote.getIdeasWithVotes(voteList);
        
        
    }
    static testMethod void IdeaWithVote_Method2(){
        IdeaTestUtil.setupTest();
       
        List<ID> lstIdeaId = new List<Id>();
        IdeaTestUtil.setupTest();
        String communityId = IdeaTestUtil.getCommunityId();
        User currentUser = IdeaTestUtil.getCurrentUser();
        
        String title = 'test idea';
         Datetime now = DateTime.now();
        String nickname = 'currentUser';
        String userId = currentUser.id;
        date today = system.today();
        Idea idea1 = IdeaTestUtil.makeIdea(title, communityId);
        
        Vote vt =[SELECT id, type FROM Vote where ParentId =: idea1.Id];
       
        IdeaWithVote iwv = new IdeaWithVote(idea1,vt,true);
        
        
    }
    
}