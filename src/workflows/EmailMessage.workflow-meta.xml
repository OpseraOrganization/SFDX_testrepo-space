<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Email_sent_to_End_User1</fullName>
        <field>Email_Sent_to_End_User__c</field>
        <formula>NOW()</formula>
        <name>Email sent to End User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_Open_working</fullName>
        <description>Once an email is sent to the end user, change the status from New to Open-working</description>
        <field>Status</field>
        <literalValue>OpenWorking</literalValue>
        <name>Set Status to Open working</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Workflow_Fired_field_TRUE</fullName>
        <description>Set the flag workflow fired field to True.</description>
        <field>Workflow_Fired__c</field>
        <literalValue>1</literalValue>
        <name>Workflow Fired field TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Email message sent-Case Management</fullName>
        <actions>
            <name>Email_sent_to_End_User1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Status_to_Open_working</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Workflow_Fired_field_TRUE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.CaseNumber</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>Sent</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_Fired__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SF Support</value>
        </criteriaItems>
        <description>This is an actual time stamp when the email was sent to the customer/end-user</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
