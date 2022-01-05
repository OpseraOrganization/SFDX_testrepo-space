<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_Request_Comments_updates</fullName>
        <ccEmails>rahul.garje@nokia.com</ccEmails>
        <description>Approval Request Comments updates</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_Email_to_PSM_about_Comment</template>
    </alerts>
    <alerts>
        <fullName>CPQ_EBG_Add_Comment_Notification</fullName>
        <description>EBG Add Comment Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Apttus_QPApprov__ProposalOwnerId__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/CPQ_EBG_Send_Email_about_Comment</template>
    </alerts>
    <alerts>
        <fullName>CPQ_EBG_Cancellation_mail_for_Recall</fullName>
        <description>EBG Cancellation mail for Recall</description>
        <protected>false</protected>
        <recipients>
            <field>Apttus_QPApprov__ProposalOwnerId__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/CPQ_EBG_Recall_Notification</template>
    </alerts>
</Workflow>
