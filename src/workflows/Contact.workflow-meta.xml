<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>NCP_Update_Sync_To_Marketo_Customer</fullName>
        <description>This field update is used to update the flag Sync To Marketo as True</description>
        <field>Sync_To_Marketo__c</field>
        <literalValue>1</literalValue>
        <name>NCP Update Sync To Marketo(Customer)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NCP_Update_Sync_To_Marketo_Supplier</fullName>
        <description>This field update is used to update the flag Sync To Marketo as False</description>
        <field>Sync_To_Marketo__c</field>
        <literalValue>0</literalValue>
        <name>NCP Update Sync To Marketo(Supplier)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Contact Inactive Mail</fullName>
        <actions>
            <name>Contact_Inactive_Mail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.User_Create_Status__c</field>
            <operation>equals</operation>
            <value>Inactive</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact Marketo check for Customer Type</fullName>
        <actions>
            <name>Update_SyncToMarketo_TRUE_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.CH_ContactType__c</field>
            <operation>equals</operation>
            <value>Customer,Partner,No Relationship</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <description>contacts which have the &apos;Contact type&apos; as Customer the Sync to Marketo checkbox should automatically/by default checked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NCP Sync To Marketo%28Customer%29</fullName>
        <actions>
            <name>NCP_Update_Sync_To_Marketo_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.CH_ContactType__c</field>
            <operation>equals</operation>
            <value>Customer</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <description>This workflow is used to update the flag Sync To Marketo as True if the contact type is a customer</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NCP Sync To Marketo%28Supplier%29</fullName>
        <actions>
            <name>NCP_Update_Sync_To_Marketo_Supplier</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.CH_ContactType__c</field>
            <operation>equals</operation>
            <value>Supplier</value>
        </criteriaItems>
        <description>This workflow is used to update the flag Sync To Marketo as False if the contact type is a supplier</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
