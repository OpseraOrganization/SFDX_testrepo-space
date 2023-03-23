<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CLF_Currency_ConversionFieldUpdate</fullName>
        <field>Exchange_Rate__c</field>
        <formula>Exchange_Rate__c/1000</formula>
        <name>CLF_Currency_ConversionFieldUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CLF_Currency_ConversionRule</fullName>
        <actions>
            <name>CLF_Currency_ConversionFieldUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Dated_Exchange_Rates__c.CurrencyIsoCode</field>
            <operation>equals</operation>
            <value>CLF</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
