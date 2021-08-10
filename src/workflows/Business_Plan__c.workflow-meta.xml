<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Send Review Email</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Business_Plan__c.Business_Plan_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Data Loader Profile</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Integration API Only Profile</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Activate_Send_Review_Email</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Business_Plan__c.Review_date__c</offsetFromField>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Deactivate_Send_Review_Email</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Review_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Business_Plan__c.Review_date__c</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
