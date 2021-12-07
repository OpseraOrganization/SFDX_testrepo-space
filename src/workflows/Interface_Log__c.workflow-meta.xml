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
    <outboundMessages>
        <fullName>Workato_Outbound</fullName>
        <apiVersion>51.0</apiVersion>
        <endpointUrl>https://www.workato.com/webhooks/notify/salesforce?sobject=Interface_Log__c&amp;org_id=00D22000000DOIh</endpointUrl>
        <fields>Id</fields>
        <fields>Interface_Request_Sent__c</fields>
        <fields>Interface_Type__c</fields>
        <fields>Name</fields>
        <fields>Operation_Type__c</fields>
        <fields>Status__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>integration@00d22000000doiheao.com</integrationUser>
        <name>Workflow Outbound sample</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
</Workflow>
