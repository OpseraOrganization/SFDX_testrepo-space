<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>PRM_Terminate_Display_on_Partner_Locator</fullName>
        <field>Co_op_Account_Created__c</field>
        <literalValue>No</literalValue>
        <name>PRM Terminate Display on Partner Locator</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Disable_Partner_Field_to_False</fullName>
        <field>Partner_Disable__c</field>
        <literalValue>0</literalValue>
        <name>Update Disable Partner Field to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Disable Partner Uncheck on Account Enabled as Partner</fullName>
        <actions>
            <name>Update_Disable_Partner_Field_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.IsPartner</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email notification to be sent out if the Partner Status is Customer Terminated or Partner Terminated</fullName>
        <actions>
            <name>Email_notification_to_be_sent_out_if_the_Partner_Status_is_Customer_Terminated_o</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>PRM_Terminate_Display_on_Partner_Locator</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Email notification to be sent out if the Partner Status is Customer Terminated or Partner Terminated</description>
        <formula>ISPICKVAL(Partner_Status__c,&apos;Customer Terminated&apos;) || ISPICKVAL(Partner_Status__c,&apos;Partner Terminated&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
