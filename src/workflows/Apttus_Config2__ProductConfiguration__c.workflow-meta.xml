<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CPQ_ApprovalCompletionEmail</fullName>
        <description>Used to send email to Config owner after cart Approval / Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/CPQ_Approval_Completion_Template</template>
    </alerts>
    <rules>
        <fullName>CPQ_Approval_Completion</fullName>
        <actions>
            <name>CPQ_ApprovalCompletionEmail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Config2__ProductConfiguration__c.NokiaCPQ_Portfolio_From_Quote__c</field>
            <operation>equals</operation>
            <value>QTC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Config2__ProductConfiguration__c.Apttus_CQApprov__Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved,Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
