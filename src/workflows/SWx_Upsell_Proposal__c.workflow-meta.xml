<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Change Upsell Stage to Replaced</fullName>
        <actions>
            <name>Change_Upsell_Stage_to_Replace_when_Prop</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SWx_Upsell_Proposal__c.Proposal_Status__c</field>
            <operation>equals</operation>
            <value>Replaced</value>
        </criteriaItems>
        <description>Change Upsell Stage to Replace when Proposal Status changes to Replaced</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DS SWX Record Type Assignment on Reject</fullName>
        <actions>
            <name>Update_CXM_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SWx_Upsell_Proposal__c.Upsell_Status__c</field>
            <operation>equals</operation>
            <value>Reject</value>
        </criteriaItems>
        <criteriaItems>
            <field>SWx_Upsell_Proposal__c.Proposal_Status__c</field>
            <operation>equals</operation>
            <value>Close-Reject</value>
        </criteriaItems>
        <criteriaItems>
            <field>SWx_Upsell_Proposal__c.Analytics_Source__c</field>
            <operation>equals</operation>
            <value>CXM</value>
        </criteriaItems>
        <description>DSI - 085 - When the customer &quot;Rejects&quot; via the portal reject button that digital proposal goes instantly in Upsell Stage &quot;Rejected&quot;, so no action anyhow to do anymore from an Account Manager point of view.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SWX Digital Proposal</fullName>
        <actions>
            <name>SWX_Record_Type_Assignment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  OR(ISPICKVAL(PRIORVALUE( Upsell_Status__c),&quot;Convert&quot;),ISPICKVAL(PRIORVALUE( Upsell_Status__c),&quot;Cancel&quot;),ISPICKVAL(PRIORVALUE( Upsell_Status__c),&quot;Reject&quot;)),  ISPICKVAL(( Upsell_Status__c),&quot;Draft&quot;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
