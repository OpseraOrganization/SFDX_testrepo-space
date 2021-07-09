<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>HWS_Update_Service_Item_Description</fullName>
        <field>CH_ServiceItemDescription__c</field>
        <formula>&quot;Commissioning Spares&quot;</formula>
        <name>HWS Update Service Item Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>HWS Update Service Item Description</fullName>
        <actions>
            <name>HWS_Update_Service_Item_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ContractLineItem.CH_ServiceClassification__c</field>
            <operation>equals</operation>
            <value>HWS Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>ContractLineItem.CH_ServiceType__c</field>
            <operation>equals</operation>
            <value>Identical Repair</value>
        </criteriaItems>
        <criteriaItems>
            <field>ContractLineItem.CH_ServiceOffering__c</field>
            <operation>equals</operation>
            <value>Commissioning Spares</value>
        </criteriaItems>
        <description>To update service item Description based on Service Type</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
