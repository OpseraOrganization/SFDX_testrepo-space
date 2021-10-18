<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EEC_Session_Ready_for_Approval</fullName>
        <description>EEC - Session Ready for Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Event_host_email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Email_Template/EEC_Session_Ready_for_Approval</template>
    </alerts>
    <alerts>
        <fullName>ERM_Content_Approval_by_Event_host</fullName>
        <description>ERM - Content Approval by Event host</description>
        <protected>false</protected>
        <recipients>
            <field>Customer_Solution_Architect_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Event_host_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Marketing_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ERM/ERM_event_host_content_approval</template>
    </alerts>
    <alerts>
        <fullName>ERM_Notify_content_owner_5_days_earlier</fullName>
        <description>ERM - Notify content owner 5 days earlier</description>
        <protected>false</protected>
        <recipients>
            <field>Content_Owner_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ERM/ERM_Content_owner_notification_Reminder_to_upload_content_for_the_review_call</template>
    </alerts>
    <alerts>
        <fullName>Event_Notification_to_speaker_to_approve_presentation</fullName>
        <description>Event - Notification to speaker to approve presentation</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Event_notification_Approve_presentation_material</template>
    </alerts>
    <fieldUpdates>
        <fullName>Event_Session_approved</fullName>
        <field>Session_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Event - Session approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Event_Session_not_approved</fullName>
        <field>Session_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Event - Session not approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Event_Session_ready_for_approval</fullName>
        <field>Session_Status__c</field>
        <literalValue>Ready_for_Approval</literalValue>
        <name>Event - Session ready for approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Session_Date</fullName>
        <description>Event start date is used for session&apos;s date / time. This information has to be checked and updated during preparation phase.</description>
        <field>Time__c</field>
        <formula>DATETIMEVALUE(Track__r.Event__r.Event_Start_Date__c)</formula>
        <name>Session - Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Session_Speaker_s_Email_Alert_address</fullName>
        <field>Email__c</field>
        <formula>Speaker__r.Speaker_Internal__r.Email</formula>
        <name>Session - Speaker&apos;s Email Alert address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Session - Date</fullName>
        <actions>
            <name>Session_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Session__c.Time__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Event start date is used for session&apos;s date / time. This information has to be checked and updated during preparation phase.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Session - Ready for Approval</fullName>
        <actions>
            <name>Event_Notification_to_speaker_to_approve_presentation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Event_Session_ready_for_approval</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Session__c.Session_Status__c</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Session__c.All_Speakers_Identified__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Session__c.Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Session status changed to Ready for Approval after:
-All speakers identified- is checked
-Date/Time- field has been filled</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Session - Speaker%27s email address</fullName>
        <actions>
            <name>Session_Speaker_s_Email_Alert_address</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Session__c.Speaker_s_name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Speaker&apos;s email address used for Email alerts.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
