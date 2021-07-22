<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>PRM Set for accreditation level Change Evaluation - downgrade</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Accreditation__c.Downgrade_Grace_Period_End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Descriptiontest_testgit</description>
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
</Workflow>
