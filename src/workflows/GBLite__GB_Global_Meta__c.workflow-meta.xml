<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>GBLite__Stamp_Original_Record_Id</fullName>
        <field>GBLite__Original_Record_Id__c</field>
        <formula>CASESAFEID(Id)</formula>
        <name>Stamp Original Record Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>GBLite__Stamp_Original_Record_Id</fullName>
        <actions>
            <name>GBLite__Stamp_Original_Record_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( NOT(ISBLANK(Id)), ISBLANK(GBLite__Original_Record_Id__c) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
