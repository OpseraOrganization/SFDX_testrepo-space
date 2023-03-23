<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Submitter_When_Question_Answered_by_Other</fullName>
        <description>Email Submitter When Question Answered by Other</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PMO/Question_Answered</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_to_question_assignee</fullName>
        <description>Email notification to question assignee</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PMO/Question_Assigned</template>
    </alerts>
    <alerts>
        <fullName>Question_Log_Send_Email_on_Query_Assignment_to_Reportee</fullName>
        <description>Question Log - Send Email on Query Assignment</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PMO/Question_Log_Send_Email_on_Query_Assignment</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_question_log_request_owner</fullName>
        <description>Send email to question log request owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PMO/Send_Email_To_Owner_Of_the_Request</template>
    </alerts>
    <rules>
        <fullName>Generate EMail for Request owner</fullName>
        <actions>
            <name>Send_email_to_question_log_request_owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Question_Log__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Question_Log__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>SaaS Delivery Question Log</value>
        </criteriaItems>
        <description>Ability to make the question log generate an auto e-mail to the owner of the request</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Question Log</fullName>
        <actions>
            <name>Email_notification_to_question_assignee</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Question_Log__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>rule to send notification a question has been opened in their name</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Question Answered in Toolkit</fullName>
        <actions>
            <name>Email_Submitter_When_Question_Answered_by_Other</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Rule to send email to Submitter when one of their questions is answered in the toolkit.</description>
        <formula>AND(
OR(
ISPICKVAL(Status__c, &quot;Closed&quot;),
ISPICKVAL(Status__c, &quot;Clarification Provided&quot;)
),
Submitter__r.Id &lt;&gt; LastModifiedById
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
