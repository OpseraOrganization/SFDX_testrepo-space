<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Apttus_Approval__Resettrigger</fullName>
        <description>Reset trigger flag when comments have been entered for requests without actually approving or rejecting the request.</description>
        <field>Apttus_Approval__Workflow_Trigger_Added_Comments__c</field>
        <literalValue>0</literalValue>
        <name>Reset trigger</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>NF_FOC_Approvers Remainder</fullName>
        <active>true</active>
        <formula>AND( $User.ProfileId != $Label.Data_Loader_Profile_Id,  OR(  ISPICKVAL(Apttus_Approval__Approval_Status__c ,&apos;Assigned&apos;),  ISPICKVAL(Apttus_Approval__Approval_Status__c ,&apos;Reassigned&apos;)  ),  CONTAINS(Apttus_Approval__Step_Name__c,&apos;FoC&apos;), NF_Remaindercount__c&gt;=1   )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>NF_PSR_FOC_Email_Alert</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>NF_FOC_Remind_Count</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>NF_FOC_Tech_Field_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Apttus_Approval__Approval_Request__c.ApprovalDateTechField__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
