<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Deactivate_PF_IsFlag_Active_time</fullName>
        <description>Deactivate PF Is Flag Active-time</description>
        <field>Is_Flag_Active__c</field>
        <literalValue>0</literalValue>
        <name>Deactivate PF Is Flag Active-time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Flag_End_Date_value</fullName>
        <description>Remove “Flag End Date” value when “Is Flag Active&quot; is set to &quot;true&quot;</description>
        <field>Flag_End_Date__c</field>
        <name>Remove “Flag End Date” value when “Is Fl</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Flag_End_Date_with_Today_date</fullName>
        <description>Update “Flag End Date” with “Today date” when “Is Flag Active” is set to false</description>
        <field>Flag_End_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update “Flag End Date” with “Today date”</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Deactivate Prog Flag when End Date past</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Program_Flag__c.Flag_End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Set &quot;Is Flag Active&quot; to &quot;false&quot; in Program Flag Data record when the Flag End Date reach today&apos;s date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Deactivate_PF_IsFlag_Active_time</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Program_Flag__c.Flag_End_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Populate %E2%80%9CFlag End Date%E2%80%9D with %E2%80%9CToday date%E2%80%9D when %E2%80%9CIs Flag Active%E2%80%9D is set to false</fullName>
        <actions>
            <name>Update_Flag_End_Date_with_Today_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Program_Flag__c.Is_Flag_Active__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Populate “Flag End Date” with “Today date” when “Is Flag Active” is set to false</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Remove %E2%80%9CFlag End Date%E2%80%9D value when %E2%80%9CIs Flag Active%E2%80%9D is set to true</fullName>
        <actions>
            <name>Remove_Flag_End_Date_value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Program_Flag__c.Is_Flag_Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Flag__c.Flag_End_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Remove “Flag End Date” value when “Is Flag Active” is set to true and “Flag End Date” is in the past</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
