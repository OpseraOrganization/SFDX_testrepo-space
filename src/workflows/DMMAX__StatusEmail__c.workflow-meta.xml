<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>DMMAX__Updated_Dealmaker_ID_Field</fullName>
        <field>DMMAX__DealmakerID__c</field>
        <formula>$Organization.Id  + &apos;-&apos; + Id</formula>
        <name>Updated Dealmaker ID Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>DMMAX__Set StatusEmail GUID</fullName>
        <actions>
            <name>DMMAX__Updated_Dealmaker_ID_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISBLANK(DMMAX__DealmakerID__c) || ISNULL(DMMAX__DealmakerID__c)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
