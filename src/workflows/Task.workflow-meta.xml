<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CLM_Update_Task_Comments_Field</fullName>
        <field>Description</field>
        <formula>&quot;This agreement is returned to you for review or signature. Please take appropriate action&quot;</formula>
        <name>CLM Update Task Comments Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Update_Task_Subject_Field</fullName>
        <field>Subject</field>
        <formula>&quot;Returned for Review/Signatures&quot;</formula>
        <name>CLM Update Task Subject Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CLM Update Task Subject on Agreement</fullName>
        <actions>
            <name>CLM_Update_Task_Comments_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CLM_Update_Task_Subject_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>equals</operation>
            <value>Returned To Requestor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Description</field>
            <operation>contains</operation>
            <value>In Authoring</value>
        </criteriaItems>
        <description>This will update the Task subject for agreement Object on Return to Requestor</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
