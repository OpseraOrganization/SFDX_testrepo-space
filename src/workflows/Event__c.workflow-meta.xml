<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EEC_Cancellation_Notify</fullName>
        <description>EEC Cancellation Notify</description>
        <protected>false</protected>
        <recipients>
            <field>Event_Host__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/EEC_Event_notification_Cancellation</template>
    </alerts>
    <alerts>
        <fullName>EEC_Event_Cancellation</fullName>
        <description>EEC - Event Cancellation</description>
        <protected>false</protected>
        <recipients>
            <field>Event_Host__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Email_Template/EEC_Event_Cancellation</template>
    </alerts>
    <alerts>
        <fullName>EEC_Event_Request</fullName>
        <description>EEC - Event Request</description>
        <protected>false</protected>
        <recipients>
            <field>Venue_Contact_Email_common__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Email_Template/EEC_Event_Request</template>
    </alerts>
    <alerts>
        <fullName>EEC_Request</fullName>
        <description>EEC Request</description>
        <protected>false</protected>
        <recipients>
            <field>Venue_Contact_Email_common__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/EEC_Event_Notification</template>
    </alerts>
    <alerts>
        <fullName>ERM_Event_Cancellation</fullName>
        <description>ERM - Event Cancellation</description>
        <protected>false</protected>
        <recipients>
            <field>Event_Host__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ERM/ERM_Event_Cancellation</template>
    </alerts>
    <alerts>
        <fullName>ERM_Notification_When_new_ERM_is_created_CF</fullName>
        <description>ERM - Notification When new ERM is created - CF</description>
        <protected>false</protected>
        <recipients>
            <recipient>ERM_Team</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ERM/ERM_Event_notification_New_CF_and_Backup</template>
    </alerts>
</Workflow>
