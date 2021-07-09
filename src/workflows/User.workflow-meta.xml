<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>DCP_Deactivate1</fullName>
        <field>DCP_deactivate__c</field>
        <literalValue>0</literalValue>
        <name>DCP Deactivate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>DCP Internal Portal User%3A Field Update</fullName>
        <actions>
            <name>DCP_Deactivate1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>DCP Internal Portal User</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Auto Deactivation DCP Internal Portal User: This WF is will ensure the safe reactivation of  DCP Internal Portal Use</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
