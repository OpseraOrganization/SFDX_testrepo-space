<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>CQ_Quote team member assignment</fullName>
        <actions>
            <name>EmailAlertToQuoteTeamMembersOn_NewQuoteTeamCreation</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>CQ_Quote_Team__c.CQ_Quote_Team_Member__c</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>CQ_Quote_Team__c.CreatedDate</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
