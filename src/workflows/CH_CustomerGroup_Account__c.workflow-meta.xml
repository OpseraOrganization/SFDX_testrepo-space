<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CH_CA_CustomerGroup_Customer</fullName>
        <field>CH_Duplicate_Check__c</field>
        <formula>CH_Customer_Grouping__c +  CH_Account__c</formula>
        <name>CH_CA_CustomerGroup_Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CH_CA_CustomerGroup_Duplication_Check</fullName>
        <actions>
            <name>CH_CA_CustomerGroup_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
