<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Partner_Acceptance_Status</fullName>
        <field>Partner_Acceptance_Status__c</field>
        <literalValue>In Review</literalValue>
        <name>Partner Acceptance Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>Rebate__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Field Update on amount change</fullName>
        <actions>
            <name>Partner_Acceptance_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Amount__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
