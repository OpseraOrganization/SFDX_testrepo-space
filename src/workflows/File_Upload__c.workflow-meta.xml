<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_technology_field</fullName>
        <description>This will update technology text field from technlogy picklist field</description>
        <field>Technology_Txt__c</field>
        <formula>TEXT(Technology__c)</formula>
        <name>Update technology field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_use_case_field</fullName>
        <description>this will update use case text field from use case picklist field</description>
        <field>Use_Case_Txt__c</field>
        <formula>TEXT(Use_Case__c )</formula>
        <name>Update use case field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>DS Update Technology and Use case</fullName>
        <actions>
            <name>Update_technology_field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_use_case_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Used to update text fields &quot;technology&quot; and &quot;use case&quot; from picklist values</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
