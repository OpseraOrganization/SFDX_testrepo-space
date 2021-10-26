<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CH_Renegotiation_Start_Date_Reminder</fullName>
        <description>CH Renegotiation Start Date Reminder</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support.services@nokia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CH_EmailTemplates/CH_RenegotiationStartDateReminder</template>
    </alerts>
    <fieldUpdates>
        <fullName>CH_CA_ServiceContractAccount_Hidden_Name</fullName>
        <field>CH_Hidden_Searchfield__c</field>
        <formula>Account.Name</formula>
        <name>CH CA ServiceContractAccount Hidden Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CH_UpdateEntitlementScriptFlag</fullName>
        <field>CH_ServiceContractEntitlementScript__c</field>
        <formula>LEN(CH_EntitlementScript__c)</formula>
        <name>CH_UpdateEntitlementScriptFlag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CH_CA_SC</fullName>
        <actions>
            <name>CH_CA_ServiceContractAccount_Hidden_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISNEW(), ISCHANGED( AccountId ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CH_CheckEntitlementScript</fullName>
        <actions>
            <name>CH_UpdateEntitlementScriptFlag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CH_RenegotiationStartDateReminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>ServiceContract.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vendor Contract</value>
        </criteriaItems>
        <criteriaItems>
            <field>ServiceContract.CH_RenegotiationStartDate__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Created as part of User Story NOKIASC-31309</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CH_Renegotiation_Start_Date_Reminder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>ServiceContract.CH_RenegotiationStartDate__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
