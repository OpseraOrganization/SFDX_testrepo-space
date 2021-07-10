<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Business_Plan_Submission_Email_Notification</fullName>
        <description>Business Plan Submission Email Notification Description</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Partner_Program_Contact_s_PRM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>nokia_global_partner_communications@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Business_Planning/Business_Plan_Submission_Email_Notification</template>
    </alerts>
    <rules>
        <fullName>Reminder After Submission of Business Plan Approval</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Business_Plan__c.Business_Plan_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Integration API Only Profile</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_1st_reminder_email_to_PSM_s_Manager_after_5_days_if_nobody_picks_up_the_for</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Business_Plan__c.X5_Business_Day_Reminder__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send Review Email</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Business_Plan__c.Business_Plan_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Integration API Only Profile</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Activate_Send_Review_Email</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Business_Plan__c.Review_date__c</offsetFromField>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Deactivate_Send_Review_Email</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Review_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Business_Plan__c.Review_date__c</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
