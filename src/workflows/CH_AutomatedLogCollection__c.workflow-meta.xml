<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CH_AccountProductName_Populate</fullName>
        <field>CH_AccountProductName__c</field>
        <formula>CH_AccountNumber__c+&apos; | &apos;+CH_Product__r.ProductCode</formula>
        <name>CH_AccountProductName Populate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CH_AccountProductName Populate</fullName>
        <actions>
            <name>CH_AccountProductName_Populate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CH_AutomatedLogCollection__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>NOKIASC-36515</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
