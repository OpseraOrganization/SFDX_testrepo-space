@isTest
private class TestClass_ApexTrigger_createIdea {

    static testMethod void createIdeaTest() {
        
        Id Community = [Select id from Community where Name = 'Ideas.Honeywell.com' limit 1].id;
        
        test.starttest();
        idea testidea = new idea(
            Title = 'Test Idea',
            Body = 'This is a Test Idea.',
            Categories = 'Electronic',
            CommunityId = Community
        );
    
        insert testidea;
        test.stoptest();
    }
}