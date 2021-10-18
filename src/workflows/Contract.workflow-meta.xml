<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Contract_Status_as_Active</fullName>
        <field>Contract_Status__c</field>
        <literalValue>Active</literalValue>
        <name>Update Contract Status as Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contract_Status_as_Expired</fullName>
        <field>Contract_Status__c</field>
        <literalValue>Expired</literalValue>
        <name>Update Contract  Status as Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_expiry_status_to_Action_Needed</fullName>
        <field>Expired_Contract_Status__c</field>
        <literalValue>Action Needed</literalValue>
        <name>Update  expiry status to Action Needed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_contract_status_to_Contract_End_D</fullName>
        <field>Contract_Status_New__c</field>
        <literalValue>Passed End Date</literalValue>
        <name>update contract status to Contract End D</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>PRM Contract updates Status to Expired</fullName>
        <active>true</active>
        <formula>ISPICKVAL(Contract_Status__c, &apos;Active&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Contract_Status_as_Expired</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contract.EndDate</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>PRM Update Contract Expiry flag to false</fullName>
        <actions>
            <name>Update_Contract_Status_as_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( AND(ISNEW(), StartDate  &lt;= today() ), AND( ISPICKVAL(Contract_Status__c, &apos;Expired&apos;), ISCHANGED(EndDate), EndDate &gt; Today() ), AND( ISCHANGED(StartDate), StartDate &lt;= Today(), EndDate &gt; Today() ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PRM Update Contract Expiry flag to false if start date is future date</fullName>
        <active>true</active>
        <formula>StartDate  &gt; today()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Contract_Status_as_Active</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contract.StartDate</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update contract status to Passed End Date1</fullName>
        <active>true</active>
        <formula>NOT(ISPICKVAL(Contract_Status__c, &apos;Expired&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_expiry_status_to_Action_Needed</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>update_contract_status_to_Contract_End_D</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contract.EndDate</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
