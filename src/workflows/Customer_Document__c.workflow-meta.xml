<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>send_email_on_status_change</fullName>
        <ccEmails>0logistics_sfr.gdc_portugal@nokia.com</ccEmails>
        <description>send email on status change</description>
        <protected>false</protected>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DS_Send_email_when_status_of_CDR_is_changed_to_Draft</template>
    </alerts>
    <alerts>
        <fullName>send_email_on_status_change_to_Registered</fullName>
        <ccEmails>0logistics_sfr.gdc_portugal@nokia.com</ccEmails>
        <ccEmails>0Projet-sfr.logistics@nokia.com</ccEmails>
        <description>send email on status change to Registered</description>
        <protected>false</protected>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DS_Send_email_when_status_of_CDR_is_changed_to_Registered</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Customer_Document_Record_type</fullName>
        <description>update the record type to read only so that it cant be edited anymore</description>
        <field>RecordTypeId</field>
        <lookupValue>Customer_Document_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Customer Document Record type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Send email when status of CDR is changed</fullName>
        <actions>
            <name>send_email_on_status_change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Document__c.Status__c</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send email when status of CDR is changed to Registered</fullName>
        <actions>
            <name>send_email_on_status_change_to_Registered</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Document__c.Status__c</field>
            <operation>equals</operation>
            <value>Registered</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Record type to ReadOnly</fullName>
        <actions>
            <name>Update_Customer_Document_Record_type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Document__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed-validated,Closed-cancelled,Closed-consumed,Closed-rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
