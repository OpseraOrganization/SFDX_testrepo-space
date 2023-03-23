<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert_on_Accreditation_Level_Change</fullName>
        <description>Email Alert on Accreditation Level Change</description>
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
        <field>Evaluated_Accreditation__c</field>
        <literalValue>1</literalValue>
        <name>PRM Update Accreditation Evaluation Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Pricing_Override_Expiration_to_blank</fullName>
        <description>set Pricing Override Expiration date field to balnk</description>
        <field>Pricing_Override_Expiration__c</field>
        <name>Set Pricing Override Expiration to blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updating_Partner_ID_field</fullName>
        <description>Here Account ID is field data is stored in to the Partner ID</description>
        <field>Partner_ID__c</field>
        <formula>Account_ID__c</formula>
        <name>updating Partner ID field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Notify on Accreditation Level Change</fullName>
        <actions>
            <name>Email_Alert_on_Accreditation_Level_Change</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Sent_Email_updates_to_PSM</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <formula>ISCHANGED(Accreditation_Level__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
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
    <rules>
        <fullName>Set Pricing Expiration Date to blank</fullName>
        <actions>
            <name>Set_Pricing_Override_Expiration_to_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>ticket num: 00008411</description>
        <formula>ISBLANK(TEXT(Pricing_Level_Override__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Account ID field as Account ID%2FPartner ID</fullName>
        <actions>
            <name>updating_Partner_ID_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK(Account_ID__c))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Sent_Email_updates_to_PSM</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Track Email sent on Accreditation Level change</subject>
    </tasks>
</Workflow>
