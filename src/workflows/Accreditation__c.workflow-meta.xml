<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert_on_Accreditation_Level_Change</fullName>
        <description>Email Alert on the Accreditation Level Change alert</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>nokia_global_partner_communications@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PRM_Email_Templates/Accreditation_Level_Change</template>
    </alerts>
    <fieldUpdates>
        <fullName>PRM_Update_Accreditation_Evaluation_Flag</fullName>
        <description>PRM Update Accreditation Evaluation Flag field updates</description>
        <field>Evaluated_Accreditation__c</field>
        <literalValue>1</literalValue>
        <name>PRM Update Accreditation Evaluation Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>PRM Set for accreditation level Change Evaluation - downgrade</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Accreditation__c.Downgrade_Grace_Period_End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>PRM_Update_Accreditation_Evaluation_Flag</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Accreditation__c.Downgrade_Grace_Period_End_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Sample_Workflow_Task</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Sample Workflow Task</subject>
    </tasks>
    <tasks>
        <fullName>Sent_Email_updates_to_PSM</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Sent Mail update on Accreditation Level PSM</subject>
    </tasks>
</Workflow>
