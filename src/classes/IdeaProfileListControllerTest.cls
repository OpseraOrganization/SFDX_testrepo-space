@isTest
private class IdeaProfileListControllerTest {
    
    static testMethod void testGetPageName() {
        Test.startTest();
        IdeaProfileListController controller = new IdeaProfileListController();
        System.assertEquals(IdeaController.PAGE_PROFILE_LIST, controller.getPageName());
        Test.stopTest();
    }

    static testMethod void testGetIdeas() {
        Test.startTest();
        // cannot instantiate IdeaStandardSetController, should return null
        System.assertEquals(null, (new IdeaProfileListController()).getIdeas()); 
        Test.stopTest();               
    }
    
    static testMethod void testIdeasWithVotes() {
        Test.startTest();
        // cannot instantiate IdeaStandardSetController, should return no ideas
        System.assertEquals(0, (new IdeaProfileListController()).ideasWithVotes.size());   
        Test.stopTest();             
    }

    static testMethod void testGetHasPreviousPage() {
        Test.startTest();
        IdeaProfileListController controller = new IdeaProfileListController();
        controller.pageParam = '1';
        System.assert(!controller.getHasPreviousPage());
        controller.pageParam = '2';
        System.assert(controller.getHasPreviousPage());                
        Test.stopTest();
    }    

    static testMethod void testGetHasNextPage() {
        Test.startTest();
        IdeaProfileListController controller = new IdeaProfileListController();
        controller.ideas = new Idea[10];
        System.assert(!controller.getHasNextPage());
        controller.ideas = new Idea[IdeaProfileListController.MAX_NUMBER_OF_IDEAS_PER_PAGE];
        System.assert(controller.getHasNextPage());                
        Test.stopTest();
    } 
}