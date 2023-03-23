<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CLM_Reset_Answer_to_Null</fullName>
        <field>CLM_L2D_Trigger_Answer__c</field>
        <name>Reset Answer to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Reset_Level_to_Null</fullName>
        <field>CLM_Level__c</field>
        <name>Reset Level to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Update_Pre_Negotiated_Clause_Text</fullName>
        <field>CLM_Pre_Negotiated_Clause_Text__c</field>
        <formula>Apttus__Text__c</formula>
        <name>Update Pre-Negotiated Clause Text</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CLM_Reset Answer and Level</fullName>
        <actions>
            <name>CLM_Reset_Answer_to_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CLM_Reset_Level_to_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( AND( ISPICKVAL(CLM_L2D_Relevant__c, &quot;Yes&quot;), OR(AND(ISCHANGED( CLM_Question__c ), ISBLANK(CLM_Question__c), NOT(ISBLANK(CLM_L2D_Trigger_Answer__c)), NOT(ISBLANK(CLM_Level__c))),  AND(ISCHANGED( CLM_Question__c ), PRIORVALUE(CLM_Question__c) &lt;&gt; CLM_Question__c))),  AND(ISCHANGED( CLM_L2D_Relevant__c ), ISPICKVAL(PRIORVALUE(CLM_L2D_Relevant__c), &quot;No&quot;), ISPICKVAL(CLM_L2D_Relevant__c, &quot;Yes&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CLM_Update Pre-Negotiated Clause Text</fullName>
        <actions>
            <name>CLM_Update_Pre_Negotiated_Clause_Text</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISBLANK( Apttus__PrimordialVersionId__c ),  ISPICKVAL(Apttus__Action__c, &quot;Inserted&quot;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
