<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DS_New_Task_Email_Alert</fullName>
        <description>DS New Task Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DS_New_Task_Notification</template>
    </alerts>
    <alerts>
        <fullName>DS_New_Task_Email_Alert_SFR_Logistics</fullName>
        <ccEmails>0projet-sfr.logistics@nokia.com</ccEmails>
        <description>DS New Task Email Alert SFR Logistics</description>
        <protected>false</protected>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DS_New_Task_Notification</template>
    </alerts>
    <alerts>
        <fullName>DS_New_Task_Email_Alert_SFR_Wipro</fullName>
        <ccEmails>0eur.orderprocess@wipro.com</ccEmails>
        <description>DS New Task Email Alert SFR Wipro</description>
        <protected>false</protected>
        <recipients>
            <recipient>joyeeta.bose.ext@singlecrm.nokia.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>prabakar.jothi_munirathinam.ext@singlecrm.nokia.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pradeepa.sankar.ext@singlecrm.nokia.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>samarjit.singh.ext@singlecrm.nokia.com.b11390187</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shridhar.pradhan.ext@singlecrm.nokia.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>suresh.arjunan.ext@singlecrm.nokia.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>vignesh.venkatesan.ext@singlecrm.nokia.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DS_New_Task_Notification</template>
    </alerts>
    <alerts>
        <fullName>DS_Task_reassigned_Email_Alert</fullName>
        <description>DS Task reassigned Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DS_Task_reassigned_Notification</template>
    </alerts>
    <alerts>
        <fullName>DS_Task_reassigned_Email_Alert_SFR_Logistics</fullName>
        <ccEmails>0projet-sfr.logistics@nokia.com</ccEmails>
        <description>DS Task reassigned Email Alert SFR Logistics</description>
        <protected>false</protected>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DS_Task_reassigned_Notification</template>
    </alerts>
    <alerts>
        <fullName>DS_Task_reassigned_Email_Alert_SFR_Wipro</fullName>
        <ccEmails>0eur.orderprocess@wipro.com</ccEmails>
        <description>DS Task reassigned Email Alert SFR Wipro</description>
        <protected>false</protected>
        <recipients>
            <recipient>prabakar.jothi_munirathinam.ext@singlecrm.nokia.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pradeepa.sankar.ext@singlecrm.nokia.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shridhar.pradhan.ext@singlecrm.nokia.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>suresh.arjunan.ext@singlecrm.nokia.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>vignesh.venkatesan.ext@singlecrm.nokia.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforce.no_reply@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DS_Task_reassigned_Notification</template>
    </alerts>
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
    <fieldUpdates>
        <fullName>Update_Task_Completion</fullName>
        <field>isTaskCompleted__c</field>
        <literalValue>1</literalValue>
        <name>Update Task Completion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
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
