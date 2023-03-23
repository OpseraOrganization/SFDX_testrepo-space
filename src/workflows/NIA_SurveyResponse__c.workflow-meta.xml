<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>NIA_SurveyResponseEmailAlert</fullName>
        <description>Email Notification To Survey Response</description>
        <protected>false</protected>
        <recipients>
            <recipient>NIA_SurveyNotificationTeam</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Surveys/SUPPORT_Survey_Notification_with_report</template>
    </alerts>
    <rules>
        <fullName>NIA_SurveyResponseNotification</fullName>
        <actions>
            <name>NIA_SurveyResponseEmailAlert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>1=1</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
