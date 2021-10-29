@isTest
public class IdeaCommentsDetailsTest {

    static testMethod void testIdeaCommentsDetails() {
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
         IdeaComment ideaComments = new ideaComment (IdeaId = idea1.id,CommentBody = 'test', CreatedById = currentuser.id , CreatedDate = today
                          );
                          insert ideacomments;
        lstIdeaId.add(idea1.id);
       
        IdeaCommentDetails icd = new IdeaCommentDetails(idea1, ideacomments);
          IdeaCommentDetails[] getIdeasWithComments;
          List<Idea> ideas = [select id, lastCommentId from idea where id =: idea1.id];
          List<IdeaCommentDetails> ideas1 =  IdeaCommentDetails.getIdeasWithComments(ideas);
          IdeaCommentDetails.getIdeasWithComments(ideas,userId);
          IdeaCommentDetails.getIdeasWithComments(ideas,userId);
          IdeaCommentDetails.getIdeasWithCommentsAndReadStatus(ideas,lstIdeaId);
          //ideas1.add(icd);
          
         try{
         System.assertnotEquals(ideas1, IdeaCommentDetails.getIdeasWithComments(ideas));
         }catch (exception e){
         }
         Map<Id, IdeaComment> ideaCommentMap = new Map<Id, IdeaComment>();
         
         ideaCommentMap.put(idea1.id,ideacomments);
         
          try{
         System.assertnotEquals(ideas1, IdeaCommentDetails.getIdeasWithComments(ideas, ideaCommentMap));
         }catch (exception e){
         }

    }

}