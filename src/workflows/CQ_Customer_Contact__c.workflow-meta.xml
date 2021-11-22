<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CQ_Update_Clonefield</fullName>
        <field>CQ_isCloned__c</field>
        <literalValue>0</literalValue>
        <name>CQ_Update_Clonefield</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CQ_Update_Cloneflag</fullName>
        <actions>
            <name>CQ_Update_Clonefield</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CQ_Customer_Contact__c.CQ_isCloned__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Changes clone flag to false after insert</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
