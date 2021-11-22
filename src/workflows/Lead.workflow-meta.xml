<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>updatedatetimeinfo</fullName>
        <field>ownershipchangedbyNokiaSales__c</field>
        <formula>NOW()</formula>
        <name>updatedatetimeinfo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Lead Ownership change to Sales</fullName>
        <actions>
            <name>updatedatetimeinfo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow is used to know when did a sales person changed the lead to himself.</description>
        <formula>AND( $Profile.Name == &apos;Nokia Sales Profile&apos;, ISCHANGED(OwnerId), Owner:User.Profile.Name == &quot;Nokia Sales Profile&quot;  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
