<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>InterfaceLogErrorNotification_CPQ</fullName>
        <actions>
            <name>Email_Alert_to_notify_users_of_a_failed_record_in_the_Interface_Log_CPQ</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Interface_Log__c.Interface_Type__c</field>
            <operation>equals</operation>
            <value>CQ Process Quote,CQ Sync Quote,CQ Sync Offer,CQ UpdateQuote/Pricing,CQ UpdateQuote/Status,QtC integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Interface_Log__c.Status__c</field>
            <operation>equals</operation>
            <value>Failure</value>
        </criteriaItems>
        <description>Send failure notifications for CPQ reated interfaces</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
