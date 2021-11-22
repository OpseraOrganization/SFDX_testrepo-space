<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert_to_notify_users_of_a_failed_record_in_the_Interface_Log_CPQ</fullName>
        <description>Email Alert to notify users of a failed record in the Interface Log_CPQ</description>
        <protected>false</protected>
        <recipients>
            <recipient>CPQ_users</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ALL/InterfaceLogErrorNotification</template>
    </alerts>
    <rules>
        <fullName>InterfaceLogErrorNotification</fullName>
        <actions>
            <name>Email_Alert_to_notify_users_of_a_failed_record_in_the_Interface_Log</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) OR (1 AND 3)</booleanFilter>
        <criteriaItems>
            <field>Interface_Log__c.Status__c</field>
            <operation>equals</operation>
            <value>Failure,Partial Success (Race Conditions Occurred)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Interface_Log__c.Interface_Type__c</field>
            <operation>equals</operation>
            <value>SRT2TerritoryAssociation,NED User Deactivation,ALCR ACC SYNC,CMD Pack1 Account Sync,CMD Pack 5 Account Sync,LoA Excel Add-in Interface,NED User Enrichment,NSA User Sync,FX Rates Integration,CQ UpdateQuote/Pricing,CQ UpdateQuote/Status</value>
        </criteriaItems>
        <criteriaItems>
            <field>Interface_Log__c.Interface_Type__c</field>
            <operation>equals</operation>
            <value>fNOK Oppty Sync,fNOK OTM Sync,CMD Pack4 Sales Role Sync,LoA Download Interface,Prospect Creation Interface,CQ Process Quote,CQ Sync Quote,CQ Sync Offer,EDP SI to Product2,EDP RedBox Data</value>
        </criteriaItems>
        <description>This rule sends out an email alert when a record is created in the Interface Log with status &quot;Failure&quot; or &quot;Partial Success&quot;.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
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
    <rules>
        <fullName>Workato_Outbound</fullName>
        <actions>
            <name>Workato_Outbound</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Interface_Log__c.Interface_Type__c</field>
            <operation>equals</operation>
            <value>QtC integration</value>
        </criteriaItems>
        <description>Triggers when an Interface Log is created with Integration Type Qtc Integration</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
