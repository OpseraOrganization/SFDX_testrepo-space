<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CH_UpdateODREndDateOnCase</fullName>
        <field>CH_OutageEndDate__c</field>
        <formula>IF( PRIORVALUE(CH_DurationEndDate__c) &lt; CH_DurationEndDate__c || ISNULL(PRIORVALUE(CH_DurationEndDate__c)), CH_DurationEndDate__c, PRIORVALUE( CH_DurationEndDate__c))</formula>
        <name>CH_UpdateODREndDateOnCase</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>CH_SupportTicket__c</targetObject>
    </fieldUpdates>
</Workflow>
