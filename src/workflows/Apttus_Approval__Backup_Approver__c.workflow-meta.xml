<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Apttus_Approval__Send Delegation Notification</fullName>
        <actions>
            <name>Apttus_Approval__ApprovalRequestDelegationNotification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Apttus_Approval__Backup_Approver__c.Apttus_Approval__InEffect__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Approval__Backup_Approver__c.Apttus_Approval__IsDelegate__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Send Delegation Notification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Apttus_Approval__Send Reassignment Notification</fullName>
        <actions>
            <name>Apttus_Approval__ApprovalRequestReassignmentNotification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Apttus_Approval__Backup_Approver__c.Apttus_Approval__InEffect__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Approval__Backup_Approver__c.Apttus_Approval__IsDelegate__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Backup Approver - Send notifications to the backup user and current user when a backup approver is activated or deactivated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Backup notification to Current User</fullName>
        <actions>
            <name>NF_Current_User_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Apttus_Approval__Backup_Approver__c.Apttus_Approval__InEffect__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Approval__Backup_Approver__c.Apttus_Approval__IsDelegate__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Backup Approver - Send notifications to Current User</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
