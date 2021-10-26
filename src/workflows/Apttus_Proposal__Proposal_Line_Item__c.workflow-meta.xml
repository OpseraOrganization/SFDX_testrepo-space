<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Customer_Grouping_to_Other</fullName>
        <field>DS_Grouping_Name__c</field>
        <formula>&apos;Other&apos;</formula>
        <name>Set Customer Grouping to &apos;Other&apos;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>DS Update Customer Grouping to Other</fullName>
        <actions>
            <name>Set_Customer_Grouping_to_Other</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set Customer grouping field to &apos;Others&apos; if it is NULL for &apos;Bundles&apos; and &apos;Standalones&apos;</description>
        <formula>AND( Apttus_Proposal__Proposal__r.Quote_Type__c =  &apos;Direct DS&apos;,TEXT(Apttus_QPConfig__LineType__c) = &apos;Product/Service&apos;, DS_Grouping_Name__c = null )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
