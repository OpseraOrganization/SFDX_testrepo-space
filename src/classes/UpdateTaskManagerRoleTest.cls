@isTest
private class UpdateTaskManagerRoleTest {
    
    static testMethod void myUnitTest() {
        
        UserRole role = [select Id, Name from UserRole where name = 'ALT' limit 1];
        
        Profile profile = [select id from Profile where name = 'System Administrator'];
        User manager = new User(LastName = 'Test Task Manager and Role',Username = 'testtaskmanagerandrole@test.com',
                            Email = 'testmanager@test.com',Alias = 'tm1' ,CommunityNickname= 'tmanager' ,
                            TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
                            ProfileId = profile.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert manager;
        
        Task task = new Task();
        task.OwnerId = manager.Id;
        task.Priority = 'Normal';
        task.Status = 'Open';
        task.Assigned_Manager__c = manager.Id;
        task.Assigned_Role__c = role.Id;
        
        insert task;
        List<Id> listOwnerId=new List<Id>();
        List<Id> listTaskId=new List<Id>();
        listOwnerId.add(manager.id);
        listTaskId.add(task.id);
        UpdateTaskManagerRole  utmr=new UpdateTaskManagerRole();
        utmr.updateTaskManagernRole(listOwnerId,listTaskId);
    }
}