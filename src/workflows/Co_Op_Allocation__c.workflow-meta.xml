<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Day_to_expire_with_today</fullName>
        <field>Days_to_expire__c</field>
        <literalValue>Today</literalValue>
        <name>Update &apos;Day to expire&apos; with today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_co_opallocation_Days_to_expire</fullName>
        <field>Days_to_expire__c</field>
        <literalValue>Today</literalValue>
        <name>Update co-opallocation Days to expire</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_days_to_expire_for_15_days</fullName>
        <field>Days_to_expire__c</field>
        <literalValue>15 DAY</literalValue>
        <name>Update days to expire for 15 days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_expiry_date</fullName>
        <field>Expiration_Date__c</field>
        <formula>DATE( Year(Available_Date__c)+floor((MONTH(Available_Date__c) + 12 - 1) / 12) , 
    mod(MONTH(Available_Date__c) + 12 -1, 12) + 1 , 
     day(Available_Date__c)
) - 1</formula>
        <name>Update expiry date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_date_Days_to_expire</fullName>
        <field>Days_to_expire__c</field>
        <literalValue>30 DAY</literalValue>
        <name>update date Days to expire</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update  Coop allocation expiration date</fullName>
        <actions>
            <name>Update_expiry_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISNEW(), ISCHANGED( Available_Date__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update co-opallocation Days to expire</fullName>
        <actions>
            <name>Update_co_opallocation_Days_to_expire</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL( Status__c , &quot;Active&quot;) ,   Expiration_Date__c = TODAY() )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update expiration date on coop allocation</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Co_Op_Allocation__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>update_date_Days_to_expire</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Co_Op_Allocation__c.Expiration_Date__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Update_days_to_expire_for_15_days</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Co_Op_Allocation__c.Expiration_Date__c</offsetFromField>
            <timeLength>-15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Day_to_expire_with_today</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Co_Op_Allocation__c.Expiration_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
