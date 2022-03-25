<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CH_720MinutesNotification</fullName>
        <description>720 Minutes Notification test</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Manager</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Customer Care Manager</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>aaqib.ali@singlecrm.nokia.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>support.services@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CH_Auto_Case_Handling/OK_CH_CSDNotRestoredI720Minutes</template>
    </alerts>
    <alerts>
        <fullName>CH_CriticalServiceDisruptionNotRestored</fullName>
        <description>Critical Service Disruption Not Restored</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Manager</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Customer Care Manager</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Incident Engineer</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Incident Expert</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Incident Manager</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Technical Escalation Manager</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CH_Auto_Case_Handling/OK_CH_OutageUpdateNotification</template>
    </alerts>
    <alerts>
        <fullName>CH_Solution_Provided_Deferred_Milestone_Violation_Email_Alert</fullName>
        <description>CH Solution Provided Deferred Milestone Violation Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Manager</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Customer Care Manager</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support.services@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CH_EmailTemplates/CH_Notification_of_Solution_Provided_Deferred_Milestone_Violation</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_for_CH_and_HWS</fullName>
        <description>Email Alert for CH and HWS</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Notification_for_CH_and_HWS</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_for_PRM</fullName>
        <description>Email Alert for PRM testing</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ALL/Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>NCP_Mail_Notification_AMS_Group</fullName>
        <ccEmails>support_portal_ams@groups.nokia.com</ccEmails>
        <description>NCP_Mail_Notification_AMS_Group</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DCP_Email_Templates/NCP_Case_creation_for_Case_team</template>
    </alerts>
    <alerts>
        <fullName>Quote_to_Order</fullName>
        <description>Quote-to-Order</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ALL/Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>User_Management_New_User_Information</fullName>
        <ccEmails>crm.usermanagement@nokia.com</ccEmails>
        <ccEmails>crm.usermanagement@1d6kmaf81l1symwfvu0uiys5vi517b8sx258m6wu3lz8f7k8u6.58-t8dkeai.na111.case.salesforce.com</ccEmails>
        <description>User Management: New User Information</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Line_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>crm.usermanagement@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ALL/WebtoCaseemailresponseSAMPLE</template>
    </alerts>
</Workflow>
