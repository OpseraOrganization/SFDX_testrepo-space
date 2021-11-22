<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>NokiaCPQ_ProductStatus</fullName>
        <actions>
            <name>ProductIsActive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product2.NokiaCPQ_State__c</field>
            <operation>equals</operation>
            <value>Create,Field Maintenance,Obsolete,Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>Product2.Portfolio__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
