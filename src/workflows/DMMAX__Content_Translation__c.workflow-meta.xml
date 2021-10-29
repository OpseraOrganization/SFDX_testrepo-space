<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>DMMAX__Set_Uniqueness_field</fullName>
        <field>DMMAX__Uniqueness__c</field>
        <formula>DMMAX__Insight__r.Id + DMMAX__Class__r.Id + &apos;-&apos; + Text(DMMAX__Language__c)</formula>
        <name>Set Uniqueness field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DMMAX__Updated_Dealmaker_ID_Field</fullName>
        <field>DMMAX__DealmakerID__c</field>
        <formula>$Organization.Id + &apos;-&apos; + Id</formula>
        <name>Updated Dealmaker ID Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>DMMAX__Set ContentTranslation GUID</fullName>
        <actions>
            <name>DMMAX__Updated_Dealmaker_ID_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISBLANK(DMMAX__DealmakerID__c) || ISNULL(DMMAX__DealmakerID__c)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>DMMAX__Set Uniqueness Field</fullName>
        <actions>
            <name>DMMAX__Set_Uniqueness_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>We don&apos;t want multiple entries</description>
        <formula>DMMAX__DealmakerID__c != (DMMAX__Class__r.Id + DMMAX__Insight__r.Id + &apos;-&apos; + Text(DMMAX__Language__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
