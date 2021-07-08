<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Access Level Change - Training Manager</fullName>
        <actions>
            <name>Access_Requested_Date_Request</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Clear_Completed_By_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Procurement_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Procurement_Status_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Removal_Requested_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Access_Requested_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND NOT (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Access_Level__c</field>
            <operation>equals</operation>
            <value>Training Manager</value>
        </criteriaItems>
        <criteriaItems>
            <field>Additional_Resource_Request__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Integration API Only Profile</value>
        </criteriaItems>
        <description>nat-bbupdate</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
