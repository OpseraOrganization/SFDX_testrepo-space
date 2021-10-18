<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Additional_DB_capacity_in_Tbytes</fullName>
        <field>Q_DBCapacity__c</field>
        <name>Additional DB capacity in Tbytes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Need_AA_Analytics</fullName>
        <field>Q_AAAnalytics__c</field>
        <literalValue>0</literalValue>
        <name>Need AA Analytics</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Number_of_Business_subscribers_per_block</fullName>
        <field>Q_BusinessSubsQty__c</field>
        <name>Number of Business subscribers per block</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Number_of_mobile_subscribers_per_block_o</fullName>
        <field>Q_MobileSubsQty__c</field>
        <name>Number of mobile subscribers per block o</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Number_of_residential_subscribers_per_b</fullName>
        <field>Q_ResidentialSubsQty__c</field>
        <name>Number of residential subscribers per b</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Analytics Clean Up</fullName>
        <actions>
            <name>Additional_DB_capacity_in_Tbytes</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Need_AA_Analytics</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Number_of_Business_subscribers_per_block</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Number_of_mobile_subscribers_per_block_o</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Number_of_residential_subscribers_per_b</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Config2__ProductAttributeValue__c.Q_NFMP_Creation__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
