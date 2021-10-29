@isTest
 private class IdeaExchIdeas_Cntrl_Test {
 
 static testMethod void myUnitTest() {
 string test1;
     //PageReference pageRef = page.IdeaExchIdeas;
   
     //Test.setCurrentPage(pageRef);
     
     IdeaExchIdeas_Cntrl IdeaxcngCnlr = new IdeaExchIdeas_Cntrl();
     IdeaExchIdeas_Cntrl.getIdeas(20, 10);
     IdeaExchIdeas_Cntrl.getPopularIdeas(20, 10);
     IdeaExchIdeas_Cntrl.getMyIdeas(20, 10);
     Idea i = new Idea();
        i.CommunityId = Label.Ideas_Zone;
        i.Title = 'Testing Version Settings';
        i.Body = 'Categories field is included in API version 16.0';
        i.Categories = 'test';
        insert i;
     IdeaExchIdeas_Cntrl.getIdea(i.id);
     IdeaExchIdeas_Cntrl.getIdeasCount();
     IdeaExchIdeas_Cntrl.addcomments(string.valueOf(i.id), 'test comments');       
     //IdeaExchIdeas_Cntrl.promoteIdea(i.id);
 }
 }