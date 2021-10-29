<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Q9__DiagramId</fullName>
        <field>Q9__DiagramId__c</field>
        <formula>TEXT(VALUE(TRIM(Q9__DiagramId__c)))</formula>
        <name>Diagram Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Q9__EvaluateDiagramId</fullName>
        <actions>
            <name>Q9__DiagramId</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Q9__Map__c.Q9__DiagramId__c</field>
            <operation>startsWith</operation>
            <value>+</value>
        </criteriaItems>
        <criteriaItems>
            <field>Q9__Map__c.Q9__DiagramId__c</field>
            <operation>startsWith</operation>
            <value>0</value>
        </criteriaItems>
        <description>Keeps Diagram Id valid.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
