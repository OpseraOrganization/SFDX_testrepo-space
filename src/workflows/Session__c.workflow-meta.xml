<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EEC_Session_Ready_for_Approval</fullName>
        <description>EEC - Session Ready for Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Event_host_email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Email_Template/EEC_Session_Ready_for_Approval</template>
    </alerts>
    <alerts>
        <fullName>ERM_Content_Approval_by_Event_host</fullName>
        <description>ERM - Content Approval by Event host</description>
        <protected>false</protected>
        <recipients>
            <field>Customer_Solution_Architect_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Event_host_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Marketing_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ERM/ERM_event_host_content_approval</template>
    </alerts>
    <alerts>
        <fullName>ERM_Notify_content_owner_5_days_earlier</fullName>
        <description>ERM - Notify content owner 5 days earlier</description>
        <protected>false</protected>
        <recipients>
            <field>Content_Owner_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ERM/ERM_Content_owner_notification_Reminder_to_upload_content_for_the_review_call</template>
    </alerts>
</Workflow>
