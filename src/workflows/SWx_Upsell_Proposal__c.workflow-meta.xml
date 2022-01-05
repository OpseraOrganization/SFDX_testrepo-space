<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DS_Email_Notification_to_AM_on_SWMP_Failure</fullName>
        <description>DS Email Notification to AM on SWMP Failure</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/DS_SWMPInterfaceLogErrorNotification</template>
    </alerts>
    <alerts>
        <fullName>DS_Nokia_ScratchOrderDPStatusEntitled</fullName>
        <description>DS_Nokia_ScratchOrderDPStatusEntitled</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DS_Nokia_ScratchOrderReadyForDelivery</template>
    </alerts>
</Workflow>
