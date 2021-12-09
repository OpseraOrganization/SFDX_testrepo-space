<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Contract_Name</fullName>
        <field>NokiaCPQ_Name__c</field>
        <formula>Name</formula>
        <name>Update Contract Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update Contract Name</fullName>
        <actions>
            <name>Update_Contract_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Config2__PriceList__c.PriceList_Type__c</field>
            <operation>equals</operation>
            <value>Direct</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Config2__PriceList__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Contract Name with the Price List Name</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
