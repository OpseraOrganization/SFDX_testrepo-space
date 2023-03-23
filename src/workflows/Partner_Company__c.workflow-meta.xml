<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Partner_Account_Name_Update</fullName>
        <field>Name</field>
        <formula>Partner_Name__r.Name</formula>
        <name>Partner Account Name Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>PARTNER NAME UPDATE</fullName>
        <actions>
            <name>Partner_Account_Name_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT (ISBLANK(Partner_Name__c) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
