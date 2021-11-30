<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CH_CheckDurationOpentoRoutedUpdated</fullName>
        <field>CH_DurationOpentoRoutedUpdated__c</field>
        <literalValue>1</literalValue>
        <name>Check Duration Open to Routed Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>Support_Ticket__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CalculateDurationOpentToRouted</fullName>
        <description>Calculate the duration a case was opened and routed to a workgroup</description>
        <field>CH_DurationOpenToRouted__c</field>
        <formula>(NOW() -  Support_Ticket__r.CreatedDate)*1440</formula>
        <name>CalculateDurationOpentToRouted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>Support_Ticket__c</targetObject>
    </fieldUpdates>
</Workflow>
