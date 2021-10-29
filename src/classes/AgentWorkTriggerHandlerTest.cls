@isTest(seealldata=true)
public class AgentWorkTriggerHandlerTest {
    
    private static testMethod void AgentWorkTriggerHandler() {

    AgentWork aw = [Select Id, Status,WorkItemId,ServiceChannelId,UserId from AgentWork 
    where ServiceChannelId in (SELECT Id FROM ServiceChannel WHERE Masterlabel = 'BFE Support') limit 1];
   
    update aw; 

    }

}