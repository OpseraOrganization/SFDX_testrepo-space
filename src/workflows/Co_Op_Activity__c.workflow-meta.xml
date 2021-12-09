<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Co_Op_Activity_expiration_date</fullName>
        <field>Activity_Expire_Date__c</field>
        <formula>IF( AND((
INCLUDES(Exception__c, &apos;Activity Start Date occurred in the past&apos;)),Activity_Approved_date__c &gt; End_Date__c ), Activity_Approved_date__c + 60,  End_Date__c + 60)</formula>
        <name>Update Co-Op Activity expiration date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>PRM Coop activity claimable</fullName>
        <actions>
            <name>PRM_coop_activity_claimable</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Co_Op_Activity__c.Activity_Status__c</field>
            <operation>equals</operation>
            <value>Claimable</value>
        </criteriaItems>
        <description>PRM Coop activity claimable</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update CoOp Activity Expiry Date</fullName>
        <actions>
            <name>Update_Co_Op_Activity_expiration_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISNEW(), AND(ISCHANGED( Activity_Approved_date__c ),  INCLUDES(Exception__c, &apos;Activity Start Date occurred in the past&apos;)),ISCHANGED( End_Date__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
