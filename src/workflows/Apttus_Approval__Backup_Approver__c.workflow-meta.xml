<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Apttus_Approval__ApprovalRequestDelegationNotification</fullName>
        <description>Approval Request Delegation Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Apttus_Approval__Current_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/NF_Delegate_Assignment_Notification</template>
    </alerts>
    <alerts>
        <fullName>Apttus_Approval__ApprovalRequestReassignmentNotification</fullName>
        <description>Approval Request Reassignment Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Apttus_Approval__Backup_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/Apttus_Approval__DelegateUserNotification</template>
    </alerts>
    <alerts>
        <fullName>NF_Current_User_Notification</fullName>
        <description>NF_Current User Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Apttus_Approval__Current_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/NF_Delegate_Assignment_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Apttus_Approval__SetCancellationDatetoNOW</fullName>
        <description>Set Cancellation Date to NOW</description>
        <field>Apttus_Approval__Cancellation_Date__c</field>
        <formula>NOW()</formula>
        <name>Set Cancellation Date to NOW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apttus_Approval__SetCancellationDatetoNull</fullName>
        <description>Set Cancellation Date to Null</description>
        <field>Apttus_Approval__Cancellation_Date__c</field>
        <name>Set Cancellation Date to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apttus_Approval__SetEffectiveDatetoNull</fullName>
        <description>Set Effective Date to Null</description>
        <field>Apttus_Approval__Effective_Date__c</field>
        <name>Set Effective Date to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apttus_Approval__SetExpirationDatetoNull</fullName>
        <description>Set Expiration Date to Null</description>
        <field>Apttus_Approval__Expiration_Date__c</field>
        <name>Set Expiration Date to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apttus_Approval__SetInEffectFlagtoFalse</fullName>
        <description>Set In Effect Flag to False</description>
        <field>Apttus_Approval__InEffect__c</field>
        <literalValue>0</literalValue>
        <name>Set In Effect Flag to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apttus_Approval__SetInEffectFlagtoTrue</fullName>
        <description>Set In Effect Flag to True</description>
        <field>Apttus_Approval__InEffect__c</field>
        <literalValue>1</literalValue>
        <name>Set In Effect Flag to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apttus_Approval__SetIsActivetoFalse</fullName>
        <description>Set Is Active to False</description>
        <field>Apttus_Approval__IsActive__c</field>
        <literalValue>0</literalValue>
        <name>Set Is Active to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
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
