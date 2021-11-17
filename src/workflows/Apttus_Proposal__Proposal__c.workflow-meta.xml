<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CPQ_Send_Email_to_Submitted_for_Approval_Status_Change</fullName>
        <description>Send Email to Submitted for Approval Status Change</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/CPQ_EBG_Send_Email_to_Inform_about_Approval_Stage</template>
    </alerts>
    <alerts>
        <fullName>CPQ_Send_Email_to_Submitter_for_Rejected_Stage</fullName>
        <description>EBG_Send Email to Submitter for Rejected Stage</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/CPQ_EBG_Send_Email_to_Inform_about_Rejected_Stage</template>
    </alerts>
    <alerts>
        <fullName>CQ_SendNotificationToCQSender</fullName>
        <description>CQ_SendNotificationToCQSender</description>
        <protected>false</protected>
        <recipients>
            <field>CQ_Sender__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>sCPQ_CQ_Email_templates/CQ_FailedNotificationForEQuote</template>
    </alerts>
    <alerts>
        <fullName>DS_Email_Alert_for_Quote_Approved_Stage</fullName>
        <description>DS Email Alert for Quote Approved Stage</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_Email_to_Account_Owner_for_Approved_Quote</template>
    </alerts>
    <alerts>
        <fullName>DS_Email_Alert_for_Quote_Draft_Stage</fullName>
        <description>DS Email Alert for Quote Draft Stage</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_Email_to_Account_Owner_for_Draft_Quote</template>
    </alerts>
    <alerts>
        <fullName>Email_to_AM</fullName>
        <description>Email to AM</description>
        <protected>false</protected>
        <recipients>
            <field>NokiaCPQ_Account_Manager_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/NotifyQuoteAccountManager_Approval_Required</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_GDC_user_when_quote_is_publised</fullName>
        <ccEmails>logistics_sfr.gdc_portugal@nokia.com</ccEmails>
        <description>Notification to GDC user when quote is publised</description>
        <protected>false</protected>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DS_Quote_Published_Notification_to_GDC</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_To_Partner_For_LEO_Quote</fullName>
        <ccEmails>heema.1.solanki@nokia.com</ccEmails>
        <ccEmails>Rahul.garje@nokia.com</ccEmails>
        <description>Send Email To Partner For LEO Quote</description>
        <protected>false</protected>
        <recipients>
            <field>NokiaCPQ_Partner_Sales_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_Email_to_Partner_to_Inform_about_his_certification</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_for_Recalled_Quotes</fullName>
        <ccEmails>rahul.garje@nokia.com</ccEmails>
        <description>Send Email for Recalled Quotes</description>
        <protected>false</protected>
        <recipients>
            <field>NokiaCPQ_Partner_Sales_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_Email_to_PSM_to_Inform_about_Recalled_Approval</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_PSM_for_Approval_Status_Change</fullName>
        <ccEmails>rahul.garje@nokia.com</ccEmails>
        <description>Send Email to PSM for Approval Status Change</description>
        <protected>false</protected>
        <recipients>
            <field>NokiaCPQ_Partner_Sales_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/CPQ_Approval_Status_Change_to_PSM</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_PSM_for_Rejected_Approval_Stage</fullName>
        <ccEmails>rahul.garje@nokia.com</ccEmails>
        <description>Send Email to PSM for Rejected Approval Stage</description>
        <protected>false</protected>
        <recipients>
            <field>NokiaCPQ_Partner_Sales_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_Email_to_PSM_to_Inform_about_Rejected_Stage</template>
    </alerts>
</Workflow>
