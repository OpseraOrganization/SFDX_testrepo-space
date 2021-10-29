trigger CaseUpdate on AgentWork (after update) {
    AgentWorkTriggerHandler handler=new AgentWorkTriggerHandler();
    handler.omniCaseAgentWork(Trigger.new );
}