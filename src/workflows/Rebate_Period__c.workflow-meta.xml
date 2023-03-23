<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Notification_to_finance_team</fullName>
        <description>Email Notification to finance team</description>
        <protected>false</protected>
        <recipients>
            <recipient>Finance_Team</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>nokia_global_partner_communications@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PRM_Email_Templates/Mail_to_FinanceTeam</template>
    </alerts>
    <fieldUpdates>
        <fullName>Reminder</fullName>
        <field>Rebate_Notification__c</field>
        <literalValue>Reminder</literalValue>
        <name>Reminder</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_to_Initial_review</fullName>
        <field>Rebate_Notification__c</field>
        <literalValue>Enrollment Notification</literalValue>
        <name>Update to Initial review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_to_final_review</fullName>
        <field>Rebate_Notification__c</field>
        <literalValue>Final Review</literalValue>
        <name>Update to final review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Link Available Mail</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Rebate_Period__c.Start_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Reminder</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Rebate_Period__c.Enrollment_End_Date__c</offsetFromField>
            <timeLength>-10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Notification_to_finance_team</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Update_to_final_review</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Rebate_Period__c.End_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Update_to_Initial_review</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Rebate_Period__c.Start_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
