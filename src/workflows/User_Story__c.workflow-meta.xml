<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Kanban_Status_Change_Email_Alert</fullName>
        <description>Kanban Status Change Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>cole.hickman.ext@singlecrm.nokia.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jonathan.holato@singlecrm.accenture.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kamna.saran@singlecrm.accenture.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sonali.j.kothavale.ext@singlecrm.nokia.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>tobias.mengert.ext@singlecrm.nokia.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>valerie.hannwacker.ext@singlecrm.nokia.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus_Config2__ApttusCPQEmailTemplates/Kanban_Status_Change_Notification</template>
    </alerts>
    <rules>
        <fullName>Kanban Status Email Notification</fullName>
        <actions>
            <name>Kanban_Status_Change_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(Team__c = &quot;Digital Sales&quot;,  ISCHANGED( Kanban_Status__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
