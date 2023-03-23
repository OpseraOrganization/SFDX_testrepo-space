<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Action_Item_Created_Email</fullName>
        <description>Email alert to send email to action item owner on creation.</description>
        <protected>false</protected>
        <recipients>
            <field>Key_Action_Decision_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PMO/Action_Item_Assignment</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Completed_Date</fullName>
        <description>Update Completed Date field</description>
        <field>Completed_Date__c</field>
        <formula>Now()</formula>
        <name>Update Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Action Item Created</fullName>
        <actions>
            <name>Action_Item_Created_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Key_Action_Decision__c.Status__c</field>
            <operation>equals</operation>
            <value>Not Started,In Progress</value>
        </criteriaItems>
        <description>Workflow for an action item whenever it is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Completed Date Workflow</fullName>
        <actions>
            <name>Update_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Key_Action_Decision__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>Update Completed Date Workflow when Status = Completed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
